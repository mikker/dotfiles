# FlickRing for Hyprland

**Action ring for your normie mouse**, as a Hyprland plugin. It's a port of [FlickRing.app](https://github.com/mikker/FlickRing) for macOS.

Hold the activator button (middle by default) and a ring shows up under the cursor. Flick in a direction and release to run that direction's action. Release without picking a direction and you get a normal click.

Requires Hyprland 0.56+ with a Lua config.

## Install

```sh
omarchy-hyprland-flickring-install
```

Builds against the installed Hyprland headers, installs to `~/.local/lib/hyprland/plugins/flickring.so`, and (re)loads it. The `install-hyprland-flickring` post-update hook reruns this after Omarchy updates. A build for a different Hyprland version refuses to load and shows a notification instead of crashing.

`omarchy/hypr/bindings.lua` loads it and calls `setup`. Its ring colors follow
the active Omarchy `[popups]` and `[controls]` theme recipes whenever Hyprland
reloads, including a theme switch.

## Configure

The plugin loads after the first config pass, so guard the call:

```lua
if hl.plugin.flickring then
  hl.plugin.flickring.setup({
    button = "middle",                               -- middle | side | extra | back | forward | 274 | "mouse:275"

    up    = "scroll_up",                             -- scrolls while hovered, faster the further you go
    down  = "scroll_down",
    left  = hl.dsp.focus({ workspace = "r-1" }),     -- any hl.dsp.* dispatcher
    right = function() hl.exec_cmd("xdg-open https://example.com") end, -- or any Lua function
    -- { click = "right" } presses a mouse button, "none" does nothing

    -- optional look & feel (defaults shown)
    size = 160,          -- ring diameter, logical px
    hole = 70,           -- dead zone diameter
    delay = 250,         -- ms before the ring shows if you don't move
    threshold = 5,       -- px of movement that shows it right away
    scroll_speed = 0.05,
    fade = 125,          -- ms
    blur = true,         -- uses decoration:blur settings
    color = "rgba(1414198c)",
    hover_color = "rgba(ffffff38)",
    border_color = "rgba(ffffff1f)",
  })
end
```

Until `setup` is called, the plugin does nothing.

## Debugging

```sh
hyprctl flickring          # current config and state
hyprctl flickring press    # fake the activator button
hyprctl flickring release
```
