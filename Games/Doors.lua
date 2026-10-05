-- SnowFall Hub - Doors module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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
                        if ln:find("key") or ln:find("drawer") or ln:find("chest") or ln:find("lever") then
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

local function speed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = cfg.speed and cfg.speedVal or 16
    end
end

local function godmode()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if cfg.godmode then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.NameDisplayDistance = 0
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    godmode()
end)

RunService.Heartbeat:Connect(function()
    if cfg.esp or cfg.items then esp() end
    coins()
    speed()
    godmode()
end)

local T = Window:CreateTab("Doors", 4483362458)
T:CreateToggle({Name = "ESP сущностей", CurrentValue = false, Callback = function(v) cfg.esp = v end})
T:CreateToggle({Name = "Подсветка предметов", CurrentValue = false, Callback = function(v) cfg.items = v end})
T:CreateToggle({Name = "Авто-монеты", CurrentValue = false, Callback = function(v) cfg.coins = v end})
T:CreateToggle({Name = "Speed", CurrentValue = false, Callback = function(v) cfg.speed = v end})
T:CreateSlider({Name = "Speed value", Range = {16,100}, Increment = 1, CurrentValue = 25, Callback = function(v) cfg.speedVal = v end})
T:CreateToggle({Name = "Godmode (режим бога)", CurrentValue = false, Callback = function(v) cfg.godmode = v end})
