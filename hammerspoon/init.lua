local hyper = {"cmd", "alt", "ctrl", "shift"}

function reload_config(files)
  hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show(" ✔︎")

-- window movement {{{

hs.hotkey.bind(hyper, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "1", function()
  local win = hs.window.focusedWindow()
  win:setFrame(win:screen():frame())
end)

hs.hotkey.bind(hyper, "2", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 8)
  f.y = max.y
  f.w = max.w / 8 * 6
  f.h = max.h
  win:setFrame(f)
end)

--- }}}
-- application hotkeys {{{

local charsToApps = {
  a = "iTerm",
  e = "Mail",
  f = "Finder",
  m = "Messages",
  r = "Rdio",
  s = "Safari",
  t = "Tweetbot",
  z = "Slack",
}
for key, app in pairs(charsToApps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end

-- }}}
-- caffeine {{{

local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setIcon("awake.pdf")
  else
    caffeine:setIcon("sleepy.pdf")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- }}}

--- vim: fdm=marker fdl=0
