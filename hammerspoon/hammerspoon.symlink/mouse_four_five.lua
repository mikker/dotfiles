mouse_four_five =
  hs.eventtap.new({hs.eventtap.event.types.otherMouseDown}, function(event)
    if event:getButtonState(3) then
      hs.eventtap.keyStroke({"cmd"}, "[")
      return true
    elseif event:getButtonState(4) then
      hs.eventtap.keyStroke({"cmd"}, "]")
      return true
    else
      return false
    end
  end)

mouse_four_five:start()
