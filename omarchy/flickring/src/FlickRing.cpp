#include "FlickRing.hpp"

#include <cmath>
#include <numbers>

#include <cairo/cairo.h>

#include <hyprland/src/config/ConfigValue.hpp>
#include <hyprland/src/managers/input/InputManager.hpp>
#include <hyprland/src/managers/KeybindManager.hpp>
#include <hyprland/src/managers/eventLoop/EventLoopManager.hpp>
#include <hyprland/src/managers/eventLoop/EventLoopTimer.hpp>
#include <hyprland/src/output/Monitor.hpp>
#include <hyprland/src/pointer/PointerManager.hpp>
#include <hyprland/src/render/Renderer.hpp>
#include <hyprland/src/render/pass/TexPassElement.hpp>

using namespace std::chrono_literals;

constexpr auto TICK = 8ms;

static uint32_t nowMs() {
    return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now().time_since_epoch()).count();
}

CFlickRing::CFlickRing() {
    m_showTimer   = makeShared<CEventLoopTimer>(std::nullopt, [this](SP<CEventLoopTimer>, void*) { show(); }, nullptr);
    m_scrollTimer = makeShared<CEventLoopTimer>(std::nullopt, [this](SP<CEventLoopTimer>, void*) { scrollTick(); }, nullptr);
    m_fadeTimer   = makeShared<CEventLoopTimer>(std::nullopt, [this](SP<CEventLoopTimer>, void*) { fadeTick(); }, nullptr);

    g_pEventLoopManager->addTimer(m_showTimer);
    g_pEventLoopManager->addTimer(m_scrollTimer);
    g_pEventLoopManager->addTimer(m_fadeTimer);
}

CFlickRing::~CFlickRing() {
    damage();

    for (auto& t : {m_showTimer, m_scrollTimer, m_fadeTimer}) {
        t->cancel();
        g_pEventLoopManager->removeTimer(t);
    }
}

void CFlickRing::onConfigChanged() {
    if (m_active || m_alpha > 0)
        damage();

    m_active  = false;
    m_visible = false;
    m_alpha   = 0;
    m_hovered = SECTION_NONE;
    m_showTimer->updateTimeout(std::nullopt);
    m_scrollTimer->updateTimeout(std::nullopt);
    m_fadeTimer->updateTimeout(std::nullopt);
    m_textures.fill(nullptr);
}

std::string CFlickRing::status() const {
    static constexpr std::array<const char*, 5> TYPES = {"none", "dispatch", "scroll_up", "scroll_down", "click"};
    static constexpr std::array<const char*, 4> DIRS  = {"up", "right", "down", "left"};
    static constexpr std::array<const char*, 5> SECS  = {"none", "up", "right", "down", "left"};

    std::string out = std::format("enabled: {}\nbutton: {}\nactive: {}\nvisible: {}\nhovered: {}\nalpha: {:.2f}\n", m_config.enabled, m_config.button, m_active,
                                  m_visible, SECS[m_hovered + 1], m_alpha);
    for (size_t i = 0; i < DIRS.size(); ++i) {
        const auto& a = m_config.actions[i];
        out += std::format("{}: {}{}\n", DIRS[i], TYPES[a.type], a.type == SAction::CLICK ? std::format(" {}", a.button) : "");
    }
    return out;
}

// ---- input ----

void CFlickRing::onButton(uint32_t button, bool pressed, bool& cancel) {
    if (m_replaying || !m_config.enabled || button != m_config.button)
        return;

    cancel = true;

    if (pressed && !m_active)
        begin();
    else if (!pressed && m_active)
        end();
}

void CFlickRing::onMove(const Vector2D& pos, bool& cancel) {
    if (!m_active)
        return;

    // Keep focus where the press started (no follow-mouse while flicking). The cursor still moves.
    cancel = true;

    const auto delta = pos - m_origin;

    if (!m_visible) {
        if (delta.size() > m_config.threshold)
            show();
        else
            return;
    }

    eSection section = SECTION_NONE;
    if (delta.size() > m_config.hole / 2.0) {
        // Screen y grows downwards; flip it so "up" is up.
        const double angle = std::atan2(-delta.y, delta.x) * 180.0 / std::numbers::pi;
        if (angle >= -45 && angle < 45)
            section = SECTION_RIGHT;
        else if (angle >= 45 && angle < 135)
            section = SECTION_UP;
        else if (angle >= 135 || angle < -135)
            section = SECTION_LEFT;
        else
            section = SECTION_DOWN;
    }

    setHovered(section);
}

// ---- state ----

void CFlickRing::begin() {
    // A previous ring may still be fading out elsewhere.
    if (m_alpha > 0) {
        damage();
        m_alpha       = 0;
        m_alphaTarget = 0;
    }

    m_active  = true;
    m_visible = false;
    m_hovered = SECTION_NONE;
    m_origin  = g_pInputManager->getMouseCoordsInternal();

    m_showTimer->updateTimeout(std::chrono::milliseconds(m_config.delayMs));
}

void CFlickRing::end() {
    const auto selected = m_hovered;

    m_active = false;
    m_showTimer->updateTimeout(std::nullopt);
    m_scrollTimer->updateTimeout(std::nullopt);

    if (m_visible)
        hide();
    m_visible = false;
    m_hovered = SECTION_NONE;

    if (selected == SECTION_NONE) {
        // Nothing picked: behave like a plain click of the activator button.
        g_pInputManager->simulateMouseMovement();
        replayClick(m_config.button);
        return;
    }

    runAction(m_config.actions[selected]);

    // Hand pointer focus back to whatever is under the cursor now.
    g_pInputManager->simulateMouseMovement();
}

void CFlickRing::show() {
    m_showTimer->updateTimeout(std::nullopt);

    if (!m_active || m_visible)
        return;

    m_visible     = true;
    m_alphaTarget = 1.F;
    m_fadeTimer->updateTimeout(TICK);
    damage();
}

void CFlickRing::hide() {
    m_alphaTarget = 0.F;
    m_fadeTimer->updateTimeout(TICK);
    damage();
}

void CFlickRing::setHovered(eSection section) {
    if (section == m_hovered)
        return;

    m_hovered = section;
    damage();

    m_scrollTimer->updateTimeout(std::nullopt);
    if (section != SECTION_NONE)
        scrollTick();
}

// ---- actions ----

void CFlickRing::runAction(const SAction& action) {
    switch (action.type) {
        case SAction::DISPATCH: {
            const auto it = g_pKeybindManager->m_dispatchers.find("__lua");
            if (it != g_pKeybindManager->m_dispatchers.end())
                it->second(std::to_string(action.luaRef));
            break;
        }
        case SAction::CLICK: replayClick(action.button); break;
        default: break; // scrolling happens while hovering
    }
}

void CFlickRing::replayClick(uint32_t button) {
    m_replaying = true;

    const auto time = nowMs();
    g_pInputManager->onMouseButton({.timeMs = time, .button = button, .state = WL_POINTER_BUTTON_STATE_PRESSED}, nullptr);
    g_pInputManager->onMouseButton({.timeMs = time, .button = button, .state = WL_POINTER_BUTTON_STATE_RELEASED}, nullptr);

    m_replaying = false;
}

// Runs every tick while hovering a scroll section.
void CFlickRing::scrollTick() {
    if (!m_active || m_hovered == SECTION_NONE)
        return;

    const auto type = m_config.actions[m_hovered].type;
    if (type != SAction::SCROLL_UP && type != SAction::SCROLL_DOWN)
        return;

    // Synthetic scroll bypasses libinput, so apply natural scrolling ourselves to match the wheel.
    static auto  PNATURAL  = CConfigValue<Config::BOOL>("input:natural_scroll");
    const int    direction = (type == SAction::SCROLL_UP ? -1 : 1) * (*PNATURAL ? -1 : 1);

    const double distance = std::abs(g_pInputManager->getMouseCoordsInternal().y - m_origin.y);
    // Same curve as the macOS app, scaled from its 10ms tick to ours.
    const double amount = distance * m_config.scrollSpeed * (TICK.count() / 10.0);

    if (amount > 0) {
        g_pInputManager->onMouseWheel({
            .timeMs = nowMs(),
            .source = WL_POINTER_AXIS_SOURCE_CONTINUOUS,
            .axis   = WL_POINTER_AXIS_VERTICAL_SCROLL,
            .delta  = amount * direction,
        });
        // Continuous axis events wait for the device's frame event, which a synthetic scroll never gets.
        g_pInputManager->onPointerFrame();
    }

    m_scrollTimer->updateTimeout(TICK);
}

// ---- rendering ----

void CFlickRing::fadeTick() {
    const float step = m_config.fadeMs > 0 ? float(TICK.count()) / m_config.fadeMs : 1.F;

    if (m_alpha < m_alphaTarget)
        m_alpha = std::min(m_alphaTarget, m_alpha + step);
    else
        m_alpha = std::max(m_alphaTarget, m_alpha - step);

    damage();

    if (m_alpha != m_alphaTarget)
        m_fadeTimer->updateTimeout(TICK);
}

// Global, logical coordinates.
CBox CFlickRing::ringBox() const {
    return {m_origin.x - m_config.size / 2.0, m_origin.y - m_config.size / 2.0, m_config.size, m_config.size};
}

void CFlickRing::damage() {
    if (g_pHyprRenderer) // gone during compositor shutdown
        g_pHyprRenderer->damageBox(ringBox().expand(2));
}

void CFlickRing::onRenderStage(eRenderStage stage) {
    if (stage != RENDER_LAST_MOMENT || m_alpha <= 0)
        return;

    const auto MONITOR = g_pHyprRenderer->m_renderData.pMonitor.lock();
    if (!MONITOR)
        return;

    // Monitor-local, physical pixels. Render on every monitor the ring overlaps.
    const auto box = ringBox().translate(-MONITOR->m_position).scale(MONITOR->m_scale).round();
    if (!box.overlaps(CBox{{}, MONITOR->m_transformedSize}))
        return;

    CTexPassElement::SRenderData data;
    data.tex = textureFor(m_hovered, MONITOR->m_scale);
    data.box = box;
    data.a   = m_alpha;

    if (m_config.blur) {
        data.blur                  = true;
        data.blurA                 = m_alpha;
        data.blockBlurOptimization = true;
        // Only blur behind the ring itself, not the transparent corners or the hole.
        data.discardMode    = DISCARD_ALPHA;
        data.discardOpacity = 0.01F;
    }

    g_pHyprRenderer->m_renderPass.add(makeUnique<CTexPassElement>(std::move(data)));

    // A software cursor has already been queued by now; queue it again so it sits above the ring.
    // (No-op with hardware cursors, which are always on top.)
    if (g_pHyprRenderer->shouldRenderCursor())
        Pointer::mgr()->renderSoftwareCursorsFor(MONITOR, Time::steadyNow(), g_pHyprRenderer->m_renderData.damage);
}

static void setColor(cairo_t* cr, const CHyprColor& c) {
    cairo_set_source_rgba(cr, c.r, c.g, c.b, c.a);
}

SP<Render::ITexture> CFlickRing::textureFor(eSection section, double scale) {
    if (scale != m_textureScale) {
        m_textures.fill(nullptr);
        m_textureScale = scale;
    }

    auto& tex = m_textures[section + 1];
    if (tex)
        return tex;

    const int    px     = std::round(m_config.size * scale);
    const double c      = px / 2.0;
    const double outerR = c - 0.5;
    const double innerR = m_config.hole * scale / 2.0;

    const auto   surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, px, px);
    const auto   cr      = cairo_create(surface);

    cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR);
    cairo_paint(cr);
    cairo_set_operator(cr, CAIRO_OPERATOR_OVER);

    // Ring body
    cairo_set_fill_rule(cr, CAIRO_FILL_RULE_EVEN_ODD);
    cairo_new_path(cr);
    cairo_arc(cr, c, c, outerR, 0, 2 * std::numbers::pi);
    cairo_new_sub_path(cr);
    cairo_arc(cr, c, c, innerR, 0, 2 * std::numbers::pi);
    setColor(cr, m_config.color);
    cairo_fill(cr);

    // Hovered wedge. Cairo angles run clockwise from +x; up is centered on -90°.
    if (section != SECTION_NONE) {
        constexpr double DEG    = std::numbers::pi / 180.0;
        const double     center = -90.0 + 90.0 * int(section);
        const double     a0 = (center - 45) * DEG, a1 = (center + 45) * DEG;

        cairo_new_path(cr);
        cairo_arc(cr, c, c, outerR, a0, a1);
        cairo_arc_negative(cr, c, c, innerR, a1, a0);
        cairo_close_path(cr);
        setColor(cr, m_config.hoverColor);
        cairo_fill(cr);
    }

    // Hairline edges
    if (m_config.borderColor.a > 0) {
        const double w = std::max(1.0, scale);
        cairo_set_line_width(cr, w);
        setColor(cr, m_config.borderColor);
        cairo_new_path(cr);
        cairo_arc(cr, c, c, outerR - w / 2.0, 0, 2 * std::numbers::pi);
        cairo_stroke(cr);
        cairo_new_path(cr);
        cairo_arc(cr, c, c, innerR + w / 2.0, 0, 2 * std::numbers::pi);
        cairo_stroke(cr);
    }

    cairo_surface_flush(surface);
    tex = g_pHyprRenderer->createTexture(surface);

    cairo_destroy(cr);
    cairo_surface_destroy(surface);

    return tex;
}
