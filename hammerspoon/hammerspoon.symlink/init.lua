local function reload_config(_)
	hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show(" ✔︎")

-- application hotkeys {{{

local hyper = { "cmd", "alt", "ctrl", "shift" }

local charsToApps = {
	a = "WezTerm",
	c = "Calendar",
	d = "Dash",
	e = "Mail",
	f = "Finder",
	i = "Music",
	m = "Messages",
	p = "Things3",
	s = "Safari",
	-- s = "Safari Technology Preview",
	-- s = "Firefox",
	t = "Tweetbot",
	w = "VimR",
	z = "Slack",
}
for key, app in pairs(charsToApps) do
	hs.hotkey.bind(hyper, key, function()
		hs.application.launchOrFocus(app)
	end)
end

require("hjkl")
require("caffeine")
require("window-management")
require("mouse_four_five")

--- vim: fdm=marker
