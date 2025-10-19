local intention = {}

local watsonIsRunning = hs.settings.get("watsonIsRunning") or false

local watson_tags = "+intention"

local function watson_callback(exitCode, stdOut, stdErr)
  if exitCode == 0 then
    print("watson command successful! Output:\n" .. stdOut)
  else
    print("watson command failed with exit code " .. exitCode .. ". Error:\n" .. stdErr)
  end
end

function intention.start()
  if watsonIsRunning then
    return
  end

  local success, intention_text = hs.osascript.applescript([[
    display dialog "What are you doing here?" default answer "" with icon note with title "Welcome Back"
    return text returned of result
  ]])

  if intention_text ~= "" then
    hs.task.new('/opt/homebrew/bin/watson', watson_callback, { 'start', intention_text, watson_tags }):start()

    watsonIsRunning = true
    hs.settings.set("watsonIsRunning", watsonIsRunning)
  end
end

function intention.stop()
  if not watsonIsRunning then
    return
  end

  hs.task.new('/opt/homebrew/bin/watson', watson_callback, { 'stop' }):start()

  watsonIsRunning = false
  hs.settings.set("watsonIsRunning", watsonIsRunning)
end

return intention
