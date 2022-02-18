hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  -- hs.alert.show("Hello World!")
  hs.alert.show(hs.configdir)
  -- hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)


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
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end


-- log system/display sleep/wake
powerEvents = {} -- events are just constant ints from C enum - we want strings -> invert table
for k,v in pairs(hs.caffeinate.watcher) do
  powerEvents[v] = k
end
-- print(hs.inspect(powerEvents))
function powerEvent(ev)
  print('powerEvent: ', powerEvents[ev])
end
powerWatcher = hs.caffeinate.watcher.new(powerEvent):start()


-- reload config manually with shortcut
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)

-- reload config automatically on save
-- symbolic links don't change on write, need to watch target:
configWatcher = hs.pathwatcher.new("~/dotfiles/macos/.hammerspoon/", hs.reload):start()

hs.alert.show("Config loaded")
