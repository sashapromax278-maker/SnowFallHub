-- SnowFall Hub - Steal a Brainrot module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Steal a Brainrot", LoadingTitle = "Steal a Brainrot", LoadingSubtitle = "module"})

local cfg = {
    autoSteal = false,
    autoBuy = false,
    autoCollect = false,
    espBrainrot = false,
    espPlayers = false,
    espBase = false,
    speed = false,
    fly = false,
    noclip = false,
    godmode = false,
    infJump = false,
    fullbright = false,
    antiAfk = false,
    speedVal = 30,
    flySpeed = 50,
    stealRange = 150
}

local drawings = {}
local function clear()
    for _, d in pairs(drawings) do if d and d.Remove then d:Remove() end end
    drawings = {}
end

local function getChar()
    return LocalPlayer.Character
end

-- АВТО-КРАЖА
local function autoSteal()
    if not cfg.autoSteal then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local closest, dist = nil, cfg.stealRange
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("brainrot") or n:find("brain") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < dist then dist = d closest = part end
                end
            end
        end
    end
    if closest then
        hrp.CFrame = CFrame.new(closest.Position + Vector3.new(0, 3, 0))
        for _, v in pairs(closest:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
            end
        end
    end
end

-- АВТО-ПОКУПКА
local function autoBuy()
    if not cfg.autoBuy then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("TextButton") then
            local t = v.Text:lower()
            if t:find("buy") or t:find("purchase") or t:find("купить") then
                v:FireServer()
            end
        end
    end
end

-- АВТО-СБОР ДЕНЕГ
local function autoCollect()
    if not cfg.autoCollect then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("cash") or n:find("money") or n:find("coin") then
                if (obj.Position - hrp.Position).Magnitude < 50 then
                    hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end
end

-- ESP
local function esp()
    clear()
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if cfg.espBrainrot then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("brainrot") or n:find("brain") then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local sp, on = Camera:WorldToViewportPoint(part.Position)
                        if on then
                            local t = Drawing.new("Text")
                            t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255, 0, 255), 14, true, true
                            t.Text = obj.Name
                            t.Position = Vector2.new(sp.X, sp.Y)
                            table.insert(drawings, t)
                        end
                    end
                end
            end
        end
    end
    if cfg.espBase then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("base") or n:find("plot") then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local sp, on = Camera:WorldToViewportPoint(part.Position)
                        if on then
                            local t = Drawing.new("Text")
                            t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(0, 255, 255), 14, true, true
                            t.Text = obj.Name
                            t.Position = Vector2.new(sp.X, sp.Y)
                            table.insert(drawings, t)
                        end
                    end
                end
            end
        end
    end
    if cfg.espPlayers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Head")
                if h then
                    local sp, on = Camera:WorldToViewportPoint(h.Position)
                    if on then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(0, 255, 0), 14, true, true
                        t.Text = p.Name
                        t.Position = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, t)
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

RunService.Heartbeat:Connect(function()
    autoSteal()
    autoBuy()
    autoCollect()
    if cfg.espBrainrot or cfg.espPlayers or cfg.espBase then esp() end
    speed()
    godmode()
    noclip()
    infJump()
    fly()
    fullbright()
end)

local T = Window:CreateTab("Steal a Brainrot", 4483362458)

T:CreateSection("Авто")
T:CreateToggle({Name = "Авто-кража брейнротов", CurrentValue = false, Callback = function(v) cfg.autoSteal = v end})
T:CreateToggle({Name = "Авто-покупка", CurrentValue = false, Callback = function(v) cfg.autoBuy = v end})
T:CreateToggle({Name = "Авто-сбор денег", CurrentValue = false, Callback = function(v) cfg.autoCollect = v end})
T:CreateSlider({Name = "Радиус кражи", Range = {50,500}, Increment = 10, CurrentValue = 150, Callback = function(v) cfg.stealRange = v end})

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP брейнротов", CurrentValue = false, Callback = function(v) cfg.espBrainrot = v end})
T:CreateToggle({Name = "ESP баз", CurrentValue = false, Callback = function(v) cfg.espBase = v end})
T:CreateToggle({Name = "ESP игроков", CurrentValue = false, Callback = function(v) cfg.espPlayers = v end})

T:CreateSection("Движение")
T:CreateToggle({Name = "Speed", CurrentValue = false, Callback = function(v) cfg.speed = v end})
T:CreateSlider({Name = "Speed value", Range = {16,200}, Increment = 1, CurrentValue = 30, Callback = function(v) cfg.speedVal = v end})
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
