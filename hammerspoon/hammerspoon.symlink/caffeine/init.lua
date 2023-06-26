local caffeine = hs.menubar.new()

local function setCaffeineDisplay(state)
	if state then
		caffeine:setIcon("caffeine/awake.pdf")
	else
		caffeine:setIcon("caffeine/sleepy.pdf")
	end
end

local function caffeineClicked()
	setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
	caffeine:setClickCallback(caffeineClicked)
	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

caffeineClicked() -- caffeine starts on
