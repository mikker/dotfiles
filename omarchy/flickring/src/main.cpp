#define WLR_USE_UNSTABLE

#include <charconv>
#include <string>
#include <string_view>

#include <linux/input-event-codes.h>

#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/event/EventBus.hpp>
#include <hyprland/src/config/ConfigManager.hpp>
#include <hyprland/src/config/shared/parserUtils/ParserUtils.hpp>
#include <hyprland/src/config/lua/bindings/LuaBindingsInternal.hpp>
#include <hyprland/src/managers/input/InputManager.hpp>

extern "C" {
#include <lua.h>
#include <lauxlib.h>
}

#include "FlickRing.hpp"

using namespace Config::Lua::Bindings;

static HANDLE PHANDLE = nullptr;

APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

// ---- lua: hl.plugin.flickring.setup({ ... }) ----

static std::optional<uint32_t> parseButton(lua_State* L, int idx) {
    if (lua_isinteger(L, idx))
        return lua_tointeger(L, idx);

    if (!lua_isstring(L, idx))
        return std::nullopt;

    const std::string_view name = lua_tostring(L, idx);
    if (name == "left")
        return BTN_LEFT;
    if (name == "right")
        return BTN_RIGHT;
    if (name == "middle")
        return BTN_MIDDLE;
    if (name == "side" || name == "back")
        return BTN_SIDE;
    if (name == "extra" || name == "forward")
        return BTN_EXTRA;
    if (name.starts_with("mouse:")) {
        uint32_t   code = 0;
        const auto rest = name.substr(6);
        if (std::from_chars(rest.data(), rest.data() + rest.size(), code).ec == std::errc{})
            return code;
    }

    return std::nullopt;
}

static std::expected<SAction, std::string> parseAction(lua_State* L, int idx) {
    if (lua_isnil(L, idx))
        return SAction{};

    if (lua_isstring(L, idx) && !lua_isnumber(L, idx)) {
        const std::string_view str = lua_tostring(L, idx);
        if (str == "none")
            return SAction{};
        if (str == "scroll_up")
            return SAction{.type = SAction::SCROLL_UP};
        if (str == "scroll_down")
            return SAction{.type = SAction::SCROLL_DOWN};
        return std::unexpected(std::format("unknown action \"{}\" (use a function, an hl.dsp.* dispatcher, \"scroll_up\", \"scroll_down\" or {{ click = <button> }})", str));
    }

    if (lua_istable(L, idx)) {
        lua_getfield(L, idx, "click");
        const auto button = parseButton(L, -1);
        lua_pop(L, 1);
        if (!button)
            return std::unexpected("table actions must be { click = <button> }");
        return SAction{.type = SAction::CLICK, .button = *button};
    }

    if (!Internal::pushDispatcherFunction(L, idx))
        return std::unexpected("action must be a function, an hl.dsp.* dispatcher, \"scroll_up\", \"scroll_down\" or { click = <button> }");

    return SAction{.type = SAction::DISPATCH, .luaRef = luaL_ref(L, LUA_REGISTRYINDEX)};
}

static std::optional<CHyprColor> parseColor(lua_State* L, int idx) {
    if (lua_isinteger(L, idx))
        return CHyprColor{static_cast<uint64_t>(lua_tointeger(L, idx))};

    if (lua_isstring(L, idx)) {
        if (auto c = Config::ParserUtils::parseColor(lua_tostring(L, idx)); c)
            return CHyprColor{static_cast<uint64_t>(*c)};
    }

    return std::nullopt;
}

static void unrefActions(lua_State* L, const std::array<SAction, 4>& actions) {
    for (const auto& a : actions) {
        if (a.type == SAction::DISPATCH)
            luaL_unref(L, LUA_REGISTRYINDEX, a.luaRef);
    }
}

static int luaSetup(lua_State* L) {
    if (!lua_istable(L, 1))
        return Internal::configError(L, "flickring.setup: expected a table");

    unrefActions(L, g_pFlickRing->m_config.actions);
    g_pFlickRing->m_config = {};

    SConfig cfg;
    cfg.enabled = true;

    lua_getfield(L, 1, "button");
    if (!lua_isnil(L, -1)) {
        const auto button = parseButton(L, -1);
        if (!button) {
            lua_pop(L, 1);
            return Internal::configError(L, "flickring.setup: button must be a button code (e.g. 274) or one of middle, side, extra, back, forward");
        }
        cfg.button = *button;
    }
    lua_pop(L, 1);

    constexpr std::array<const char*, 4> DIRECTIONS = {"up", "right", "down", "left"};
    for (size_t i = 0; i < DIRECTIONS.size(); ++i) {
        lua_getfield(L, 1, DIRECTIONS[i]);
        auto action = parseAction(L, lua_gettop(L));
        lua_pop(L, 1);

        if (!action) {
            unrefActions(L, cfg.actions);
            return Internal::configError(L, std::format("flickring.setup: {}: {}", DIRECTIONS[i], action.error()));
        }

        cfg.actions[i] = *action;
    }

    auto number = [&](const char* field, auto& out) {
        lua_getfield(L, 1, field);
        if (lua_isnumber(L, -1))
            out = lua_tonumber(L, -1);
        lua_pop(L, 1);
    };

    number("size", cfg.size);
    number("hole", cfg.hole);
    number("delay", cfg.delayMs);
    number("threshold", cfg.threshold);
    number("scroll_speed", cfg.scrollSpeed);
    number("fade", cfg.fadeMs);

    lua_getfield(L, 1, "blur");
    if (lua_isboolean(L, -1))
        cfg.blur = lua_toboolean(L, -1);
    lua_pop(L, 1);

    for (auto [field, out] : {std::pair{"color", &cfg.color}, std::pair{"hover_color", &cfg.hoverColor}, std::pair{"border_color", &cfg.borderColor}}) {
        lua_getfield(L, 1, field);
        if (!lua_isnil(L, -1)) {
            const auto color = parseColor(L, -1);
            if (!color) {
                lua_pop(L, 1);
                return Internal::configError(L, std::format("flickring.setup: {} is not a valid color", field));
            }
            *out = *color;
        }
        lua_pop(L, 1);
    }

    g_pFlickRing->m_config = cfg;
    g_pFlickRing->onConfigChanged();

    return 0;
}

// ---- hyprctl ----

// `hyprctl flickring` prints state. `hyprctl flickring press|release` fakes the activator button.
static std::string hyprctlCommand(eHyprCtlOutputFormat, std::string args) {
    if (!g_pFlickRing)
        return "not loaded";

    const auto arg = args.substr(std::min(args.size(), args.find_last_of(' ') + 1));
    if (arg != "press" && arg != "release")
        return g_pFlickRing->status();

    const auto state = arg == "press" ? WL_POINTER_BUTTON_STATE_PRESSED : WL_POINTER_BUTTON_STATE_RELEASED;
    g_pInputManager->onMouseButton({.button = g_pFlickRing->m_config.button, .state = state}, nullptr);
    return "ok";
}

// ---- plugin lifecycle ----

[[noreturn]] static void fail(const std::string& message) {
    HyprlandAPI::addNotification(PHANDLE, "[flickring] " + message, CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
    throw std::runtime_error("[flickring] " + message);
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    const std::string HASH        = __hyprland_api_get_hash();
    const std::string CLIENT_HASH = __hyprland_api_get_client_hash();

    if (HASH != CLIENT_HASH)
        fail("Version mismatch: rebuild the plugin against the running Hyprland");

    if (Config::mgr()->type() != Config::CONFIG_LUA)
        fail("Requires a Lua Hyprland config (hyprland.lua)");

    g_pFlickRing = makeUnique<CFlickRing>();

    HyprlandAPI::addLuaFunction(PHANDLE, "flickring", "setup", ::luaSetup);

    static auto P1 = Event::bus()->m_events.input.mouse.button.listen([](IPointer::SButtonEvent e, Event::SCallbackInfo& info) {
        if (g_pFlickRing)
            g_pFlickRing->onButton(e.button, e.state == WL_POINTER_BUTTON_STATE_PRESSED, info.cancelled);
    });
    static auto P2 = Event::bus()->m_events.input.mouse.move.listen([](Vector2D pos, Event::SCallbackInfo& info) {
        if (g_pFlickRing)
            g_pFlickRing->onMove(pos, info.cancelled);
    });
    static auto P3 = Event::bus()->m_events.render.stage.listen([](eRenderStage stage) {
        if (g_pFlickRing)
            g_pFlickRing->onRenderStage(stage);
    });
    // The lua state is torn down on reload, taking our refs with it. setup() runs again with the new config.
    static auto P4 = Event::bus()->m_events.config.preReload.listen([] {
        if (!g_pFlickRing)
            return;
        g_pFlickRing->m_config = {};
        g_pFlickRing->onConfigChanged();
    });

    HyprlandAPI::registerHyprCtlCommand(PHANDLE, SHyprCtlCommand{.name = "flickring", .exact = false, .fn = ::hyprctlCommand});

    // Re-run the config so hl.plugin.flickring.setup exists for it.
    HyprlandAPI::reloadConfig();

    return {"flickring", "Action ring for your mouse", "Mikkel Malmberg", "0.1.0"};
}

APICALL EXPORT void PLUGIN_EXIT() {
    g_pFlickRing.reset();
}
