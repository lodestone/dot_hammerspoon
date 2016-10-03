local LOGLEVEL = 'debug'


require("hs.ipc")

-- local cheaphints = require "modules/cheaphints"

-- List of modules to load (found in modules/ dir)
local modules = {
  -- 'appwindows',
  -- 'battery',
  -- 'browser',
  -- 'caffeine',
  -- 'cheatsheet',
  'dblcontrol',
  'dblcommand',
  -- 'hazel',
  'notational',
  -- 'scratchpad',
  -- 'songs',
  -- 'timer',
  -- 'weather',
  -- 'wifi',
  -- 'worktime',
}

-- global modules namespace (short for easy console use)
hsm = {}

-- load module configuration
local cfg = require('config')
hsm.cfg = cfg.global

-- global log
hsm.log = hs.logger.new(hs.host.localizedName(), LOGLEVEL)

-- load a module from modules/ dir, and set up a logger for it
local function loadModuleByName(modName)
  hsm[modName] = require('modules.' .. modName)
  hsm[modName].name = modName
  hsm[modName].log = hs.logger.new(modName, LOGLEVEL)
  hsm.log.i(hsm[modName].name .. ': module loaded')
end

-- save the configuration of a module in the module object
local function configModule(mod)
  mod.cfg = mod.cfg or {}
  if (cfg[mod.name]) then
    for k,v in pairs(cfg[mod.name]) do mod.cfg[k] = v end
    hsm.log.i(mod.name .. ': module configured')
  end
end

-- start a module
local function startModule(mod)
  if mod.start == nil then return end
  mod.start()
  hsm.log.i(mod.name .. ': module started')
end

-- stop a module
local function stopModule(mod)
  if mod.stop == nil then return end
  mod.stop()
  hsm.log.i(mod.name .. ': module stopped')
end

-- load, configure, and start each module
hs.fnutils.each(modules, loadModuleByName)
hs.fnutils.each(hsm, configModule)
hs.fnutils.each(hsm, startModule)

-- global function to stop modules and reload hammerspoon config
function hs_reload()
  hs.fnutils.each(hsm, stopModule)
  hs.reload()
end

-- load and bind key bindings
local bindings = require('bindings')
bindings.bind()

-- Disable all window animations
hs.window.animationDuration = 0.5

local LOGLEVEL = 'debug'

-- local expose=hs.expose.new(hs.window.filter.new(nil,true,nil))
-- bind("⌥",'e',function()expose:expose()end,'Expose')


-- switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter())
-- switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter()) -- include minimized/hidden windows, current Space only
-- bind to hotkeys; WARNING: at least one modifier key is required!
-- hs.hotkey.bind('alt','tab','Next window',function()switcher:next()end)
-- hs.hotkey.bind('alt-shift','tab','Prev window',function()switcher:previous()end)

function listerCallback(recognizer, string)
  if string == 'pause' then
    toggleMPV()
    hs.alert.show(string)
  end

  if string == 'play' then
    toggleMPV()
    hs.alert.show(string)
  end

  if string == 'back' then
    backMPV()
    hs.alert.show(string)
  end

  if string == 'forward' then
    fwdMPV()
    hs.alert.show(string)
  end

end

-- -- GOOD -- --
-- listener = hs.speech.listener.new('Bard')
-- listener:commands({'pause', 'play', 'time', 'back', 'forward'})
-- listener:setCallback(listerCallback)
-- listener:start()
-- -- GOOD -- --

-- mpv = hs.appFromWindowTitlePattern("mpv")
-- hs.task.new(launchPath, callbackFn[, streamCallbackFn, arguments])
-- hs.hints.windowHints()


sendKeystroke = function()
  hs.eventtap.keyStroke({},"space")
end

toggleMPV = function()
  hs.application.launchOrFocus("Terminal")
  hs.eventtap.keyStroke({},"space")
  hs.timer.doAfter(1, focusAtom)
end

backMPV = function()
  hs.application.launchOrFocus("Terminal")
  hs.eventtap.keyStroke({},"left")
  hs.timer.doAfter(1, focusAtom)
end

fwdMPV = function()
  hs.application.launchOrFocus("Terminal")
  hs.eventtap.keyStroke({},"right")
  hs.timer.doAfter(1, focusAtom)
end

focusAtom = function()
  hs.application.launchOrFocus("Atom")
end

-- toggleMPV = hs.hotkey.new('alt', 'return', function()
    -- hs.application.launchOrFocus("Terminal")
    -- toggleMPV:disable() -- does not work without this, even though it should
    -- hs.timer.doAfter(1, focusAtom)
  -- end
-- )

-- hs.window.filter.new('Atom')
  -- :subscribe(hs.window.filter.windowFocused,function() toggleMPV:enable() end)
  -- :subscribe(hs.window.filter.windowUnfocused,function() toggleMPV:disable() end)






-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- -- HYPER+L: Open news.google.com in the default browser
-- lfun = function()
--   news = "app = Application.currentApplication(); app.includeStandardAdditions = true; app.doShellScript('open http://news.google.com')"
--   hs.osascript.javascript(news)
--   k.triggered = true
-- end
-- k:bind('', 'l', nil, lfun)

-- HYPER+M: Call a pre-defined trigger in Alfred 3
mfun = function()
  cmd = "tell application \"Alfred 3\" to run trigger \"emoj\" in workflow \"com.sindresorhus.emoj\" with argument \"\""
  hs.osascript.applescript(cmd)
  k.triggered = true
end
k:bind({}, 'm', nil, mfun)

-- HYPER+E: Act like ⌃e and move to end of line.
efun = function()
  hs.eventtap.keyStroke({'⌃'}, 'e')
  k.triggered = true
end
k:bind({}, 'e', nil, efun)

-- HYPER+A: Act like ⌃a and move to beginning of line.
afun = function()
  hs.eventtap.keyStroke({'⌃'}, 'a')
  k.triggered = true
end
k:bind({}, 'a', nil, afun)

k:bind({}, 'n', nil, function() hs.eventtap.keyStroke({'⌃'}, 'n'); k.triggered = true; end)
k:bind({}, 'p', nil, function() hs.eventtap.keyStroke({'⌃'}, 'p'); k.triggered = true; end)
k:bind({}, 'i', nil, function() hs.eventtap.keyStroke({'⇧','⌃', '⌘', '⌥'}, 'i'); k.triggered = true; end)
-- k:bind({}, 'l', nil, function() hs.eventtap.keyStroke({'⌃'}, 'l'); k.triggered = true; end)
k:bind({}, 's', nil, function() hs.task.new('/usr/bin/say', nil, {'Hello, this is a test'}):start(); end)



-- Launch or Focus an App
launch = function(appname)
  hs.application.launchOrFocus(appname)
  k.triggered = true
end
-- k:bind({}, 'f', nil, function() launch('Finder') end)


-- pressedT = function()
--   d:show()
-- end
-- releasedT = function()
--   -- d:setText("")
-- end
-- k:bind({}, 't', nil, pressedT, releasedT)
-- k:bind({}, 'c', nil, function() d:hide(); end)

k:bind({}, 't', nil, function() launch('iTerm2-borderless') end)
k:bind({}, 'e', nil, function() launch('Atom Beta') end)

--------------------------------------------------------------------------
-- Set up a little text overlay to let us know we are in "Launch mode"
r = hs.geometry.rect(10,10,1000,1000)
d = hs.drawing.text(r, "Launching...")
d:setTextFont("Realtime Text")

o = hs.hotkey.modal.new({}, "F16")

-- Hyper+O,F launches Finder
o:bind({}, 'f', function() launch("Finder"); o:exit(); d:hide() end)
o:bind({}, 'e', function() launch("Atom Beta"); o:exit(); d:hide() end)
o:bind({}, 't', function() launch("iTerm2-borderless"); o:exit(); d:hide() end)
o:bind({}, 'ESCAPE', function() o:exit(); d:hide() end)

pressedO = function()
  o:enter()
  d:show()
  k.triggered = true
end
k:bind({}, 'o', nil, pressedO)
--------------------------------------------------------------------------

  -- hs.task.new(launchPath, callbackFn[, streamCallbackFn, arguments])

-- -- HYPER+V: Super Paste
-- vfun = function()
--   hs.eventtap.keyStrokes(hs.pasteboard.getContents())
--   k.triggered = true
-- end
-- k:bind({}, 'v', nil, vfun)
hs.hotkey.bind({"cmd", "shift"}, "v", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)






-----------------------------------------------
-- Reload configs on write
-----------------------------------------------

function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()

hs.alert.show('Hammerspoon Config Loaded', 1)





-- set up your instance(s)
-- expose = hs.expose.new(nil,{showThumbnails=true}) -- default windowfilter, no thumbnails
-- expose_app = hs.expose.new(nil,{onlyActiveApplication=true}) -- show windows for the current application
-- expose_space = hs.expose.new(nil,{includeOtherSpaces=false}) -- only windows in the current Mission Control Space
-- expose_browsers = hs.expose.new{'Safari','Google Chrome'} -- specialized expose using a custom windowfilter
-- for your dozens of browser windows :)

-- then bind to a hotkey
-- hs.hotkey.bind('ctrl-cmd','e','Expose',function()expose:toggleShow()end)
-- hs.hotkey.bind('ctrl-cmd-shift','e','App Expose',function()expose_app:toggleShow()end)
-- k:bind({}, 'RETURN', nil, function() expose:toggleShow() end)







hs.hints.style = 'vimperator'
hs.hotkey.bind({'⌥'}, 'TAB', function() hs.hints.windowHints(hs.window.allWindows()) end)


-- HYPER+R
choices = function()
  return {
   {
    ["text"] = "First Choice",
    ["subText"] = "This is the subtext of the first choice",
    ["uuid"] = "0001"
   },
   { ["text"] = "Second Option",
     ["subText"] = "I wonder what I should type here?",
     ["uuid"] = "Bbbb"
   },
   { ["text"] = "Third Possibility",
     ["subText"] = "What a lot of choosing there is going on here!",
     ["uuid"] = "III3"
   },
  }
end
rfun = function()
  chooser = hs.chooser.new(choices)
  chooser:choices(choices)
  chooser:show()
  k.triggered = true
end
k:bind({}, 'r', nil, rfun)

-- k:bind({}, 't', nil, function() hsm.timer.toggle(); k.triggered = true; end)
k:bind({}, 'l', nil, function() hsm.notational.toggle(); k.triggered = true; end)

spaceFun = function()
  local task = hs.task.new('/usr/bin/open', nil, {'-a', 'Alfred 3'})
  task:start()
  k.triggered = true
end

k:bind({}, 'SPACE', nil, spaceFun)

k:bind({}, 'h', nil, function() hs.hints.windowHints(); k.triggered=true; end)

-- hs.hotkey.bind(mod.hyper,  hs.keycodes.map.space, hsm.notational.toggle)
-- hs.hotkey.bind(mod.as,     hs.keycodes.map.space, hsm.timer.toggle)


-- spaces = require('hs.spaces')
-- -- imitate ios dots for spaces
-- spacesDots = function()
--   local spacesCount  = spaces.count()
--   local currentSpace = spaces.currentSpace();
--   local screenFrame  = hs.screen.allScreens()[1]:fullFrame()
--
--   -- TODO: move to config on top
--   local circleSize          = 8
--   local circleDistance      = 16
--   local circleSelectedAlpha = 0.45
--   local circleAlpha         = 0.15
--
--   -- init circles in cache
--   if spaces == 0 then
--     for i = 1, 9 do
--       local circle = hs.drawing.circle({ x = -10, y = -10, w = circleSize, h = circleSize })
--
--       circle
--         :setStroke(false)
--         :setBehaviorByLabels({ 'canJoinAllSpaces', 'stationary' }) -- stick to all spaces
--         :setLevel(hs.drawing.windowLevels.desktopIcon) -- lay as high as icons (lower values disable click callback?)
--         :setClickCallback(function() hs.eventtap.keyStroke({ 'ctrl' }, i) end) -- switch to space on click
--
--       spaces[i] = circle
--     end
--   end
--
--   -- update circles
--   for i = 1, 9 do
--     local circle = ext.cache.spaces[i]
--     local x      = screenFrame.w / 2 - (spacesCount / 2) * circleDistance + i * circleDistance - circleSize
--     local y      = screenFrame.h - circleDistance
--     local alpha  = i == currentSpace and circleSelectedAlpha or circleAlpha
--
--     circle
--       :setTopLeft({ x = x, y = y })
--       :setFillColor({ red = 1.0, green = 1.0, blue = 1.0, alpha = alpha })
--
--     if i <= spacesCount then
--       circle:show()
--     else
--       circle:hide()
--     end
--   end
-- end
--
-- -- setup dots on startup
-- ext.utils.spacesDots()
--
-- -- spaces watcher
-- ext.watchers.spaces = hs.spaces.watcher.new(ext.utils.spacesDots):start()
