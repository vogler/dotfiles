-- Getting Started: https://www.hammerspoon.org/go/
-- https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/
-- https://github.com/heptal/dotfiles/blob/master/roles/hammerspoon/files/init.lua
-- https://github.com/ashfinal/awesome-hammerspoon

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "w", function()
--   hs.alert.show(hs.configdir)
--   -- hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
-- end)
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "h", function()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
--   f.x = f.x - 10
--   win:setFrame(f)
-- end)

-- aliases
bind = hs.hotkey.bind
hyper = {'cmd', 'alt', 'ctrl'}
fn = {'fn'}

-- reload config manually
bind(hyper, 'r', hs.reload)
-- reload config automatically on save
-- symbolic links don't change on write, so can't watch hs.configdir, but need to watch its target
configWatcher = hs.pathwatcher.new("~/dotfiles/macos/.hammerspoon/", hs.reload):start()

bind(hyper, "h", hs.toggleConsole)
bind(hyper, '.', hs.hints.windowHints)


-- Spoons - https://www.hammerspoon.org/Spoons/ are distributed as zip files...
-- Spoon to install and manage: http://www.hammerspoon.org/Spoons/SpoonInstall.html
-- but will just commit the symlinked Spoons directory
-- hs.loadSpoon("HSKeybindings") -- display cheatsheet in a webview - but only shows hotkeys
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function() spoon.HSKeybindings:show() end)
hs.loadSpoon("KSheet") -- Keybindings cheatsheet for current application
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function() spoon.KSheet:toggle() end)
-- hs.loadSpoon("FnMate") -- Use Fn + `h/l/j/k` as arrow keys, `y/u/i/o` as mouse wheel, `,/.` as left/right click. Does not work at all or sends keys to wrong window.

-- Fix FnMate (and shift right yuio to uiop, add wasd as alternative for hjkl)
-- Odd behavior for newKeyEvent that FnMate uses is mentioned in the notes: https://www.hammerspoon.org/docs/hs.eventtap.event.html#newKeyEvent - only sends keyDown which confuses many apps -> can use hs.eventtap.keyStroke or newKeyEventSequence instead.
-- hs.hotkey.bind({'fn'}, 'k', function() hs.eventtap.event.newKeyEvent({}, "up", true) end) -- this will not cancel k
local function FnMate(event)
    local fn = event:getFlags()['fn']
    local ch = event:getCharacters()
    local ke = hs.eventtap.event.newKeyEventSequence
    if not fn then return end
    -- Mouse scrolls window under cursor instead of focused window which is what I want when using the mouse, but not when scrolling via keyboard. So this function centers the mouse on the focused window which is hopefully a good position for scrolling.
    local function centerMouse()
      local f = hs.window.focusedWindow():frame()
      -- only move mouse if it is outside the focused window - can be commented out to always center
      if not hs.geometry(hs.mouse.absolutePosition()):inside(f) then
        hs.mouse.absolutePosition(f.center)
      end
    end
    if ch == 'h' or ch == 'a' then
        return true, ke({}, 'left')
    elseif ch == 'l' or ch == 'd' then
        return true, ke({}, 'right')
    elseif ch == 'j' or ch == 's' then
        return true, ke({}, 'down')
    elseif ch == 'k' or ch == 'w' then
        return true, ke({}, 'up')
    elseif ch == 'u' then
        centerMouse()
        return true, {hs.eventtap.event.newScrollEvent({3, 0}, {}, 'line')}
    elseif ch == 'i' then
        centerMouse()
        return true, {hs.eventtap.event.newScrollEvent({0, -3}, {}, 'line')}
    elseif ch == 'o' then
        centerMouse()
        return true, {hs.eventtap.event.newScrollEvent({0, 3}, {}, 'line')}
    elseif ch == 'p' then
        centerMouse()
        return true, {hs.eventtap.event.newScrollEvent({-3, 0}, {}, 'line')}
    elseif ch == ',' then
        return true, {hs.eventtap.leftClick(hs.mouse.absolutePosition())}
    elseif ch == '.' then
        return true, {hs.eventtap.rightClick(hs.mouse.absolutePosition())}
    end
end
fn_tapper = hs.eventtap.new({hs.eventtap.event.types.keyDown}, FnMate):start()


-- Books.app: map scroll to left/right when focused
booksScrollWatcher = hs.eventtap.new({hs.eventtap.event.types.scrollWheel}, function(event)
    local w = hs.window.focusedWindow()
    -- hs.alert.show(w:application():name())
    -- note that this will not scroll the window under the cursor but always Books if focused
    if w:application():name() == 'Books' and w:title() ~= 'Books' then -- don't remap the main Books window, but just opened Book windows which will have the title of the book
      local direction = event:getProperty(hs.eventtap.event.properties.scrollWheelEventFixedPtDeltaAxis1)
      if direction > 0 then
        return true, hs.eventtap.event.newKeyEventSequence({}, 'left')
      elseif direction < 0 then
        return true, hs.eventtap.event.newKeyEventSequence({}, 'right')
      end
    end
end)
-- booksScrollWatcher:start() -- this will always watch, but we only need it if Books is active
local booksWindowFilter = hs.window.filter.new('Books')
-- TODO sometimes it triggers unfocus when switching between Books windows
booksWindowFilter:subscribe(hs.window.filter.windowFocused, function()
  hs.alert.show('books')
  booksScrollWatcher:start()
end)
booksWindowFilter:subscribe(hs.window.filter.windowUnfocused, function()
  hs.alert.show('unbooks')
  booksScrollWatcher:stop()
end)


-- example for showing a website
function showWebview()
    mousepoint = hs.mouse.absolutePosition()
    rect = hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 800, 800)
    webview = hs.webview.newBrowser(rect) -- new is without window title bar, need to close programmatically then
    webview:url('https://www.tvtoday.de/programm/tv-programm-nach-zeit/')
    webview:show()
end
-- hs.hotkey.bind({"cmd","alt","shift"}, "D", showWebview)


-- example for menubar entry
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("AWAKE")
    else
        caffeine:setTitle("SLEEPY")
    end
end
function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
    -- showWebview() -- shows in background...
end
if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end


-- log system/display sleep/wake
powerEvents = {} -- events are just constant ints from C enum - we want strings -> invert table
-- http://www.hammerspoon.org/docs/hs.caffeinate.watcher.html
for k,v in pairs(hs.caffeinate.watcher) do
  powerEvents[v] = k
end
-- print(hs.inspect(powerEvents))
-- { [0] = "systemDidWake", "systemWillSleep", "systemWillPowerOff", "screensDidSleep", "screensDidWake", "sessionDidResignActive", "sessionDidBecomeActive", "screensaverDidStart", "screensaverWillStop", "screensaverDidStop", "screensDidLock", "screensDidUnlock" }
function powerEvent(ev)
  print('powerEvent: ', powerEvents[ev])
end
powerWatcher = hs.caffeinate.watcher.new(powerEvent):start()


-- keep this at the end
hs.alert.show('Config loaded 👍')
