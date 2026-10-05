-- SnowFall Hub - Universal module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Universal", LoadingTitle = "Universal", LoadingSubtitle = "module"})

local cfg = {
    espPlayers = false,
    espNames = false,
    espHealth = false,
    espDistance = false,
    tracers = false,
    speed = false,
    fly = false,
    noclip = false,
    infJump = false,
    godmode = false,
    fullbright = false,
    antiAfk = false,
    freecam = false,
    speedVal = 25,
    flySpeed = 50,
    jumpPower = 200
}

local drawings = {}
local function clear()
    for _, d in pairs(drawings) do if d and d.Remove then d:Remove() end end
    drawings = {}
end

local function getChar()
    return LocalPlayer.Character
end

-- ESP ИГРОКОВ
local function esp()
    clear()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if h and hrp then
                local sp, on = Camera:WorldToViewportPoint(h.Position)
                if on then
                    if cfg.espNames then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255,255,255), 14, true, true
                        t.Text = p.Name
                        t.Position = Vector2.new(sp.X, sp.Y - 30)
                        table.insert(drawings, t)
                    end
                    if cfg.espHealth and hum then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(0,255,0), 13, true, true
                        t.Text = tostring(math.floor(hum.Health)) .. " HP"
                        t.Position = Vector2.new(sp.X, sp.Y + 40)
                        table.insert(drawings, t)
                    end
                    if cfg.espDistance and hrp then
                        local myChar = getChar()
                        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myHrp then
                            local d = (hrp.Position - myHrp.Position).Magnitude
                            local t = Drawing.new("Text")
                            t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(200,200,200), 12, true, true
                            t.Text = tostring(math.floor(d)) .. "m"
                            t.Position = Vector2.new(sp.X, sp.Y + 55)
                            table.insert(drawings, t)
                        end
                    end
                    if cfg.espPlayers then
                        local b = Drawing.new("Square")
                        b.Visible, b.Color, b.Thickness, b.Filled = true, Color3.fromRGB(255,0,0), 1, false
                        b.Size = Vector2.new(50, 70)
                        b.Position = Vector2.new(sp.X - 25, sp.Y - 35)
                        table.insert(drawings, b)
                    end
                    if cfg.tracers then
                        local l = Drawing.new("Line")
                        l.Visible, l.Color, l.Thickness = true, Color3.fromRGB(255,255,255), 1
                        l.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        l.To = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, l)
                    end
                end
            end
        end
    end
end

-- SPEED
local function speed()
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = cfg.speed and cfg.speedVal or 16 end
end

-- GODMODE
local function godmode()
    if not cfg.godmode then return end
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
end

-- NOCLIP
local function noclip()
    if not cfg.noclip then return end
    local char = getChar()
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end

-- INF JUMP
local function infJump()
    if not cfg.infJump then return end
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = cfg.jumpPower end
end

-- FLY
local flyBV = nil
local function fly()
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not cfg.fly then
        if flyBV then flyBV:Destroy() flyBV = nil end
        return
    end
    if not flyBV then
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBV.Parent = hrp
    end
    local move = Vector3.new(0, 0, 0)
    local cam = Camera.CFrame
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
    flyBV.Velocity = move * cfg.flySpeed
end

-- FULLBRIGHT
local function fullbright()
    if cfg.fullbright then
        local l = game:GetService("Lighting")
        l.Brightness = 3
        l.ClockTime = 12
        l.FogEnd = 100000
        l.GlobalShadows = false
    end
end

-- FREECAM
local freecamActive = false
local freecamConn = nil
local function freecam()
    if cfg.freecam and not freecamActive then
        freecamActive = true
        local cam = workspace.CurrentCamera
        local orig = cam.CameraType
        cam.CameraType = Enum.CameraType.Scriptable
        local pos = cam.CFrame
        freecamConn = RunService.RenderStepped:Connect(function()
            local speedF = 2
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + pos.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - pos.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - pos.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + pos.RightVector end
            pos = pos + move * speedF
            cam.CFrame = pos
        end)
    elseif not cfg.freecam and freecamActive then
        freecamActive = false
        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

LocalPlayer.Idled:Connect(function()
    if cfg.antiAfk then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    godmode()
end)

RunService.RenderStepped:Connect(function()
    if cfg.espPlayers or cfg.espNames or cfg.espHealth or cfg.espDistance or cfg.tracers then esp() end
    speed()
    godmode()
    noclip()
    infJump()
    fly()
    fullbright()
    freecam()
end)

local T = Window:CreateTab("Universal", 4483362458)

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP игроков (боксы)", CurrentValue = false, Callback = function(v) cfg.espPlayers = v end})
T:CreateToggle({Name = "Имена", CurrentValue = false, Callback = function(v) cfg.espNames = v end})
T:CreateToggle({Name = "Здоровье", CurrentValue = false, Callback = function(v) cfg.espHealth = v end})
T:CreateToggle({Name = "Дистанция", CurrentValue = false, Callback = function(v) cfg.espDistance = v end})
T:CreateToggle({Name = "Трассеры", CurrentValue = false, Callback = function(v) cfg.tracers = v end})

T:CreateSection("Движение")
T:CreateToggle({Name = "Speed", CurrentValue = false, Callback = function(v) cfg.speed = v end})
T:CreateSlider({Name = "Speed value", Range = {16,300}, Increment = 1, CurrentValue = 25, Callback = function(v) cfg.speedVal = v end})
T:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v) cfg.fly = v end})
T:CreateSlider({Name = "Fly speed", Range = {10,300}, Increment = 5, CurrentValue = 50, Callback = function(v) cfg.flySpeed = v end})
T:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) cfg.noclip = v end})
T:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) cfg.infJump = v end})
T:CreateSlider({Name = "Jump Power", Range = {50,500}, Increment = 10, CurrentValue = 200, Callback = function(v) cfg.jumpPower = v end})

T:CreateSection("Защита")
T:CreateToggle({Name = "Godmode", CurrentValue = false, Callback = function(v) cfg.godmode = v end})

T:CreateSection("Визуал")
T:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) cfg.fullbright = v end})
T:CreateToggle({Name = "Freecam", CurrentValue = false, Callback = function(v) cfg.freecam = v end})

T:CreateSection("Прочее")
T:CreateToggle({Name = "Anti-AFK", CurrentValue = false, Callback = function(v) cfg.antiAfk = v end})
