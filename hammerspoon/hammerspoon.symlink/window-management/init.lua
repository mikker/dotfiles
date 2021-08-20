local hyper = {"cmd", "alt", "ctrl", "shift"}

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

hs.hotkey.bind(hyper, '6', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()

  local f = win:frame()
  f.w = 770
  f.h = 550
  f.y = (screen:frame().h / 2) - (f.h / 2)
  f.x = (screen:frame().w / 2) - (f.w / 2)

  win:setFrame(f)
end)

hs.hotkey.bind(hyper, '7', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()

  local f = win:frame()
  f.w = 1280
  f.h = 720
  f.y = 0
  f.x = 0

  win:setFrame(f)
end)

hs.hotkey.bind(hyper, '8', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()

  local f = win:frame()
  f.w = 1920
  f.h = 1080
  f.y = 20
  f.x = 0

  win:setFrame(f)
end)

hs.hotkey.bind(hyper, '9', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()

  local f = win:frame()
  f.w = 1920 / 9 * 5
  f.h = 1080
  f.y = 20
  f.x = 0

  win:setFrame(f)
end)

hs.hotkey.bind(hyper, '0', function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()

  local f = win:frame()
  f.w = 1920 / 9 * 4
  f.h = 1080
  f.y = 20 -- (screen:frame().h / 2) - (f.h / 2)
  f.x = 1920 - f.w

  win:setFrame(f)
end)

