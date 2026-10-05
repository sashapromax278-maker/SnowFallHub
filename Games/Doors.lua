-- SnowFall Hub - Doors module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Doors", LoadingTitle = "Doors", LoadingSubtitle = "module"})

local cfg = {
    esp = false,
    items = false,
    coins = false,
    speed = false,
    godmode = false,
    noclip = false,
    infJump = false,
    fullbright = false,
    antiAfk = false,
    autoDoor = false,
    hide = false,
    speedVal = 25
}

local drawings = {}
local function clear()
    for _, d in pairs(drawings) do if d and d.Remove then d:Remove() end end
    drawings = {}
end

local entities = {"Rush","Ambush","Screech","Eyes","Dupe","Seek","Figure","Hide","Jack","Shadow","Glitch"}

local function isEntity(name)
    for _, n in pairs(entities) do
        if name:lower():find(n:lower()) then return n end
    end
end

-- ESP
local function esp()
    clear()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on then
                    local n = isEntity(obj.Name)
                    if n and cfg.esp then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255,0,0), 16, true, true
                        t.Text = n
                        t.Position = Vector2.new(sp.X, sp.Y)
                        table.insert(drawings, t)
                    end
                    if cfg.items then
                        local ln = obj.Name:lower()
                        if ln:find("key") or ln:find("drawer") or ln:find("chest") or ln:find("lever") or ln:find("book") or ln:find("candle") then
                            local t = Drawing.new("Text")
                            t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(0,255,0), 14, true, true
                            t.Text = obj.Name
                            t.Position = Vector2.new(sp.X, sp.Y)
                            table.insert(drawings, t)
                        end
                    end
                end
            end
        end
    end
end

-- АВТО-МОНЕТЫ
local function coins()
    if not cfg.coins then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("coin") then
            if (obj.Position - hrp.Position).Magnitude < 30 then
                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0,3,0))
            end
        end
    end
end

-- SPEED
local function speed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = cfg.speed and cfg.speedVal or 16
    end
end

-- GODMODE
local function godmode()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if cfg.godmode then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end

-- NOCLIP
local function noclip()
    if not cfg.noclip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

-- INF JUMP
local function infJump()
    if not cfg.infJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 200 end
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

-- АВТО-ОТКРЫТИЕ ДВЕРЕЙ
local function autoDoor()
    if not cfg.autoDoor then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = obj.Name:lower()
            if n:find("door") and obj:FindFirstChild("Prompt") then
                local d = (obj.Position - hrp.Position).Magnitude
                if d < 10 then
                    for _, v in pairs(obj:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then
                            fireproximityprompt(v)
                        end
                    end
                end
            end
        end
    end
end

-- АВТО-СПРЯТАТЬСЯ (если рядом сущность)
local function autoHide()
    if not cfg.hide then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local n = isEntity(obj.Name)
            if n then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part and (part.Position - hrp.Position).Magnitude < 40 then
                    for _, closet in pairs(workspace:GetDescendants()) do
                        if closet.Name:lower():find("closet") or closet.Name:lower():find("wardrobe") then
                            local cpart = closet:IsA("BasePart") and closet or closet:FindFirstChildWhichIsA("BasePart")
                            if cpart then
                                hrp.CFrame = CFrame.new(cpart.Position + Vector3.new(0, 3, 0))
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ANTI-AFK
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
    if cfg.esp or cfg.items then esp() end
    coins()
    speed()
    godmode()
    noclip()
    infJump()
    fullbright()
    autoDoor()
    autoHide()
end)

local T = Window:CreateTab("Doors", 4483362458)

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP сущностей", CurrentValue = false, Callback = function(v) cfg.esp = v end})
T:CreateToggle({Name = "Подсветка предметов", CurrentValue = false, Callback = function(v) cfg.items = v end})

T:CreateSection("Авто")
T:CreateToggle({Name = "Авто-монеты", CurrentValue = false, Callback = function(v) cfg.coins = v end})
T:CreateToggle({Name = "Авто-открытие дверей", CurrentValue = false, Callback = function(v) cfg.autoDoor = v end})
T:CreateToggle({Name = "Авто-спрятаться", CurrentValue = false, Callback = function(v) cfg.hide = v end})

T:CreateSection("Движение")
T:CreateToggle({Name = "Speed", CurrentValue = false, Callback = function(v) cfg.speed = v end})
T:CreateSlider({Name = "Speed value", Range = {16,150}, Increment = 1, CurrentValue = 25, Callback = function(v) cfg.speedVal = v end})
T:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) cfg.noclip = v end})
T:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) cfg.infJump = v end})

T:CreateSection("Защита")
T:CreateToggle({Name = "Godmode (режим бога)", CurrentValue = false, Callback = function(v) cfg.godmode = v end})

T:CreateSection("Визуал")
T:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) cfg.fullbright = v end})

T:CreateSection("Прочее")
T:CreateToggle({Name = "Anti-AFK", CurrentValue = false, Callback = function(v) cfg.antiAfk = v end})
