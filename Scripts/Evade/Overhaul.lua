local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/AloeliuEJGJPWFJGWJSGPKSGM/main/Fluent/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/AloeliuEJGJPWFJGWJSGPKSGM/main/Fluent/SaveManager.lua"))()
local FBM = loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/AloeliuEJGJPWFJGWJSGPKSGM/main/Fluent/FloatingButton.Lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/AloeliuEJGJPWFJGWJSGPKSGM/main/Fluent/InterfaceManager.lua"))()

if not Fluent or not SaveManager or not InterfaceManager or not FBM then
    return game.Players.LocalPlayer:Kick("Error: Interface didn't load")
end

if _G.ElderwyrmHubXIsAlreadyRunning then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script is already running!",
        Text = ""
    })
    return
end

_G.ElderwyrmHubXIsAlreadyRunning = true

getgenv().ButtonGradients = getgenv().ButtonGradients or {
    Background = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
    }),
    Stroke = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 255))
    })
}

local Window = Fluent:CreateWindow({
    Title = "Elderwyrm Hub X - Evade Overhaul",
    SubTitle = "V2.9.2 Made by Vraigos and Aerave",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Azure",
    MinimizeKey = Enum.KeyCode.LeftControl
})

Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://7733960981" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farms", Icon = "rbxassetid://10709811110" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "rbxassetid://10734975692" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://7734068321" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "rbxassetid://10709819149" }),
    Info = Window:AddTab({ Title = "Info", Icon = "rbxassetid://10723415903" }),
    Settings = Window:AddTab({ Title = "Configuration", Icon = "rbxassetid://7734052335" }),
    Extension = Window:AddTab({ Title = "Extension", Icon = "rbxassetid://10734930886" })
}

local Options = Fluent.Options

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local CAS = game:GetService("ContextActionService")

local function GetAutoDuration()
    local dt = RunService.RenderStepped:Wait()
    local fps = 1 / dt
    local duration = 60 / math.clamp(fps, 5, 60)
    return math.clamp(duration, 1, 6)
end

local Duration = GetAutoDuration()

local openshit = Instance.new("ScreenGui")
openshit.Name = "openshit"
openshit.Parent = LocalPlayer.PlayerGui
openshit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
openshit.ResetOnSpawn = false

local mainopen = Instance.new("TextButton")
mainopen.Name = "mainopen"
mainopen.Parent = openshit
mainopen.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainopen.BackgroundTransparency = 1
mainopen.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
mainopen.Size = UDim2.new(0, 64, 0, 42)
mainopen.Text = ""
mainopen.Visible = true

local mainopens = Instance.new("UICorner")
mainopens.Parent = mainopen

local SizeBackMulti = 0.1

local function DownloadAsset(url, filename)
    local request = http_request or (syn and syn.request) or request
    if not request then return nil end
    local ok, response = pcall(function()
        return request({ Url = url, Method = "GET" }).Body
    end)
    if not ok or not response then return nil end
    writefile(filename, response)
    return getcustomasset(filename)
end

local AssetsIcon = DownloadAsset(
    "https://raw.githubusercontent.com/Vraigos/Elderwyrm-Hub-X/03664e8f5718dcf889a6827c5613d51685c98151/images/AssetsIcon.png",
    "AssetsIcon.png"
) or ""

local AssetsBackground = DownloadAsset(
    "https://raw.githubusercontent.com/Vraigos/Elderwyrm-Hub-X/03664e8f5718dcf889a6827c5613d51685c98151/images/AssetsBackground.png",
    "AssetsBackground.png"
) or ""

local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "RotatingBackground"
backgroundImage.Parent = mainopen
backgroundImage.Size = UDim2.new(1.8 + SizeBackMulti, 0, 1.8 + SizeBackMulti, 0)
backgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
backgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = AssetsBackground
backgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
backgroundImage.ZIndex = 0

local WIDTH = 0.85
local HEIGHT = 1

local frontImage = Instance.new("ImageLabel")
frontImage.Name = "StaticIcon"
frontImage.Parent = mainopen
frontImage.Size = UDim2.new(WIDTH, 0, HEIGHT, 0)
frontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
frontImage.AnchorPoint = Vector2.new(0.5, 0.5)
frontImage.BackgroundTransparency = 1
frontImage.Image = AssetsIcon
frontImage.ZIndex = 1
frontImage.ScaleType = Enum.ScaleType.Stretch

local frontCorner = Instance.new("UICorner")
frontCorner.CornerRadius = UDim.new(1, 0)
frontCorner.Parent = frontImage

local rotation = 0
local speed = 90
local lastTime = tick()

task.spawn(function()
    while true do
        local now = tick()
        local delta = now - lastTime
        lastTime = now
        rotation = (rotation + speed * delta) % 360
        backgroundImage.Rotation = rotation
        task.wait()
    end
end)

local function MakeDraggable(topbarobject, object, locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0

    object:SetAttribute("Locked", locked or false)

    local function Update(input)
        if object:GetAttribute("Locked") then return end
        local delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end

    local function ToggleLock()
        local newState = not object:GetAttribute("Locked")
        object:SetAttribute("Locked", newState)
        Fluent:Notify({
            Title = newState and "Button Locked" or "Button Unlocked",
            Content = newState and "This button is now locked in place." or "This button can now be moved.",
            Duration = 2
        })
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        Dragging = not object:GetAttribute("Locked")
        Holding = true
        DragStart = input.Position
        StartPosition = object.Position

        HoldToken += 1
        local token = HoldToken

        task.delay(HoldTime, function()
            if Holding and token == HoldToken then
                ToggleLock()
            end
        end)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    topbarobject.InputChanged:Connect(function(input)
        if not DragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            if (input.Position - DragStart).Magnitude > MoveCancelThreshold then
                Holding = false
            end
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

MakeDraggable(mainopen, mainopen, false)

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

mainopen.MouseButton1Click:Connect(function()
    local sounds = { "7127123605", "137566474343039", "438666542", "257001341", "257000833", "7127123554", "131607746976396", "97325669841459", "109312518223078" }
    playSound(sounds[math.random(#sounds)])
    Window:Minimize()

    local function smoothSpeed(target, duration)
        local start = speed
        local steps = 30
        for i = 1, steps do
            speed = start + (target - start) * (i / steps)
            task.wait(duration / steps)
        end
        speed = target
    end

    smoothSpeed(360, 0.4)
    task.wait(0.5)
    smoothSpeed(180, 0.4)
    task.wait(0.3)
    smoothSpeed(90, 0.4)
end)

local Stats = game:GetService("Stats")

local fpsCounter = Instance.new("ScreenGui")
fpsCounter.Name = "FPSCounter"
fpsCounter.Parent = game.CoreGui
fpsCounter.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fpsCounter.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = fpsCounter
frame.Size = UDim2.new(0, 180, 0, 80)
frame.Position = UDim2.new(0, 300, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.7

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradient.Parent = frame

task.spawn(function()
    while task.wait(0.03) do
        gradient.Rotation = (gradient.Rotation + 1) % 360
    end
end)

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(80, 180, 255)
uiStroke.Parent = frame

task.spawn(function()
    local a = Color3.fromRGB(80, 180, 255)
    local b = Color3.fromRGB(255, 255, 255)
    local t, d = 0, 1
    while task.wait(0.03) do
        t += 0.02 * d
        if t >= 1 then t, d = 1, -1 elseif t <= 0 then t, d = 0, 1 end
        uiStroke.Color = a:Lerp(b, t)
    end
end)

local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1, -10, 1, -10)
label.Position = UDim2.new(0, 5, 0, 5)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBlack
label.TextSize = 10
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.Text = "FPS: 0 | Ping: 0 ms\nClient Timer: 0h 0m 0s"

MakeDraggable(frame, frame, false)

local function GetPing()
    local n = Stats:FindFirstChild("Network")
    if not n then return 0 end
    local s = n:FindFirstChild("ServerStatsItem")
    if not s then return 0 end
    local p = s:FindFirstChild("Data Ping")
    if not p then return 0 end
    return math.floor(p:GetValue())
end

local startTime = tick()
local lastUpdateTime = startTime
local frameCount = 0
local previousText = ""

RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    local dt = now - lastUpdateTime

    if dt >= 1 then
        local fps = math.round(frameCount / dt)
        local elapsed = now - startTime
        local h = math.floor(elapsed / 3600)
        local m = math.floor((elapsed % 3600) / 60)
        local s = math.floor(elapsed % 60)
        local ping = GetPing()

        local text = string.format(
            "FPS: %d | Ping: %d ms\nClient Timer: %dh %dm %ds",
            fps, ping, h, m, s
        )

        if text ~= previousText then
            label.Text = text
            previousText = text
        end

        lastUpdateTime = now
        frameCount = 0
    end
end)

if require then
    print("Supported require()")
end
if firetouchinterest then
    print("Supported firetouchinterest()")
end
if game.Players then
    print("Advance Api")
else
    print("Common Api")
end

local DFunctions = {}
local DConfiguration = {
    ESP = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Tracers = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Highlight = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
        OutlineOnly = false,
    },
    Boxes = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Removals = {
        CameraShake = false,
        Vignette = false,
        InvisibleWalls = false,
        ReducingRewards = false,
        DamageParts = false,
    },
    Main = {
        AntiAFK = true,
        AutoRespawn = false,
        RespawnType = "Spawnpoint",
        AutoWhistle = false,
        ShowTimer = false,
        Fly = false,
        FlySpeed = 20,
        Noclip = false,
    },
    Battlepass = {
        BypassTimer = false,
    },
    AutoFarm = {
        FarmingStates = {
            IsReviving = false,
            IsCompletingObjective = false,
            IsCollectingTickets = false,
            IsCatchingNPC = false,
        },
        AFKFarm = false,
        FarmTickets = false,
        CompleteObjective = false,
        FarmTokens = false,
        PurchaseAutomations = {
            Enabled = false,
            Selected = "Cola",
        },
        VIPAutomations = {
            AutoVote = false,
            MapSection = 1,
            GamemodeSection = 1,
            AutoMap = false,
            MapInput = "DesertBus",
            AutoSpecialRound = false,
            SpecialRoundInput = "Plushie Hell",
            AutoTimer = false,
            TimerInput = "",
            AutoProMode = false,
        },
    },
    Combat = {
        AntiNextbot = false,
        AntiNextbotRange = 15,
        AntiNextbotType = "Spawn",
    },
    Misc = {
        PlayerAdjustment = {
            Default = {
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                JumpAcceleration = 1.5,
                AirStrafe = 182,
                GroundAcceleration = 5,
                BHOPEnabled = false,
            },
            Update = {
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                JumpAcceleration = 1.5,
                AirStrafe = 182,
                GroundAcceleration = 5,
                BHOPEnabled = false,
            },
            Saved = {
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                JumpAcceleration = 1.5,
                AirStrafe = 182,
                GroundAcceleration = 5,
            },
            Tick = {
                Speed = 0,
                JumpHeight = 0,
                JumpCap = 0,
                JumpAcceleration = 0,
                AirStrafe = 0,
                GroundAcceleration = 0,
                BHOPEnabled = 0,
            },
            Debounce = {
                Speed = false,
                JumpHeight = false,
                JumpCap = false,
                JumpAcceleration = false,
                AirStrafe = false,
                GroundAcceleration = false,
                BHOPEnabled = false,
            },
        },
        Humanoids = {
            WalkspeedCF = false,
            OriginalJumpHeight = false,
            CF = 5,
            JP = 20,
        },
        Utilities = {
            GetCurrentSpeed = 0,
            BounceModification = {
                Enabled = false,
                DefaultBounce = 80,
                EmoteBounce = 120,
                SuperBounce = false,
                SuperBounceStrength = -50,
            },
            EdgeTrimpModification = {
                Enabled = false,
                HeightMultiplier = 1.5,
                DownThreshold = 4.5
            },
            LagSwitch = {
                MSDelay = 200,
                Mode = "Normal",
            },
        },
        CameraAdjustment = {
            StretchX = 1,
            StretchY = 1,
        },
        GunAdjustment = {
            v = nil,
        },
        GameAutomation = {
            Revive = {
                Enabled = false,
                FloatingButton = false,
                Keybind = false,
                WhileEmote = false,
                Delay = 0.1,
            },
            Carry = {
                Enabled = false,
                FloatingButton = false,
                Keybind = false,
                WhileEmote = false,
            },
            Macro = {
                SelectedEmote = "BoldMarch",
                FloatingButton = false,
                Keybind = false,
            },
        },
        MovementModification = {
            AggressiveEmoteDash = {
                Enabled = false,
                Type = "Blatant",
                Speed = 3000,
                Acceleration = -2,
            },
            SlideModification = {
                FloatingButton = false,
                Enabled = false,
                Acceleration = -3,
            },
            Gravity = {
                FloatingButton = false,
                Keybind = false,
                Value = 10,
            },
            BHOP = {
                Enabled = false,
                Keybind = false,
                HoldKeybind = false,
                FloatingButton = false,
                JumpButton = false,
                HipHeight1 = 0,
                HipHeight2 = 0,
                lastTick = 0.01,
                Settings = {
                    AutoAcceleration = {
                        Enabled = false,
                        MaxAccelerate = 3,
                        MinAccelerate = -1,
                        MinSpeed = 70
                    },
                    SpiderHop = false,
                    Backwards = false,
                    Type = "Acceleration",
                    JumpType = "Simulated",
                    Acceleration = -0.1,
                },
            },
            Crouch = {
                FloatingButton = false,
                Keybind = false,
                Type = "Rapid",
                isHolding = false,
                debounce = 0.1,
                lastTick = 0.1,
                lastReleaseTick = 0.1,
            },
        },
    },
    Visual = {
        OriginalCosmetics = {
            Cosmetics1 = "",
            Cosmetics2 = "",
            Cosmetics3 = "",
            Cosmetics4 = "",
        },
        ModifyCosmetics = {
            Cosmetics1 = "",
            Cosmetics2 = "",
            Cosmetics3 = "",
            Cosmetics4 = "",
        },
        OriginalEmotes = {
            Emote1 = "",
            Emote2 = "",
            Emote3 = "",
            Emote4 = "",
            Emote5 = "",
            Emote6 = "",
            Emote7 = "",
            Emote8 = "",
            Emote9 = "",
            Emote10 = "",
            Emote11 = "",
            Emote12 = "",
        },
        ModifyEmotes = {
            Emote1 = "",
            Emote2 = "",
            Emote3 = "",
            Emote4 = "",
            Emote5 = "",
            Emote6 = "",
            Emote7 = "",
            Emote8 = "",
            Emote9 = "",
            Emote10 = "",
            Emote11 = "",
            Emote12 = "",
        },
    },
    Settings = {
        GuiScale = {
            Respawn = 0,
            SuperBounce = 0,
            AutoCarry = 0,
            InstantRevive = 0,
            AutoEmoteDash = 0,
            Gravity = 0,
            InfiniteSlide = 0,
            AutoJump = 0,
            AutoCrouch = 0,
            LagSwitch = 0,
        },
    },
}

function CreateBillboardESP(...) return nil end
function UpdateBillboardESP(...) return false end
function DestroyBillboardESP(...) return false end
function CreateTracerESP(...) return nil end
function UpdateTracerESP(...) end
function DestroyTracerESP(...) end
function CreateHighlightESP(...) return false end
function UpdateHighlightESP(...) return false end
function DestroyHighlightESP(...) return false end

function DFunctions.CreateButton(ButtonName, Name, Size1, Size2, ScriptLogic, CircleMode)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = ButtonName
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Name = ButtonName
    frame.Size = UDim2.new(Size1, 0, Size2, 0)
    frame.Position = UDim2.new(0.5 - Size1 / 2, 0, 0.5 - Size2 / 2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.7
    frame.Parent = screenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = getgenv().ButtonGradients.Background
    gradient.Parent = frame

    task.spawn(function()
        while task.wait(0.03) do
            gradient.Rotation = (gradient.Rotation + 1) % 360
            gradient.Color = getgenv().ButtonGradients.Background
        end
    end)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = frame

    local gradientstroke = Instance.new("UIGradient")
    gradientstroke.Color = getgenv().ButtonGradients.Stroke
    gradientstroke.Rotation = 0
    gradientstroke.Parent = stroke

    task.spawn(function()
        while frame.Parent do
            gradientstroke.Rotation = (gradientstroke.Rotation + 0.5) % 360
            gradientstroke.Color = getgenv().ButtonGradients.Stroke
            task.wait()
        end
    end)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = Name
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 24
    button.TextScaled = false
    button.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 28, 0, 28)
    toggle.Position = UDim2.new(1, 6, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.Text = "○"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Visible = false
    toggle.Parent = frame

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = toggle

    local originalSize = UDim2.new(Size1, 0, Size2, 0)
    local holding = false
    local holdStart = 0
    local hideAt = 0

    frame:SetAttribute("IsCircle", false)

    local isCircle = CircleMode ~= nil and CircleMode or frame:GetAttribute("IsCircle")

    local function applyShape(circle)
        frame:SetAttribute("IsCircle", circle)
        local s = math.min(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
        if circle then
            frame.Size = UDim2.new(0, s, 0, s)
            button.TextWrapped = true
            button.TextScaled = true
            button.TextSize = math.floor(s * 0.45)
            corner.CornerRadius = UDim.new(1, 0)
            toggle.Text = "▢"
        else
            frame.Size = originalSize
            button.TextWrapped = false
            button.TextScaled = false
            button.TextSize = 24
            corner.CornerRadius = UDim.new(0, 15)
            toggle.Text = "○"
        end
    end

    applyShape(isCircle)

    task.spawn(function()
        while task.wait(0.25) do
            if toggle.Visible and tick() - hideAt >= 10 then
                toggle.Visible = false
            end
        end
    end)

    button.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            holding = true
            holdStart = tick()
        end
    end)

    button.InputEnded:Connect(function(i)
        if holding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            holding = false
            if tick() - holdStart >= 0.6 then
                toggle.Visible = true
                hideAt = tick()
            end
        end
    end)

    toggle.MouseButton1Click:Connect(function()
        hideAt = tick()
        local current = frame:GetAttribute("IsCircle")
        applyShape(not current)
    end)

    button.Activated:Connect(function()
        if ScriptLogic then
            ScriptLogic(button)
        end
    end)

    FBM:AddButton(ButtonName, frame, false)
    MakeDraggable(button, frame, false)

    return button
end

function DFunctions.UpdateButton(Name, Size1, Size2)
    local gui = LocalPlayer.PlayerGui:FindFirstChild(Name)
    if gui then
        local frame = gui:FindFirstChild(Name)
        if frame then
            frame.Size = UDim2.new(Size1, 0, Size2, 0)
            local isCircle = frame:GetAttribute("IsCircle")
            if isCircle then
                local s = math.min(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
                frame.Size = UDim2.new(0, s, 0, s)
            end
        end
    end
end

function DFunctions.DestroyButton(Name)
    local gui = LocalPlayer.PlayerGui:FindFirstChild(Name)
    if gui then
        gui:Destroy()
    end
end

function DFunctions.AutoRespawn() end
function DFunctions.RemoveDamagePart() end
function DFunctions.DisableTouch() end
function DFunctions.CreateTimer() end
function DFunctions.RemoveTimer() end
function DFunctions.RemoveReduceRewards() end
function DFunctions.DisableInvisParts() end
function DFunctions.DisableCameraShake() end
function DFunctions.DisableVignette() end
function DFunctions.GetDownedPlayer() return nil end
function DFunctions.GetEventNPC() return nil end
function DFunctions.TPEventNPC() end
function DFunctions.GetObjective() return nil end
function DFunctions.AFKFarming() end
function DFunctions.RevivePlayer() end
function DFunctions.PointFarming() end
function DFunctions.TicketsFarming() end
function DFunctions.AutoVote() end
function DFunctions.SetVIPCommands() end
function DFunctions.BuyItem() end
function DFunctions.GetEmotesName() return {} end
function DFunctions.GetLoadoutName() return {} end
function DFunctions.AntiNextbot() end
function DFunctions.GetAdjustments() end
function DFunctions.setTSpeed() end
function DFunctions.setTJump() end
function DFunctions.setTJumpCap() end
function DFunctions.setTJumpAcceleration() end
function DFunctions.setTFriction() end
function DFunctions.setBhopEnabled() end
function DFunctions.setStrafeAcceleration() end
function DFunctions.SetPreviousAdjustment() end
function DFunctions.GetSpeedometer() return nil end
function DFunctions.BounceFunction() end
function DFunctions.SuperBounce() end
function DFunctions.StartLag() end
function DFunctions.ModifyEdgeTrimp() end
function DFunctions.getNearestDownedPlayer() return nil end
function DFunctions.InstantRevive() end
function DFunctions.CarryPlayer() end
function DFunctions.AggressiveEmoteDashFunction() end
function DFunctions.SetToMovableEmote() end
function DFunctions.InfiniteSlideFunction() end
function DFunctions.BHOPFunction() end
function DFunctions.ResetBHOP() end
function DFunctions.CrouchFunction() end
function DFunctions.Normalize(input) return input end
function DFunctions.FindRealName() return nil end
function DFunctions.ChangeCosmetics() end
function DFunctions.RestoreCosmetics() end
function DFunctions.ChangeAnimation() end
function DFunctions.ChangeEmotes() end
function DFunctions.ResetEmoteChanges() end
function DFunctions.RestoreEmoteChanges() end
function DFunctions.Noclip() end

local EmoteNames = {"BoldMarch", "DefaultEmote"}
local LoadoutNames = {"Cola", "DefaultItem"}

Tabs.Main:AddSection("Billboard ESP")

local Toggle = Tabs.Main:AddToggle("BillboardNextbots", {Title = "Billboard Nextbots", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.ESP.Nextbots = value
end)

local Toggle = Tabs.Main:AddToggle("BillboardPlayers", {Title = "Billboard Players", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.ESP.Players = value
end)

local Toggle = Tabs.Main:AddToggle("BillboardTicket", {Title = "Billboard Tickets", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.ESP.Tickets = State
end)

Tabs.Main:AddSection("Tracer ESP")

local Toggle = Tabs.Main:AddToggle("TracersPlayers", {Title = "Tracer Players", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Tracers.Players = State
end)

local Toggle = Tabs.Main:AddToggle("TracersBots", {Title = "Tracer Bots", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Tracers.Nextbots = State
end)

local Toggle = Tabs.Main:AddToggle("TracerTickets", {Title = "Tracer Tickets", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Tracers.Tickets = State
end)

Tabs.Main:AddSection("Highlight ESP")

local Toggle = Tabs.Main:AddToggle("HighlightNextbot", {Title = "Highlight Nextbots", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Highlight.Nextbots = value
end)

local Toggle = Tabs.Main:AddToggle("HighlightPlayers", {Title = "Highlight Players", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Highlight.Players = value
end)

local Toggle = Tabs.Main:AddToggle("HighlightTicket", {Title = "Highlight Tickets", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Highlight.Tickets = State
end)

Tabs.Main:AddSection("Game Modification")

local Toggle = Tabs.Main:AddToggle("AutoRespawn", {Title = "Auto Respawn", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.AutoRespawn = value
end)

local Toggle = Tabs.Main:AddToggle("RespawnButton", {Title = "Respawn (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("RespawnButton", "Respawn", 0.15 + DConfiguration.Settings.GuiScale.Respawn, 0.1 + DConfiguration.Settings.GuiScale.Respawn, function(btn)
            btn.Text = "Respawning..."
            wait(0.1)
            btn.Text = "Respawned!"
            wait(0.2)
            btn.Text = "Respawn"
        end)
    else
        DFunctions.DestroyButton("RespawnButton")
    end
end)

Tabs.Main:AddInput("RespawnButtonSize", {
    Title = "Respawn Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.Respawn),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.Respawn = num * 0.01
        else
            DConfiguration.Settings.GuiScale.Respawn = 0
        end
        DFunctions.UpdateButton("RespawnButton", 0.15 + DConfiguration.Settings.GuiScale.Respawn, 0.1 + DConfiguration.Settings.GuiScale.Respawn)
    end
})

Tabs.Main:AddButton({
    Title = "Force Respawn",
    Description = "",
    Callback = function()
    end
})

local Dropdown = Tabs.Main:AddDropdown("RespawnType", {
    Title = "Respawn Type",
    Values = {"Spawnpoint", "Fake Revive"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(value)
    DConfiguration.Main.RespawnType = value
end)

Tabs.Main:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Main:AddToggle("AutoWhistle", {Title = "Auto Whistle", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.AutoWhistle = value
end)

Tabs.Main:AddSection("Alternative Settings")

local Toggle = Tabs.Main:AddToggle("AntiAfk", {Title = "Anti-AFK", Default = false })
Toggle:OnChanged(function()
end)
pcall(function() Options.AntiAfk:SetValue(true) end)

local Toggle = Tabs.Main:AddToggle("ShowTimer", {Title = "Show Timer", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Main.ShowTimer = State
end)

local Toggle = Tabs.Main:AddToggle("DisableCameraShake", {Title = "Disable Camera Shake", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.CameraShake = value
end)

local Toggle = Tabs.Main:AddToggle("DisableVignette", {Title = "Disable Vignette", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.Vignette = value
end)

Tabs.Main:AddButton({
    Title = "Open Leaderboard",
    Description = "",
    Callback = function()
    end
})

Tabs.Main:AddSection("Map Modification")

local Toggle = Tabs.Main:AddToggle("RemoveDamage", {Title = "Remove Damage Objects", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.DamageParts = value
end)

local Toggle = Tabs.Main:AddToggle("RemoveReducingRewards", {Title = "Remove Reducing Rewards", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.ReducingRewards = value
end)

local Toggle = Tabs.Main:AddToggle("RemoveInvisibleWalls", {Title = "Remove Invisible Walls", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.InvisibleWalls = value
end)

Tabs.Main:AddSection("Battlepass Modification")

local Toggle = Tabs.Main:AddToggle("BypassTimer", { Title = "Bypass Timer", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Battlepass.BypassTimer = value
end)

local Toggle = Tabs.Main:AddToggle("EnableExchange", {Title = "Enable Exchange", Default = false })
Toggle:OnChanged(function(value)
end)

Tabs.Main:AddSection("Player Modification")

local Toggle = Tabs.Main:AddToggle("Noclip", {Title = "Noclip", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.Noclip = value
end)

_G.Fly = false
_G.flySpeed = 20

local Toggle = Tabs.Main:AddToggle("FlyToggle", { Title = "Fly Toggle", Default = false })
Toggle:OnChanged(function(Value)
    _G.Fly = Value
end)
pcall(function() Options.FlyToggle:SetValue(false) end)

local FlySpeedInput = Tabs.Main:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = tostring(_G.flySpeed),
    Placeholder = "Enter fly speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        _G.flySpeed = tonumber(Value) or 20
    end
})

wait(Duration)

Tabs.AutoFarm:AddSection("Farmings")

local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmMoney", {Title = "Auto Farm Money", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.FarmTokens = State
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmTickets", {Title = "Auto Farm Tickets", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.FarmTickets = State
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoCompleteObjectives", {Title = "Auto Complete Objective", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.CompleteObjective = State
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoCatchNPC", {Title = "Auto Catch NPC", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.CatchEventNPC = State
end)

local Toggle = Tabs.AutoFarm:AddToggle("AFKFarm", {Title = "AFK Farm", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.AFKFarm = State
end)

Tabs.AutoFarm:AddSection("Purchase Automations")

local Toggle = Tabs.AutoFarm:AddToggle("AutoBuy", {Title = "Auto Purchase Selected Item", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.PurchaseAutomations.Enabled = State
end)

local Dropdown = Tabs.AutoFarm:AddDropdown("SelectedItem", {
    Title = "Select Item",
    Values = LoadoutNames,
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.AutoFarm.PurchaseAutomations.Selected = Value
end)

Tabs.AutoFarm:AddSection("VIP Automations")

local Toggle = Tabs.AutoFarm:AddToggle("AutoVote", {Title = "Auto Vote", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoVote = State
end)

local Dropdown = Tabs.AutoFarm:AddDropdown("MapSection", {
    Title = "Map Section",
    Values = {1, 2, 3, 4},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.AutoFarm.VIPAutomations.MapSection = Value
end)

local Dropdown = Tabs.AutoFarm:AddDropdown("GamemodeSection", {
    Title = "Gamemode Section",
    Values = {1, 2, 3, 4},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.AutoFarm.VIPAutomations.GamemodeSection = Value
end)

Tabs.AutoFarm:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.AutoFarm:AddToggle("AutoSetMap", {Title = "Auto Set Map", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoMap = State
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoSetSpecialRound", {Title = "Auto Set Special Round", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoSpecialRound = State
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoSetTimer", {Title = "Auto Set Timer", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoTimer = State
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoProMode", {Title = "Auto Set Gamemode to Pro (RECOMMENDED)", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoProMode = State
end)

Tabs.AutoFarm:AddInput("MapInput", {
    Title = "Map Input",
    Default = "DesertBus",
    Placeholder = "DesertBus",
    Numeric = false,
    Finished = false,
    Description = "NO SPACE NEEDED",
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.MapInput = Value
    end
})

Tabs.AutoFarm:AddInput("SpecialRoundInput", {
    Title = "Special Round Input",
    Default = "Plushie Hell",
    Placeholder = "Plushie Hell",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.SpecialRoundInput = Value
    end
})

Tabs.AutoFarm:AddInput("TimerInput", {
    Title = "Timer Input",
    Default = "180",
    Placeholder = "180",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.TimerInput = Value
    end
})

wait(Duration)

Tabs.Combat:AddSection("Nextbot Modification")

local Toggle = Tabs.Combat:AddToggle("AntiNextbotToggle", {Title = "Anti Nextbot Toggle", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Combat.AntiNextbot = value
end)

local Dropdown = Tabs.Combat:AddDropdown("AntiBotTeleport", {
    Title = "Anti Nextbot Teleport Type",
    Values = {"Spawn", "Players"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Combat.AntiNextbotType = Value
end)

Tabs.Combat:AddInput("NextbotDistance", {
    Title = "Anti Nextbot Distance",
    Default = 15,
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Combat.AntiNextbotRange = tonumber(Value) or 15
    end
})

wait(Duration)

Tabs.Misc:AddSection("Player Adjustments")

Tabs.Misc:AddInput("PlayerSpeed", {
    Title = "Player Speed",
    Description = "Change how fast your character moves.",
    Default = "1500",
    Placeholder = "Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.PlayerAdjustment.Update.Speed = tonumber(Value) or 1500
        DConfiguration.Misc.PlayerAdjustment.Saved.Speed = tonumber(Value) or 1500
    end
})

Tabs.Misc:AddInput("PlayerJump", {
    Title = "Player Jump",
    Description = "Change how high your character jumps,",
    Default = "3",
    Placeholder = "Jump Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.PlayerAdjustment.Update.JumpHeight = tonumber(Value) or 3
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpHeight = tonumber(Value) or 3
    end
})

Tabs.Misc:AddInput("PlayerJumpAcce", {
    Title = "Player Jump Acceleration",
    Description = "Your speed increases when you jump.",
    Default = "1.5",
    Placeholder = "Jump Acceleration Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.PlayerAdjustment.Update.JumpAcceleration = tonumber(Value) or 1.5
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpAcceleration = tonumber(Value) or 1.5
    end
})

Tabs.Misc:AddInput("PlayerJumpCap", {
    Title = "Player Jump Cap",
    Description = "Allows air jumping.",
    Default = "1",
    Placeholder = "Jump Cap Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.PlayerAdjustment.Update.JumpCap = tonumber(Value) or 1
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpCap = tonumber(Value) or 1
    end
})

Tabs.Misc:AddInput("PlayerStrafeAcceleration", {
    Title = "Player Strafe Acceleration",
    Description = "Change how fast you move sideways in the air.",
    Default = "182",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.PlayerAdjustment.Update.AirStrafe = tonumber(Value) or 182
        DConfiguration.Misc.PlayerAdjustment.Saved.AirStrafe = tonumber(Value) or 182
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("PlayerJumpPower", {Title = "Jump Power Toggle", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Humanoids.OriginalJumpHeight = State
end)

Tabs.Misc:AddInput("PlayerJumpPower", {
    Title = "Player Jump Power",
    Default = "20",
    Placeholder = "Jump Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Humanoids.JP = tonumber(Value) or 20
    end
})

local Toggle = Tabs.Misc:AddToggle("PlayerWalkspeed", {Title = "Walkspeed Toggle", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Humanoids.WalkspeedCF = State
end)

Tabs.Misc:AddInput("PlayerWalkCf", {
    Title = "Player Walkspeed",
    Default = "5",
    Placeholder = "Walk Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Humanoids.CF = tonumber(Value) or 5
    end
})

Tabs.Misc:AddSection("Utilities")

local Toggle = Tabs.Misc:AddToggle("LagSwitch", {Title = "Lag Switch (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("LagSwitchButton", "Start Lag", 0.15 + DConfiguration.Settings.GuiScale.LagSwitch, 0.1 + DConfiguration.Settings.GuiScale.LagSwitch, function(btn)
            btn.Text = "..."
            wait(0.1)
            btn.Text = "Start Lag"
        end)
    else
        DFunctions.DestroyButton("LagSwitchButton")
    end
end)

local Keybind = Tabs.Misc:AddKeybind("LagSwitchKey", {
    Title = "Lag Switch Keybind",
    Mode = "Toggle",
    Default = "H",
    Callback = function()
    end,
})

Tabs.Misc:AddInput("LagSwitchButtonSize", {
    Title = "Lag Switch Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.LagSwitch),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.LagSwitch = num * 0.01
        else
            DConfiguration.Settings.GuiScale.LagSwitch = 0
        end
        DFunctions.UpdateButton("LagSwitchButton", 0.15 + DConfiguration.Settings.GuiScale.LagSwitch, 0.1 + DConfiguration.Settings.GuiScale.LagSwitch)
    end
})

Tabs.Misc:AddInput("DelayMS", {
    Title = "Delay MS",
    Default = "200",
    Placeholder = "Value",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.LagSwitch.MSDelay = tonumber(Value) or 200
    end
})

local Dropdown = Tabs.Misc:AddDropdown("LagMode", {
    Title = "Lag Mode",
    Values = {"Normal", "Demon", "FastFlag"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.Utilities.LagSwitch.Mode = Value
end)

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("AdjustBounce", {Title = "Modify Bounce", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Utilities.BounceModification.Enabled = State
end)

local Toggle = Tabs.Misc:AddToggle("SuperBounce", {Title = "Super Bounce", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("SuperBounceButton", "Super Bounce", 0.1 + DConfiguration.Settings.GuiScale.SuperBounce, 0.1 + DConfiguration.Settings.GuiScale.SuperBounce, function(btn)
            btn.Text = "..."
            wait(0.1)
            btn.Text = "Super Bounce"
        end)
    else
        DFunctions.DestroyButton("SuperBounceButton")
    end
end)

Tabs.Misc:AddInput("PlayerBounce", {
    Title = "Player Bounce",
    Default = "80",
    Placeholder = "Bounce Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.BounceModification.DefaultBounce = tonumber(Value) or 80
    end
})

Tabs.Misc:AddInput("EmoteBounce", {
    Title = "Emote Bounce",
    Default = "120",
    Placeholder = "Bounce Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.BounceModification.EmoteBounce = tonumber(Value) or 120
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("AdjustEdgeTrimp", {Title = "Modify Edge Trimp", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Utilities.EdgeTrimpModification.Enabled = State
end)

Tabs.Misc:AddInput("EdgeTrimpHeight", {
    Title = "Height Multiplier",
    Default = "1.5",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.EdgeTrimpModification.HeightMultiplier = tonumber(Value) or 1.5
    end
})

Tabs.Misc:AddInput("DownThreshold", {
    Title = "Falling Threshold",
    Default = "4.5",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.EdgeTrimpModification.DownThreshold = tonumber(Value) or 4.5
    end
})

Tabs.Misc:AddSection("Camera Adjustments")

Tabs.Misc:AddInput("CamX", {
    Title = "Stretch Horizontal",
    Default = "1",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.CameraAdjustment.StretchX = tonumber(Value) or 1
    end
})

Tabs.Misc:AddInput("CamY", {
    Title = "Stretch Vertical",
    Default = "1",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.CameraAdjustment.StretchY = tonumber(Value) or 1
    end
})

Tabs.Misc:AddInput("PlayerFOV", {
    Title = "Player FOV",
    Default = "1",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
    end
})

Tabs.Misc:AddButton({
    Title = "Set Camera Stretch",
    Description = "(Warning: Stretch settings can make billboards look weird or disappear from far away.)",
    Callback = function()
    end
})

Tabs.Misc:AddButton({
    Title = "Enable Front Camera",
    Description = "",
    Callback = function()
    end
})

Tabs.Misc:AddSection("Gun Adjustments")

Tabs.Misc:AddButton({
    Title = "Set to Infinite Ammo",
    Description = " ",
    Callback = function()
    end
})

Tabs.Misc:AddButton({
    Title = "Set to Infinite Range",
    Description = " ",
    Callback = function()
    end
})

Tabs.Misc:AddButton({
    Title = "No Cooldown",
    Description = " ",
    Callback = function()
    end
})

Tabs.Misc:AddSection("Game Automations")

local Toggle = Tabs.Misc:AddToggle("InstantReviveButton", {Title = "Instant Revive (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("InstantReviveButton", "Instant Revive: OFF", 0.15 + DConfiguration.Settings.GuiScale.InstantRevive, 0.1 + DConfiguration.Settings.GuiScale.InstantRevive, function(btn)
            DConfiguration.Misc.GameAutomation.Revive.FloatingButton = not DConfiguration.Misc.GameAutomation.Revive.FloatingButton
            btn.Text = DConfiguration.Misc.GameAutomation.Revive.FloatingButton and "Instant Revive: ON" or "Instant Revive: OFF"
        end)
    else
        DFunctions.DestroyButton("InstantReviveButton")
    end
end)

local Toggle = Tabs.Misc:AddToggle("InstantRevive", {Title = "Instant Revive", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Misc.GameAutomation.Revive.Enabled = State
end)

local Toggle = Tabs.Misc:AddToggle("InsQua", {Title = "Instant Revive While Emote", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Misc.GameAutomation.Revive.WhileEmote = State
end)

local Slider = Tabs.Misc:AddSlider("ReviveDelay", {
    Title = "Revive Delay",
    Description = "",
    Default = 0.1,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(v)
        DConfiguration.Misc.GameAutomation.Revive.Delay = v
    end
})

local Keybind = Tabs.Misc:AddKeybind("KeybindRevive", {
    Title = "Keybind to Instant Revive",
    Mode = "Toggle",
    Default = "RightShift",
    Callback = function(Bool)
        DConfiguration.Misc.GameAutomation.Revive.Keybind = Bool
    end,
})

Tabs.Misc:AddInput("InstantReviveButtonSize", {
    Title = "Instant Revive Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.InstantRevive),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.InstantRevive = num * 0.01
        else
            DConfiguration.Settings.GuiScale.InstantRevive = 0
        end
        DFunctions.UpdateButton("InstantReviveButton", 0.15 + DConfiguration.Settings.GuiScale.InstantRevive, 0.1 + DConfiguration.Settings.GuiScale.InstantRevive)
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("AutoCarry", {Title = "Auto Carry (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("AutoCarryGui", "Auto Carry: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoCarry, 0.1 + DConfiguration.Settings.GuiScale.AutoCarry, function(btn)
            DConfiguration.Misc.GameAutomation.Carry.FloatingButton = not DConfiguration.Misc.GameAutomation.Carry.FloatingButton
            btn.Text = DConfiguration.Misc.GameAutomation.Carry.FloatingButton and "Auto Carry: ON" or "Auto Carry: OFF"
        end)
    else
        DFunctions.DestroyButton("AutoCarryGui")
    end
end)

local Toggle = Tabs.Misc:AddToggle("EmoteCarry", {Title = "Carry While Emote", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Misc.GameAutomation.Carry.WhileEmote = State
end)

local Keybind = Tabs.Misc:AddKeybind("KeybindCarry", {
    Title = "Keybind to Carry",
    Mode = "Toggle",
    Default = "Q",
    Callback = function(Bool)
        DConfiguration.Misc.GameAutomation.Carry.Keybind = Bool
    end,
})

Tabs.Misc:AddInput("CarryButtonSize", {
    Title = "Auto Carry Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoCarry),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoCarry = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoCarry = 0
        end
        DFunctions.UpdateButton("AutoCarryGui", 0.15 + DConfiguration.Settings.GuiScale.AutoCarry, 0.1 + DConfiguration.Settings.GuiScale.AutoCarry)
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

wait(Duration)

local Toggle = Tabs.Misc:AddToggle("AutoEmote", {Title = "Auto Emote Dash Button", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("EmoteDashButton", "Start Emote", 0.15 + DConfiguration.Settings.GuiScale.AutoEmoteDash, 0.1 + DConfiguration.Settings.GuiScale.AutoEmoteDash, function(btn)
            btn.Text = "Emoting..."
            wait(0.1)
            btn.Text = "Crouching..."
            wait(0.1)
            btn.Text = "Start Emote"
        end)
    else
        DFunctions.DestroyButton("EmoteDashButton")
    end
end)

Tabs.Misc:AddInput("EmoteButtonSize", {
    Title = "Auto Emote Dash Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoEmoteDash),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoEmoteDash = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoEmoteDash = 0
        end
        DFunctions.UpdateButton("EmoteDashButton", 0.15 + DConfiguration.Settings.GuiScale.AutoEmoteDash, 0.1 + DConfiguration.Settings.GuiScale.AutoEmoteDash)
    end
})

local Keybind = Tabs.Misc:AddKeybind("KeyEmoteDash", {
    Title = "Keybind to Emote Dash",
    Mode = "Toggle",
    Default = "RightControl",
    Callback = function(Bool)
        DConfiguration.Misc.GameAutomation.Macro.Keybind = Bool
    end,
})

local Dropdown = Tabs.Misc:AddDropdown("EmoteID", {
    Title = "Select Emote ID",
    Values = EmoteNames,
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.GameAutomation.Macro.SelectedEmote = Value
end)

Tabs.Misc:AddSection("Movement Modification")

local Toggle = Tabs.Misc:AddToggle("AggressiveEmoteDash", {Title = "Aggressive Emote Dash", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Enabled = State
end)

local Dropdown = Tabs.Misc:AddDropdown("AggressiveEmoteType", {
    Title = "Aggressive Emote Type",
    Values = {"Legit", "Blatant"},
    Multi = false,
    Default = 2,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Type = Value
end)

Tabs.Misc:AddInput("EmoteSpeed", {
    Title = "Aggressive Emote Speed",
    Default = "2000",
    Placeholder = "Emote Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Speed = tonumber(Value) or 2000
    end
})

Tabs.Misc:AddInput("CrouchSpeedAgg", {
    Title = "Aggressive Emote Acceleration (Negative Only)",
    Default = "-2",
    Placeholder = "Acceleration Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Acceleration = tonumber(Value) or -2
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("InfiniteSlide", {Title = "Infinite Slide", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.SlideModification.Enabled = State
end)

local Toggle = Tabs.Misc:AddToggle("InfiniteSlideButton", {Title = "Infinite Slide (Button)", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("InfiniteSlideButton", "Infinite Slide: OFF", 0.15 + DConfiguration.Settings.GuiScale.InfiniteSlide, 0.1 + DConfiguration.Settings.GuiScale.InfiniteSlide, function(btn)
            DConfiguration.Misc.MovementModification.SlideModification.FloatingButton = not DConfiguration.Misc.MovementModification.SlideModification.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.SlideModification.FloatingButton and "Infinite Slide: ON" or "Infinite Slide: OFF"
            DConfiguration.Misc.MovementModification.SlideModification.Enabled = DConfiguration.Misc.MovementModification.SlideModification.FloatingButton
        end)
    else
        DFunctions.DestroyButton("InfiniteSlideButton")
    end
end)

Tabs.Misc:AddInput("InfiniteSlideButtonSize", {
    Title = "Infinite Slide Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.InfiniteSlide),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.InfiniteSlide = num * 0.01
        else
            DConfiguration.Settings.GuiScale.InfiniteSlide = 0
        end
        DFunctions.UpdateButton("InfiniteSlideButton", 0.15 + DConfiguration.Settings.GuiScale.InfiniteSlide, 0.1 + DConfiguration.Settings.GuiScale.InfiniteSlide)
    end
})

Tabs.Misc:AddInput("SlideSpeed", {
    Title = "Slide Speed (Negative Only)",
    Default = "-3",
    Placeholder = "Crouch Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.SlideModification.Acceleration = tonumber(Value) or -3
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local NormalGravity = game.Workspace.Gravity

local Toggle = Tabs.Misc:AddToggle("GravityToggle", {Title = "Gravity Button", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("GravityGui", "Gravity: OFF", 0.15 + DConfiguration.Settings.GuiScale.Gravity, 0.1 + DConfiguration.Settings.GuiScale.Gravity, function(btn)
            DConfiguration.Misc.MovementModification.Gravity.FloatingButton = not DConfiguration.Misc.MovementModification.Gravity.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.Gravity.FloatingButton and "Gravity: ON" or "Gravity: OFF"
        end)
    else
        DFunctions.DestroyButton("GravityGui")
    end
end)

Tabs.Misc:AddInput("GravityButtonSize", {
    Title = "Gravity Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.Gravity),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.Gravity = num * 0.01
        else
            DConfiguration.Settings.GuiScale.Gravity = 0
        end
        DFunctions.UpdateButton("GravityGui", 0.15 + DConfiguration.Settings.GuiScale.Gravity, 0.1 + DConfiguration.Settings.GuiScale.Gravity)
    end
})

local Keybind = Tabs.Misc:AddKeybind("GravitKey", {
    Title = "Gravity Keybind",
    Mode = "Toggle",
    Default = "J",
    Callback = function(Bool)
        DConfiguration.Misc.MovementModification.Gravity.Keybind = Bool
    end,
})

Tabs.Misc:AddInput("GravityAdjust", {
    Title = "Gravity Adjustment",
    Default = "10",
    Placeholder = " Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.Gravity.Value = tonumber(Value) or 10
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("BHOPToggle", {Title = "BHOP (Button)", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("BHOPGui", "Auto Jump: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoJump, 0.1 + DConfiguration.Settings.GuiScale.AutoJump, function(btn)
            DConfiguration.Misc.MovementModification.BHOP.FloatingButton = not DConfiguration.Misc.MovementModification.BHOP.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.BHOP.FloatingButton and "Auto Jump: ON" or "Auto Jump: OFF"
            DConfiguration.Misc.MovementModification.BHOP.Enabled = DConfiguration.Misc.MovementModification.BHOP.FloatingButton
        end)
    else
        DFunctions.DestroyButton("BHOPGui")
    end
end)

local Toggle = Tabs.Misc:AddToggle("BHOPJumpButton", {Title = "BHOP (Jump Button)", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.BHOP.JumpButton = State
end)

local Keybind = Tabs.Misc:AddKeybind("KeybindBHOP", {
    Title = "Keybind to BHOP",
    Mode = "Toggle",
    Default = "B",
    Callback = function(Bool)
        DConfiguration.Misc.MovementModification.BHOP.Keybind = Bool
    end,
})

local Keybind = Tabs.Misc:AddKeybind("KeybindBHOP2", {
    Title = "Keybind to BHOP (Hold)",
    Mode = "Hold",
    Default = "Space",
    Callback = function(Bool)
        DConfiguration.Misc.MovementModification.BHOP.HoldKeybind = Bool
    end,
})

Tabs.Misc:AddInput("BHOPButtonSize", {
    Title = "BHOP Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoJump),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoJump = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoJump = 0
        end
        DFunctions.UpdateButton("BHOPGui", 0.15 + DConfiguration.Settings.GuiScale.AutoJump, 0.1 + DConfiguration.Settings.GuiScale.AutoJump)
    end
})

local Dropdown = Tabs.Misc:AddDropdown("BHOPVersion", {
    Title = "Select BHOP Version",
    Values = {"Acceleration", "Ground Acceleration", "No Acceleration"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.BHOP.Settings.Type = Value
end)

local Dropdown = Tabs.Misc:AddDropdown("JumpType", {
    Title = "Select Jump Type",
    Values = {"Simulated", "Realistic"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.BHOP.Settings.JumpType = Value
end)

local Toggle = Tabs.Misc:AddToggle("BackwardBHOP", {Title = "BHOP Backwards", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.BHOP.Settings.Backwards = State
end)

local Toggle = Tabs.Misc:AddToggle("SpiderHop", {Title = "Spider Hop (Beta)", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.BHOP.Settings.SpiderHop = State
end)

Tabs.Misc:AddInput("BHOPAcceleration", {
    Title = "BHOP Acceleration (Negative Only)",
    Default = "-0.1",
    Placeholder = "-1",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Settings.Acceleration = tonumber(Value) or -0.1
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("BHOPAutoAccelerate", {Title = "Auto Acceleration (Legit)", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.BHOP.Settings.AutoAcceleration.Enabled = State
end)

Tabs.Misc:AddInput("AutoAccelerationMaxAccel", {
    Title = "Max Acceleration",
    Default = "3",
    Placeholder = "3",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Settings.AutoAcceleration.MaxAccelerate = tonumber(Value) or 3
    end
})

Tabs.Misc:AddInput("AutoAccelerationMinAccel", {
    Title = "Min Acceleration",
    Default = "-1",
    Placeholder = "-1",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Settings.AutoAcceleration.MinAccelerate = tonumber(Value) or -1
    end
})

Tabs.Misc:AddInput("AutoAccelerationMaxSpeed", {
    Title = "Max Speed",
    Default = "70",
    Placeholder = "70",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Settings.AutoAcceleration.MinSpeed = tonumber(Value) or 70
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("AutoCrouch", {Title = "Auto Crouch (Button)", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("AutoCrouchGui", "Auto Crouch: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoCrouch, 0.1 + DConfiguration.Settings.GuiScale.AutoCrouch, function(btn)
            DConfiguration.Misc.MovementModification.Crouch.FloatingButton = not DConfiguration.Misc.MovementModification.Crouch.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.Crouch.FloatingButton and "Auto Crouch: ON" or "Auto Crouch: OFF"
        end)
    else
        DFunctions.DestroyButton("AutoCrouchGui")
    end
end)

local Keybind = Tabs.Misc:AddKeybind("KeybindCrouch", {
    Title = "Keybind to Auto Crouch (Hold)",
    Mode = "Hold",
    Default = "RightControl",
    Callback = function(Bool)
        DConfiguration.Misc.MovementModification.Crouch.Keybind = Bool
    end,
})

Tabs.Misc:AddInput("CrouchButtonSize", {
    Title = "Auto Crouch Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoCrouch),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoCrouch = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoCrouch = 0
        end
        DFunctions.UpdateButton("AutoCrouchGui", 0.15 + DConfiguration.Settings.GuiScale.AutoCrouch, 0.1 + DConfiguration.Settings.GuiScale.AutoCrouch)
    end
})

local Dropdown = Tabs.Misc:AddDropdown("CrouchType", {
    Title = "Select Crouch Type",
    Values = {"Rapid", "Ground", "Air", "Normal"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.Crouch.Type = Value
end)

Tabs.Misc:AddInput("CrouchDebounce", {
    Title = "Crouch Speed",
    Default = "0.1",
    Placeholder = "0.1",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.Crouch.debounce = tonumber(Value) or 0.1
    end
})

Tabs.Visual:AddParagraph({
    Title = "Warning: Do not use locked emotes from the emote changer or you may get banned easily",
    Content = ""
})

Tabs.Visual:AddParagraph({
    Title = "To change it back to the original, please rejoin.",
    Content = ""
})

Tabs.Visual:AddSection("Cosmetics Changer")

Tabs.Visual:AddInput("O_C1", {
    Title = "Current Cosmetics 1",
    Default = " ",
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.OriginalCosmetics.Cosmetics1 = Value
    end
})

Tabs.Visual:AddInput("O_C2", {
    Title = "Current Cosmetics 2",
    Default = " ",
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.OriginalCosmetics.Cosmetics2 = Value
    end
})

Tabs.Visual:AddInput("O_C3", {
    Title = "Current Effect",
    Default = " ",
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.OriginalCosmetics.Cosmetics3 = Value
    end
})

Tabs.Visual:AddInput("O_C4", {
    Title = "Current Character",
    Default = " ",
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.OriginalCosmetics.Cosmetics4 = Value
    end
})

Tabs.Visual:AddParagraph({Title = " ", Content = ""})

Tabs.Visual:AddInput("M_C1", {
    Title = "Select Cosmetics 1",
    Default = " ",
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.ModifyCosmetics.Cosmetics1 = Value
    end
})

Tabs.Visual:AddInput("M_C2", {
    Title = "Select Cosmetics 2",
    Default = " ",
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.ModifyCosmetics.Cosmetics2 = Value
    end
})

Tabs.Visual:AddInput("M_C3", {
    Title = "Select Effect",
    Default = " ",
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.ModifyCosmetics.Cosmetics3 = Value
    end
})

Tabs.Visual:AddInput("M_C4", {
    Title = "Select Character",
    Default = " ",
    Placeholder = "",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.ModifyCosmetics.Cosmetics4 = Value
    end
})

Tabs.Visual:AddButton({
    Title = "Change Cosmetics",
    Description = "",
    Callback = function()
    end
})

Tabs.Visual:AddButton({
    Title = "Change Effect",
    Description = "",
    Callback = function()
    end
})

Tabs.Visual:AddButton({
    Title = "Change Character",
    Description = "",
    Callback = function()
    end
})

Tabs.Visual:AddButton({
    Title = "Restore Cosmetics",
    Description = "",
    Callback = function()
    end
})

Tabs.Visual:AddSection("Emote Changer")

for i = 1, 12 do
    Tabs.Visual:AddInput("O_E" .. i, {
        Title = "Current Emote " .. i,
        Default = " ",
        Placeholder = "",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            DConfiguration.Visual.OriginalEmotes["Emote" .. i] = Value
        end
    })
end

Tabs.Visual:AddParagraph({Title = " ", Content = ""})

for i = 1, 12 do
    Tabs.Visual:AddInput("M_E" .. i, {
        Title = "Select Emote " .. i,
        Default = " ",
        Placeholder = "",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            DConfiguration.Visual.ModifyEmotes["Emote" .. i] = Value
        end
    })
end

local Dropdown = Tabs.Visual:AddDropdown("EmoteOption", {
    Title = "Select Animation Type",
    Values = {"A", "B", "C", "D"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
end)

Tabs.Visual:AddButton({
    Title = "Change Emotes",
    Description = "",
    Callback = function()
    end
})

Tabs.Visual:AddButton({
    Title = "Restore Emotes",
    Description = "Having Trouble?",
    Callback = function()
    end
})

Tabs.Info:AddParagraph({
    Title = "Elderwyrm Hub X / Overhaul Script",
    Content = "Created by Vraigos"
})

Tabs.Info:AddParagraph({
    Title = "Adjustments / Movement Modification",
    Content = "Created by Vraigos and Aerave"
})

Tabs.Info:AddParagraph({
    Title = "Adjustments / ESP / Legacy Script",
    Content = "Created by Aerave"
})

Tabs.Info:AddButton({
    Title = "Join Discord",
    Description = "Tap to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/zvhjwgVVbR")
        end
    end
})

Tabs.Info:AddParagraph({
    Title = "UI: Fluent",
    Content = "Created by dawidscripts"
})

Tabs.Settings:AddParagraph({
    Title = "Configuration",
    Content = " "
})

Tabs.Settings:AddButton({
    Title = "Remove FPS Counter",
    Description = "",
    Callback = function()
        if fpsCounter then
            fpsCounter:Destroy()
        end
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
FBM:SetLibrary(Fluent)

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("ElderwyrmHubXUniversal")
FBM:SetFolder("ElderwyrmHubXUniversal/Evade/FloatingButtons")
SaveManager:SetFolder("ElderwyrmHubXUniversal/Evade")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
FBM:BuildConfigSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

local ExtensionLoaded = false

Tabs.Extension:AddButton({
    Title = "Load Extension",
    Description = "Not all the scripts here are ours. Some are recommendations from this tab.",
    Callback = function()
        Window:Dialog({
            Title = "WARNING",
            Content = "Extension loading is currently unavailable.",
            Buttons = {
                {
                    Title = "OK",
                    Callback = function() end
                },
            },
        })
    end
})

print("[Elderwyrm Hub X] Loaded.")
