-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Cycle through existing workspaces with vim-style keys.
-- ALT+SHIFT+L was previously "Copy URL from Web App".
hl.unbind("ALT + SHIFT + H")
hl.unbind("ALT + SHIFT + L")
o.bind("ALT + SHIFT + code:43", "Previous workspace", hl.dsp.focus({ workspace = "r-1" }))
o.bind("ALT + SHIFT + code:46", "Next workspace", hl.dsp.focus({ workspace = "r+1" }))

-- Replace the stock SUPER+Arrow directional focus bindings with Alt+H/J/K/L,
-- leaving the horizontal arrows available for macOS-style text navigation.
hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + DOWN")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + RIGHT")

local function send_shortcut(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

-- macOS-style history navigation: Command+[ / Command+].
o.bind("SUPER + BRACKETLEFT", "Back", send_shortcut("ALT", "LEFT"))
o.bind("SUPER + BRACKETRIGHT", "Forward", send_shortcut("ALT", "RIGHT"))

local function active_window_is_terminal()
  local window = hl.get_active_window()
  for _, tag in ipairs(window and window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

local function clear_to_line_start()
  if active_window_is_terminal() then
    send_shortcut("CTRL", "U")()
    return
  end

  send_shortcut("SHIFT", "HOME")()
  hl.timer(function()
    send_shortcut("", "BACKSPACE")()
  end, { timeout = 75, type = "oneshot" })
end

local function clear_previous_word()
  if active_window_is_terminal() then
    send_shortcut("CTRL", "W")()
  else
    send_shortcut("CTRL", "BACKSPACE")()
  end
end

o.bind("SUPER + LEFT", "Beginning of line", send_shortcut("", "HOME"), { repeating = true })
o.bind("SUPER + RIGHT", "End of line", send_shortcut("", "END"), { repeating = true })
o.bind("ALT + LEFT", "Previous word", send_shortcut("CTRL", "LEFT"), { repeating = true })
o.bind("ALT + RIGHT", "Next word", send_shortcut("CTRL", "RIGHT"), { repeating = true })

-- SUPER+BACKSPACE was previously "Toggle window transparency".
hl.unbind("SUPER + BACKSPACE")
o.bind("SUPER + BACKSPACE", "Clear to beginning of line", clear_to_line_start, { repeating = true })
o.bind("ALT + BACKSPACE", "Clear previous word", clear_previous_word, { repeating = true })

-- Hyper is SUPER+CTRL+ALT+SHIFT.
o.bind("SUPER + CTRL + ALT + SHIFT + S", "Toggle dictation", "voxtype record toggle")

o.bind("ALT + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("ALT + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("ALT + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("ALT + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- FlickRing: hold middle mouse, flick a direction, release.
-- Plugin source lives in omarchy/flickring; built and installed by omarchy-hyprland-flickring-install.
local flickring = os.getenv("HOME") .. "/.local/lib/hyprland/plugins/flickring.so"
if io.open(flickring) then
  hl.plugin.load(flickring)
end

local function flickring_theme()
  local file = io.open(os.getenv("HOME") .. "/.local/state/omarchy/current/theme/shell.toml")
  if not file then return {} end

  local section, values = "", {}
  for line in file:lines() do
    local next_section = line:match("^%s*%[([^%]]+)%]")
    if next_section then
      section = next_section
    elseif section == "popups" or section == "controls" then
      local key, value = line:match('^%s*([%w%-]+)%s*=%s*"?([^"%s]+)"?')
      if key and value then values[section .. "." .. key] = value end
    end
  end
  file:close()

  local function rgba(color, alpha)
    if not color or not alpha then return nil end
    local hex = color:match("^#?(%x%x%x%x%x%x)$")
    local opacity = tonumber(alpha)
    if not hex or not opacity then return nil end
    return string.format("rgba(%s%02X)", hex, math.floor(math.max(0, math.min(1, opacity)) * 255 + 0.5))
  end

  return {
    color = rgba(values["popups.background"], values["popups.background-alpha"]),
    border_color = rgba(values["popups.border"], values["popups.border-alpha"]),
    hover_color = rgba(values["controls.selected-color"], values["controls.selected-fill-alpha"]),
  }
end

if hl.plugin.flickring then
  local config = {
    up = "scroll_up",
    down = "scroll_down",
    scroll_speed = 0.015,
    left = send_shortcut("ALT", "LEFT"),
    right = send_shortcut("ALT", "RIGHT"),
  }
  for key, value in pairs(flickring_theme()) do
    if value then config[key] = value end
  end
  hl.plugin.flickring.setup(config)
end
