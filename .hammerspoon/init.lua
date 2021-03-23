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
		        })

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
    local action = "unknown"
	if (eventType == hs.caffeinate.watcher.systemWillSleep) then
		hs.alert.show("Going to sleep!")
		host = hs.host.localizedName()
        	action = "sleep"
		-- Set volume of default output device to 10% on sleep 
		hs.audiodevice.defaultOutputDevice():setVolume(10)
	elseif (eventType == hs.caffeinate.watcher.systemDidWake) then
		hs.alert.show("Waking up!")
        	action = "awake"
	end

    -- write current state of laptop lid to file
    if (action ~= "unknown") then
        filename = string.format("%s/mylaptoplid.txt", os.getenv( "HOME" ))
        local f = assert(io.open(filename, "a+"))
        local tstamp = os.date("%d/%m/%y %H:%M:%S")
        local s = string.format("%s %s\n", tstamp, action)
        f:write( s )
        f:flush()
        f:close()
    end
end

local sleepWatcher = hs.caffeinate.watcher.new(sleepWatch)
sleepWatcher:start()

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
      if (appName == "Emacs" or appName == "Terminal") then
      print(appName)
	 if (eventType == hs.application.watcher.activated) then
	    -- Emacs just got focus, disable our hotkeys
	    emacsKeys:exit()
	 elseif (eventType == hs.application.watcher.deactivated) then
	    -- Emacs just lost focus, enable our hotkeys
	    emacsKeys:enter()
	 end
      end
   end
)

watcher:start()
emacsKeys:enter()


