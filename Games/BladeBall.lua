-- SnowFall Hub - Blade Ball module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Blade Ball", LoadingTitle = "Blade Ball", LoadingSubtitle = "module"})

local cfg = {
    autoParry = false,
    autoParryRange = 20,
    espBall = false,
    espPlayers = false,
    espNames = false,
    speed = false,
    fly = false,
    noclip = false,
    godmode = false,
    infJump = false,
    fullbright = false,
    antiAfk = false,
    speedVal = 25,
    flySpeed = 50
}

local drawings = {}
local function clear()
    for _, d in pairs(drawings) do if d and d.Remove then d:Remove() end end
    drawings = {}
end

local function getChar()
    return LocalPlayer.Character
end

-- AUTO PARRY
local parryConn = nil
local function autoParry()
    if cfg.autoParry and not parryConn then
        parryConn = RunService.Heartbeat:Connect(function()
            local char = getChar()
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = obj.Name:lower()
                    if n:find("ball") or n:find("orb") then
                        local d = (obj.Position - hrp.Position).Magnitude
                        if d < cfg.autoParryRange then
                            local vu = game:GetService("VirtualUser")
                            vu:CaptureController()
                            vu:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
                        end
                    end
                end
            end
        end)
    elseif not cfg.autoParry and parryConn then
        parryConn:Disconnect()
        parryConn = nil
    end
end

-- ESP
local function esp()
    clear()
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if cfg.espBall then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("ball") or n:find("orb") then
                    local sp, on = Camera:WorldToViewportPoint(obj.Position)
                    if on then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255,0,255), 16, true, true
                        t.Text = obj.Name
                        t.Position = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, t)
                    end
                end
            end
        end
    end
    if cfg.espPlayers or cfg.espNames then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Head")
                if h then
                    local sp, on = Camera:WorldToViewportPoint(h.Position)
                    if on then
                        if cfg.espNames then
                            local t = Drawing.new("Text")
                            t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255,255,255), 14, true, true
                            t.Text = p.Name
                            t.Position = Vector2.new(sp.X, sp.Y - 30)
                            table.insert(drawings, t)
                        end
                        if cfg.espPlayers then
                            local b = Drawing.new("Square")
                            b.Visible, b.Color, b.Thickness, b.Filled = true, Color3.fromRGB(255,0,0), 1, false
                            b.Size = Vector2.new(50, 70)
                            b.Position = Vector2.new(sp.X - 25, sp.Y - 35)
                            table.insert(drawings, b)
                        end
                    end
                end
            end
        end
    end
end

-- SPEED / GODMODE / NOCLIP / INFJUMP
local function speed()
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = cfg.speed and cfg.speedVal or 16 end
end

local function godmode()
    if not cfg.godmode then return end
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
end

local function noclip()
    if not cfg.noclip then return end
    local char = getChar()
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end

local function infJump()
    if not cfg.infJump then return end
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 200 end
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

local function fullbright()
    if cfg.fullbright then
        local l = game:GetService("Lighting")
        l.Brightness = 3
        l.ClockTime = 12
        l.GlobalShadows = false
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
    esp()
    autoParry()
    speed()
    godmode()
    noclip()
    infJump()
    fly()
    fullbright()
end)

local T = Window:CreateTab("Blade Ball", 4483362458)

T:CreateSection("Aim")
T:CreateToggle({Name = "Auto Parry", CurrentValue = false, Callback = function(v) cfg.autoParry = v end})
T:CreateSlider({Name = "Parry Range", Range = {5,100}, Increment = 5, CurrentValue = 20, Callback = function(v) cfg.autoParryRange = v end})

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP шара", CurrentValue = false, Callback = function(v) cfg.espBall = v end})
T:CreateToggle({Name = "ESP игроков (боксы)", CurrentValue = false, Callback = function(v) cfg.espPlayers = v end})
T:CreateToggle({Name = "Имена игроков", CurrentValue = false, Callback = function(v) cfg.espNames = v end})

T:CreateSection("Движение")
T:CreateToggle({Name = "Speed", CurrentValue = false, Callback = function(v) cfg.speed = v end})
T:CreateSlider({Name = "Speed value", Range = {16,150}, Increment = 1, CurrentValue = 25, Callback = function(v) cfg.speedVal = v end})
T:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v) cfg.fly = v end})
T:CreateSlider({Name = "Fly speed", Range = {10,200}, Increment = 5, CurrentValue = 50, Callback = function(v) cfg.flySpeed = v end})
T:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) cfg.noclip = v end})
T:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) cfg.infJump = v end})

T:CreateSection("Защита")
T:CreateToggle({Name = "Godmode", CurrentValue = false, Callback = function(v) cfg.godmode = v end})

T:CreateSection("Визуал")
T:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) cfg.fullbright = v end})

T:CreateSection("Прочее")
T:CreateToggle({Name = "Anti-AFK", CurrentValue = false, Callback = function(v) cfg.antiAfk = v end})
