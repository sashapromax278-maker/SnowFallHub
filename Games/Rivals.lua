-- SnowFall Hub - Rivals module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Rivals", LoadingTitle = "Rivals", LoadingSubtitle = "module"})

local cfg = {
    esp = false,
    box = false,
    tracers = false,
    health = false,
    aimbot = false,
    silentAim = false,
    autoShoot = false,
    fly = false,
    speed = false,
    noclip = false,
    godmode = false,
    infJump = false,
    fullbright = false,
    antiAfk = false,
    aimPart = "Head",
    fov = 120,
    speedVal = 25,
    flySpeed = 50
}

local drawings = {}
local function clear()
    for _, d in pairs(drawings) do if d and d.Remove then d:Remove() end end
    drawings = {}
end

local function getEnemies()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and head and hum and hum.Health > 0 then
                table.insert(list, {player = p, hrp = hrp, head = head, hum = hum})
            end
        end
    end
    return list
end

-- ESP
local function esp()
    clear()
    for _, e in pairs(getEnemies()) do
        local sp, on = Camera:WorldToViewportPoint(e.head.Position)
        if on then
            if cfg.box then
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
            if cfg.health then
                local h = Drawing.new("Text")
                h.Visible, h.Color, h.Size, h.Center, h.Outline = true, Color3.fromRGB(0,255,0), 14, true, true
                h.Text = tostring(math.floor(e.hum.Health)) .. " HP"
                h.Position = Vector2.new(sp.X, sp.Y + 40)
                table.insert(drawings, h)
            end
            if cfg.esp then
                local n = Drawing.new("Text")
                n.Visible, n.Color, n.Size, n.Center, n.Outline = true, Color3.fromRGB(255,255,255), 14, true, true
                n.Text = e.player.Name
                n.Position = Vector2.new(sp.X, sp.Y - 50)
                table.insert(drawings, n)
            end
        end
    end
end

-- AIMBOT
local function aimbot()
    if not cfg.aimbot then return end
    local closest, shortest = nil, cfg.fov
    for _, e in pairs(getEnemies()) do
        local sp, on = Camera:WorldToViewportPoint(e[cfg.aimPart].Position)
        if on then
            local dist = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if dist < shortest then shortest = dist closest = e end
        end
    end
    if closest then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest[cfg.aimPart].Position)
    end
end

-- SILENT AIM
local function silentAim()
    if not cfg.silentAim then return end
    local closest, shortest = nil, cfg.fov
    for _, e in pairs(getEnemies()) do
        local sp, on = Camera:WorldToViewportPoint(e[cfg.aimPart].Position)
        if on then
            local dist = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if dist < shortest then shortest = dist closest = e end
        end
    end
    if closest and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local mt = getgenv and getgenv().mt or nil
        if mt then
            mt.__index = function(t, k)
                if k == "Hit" then return closest.hrp end
                return mt[k]
            end
        end
    end
end

-- AUTO SHOOT
local function autoShoot()
    if not cfg.autoShoot then return end
    local closest, shortest = nil, cfg.fov
    for _, e in pairs(getEnemies()) do
        local sp, on = Camera:WorldToViewportPoint(e[cfg.aimPart].Position)
        if on then
            local dist = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if dist < shortest then shortest = dist closest = e end
        end
    end
    if closest then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
    end
end

-- SPEED / GODMODE / NOCLIP / INFJUMP
local function speed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = cfg.speed and cfg.speedVal or 16 end
end

local function godmode()
    if not cfg.godmode then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
end

local function noclip()
    if not cfg.noclip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end

local function infJump()
    if not cfg.infJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 200 end
end

-- FLY
local flyBV = nil
local function fly()
    local char = LocalPlayer.Character
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
    local move = Vector3.new(0,0,0)
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
    if cfg.esp or cfg.box or cfg.tracers or cfg.health then esp() end
    aimbot()
    silentAim()
    autoShoot()
    speed()
    godmode()
    noclip()
    infJump()
    fly()
    fullbright()
end)

local T = Window:CreateTab("Rivals", 4483362458)

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP игроков", CurrentValue = false, Callback = function(v) cfg.esp = v end})
T:CreateToggle({Name = "Box ESP", CurrentValue = false, Callback = function(v) cfg.box = v end})
T:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) cfg.tracers = v end})
T:CreateToggle({Name = "Health ESP", CurrentValue = false, Callback = function(v) cfg.health = v end})

T:CreateSection("Aim")
T:CreateToggle({Name = "Aimbot", CurrentValue = false, Callback = function(v) cfg.aimbot = v end})
T:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(v) cfg.silentAim = v end})
T:CreateToggle({Name = "Auto Shoot", CurrentValue = false, Callback = function(v) cfg.autoShoot = v end})
T:CreateDropdown({Name = "Aim Part", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {"Head"}, Callback = function(o) cfg.aimPart = o[1] end})
T:CreateSlider({Name = "FOV", Range = {10,500}, Increment = 10, CurrentValue = 120, Callback = function(v) cfg.fov = v end})

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
