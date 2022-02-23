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
-- hs.loadSpoon("FnMate") -- Use Fn + `h/l/j/k` as arrow keys, `y/u/i/o` as mouse wheel, `,/.` as left/right click. Does not work at all or sends keys to wrong window. Problem is likely that it only replaces keyDown events.

-- TODO try to fix it myself
-- hs.hotkey.bind({'fn'}, 'k', function() hs.eventtap.event.newKeyEvent({}, "up", true) end) -- this will not cancel k
local function catcher(event)
    if event:getFlags()['fn'] and event:getCharacters() == "h" then
        return true, {hs.eventtap.event.newKeyEvent({}, "left", true)}
    elseif event:getFlags()['fn'] and event:getCharacters() == "l" then
        return true, {hs.eventtap.event.newKeyEvent({}, "right", true)}
    elseif event:getFlags()['fn'] and event:getCharacters() == "j" then
        return true, {hs.eventtap.event.newKeyEvent({}, "down", true)}
    elseif event:getFlags()['fn'] and event:getCharacters() == "k" then
        return true, {hs.eventtap.event.newKeyEvent({}, "up", true)}
    elseif event:getFlags()['fn'] and event:getCharacters() == "y" then
        return true, {hs.eventtap.event.newScrollEvent({3, 0}, {}, "line")}
    elseif event:getFlags()['fn'] and event:getCharacters() == "o" then
        return true, {hs.eventtap.event.newScrollEvent({-3, 0}, {}, "line")}
    elseif event:getFlags()['fn'] and event:getCharacters() == "u" then
        return true, {hs.eventtap.event.newScrollEvent({0, -3}, {}, "line")}
    elseif event:getFlags()['fn'] and event:getCharacters() == "i" then
        return true, {hs.eventtap.event.newScrollEvent({0, 3}, {}, "line")}
    elseif event:getFlags()['fn'] and event:getCharacters() == "," then
        local currentpos = hs.mouse.getAbsolutePosition()
        return true, {hs.eventtap.leftClick(currentpos)}
    elseif event:getFlags()['fn'] and event:getCharacters() == "." then
        local currentpos = hs.mouse.getAbsolutePosition()
        return true, {hs.eventtap.rightClick(currentpos)}
    end
end
fn_tapper = hs.eventtap.new({hs.eventtap.event.types.keyDown}, catcher):start()


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
