-- SnowFall Hub - Build a Boat For Treasure module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | Build a Boat", LoadingTitle = "Build a Boat", LoadingSubtitle = "module"})

local cfg = {
    autoSail = false,
    autoCollect = false,
    autoRespawn = false,
    autoUpgrade = false,
    autoBuy = false,
    espTreasure = false,
    espPlayers = false,
    speedBoat = false,
    fly = false,
    noclip = false,
    infJump = false,
    sailSpeed = 50,
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

local function autoSail()
    if not cfg.autoSail then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local boat = workspace:FindFirstChild("Boat")
    if hrp and boat then
        local seat = boat:FindFirstChildWhichIsA("VehicleSeat")
        if seat then
            hrp.CFrame = seat.CFrame * CFrame.new(0, 3, 0)
        end
        local body = boat:FindFirstChild("SnowFallSail")
        if not body then
            body = Instance.new("BodyVelocity")
            body.Name = "SnowFallSail"
            body.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            body.Parent = boat.PrimaryPart or boat
        end
        body.Velocity = Vector3.new(0, 0, -cfg.sailSpeed)
    end
end

local function autoCollect()
    if not cfg.autoCollect then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("treasure") or n:find("gold") or n:find("chest") or n:find("coin") then
                if (obj.Position - hrp.Position).Magnitude < 50 then
                    hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end
end

local function autoRespawn()
    if not cfg.autoRespawn then return end
    local char = getChar()
    if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
        LocalPlayer:LoadCharacter()
    end
end

local function autoUpgrade()
    if not cfg.autoUpgrade then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("TextButton") then
            local t = v.Text:lower()
            if t:find("upgrade") or t:find("улучшить") then
                v:FireServer()
            end
        end
    end
end

local function autoBuy()
    if not cfg.autoBuy then return end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("TextButton") then
            local t = v.Text:lower()
            if t:find("buy") or t:find("купить") or t:find("purchase") then
                v:FireServer()
            end
        end
    end
end

local function esp()
    clear()
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if cfg.espTreasure then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("treasure") or n:find("gold") or n:find("chest") then
                    local sp, on = Camera:WorldToViewportPoint(obj.Position)
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

local function speedBoat()
    if not cfg.speedBoat then return end
    local boat = workspace:FindFirstChild("Boat")
    if boat then
        local body = boat:FindFirstChild("SnowFallSpeed")
        if not body then
            body = Instance.new("BodyVelocity")
            body.Name = "SnowFallSpeed"
            body.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            body.Parent = boat.PrimaryPart or boat
        end
        body.Velocity = Vector3.new(0, 0, -cfg.sailSpeed)
    end
end

local function fly()
    if not cfg.fly then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local move = Vector3.new(0, 0, 0)
    local cam = workspace.CurrentCamera.CFrame
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
    hrp.Velocity = move * cfg.flySpeed
end

local function noclip()
    if not cfg.noclip then return end
    local char = getChar()
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

local function infJump()
    if not cfg.infJump then return end
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 200 end
end

RunService.Heartbeat:Connect(function()
    autoSail()
    autoCollect()
    autoRespawn()
    autoUpgrade()
    autoBuy()
    if cfg.espTreasure or cfg.espPlayers then esp() end
    speedBoat()
    fly()
    noclip()
    infJump()
end)

local T = Window:CreateTab("Build a Boat", 4483362458)

T:CreateSection("Авто")
T:CreateToggle({Name = "Авто-плавание", CurrentValue = false, Callback = function(v) cfg.autoSail = v end})
T:CreateToggle({Name = "Авто-сбор сокровищ", CurrentValue = false, Callback = function(v) cfg.autoCollect = v end})
T:CreateToggle({Name = "Авто-респавн", CurrentValue = false, Callback = function(v) cfg.autoRespawn = v end})
T:CreateToggle({Name = "Авто-улучшение", CurrentValue = false, Callback = function(v) cfg.autoUpgrade = v end})
T:CreateToggle({Name = "Авто-покупка", CurrentValue = false, Callback = function(v) cfg.autoBuy = v end})

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP сокровищ", CurrentValue = false, Callback = function(v) cfg.espTreasure = v end})
T:CreateToggle({Name = "ESP игроков", CurrentValue = false, Callback = function(v) cfg.espPlayers = v end})

T:CreateSection("Движение")
T:CreateToggle({Name = "Speed лодки", CurrentValue = false, Callback = function(v) cfg.speedBoat = v end})
T:CreateSlider({Name = "Скорость лодки", Range = {10,200}, Increment = 5, CurrentValue = 50, Callback = function(v) cfg.sailSpeed = v end})
T:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v) cfg.fly = v end})
T:CreateSlider({Name = "Скорость полёта", Range = {10,200}, Increment = 5, CurrentValue = 50, Callback = function(v) cfg.flySpeed = v end})
T:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) cfg.noclip = v end})
T:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) cfg.infJump = v end})
