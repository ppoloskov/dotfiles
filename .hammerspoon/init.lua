savedCover = ""


hs.menuIcon(true)

coverDisplay = hs.canvas.new{
   x=100,
   y=100,
   h=50,
   w=50}
   :appendElements(
      {
         type="image",
	 imageScaling = "scaleToFit",
      }
		  )

local coverUrl = ""

local function getCover(exitCode, stdOut,stdErr)
   if exitCode == 0 then
      coverUrl = string.gsub(stdOut, "[\n\r]", "")
      coverDisplay[1].image = hs.image.imageFromURL(coverUrl)
   else
      print("ERROR getting currentTrack " .. stdErr)
   end
end


-- So, lools like osascript is prone to memory leaks, so it's better to minimize it's usage.

-- Let's use window filters to determine what Spotify is playing
spotifyWatcher = hs.window.filter.new(false):setAppFilter('Spotify',{allowTitles=1})
spotifyWatcher:subscribe(
   hs.window.filter.windowTitleChanged,
   function()
      local title = spotifyWatcher:getWindows()[1]:title()
      if title == 'Spotify Premium' then
	 -- savedCover = nil
	 return
      end
      if savedCover ~= title then
	 savedCover = title
	 -- Get coverUrl from cli osascript trying to reduce memory leak
	 hs.task.new(
	    "/usr/bin/osascript",
	    getCover,
	    {
	       "-e",
	       "Application('Spotify').currentTrack.artworkUrl()",
	       "-l",
	       "JavaScript"
	    }
	 ):start()
	 --local ok,coverUrl,_ =
	 --   hs.osascript.javascript("Application('Spotify').currentTrack.artworkUrl()")
	 --coverDisplay[1].image = hs.image.imageFromURL(coverUrl) or nil
      end
end)

function sleepWatch(eventType)
   if (eventType == hs.caffeinate.watcher.screensDidSleep) then
      -- Set volume of default output device to 10% on sleep
      print(hs.audiodevice.defaultOutputDevice():volume())
      hs.audiodevice.defaultOutputDevice():setVolume(10)
      print("Going to sleep, setting volume to 10%")
      print(hs.audiodevice.defaultOutputDevice():name())
      print(hs.audiodevice.defaultOutputDevice():volume())
    elseif (eventType == hs.caffeinate.watcher.systemDidWake) then
       hs.alert.show("Waking up!")
       action = "awake"
       print(hs.audiodevice.defaultOutputDevice():volume())
    end
end

sleepWatcher = hs.caffeinate.watcher.new(sleepWatch)
sleepWatcher:start()

-- Set airpods volume to 35% when connected
hs.audiodevice.watcher.setCallback(function (event_name)
      if hs.audiodevice.current().name:find("AirPods") then
	 print(event_name, "_", "Airpods connected")
	 hs.audiodevice.defaultOutputDevice():setVolume(35)
      end
end)

hs.audiodevice.watcher:start()


-- Add mouse callback to close on click
-- https://www.hammerspoon.org/docs/hs.canvas.html#mouseCallback
-- Examples: https://github.com/asmagill/hammerspoon/wiki/hs.canvas.examples

-- c = hs.canvas.new{
--    x=100,
--    y=100,
--    h=50,
--    w=50}
--    :appendElements(
--       {
-- 	 type="image",
-- 	 image = getSpotifyCover(),
-- 	 imageScaling = "scaleToFit",
-- 		  })

-- c:show()
-- c:setLevel('normal')

-- Print CPU load averaged by all cores
-- print(math.floor(hs.host.cpuUsage().overall.active * 100) / 100)

-- Emacs keybindings I use. Now they work in MS Word
emacsKeys = hs.hotkey.modal.new({}, F20)

emacsKeys:bind({'ctrl'}, 'k',
   function()
      hs.eventtap.keyStroke({"command", "shift"}, "right", 100000)
      hs.eventtap.keyStroke({"command"}, "x", 100000)
   end
)

emacsKeys:bind({'ctrl'}, 'a', function() hs.eventtap.keyStroke({"cmd"}, "left") end)
emacsKeys:bind({'ctrl'}, 'e', function() hs.eventtap.keyStroke({"cmd"}, "right") end)

-- Create and start the application event watcher
-- with a callback function to be called when application events happen
watcher = hs.application.watcher.new(
   function (appName, eventType, appObject)
      if (eventType == hs.application.watcher.activated) then
	 if (appName == "Emacs" or appName == "Terminal") then
	    -- Emacs just got focus, disable our hotkeys
	    emacsKeys:exit()
	 else
	    --if (eventType == hs.application.watcher.deactivated) then
	    -- Emacs just lost focus, enable our hotkeys
	    emacsKeys:enter()
	 end
      end
   end
)

watcher:start()
emacsKeys:enter()

for _, dev in pairs(hs.audiodevice.allDevices()) do
   if dev:name():find("Airpods") then
      print("Airpods")
   end
end

