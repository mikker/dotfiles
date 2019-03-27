function reload_config(files)
  hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show(" ✔︎")

-- application hotkeys {{{

local hyper = {"cmd", "alt", "ctrl", "shift"}

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
  -- s = "Safari Technology Preview",
  s = "Firefox",
  t = "Tweetbot",
  w = "VimR",
  z = "Slack",
}
for key, app in pairs(charsToApps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end

-- our new mechanical future
local mechToApps = {
  f1 = "iTerm",
  f4 = "Spotify",
}
for key, app in pairs(mechToApps) do
  hs.hotkey.bind({}, key, function()
    hs.application.launchOrFocus(app)
  end)
end

-- hs.hotkey.bind({}, 'f10', hs.spotify.playpause)
-- hs.hotkey.bind({}, 'pad-', hs.spotify.playpause)
-- hs.hotkey.bind({}, 'pagedown', hs.spotify.next)
-- hs.hotkey.bind({}, 'end', hs.spotify.previous)

-- }}}

-- require("hjkl")
require("caffeine")
require("window-management")

--- vim: fdm=marker
