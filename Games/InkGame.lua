-- SnowFall Hub - Ink Game module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Ink Game", LoadingTitle = "Ink Game", LoadingSubtitle = "module"})

local cfg = {
    espMonster = false,
    espItems = false,
    espDoors = false,
    espPlayers = false,
    espRoles = false,
    glassVision = false,
    autoCollect = false,
    autoDoor = false,
    hide = false,
    autoFinish = false,
    autoDalgona = false,
    autoTug = false,
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

local monsterNames = {"monster","ink","demon","entity","shadow","beast","creature","seeker"}

local function isMonster(name)
    for _, n in pairs(monsterNames) do
        if name:lower():find(n) then return true end
    end
    return false
end

-- ESP
local function esp()
    clear()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on then
                    local n = obj.Name:lower()
                    if cfg.espMonster and isMonster(n) then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255,0,0), 16, true, true
                        t.Text = "МОНСТР: " .. obj.Name
                        t.Position = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, t)
                    end
                    if cfg.espItems and (n:find("item") or n:find("key") or n:find("coin") or n:find("paper") or n:find("note") or n:find("bandage")) then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255,215,0), 14, true, true
                        t.Text = obj.Name
                        t.Position = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, t)
                    end
                    if cfg.espDoors and n:find("door") then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(0,255,0), 14, true, true
                        t.Text = "Дверь"
                        t.Position = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, t)
                    end
                    if cfg.glassVision and (n:find("glass") or n:find("panel") or n:find("bridge") or n:find("tile")) then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(0,255,255), 14, true, true
                        t.Text = "БЕЗОПАСНО"
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
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(0,255,255), 14, true, true
                        t.Text = p.Name
                        t.Position = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, t)
                    end
                end
            end
        end
    end
    if cfg.espRoles then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Head")
                if h then
                    local sp, on = Camera:WorldToViewportPoint(h.Position)
                    if on then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255,100,0), 14, true, true
                        t.Text = "Игрок"
                        t.Position = Vector2.new(sp.X, sp.Y + 15)
                        table.insert(drawings, t)
                    end
                end
            end
        end
    end
end

-- АВТО-СБОР
local function autoCollect()
    if not cfg.autoCollect then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("item") or n:find("key") or n:find("coin") or n:find("paper") or n:find("note") or n:find("bandage") then
                if (obj.Position - hrp.Position).Magnitude < 50 then
                    hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end
end

-- АВТО-ДВЕРИ
local function autoDoor()
    if not cfg.autoDoor then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("door") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part and (part.Position - hrp.Position).Magnitude < 10 then
                for _, v in pairs(obj:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                end
            end
        end
    end
end

-- АВТО-СПРЯТАТЬСЯ
local function autoHide()
    if not cfg.hide then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if isMonster(obj.Name) then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part and (part.Position - hrp.Position).Magnitude < 40 then
                    for _, c in pairs(workspace:GetDescendants()) do
                        local cn = c.Name:lower()
                        if cn:find("closet") or cn:find("locker") or cn:find("cabinet") or cn:find("hide") then
                            local cp = c:IsA("BasePart") and c or c:FindFirstChildWhichIsA("BasePart")
                            if cp then hrp.CFrame = CFrame.new(cp.Position + Vector3.new(0,3,0)) end
                        end
                    end
                end
            end
        end
    end
end

-- АВТО-ФИНИШ (телепорт к финишу)
local function autoFinish()
    if not cfg.autoFinish then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("finish") or n:find("goal") or n:find("end") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                break
            end
        end
    end
end

-- АВТО-ДАЛЬГОНА (спам кликов по печенью)
local function autoDalgona()
    if not cfg.autoDalgona then return end
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
end

-- АВТО-TUG (спам QTE)
local function autoTug()
    if not cfg.autoTug then return end
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
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
    if cfg.espMonster or cfg.espItems or cfg.espDoors or cfg.espPlayers or cfg.espRoles or cfg.glassVision then esp() end
    autoCollect()
    autoDoor()
    autoHide()
    autoFinish()
    autoDalgona()
    autoTug()
    speed()
    godmode()
    noclip()
    infJump()
    fly()
    fullbright()
end)

local T = Window:CreateTab("Ink Game", 4483362458)

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP монстров", CurrentValue = false, Callback = function(v) cfg.espMonster = v end})
T:CreateToggle({Name = "ESP предметов", CurrentValue = false, Callback = function(v) cfg.espItems = v end})
T:CreateToggle({Name = "ESP дверей", CurrentValue = false, Callback = function(v) cfg.espDoors = v end})
T:CreateToggle({Name = "ESP игроков", CurrentValue = false, Callback = function(v) cfg.espPlayers = v end})
T:CreateToggle({Name = "ESP ролей", CurrentValue = false, Callback = function(v) cfg.espRoles = v end})
T:CreateToggle({Name = "Glass Vision (безопасные панели)", CurrentValue = false, Callback = function(v) cfg.glassVision = v end})

T:CreateSection("Авто")
T:CreateToggle({Name = "Авто-сбор предметов", CurrentValue = false, Callback = function(v) cfg.autoCollect = v end})
T:CreateToggle({Name = "Авто-открытие дверей", CurrentValue = false, Callback = function(v) cfg.autoDoor = v end})
T:CreateToggle({Name = "Авто-спрятаться", CurrentValue = false, Callback = function(v) cfg.hide = v end})
T:CreateToggle({Name = "Авто-финиш (телепорт)", CurrentValue = false, Callback = function(v) cfg.autoFinish = v end})
T:CreateToggle({Name = "Авто-Дальгона", CurrentValue = false, Callback = function(v) cfg.autoDalgona = v end})
T:CreateToggle({Name = "Авто-Tug of War", CurrentValue = false, Callback = function(v) cfg.autoTug = v end})

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
