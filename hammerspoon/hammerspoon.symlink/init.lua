local hyper = {"cmd", "alt", "ctrl", "shift"}

function reload_config(files)
  hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show(" ✔︎")

-- window movement {{{

hs.grid.GRIDHEIGHT = 12
hs.grid.GRIDWIDTH = 12
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

hs.hotkey.bind(hyper, "H", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  hs.grid.set(win, {x = 0, y = 0, w = 6, h = 12}, win:screen())
end)

hs.hotkey.bind(hyper, "L", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  hs.grid.set(win, {x = 6, y = 0, w = 6, h = 12}, win:screen())
end)

hs.hotkey.bind(hyper, "O", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  hs.grid.set(win, {x = 4, y = 0, w = 8, h = 12}, win:screen())
end)

hs.hotkey.bind(hyper, "N", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  hs.grid.set(win, {x = 0, y = 0, w = 4, h = 12}, win:screen())
end)

hs.hotkey.bind(hyper, "1", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:setFrame(win:screen():frame())
end)

hs.hotkey.bind(hyper, "2", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  hs.grid.set(win, {x = 1, y = 0, w = 10, h = 12}, win:screen())
end)

hs.hotkey.bind(hyper, "-", function ()
  local win = hs.window.focusedWindow()
  if not win then return end
  local f = win:frame()
  local screen = win:screen()

  f.x = (screen:frame().w / 2) - (f.w / 2)
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "=", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local f = win:frame()
  local screen = win:screen()

  f.y = 0
  f.h = screen:frame().h
  win:setFrame(f)
end)

--- }}}
-- application hotkeys {{{

local charsToApps = {
  a = "iTerm",
  c = "Calendar",
  d = "Dash",
  e = "Mail",
  f = "Finder",
  i = "Spotify",
  m = "Messages",
  p = "Things3",
  -- s = "Safari",
  s = "Safari Technology Preview",
  t = "Tweetbot",
  v = "VimR",
  z = "Slack"
}
for key, app in pairs(charsToApps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end

hs.hotkey.bind(hyper, "u", function()
  hs.itunes.displayCurrentTrack()
end)

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

caffeineClicked() -- caffeine starts on

-- }}}

--- vim: fdm=marker fdl=0
