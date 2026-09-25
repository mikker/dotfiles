#pragma once

#include <array>
#include <cstdint>
#include <string>

#include <hyprland/src/helpers/Color.hpp>
#include <hyprland/src/helpers/math/Math.hpp>
#include <hyprland/src/helpers/memory/Memory.hpp>
#include <hyprland/src/SharedDefs.hpp>

class CEventLoopTimer;
namespace Render {
    class ITexture;
}

enum eSection : int8_t {
    SECTION_NONE  = -1,
    SECTION_UP    = 0,
    SECTION_RIGHT = 1,
    SECTION_DOWN  = 2,
    SECTION_LEFT  = 3,
};

struct SAction {
    enum eType : uint8_t {
        NONE,
        DISPATCH, // a lua function or hl.dsp.* dispatcher, stored as a registry ref
        SCROLL_UP,
        SCROLL_DOWN,
        CLICK,
    };

    eType    type   = NONE;
    int      luaRef = -2; // LUA_NOREF
    uint32_t button = 0;
};

struct SConfig {
    bool                   enabled = false; // flipped on by hl.plugin.flickring.setup()
    uint32_t               button  = 274;   // BTN_MIDDLE
    std::array<SAction, 4> actions;

    double                 size        = 160;
    double                 hole        = 70;
    int                    delayMs     = 250;
    double                 threshold   = 5;
    double                 scrollSpeed = 0.05;
    int                    fadeMs      = 125;
    bool                   blur        = true;

    CHyprColor             color       = CHyprColor{0.08, 0.08, 0.10, 0.55};
    CHyprColor             hoverColor  = CHyprColor{1.0, 1.0, 1.0, 0.22};
    CHyprColor             borderColor = CHyprColor{1.0, 1.0, 1.0, 0.12};
};

class CFlickRing {
  public:
    CFlickRing();
    ~CFlickRing();

    SConfig m_config;

    void    onButton(uint32_t button, bool pressed, bool& cancel);
    void    onMove(const Vector2D& pos, bool& cancel);
    void    onRenderStage(eRenderStage stage);
    void    onConfigChanged();
    std::string status() const;

  private:
    void                                  begin();
    void                                  end();
    void                                  show();
    void                                  hide();
    void                                  setHovered(eSection section);
    void                                  runAction(const SAction& action);
    void                                  replayClick(uint32_t button);
    void                                  scrollTick();
    void                                  fadeTick();
    void                                  damage();
    CBox                                  ringBox() const;
    SP<Render::ITexture>                  textureFor(eSection section, double scale);

    bool                                  m_active  = false; // activator button is held
    bool                                  m_visible = false; // ring has been shown during this press
    bool                                  m_replaying = false;
    Vector2D                              m_origin;
    eSection                              m_hovered = SECTION_NONE;

    float                                 m_alpha       = 0.F;
    float                                 m_alphaTarget = 0.F;

    SP<CEventLoopTimer>                   m_showTimer;
    SP<CEventLoopTimer>                   m_scrollTimer;
    SP<CEventLoopTimer>                   m_fadeTimer;

    std::array<SP<Render::ITexture>, 5>   m_textures; // index 0 = none, 1..4 = sections
    double                                m_textureScale = 0;
};

inline UP<CFlickRing> g_pFlickRing;
