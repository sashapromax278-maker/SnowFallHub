-- SnowFall Hub - Grow a Garden module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Grow a Garden", LoadingTitle = "Grow a Garden", LoadingSubtitle = "module"})

local cfg = {
    autoCollect = false,
    autoPlant = false,
    autoBuy = false,
    autoSell = false,
    speed = false,
    fly = false,
    noclip = false,
    godmode = false,
    infJump = false,
    fullbright = false,
    antiAfk = false,
    speedVal = 30,
    flySpeed = 50,
    collectRange = 150
}

local function getChar()
    return LocalPlayer.Character
end

-- АВТО-СБОР
local function autoCollect()
    if not cfg.autoCollect then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = obj.Name:lower()
            if n:find("fruit") or n:find("crop") or n:find("plant") or n:find("harvest") or n:find("flower") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part and (part.Position - hrp.Position).Magnitude < cfg.collectRange then
                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                    for _, v in pairs(obj:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                    end
                end
            end
        end
    end
end

-- АВТО-ПОСАДКА
local function autoPlant()
    if not cfg.autoPlant then return end
    local char = getChar()
    if not char then return end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then return end
    tool:Activate()
end

-- АВТО-ПОКУПКА
local function autoBuy()
    if not cfg.autoBuy then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("TextButton") then
            local t = v.Text:lower()
            if t:find("buy") or t:find("purchase") or t:find("seed") then
                v:FireServer()
            end
        end
    end
end

-- АВТО-ПРОДАЖА
local function autoSell()
    if not cfg.autoSell then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("TextButton") then
            local t = v.Text:lower()
            if t:find("sell") or t:find("продать") then
                v:FireServer()
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
    autoCollect()
    autoPlant()
    autoBuy()
    autoSell()
    speed()
    godmode()
    noclip()
    infJump()
    fly()
    fullbright()
end)

local T = Window:CreateTab("Grow a Garden", 4483362458)

T:CreateSection("Авто")
T:CreateToggle({Name = "Авто-сбор", CurrentValue = false, Callback = function(v) cfg.autoCollect = v end})
T:CreateToggle({Name = "Авто-посадка", CurrentValue = false, Callback = function(v) cfg.autoPlant = v end})
T:CreateToggle({Name = "Авто-покупка семян", CurrentValue = false, Callback = function(v) cfg.autoBuy = v end})
T:CreateToggle({Name = "Авто-продажа", CurrentValue = false, Callback = function(v) cfg.autoSell = v end})
T:CreateSlider({Name = "Радиус сбора", Range = {50,500}, Increment = 10, CurrentValue = 150, Callback = function(v) cfg.collectRange = v end})

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
