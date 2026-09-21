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

-- macOS-style tab switching: Command+Shift+[ / Command+Shift+].
o.bind("SUPER + SHIFT + BRACKETLEFT", "Previous tab", send_shortcut("CTRL SHIFT", "TAB"))
o.bind("SUPER + SHIFT + BRACKETRIGHT", "Next tab", send_shortcut("CTRL", "TAB"))

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

o.bind("ALT + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("ALT + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("ALT + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("ALT + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
