local function autofarm()
  loadstring(game:HttpGet("https://paste.debian.net/plainh/80540862/", true))()
end

local function library()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/exploiter101/ExclusiveScripts/refs/heads/main/AutoFarmLib"))()
end

task.spawn(autofarm)
task.spawn(library)
