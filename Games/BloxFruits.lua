-- SnowFall Hub - Blox Fruits module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Blox Fruits", LoadingTitle = "Blox Fruits", LoadingSubtitle = "module"})

local cfg = {
    autoFarm = false,
    autoQuest = false,
    autoChest = false,
    autoFruit = false,
    espFruit = false,
    espPlayers = false,
    espChest = false,
    speed = false,
    fly = false,
    noclip = false,
    godmode = false,
    infJump = false,
    fullbright = false,
    antiAfk = false,
    speedVal = 50,
    flySpeed = 60,
    farmRange = 200
}

local drawings = {}
local function clear()
    for _, d in pairs(drawings) do if d and d.Remove then d:Remove() end end
    drawings = {}
end

local function getChar()
    return LocalPlayer.Character
end

-- АВТО-ФАРМ (ближайший NPC)
local function autoFarm()
    if not cfg.autoFarm then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local closest, dist = nil, cfg.farmRange
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum.Health > 0 then
                local hrp2 = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if hrp2 then
                    local d = (hrp2.Position - hrp.Position).Magnitude
                    if d < dist then dist = d closest = obj end
                end
            end
        end
    end
    if closest then
        local target = closest:FindFirstChild("HumanoidRootPart") or closest:FindFirstChild("Head")
        if target then
            hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 5, 0))
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    tool:Activate()
                end
            end
        end
    end
end

-- АВТО-КВЕСТ
local function autoQuest()
    if not cfg.autoQuest then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("TextButton") and (v.Text:lower():find("quest") or v.Text:lower():find("accept")) then
            v:FireServer()
        end
    end
end

-- АВТО-СУНДУКИ
local function autoChest()
    if not cfg.autoChest then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("chest") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part and (part.Position - hrp.Position).Magnitude < 100 then
                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
                end
            end
        end
    end
end

-- АВТО-ФРУКТЫ
local function autoFruit()
    if not cfg.autoFruit then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj.Name:lower():find("fruit") then
            hrp.CFrame = CFrame.new(obj.Handle.Position + Vector3.new(0, 3, 0))
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
    if cfg.espFruit then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:lower():find("fruit") then
                local sp, on = Camera:WorldToViewportPoint(obj.Handle.Position)
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
    if cfg.espChest then
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("BasePart")) and obj.Name:lower():find("chest") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local sp, on = Camera:WorldToViewportPoint(part.Position)
                    if on then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255, 215, 0), 14, true, true
                        t.Text = obj.Name
                        t.Position = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, t)
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
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(0, 255, 255), 14, true, true
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
    autoFarm()
    autoQuest()
    autoChest()
    autoFruit()
    if cfg.espFruit or cfg.espChest or cfg.espPlayers then esp() end
    speed()
    godmode()
    noclip()
    infJump()
    fly()
    fullbright()
end)

local T = Window:CreateTab("Blox Fruits", 4483362458)

T:CreateSection("Авто")
T:CreateToggle({Name = "Авто-фарм NPC", CurrentValue = false, Callback = function(v) cfg.autoFarm = v end})
T:CreateToggle({Name = "Авто-квест", CurrentValue = false, Callback = function(v) cfg.autoQuest = v end})
T:CreateToggle({Name = "Авто-сундуки", CurrentValue = false, Callback = function(v) cfg.autoChest = v end})
T:CreateToggle({Name = "Авто-фрукты", CurrentValue = false, Callback = function(v) cfg.autoFruit = v end})
T:CreateSlider({Name = "Радиус фарма", Range = {50,500}, Increment = 10, CurrentValue = 200, Callback = function(v) cfg.farmRange = v end})

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP фруктов", CurrentValue = false, Callback = function(v) cfg.espFruit = v end})
T:CreateToggle({Name = "ESP сундуков", CurrentValue = false, Callback = function(v) cfg.espChest = v end})
T:CreateToggle({Name = "ESP игроков", CurrentValue = false, Callback = function(v) cfg.espPlayers = v end})

T:CreateSection("Движение")
T:CreateToggle({Name = "Speed", CurrentValue = false, Callback = function(v) cfg.speed = v end})
T:CreateSlider({Name = "Speed value", Range = {16,300}, Increment = 1, CurrentValue = 50, Callback = function(v) cfg.speedVal = v end})
T:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v) cfg.fly = v end})
T:CreateSlider({Name = "Fly speed", Range = {10,300}, Increment = 5, CurrentValue = 60, Callback = function(v) cfg.flySpeed = v end})
T:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) cfg.noclip = v end})
T:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) cfg.infJump = v end})

T:CreateSection("Защита")
T:CreateToggle({Name = "Godmode", CurrentValue = false, Callback = function(v) cfg.godmode = v end})

T:CreateSection("Визуал")
T:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) cfg.fullbright = v end})

T:CreateSection("Прочее")
T:CreateToggle({Name = "Anti-AFK", CurrentValue = false, Callback = function(v) cfg.antiAfk = v end})
