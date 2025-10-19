package.path = hs.configdir .. "/modules/?.lua;" .. package.path

local intention = require('intention')

local lockWatcher = hs.caffeinate.watcher.new(function(eventType)
  if eventType == hs.caffeinate.watcher.screensDidUnlock then
    intention.start()
  end

  if eventType == hs.caffeinate.watcher.screensDidLock then
    intention.stop()
  end
end)

lockWatcher:start()
