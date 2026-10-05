-- SnowFall Hub - MM2 module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "SnowFall | MM2", LoadingTitle = "MM2", LoadingSubtitle = "module"})

local cfg = {
    espMurderer = false,
    espSheriff = false,
    espInnocent = false,
    espGun = false,
    espCoin = false,
    silentAim = false,
    autoKill = false,
    autoPickup = false,
    speed = false,
    fly = false,
    noclip = false,
    godmode = false,
    infJump = false,
    fullbright = false,
    antiAfk = false,
    speedVal = 25,
    flySpeed = 50,
    fov = 120
}

local drawings = {}
local function clear()
    for _, d in pairs(drawings) do if d and d.Remove then d:Remove() end end
    drawings = {}
end

local function getRole(p)
    if not p.Character then return "Innocent" end
    for _, tool in pairs(p.Character:GetChildren()) do
        if tool:IsA("Tool") then
            if tool.Name:lower():find("knife") then return "Murderer" end
            if tool.Name:lower():find("gun") or tool.Name:lower():find("revolver") then return "Sheriff" end
        end
    end
    return "Innocent"
end

local function roleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 0, 0) end
    if role == "Sheriff" then return Color3.fromRGB(0, 100, 255) end
    return Color3.fromRGB(0, 255, 0)
end

-- ESP
local function esp()
    clear()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Head")
            if h then
                local sp, on = Camera:WorldToViewportPoint(h.Position)
                if on then
                    local role = getRole(p)
                    local show = false
                    if role == "Murderer" and cfg.espMurderer then show = true end
                    if role == "Sheriff" and cfg.espSheriff then show = true end
                    if role == "Innocent" and cfg.espInnocent then show = true end
                    if show then
                        local t = Drawing.new("Text")
                        t.Visible, t.Color, t.Size, t.Center, t.Outline = true, roleColor(role), 16, true, true
                        t.Text = p.Name .. " [" .. role .. "]"
                        t.Position = Vector2.new(sp.X, sp.Y - 20)
                        table.insert(drawings, t)
                    end
                end
            end
        end
    end
    if cfg.espGun or cfg.espCoin then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Tool") then
                local n = obj.Name:lower()
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChild("Handle")
                if part then
                    local sp, on = Camera:WorldToViewportPoint(part.Position)
                    if on then
                        if cfg.espGun and (n:find("gun") or n:find("revolver")) then
                            local t = Drawing.new("Text")
                            t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255, 255, 0), 14, true, true
                            t.Text = obj.Name
                            t.Position = Vector2.new(sp.X, sp.Y)
                            table.insert(drawings, t)
                        end
                        if cfg.espCoin and n:find("coin") then
                            local t = Drawing.new("Text")
                            t.Visible, t.Color, t.Size, t.Center, t.Outline = true, Color3.fromRGB(255, 215, 0), 14, true, true
                            t.Text = "Coin"
                            t.Position = Vector2.new(sp.X, sp.Y)
                            table.insert(drawings, t)
                        end
                    end
                end
            end
        end
    end
end

-- SILENT AIM
local function silentAim()
    if not cfg.silentAim then return end
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
    local closest, shortest = nil, cfg.fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local role = getRole(p)
            if role == "Murderer" or role == "Innocent" then
                local h = p.Character:FindFirstChild("Head")
                if h then
                    local sp, on = Camera:WorldToViewportPoint(h.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if d < shortest then shortest = d closest = h end
                    end
                end
            end
        end
    end
    if closest then
        tool:Activate()
    end
end

-- AUTO KILL (если ты маньяк)
local function autoKill()
    if not cfg.autoKill then return end
    local char = LocalPlayer.Character
    if not char then return end
    local knife = nil
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("knife") then knife = tool end
    end
    if not knife then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local role = getRole(p)
            if role == "Innocent" or role == "Sheriff" then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and myHrp and (hrp.Position - myHrp.Position).Magnitude < 5 then
                    knife:Activate()
                end
            end
        end
    end
end

-- AUTO PICKUP
local function autoPickup()
    if not cfg.autoPickup then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("coin") then
            if (obj.Position - hrp.Position).Magnitude < 50 then
                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
            end
        end
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
    if cfg.espMurderer or cfg.espSheriff or cfg.espInnocent or cfg.espGun or cfg.espCoin then esp() end
    silentAim()
    autoKill()
    autoPickup()
    speed()
    godmode()
    noclip()
    infJump()
    fly()
    fullbright()
end)

local T = Window:CreateTab("MM2", 4483362458)

T:CreateSection("ESP")
T:CreateToggle({Name = "ESP Murderer", CurrentValue = false, Callback = function(v) cfg.espMurderer = v end})
T:CreateToggle({Name = "ESP Sheriff", CurrentValue = false, Callback = function(v) cfg.espSheriff = v end})
T:CreateToggle({Name = "ESP Innocent", CurrentValue = false, Callback = function(v) cfg.espInnocent = v end})
T:CreateToggle({Name = "ESP оружия", CurrentValue = false, Callback = function(v) cfg.espGun = v end})
T:CreateToggle({Name = "ESP монет", CurrentValue = false, Callback = function(v) cfg.espCoin = v end})

T:CreateSection("Aim")
T:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(v) cfg.silentAim = v end})
T:CreateSlider({Name = "FOV", Range = {10,500}, Increment = 10, CurrentValue = 120, Callback = function(v) cfg.fov = v end})

T:CreateSection("Авто")
T:CreateToggle({Name = "Auto Kill (маньяк)", CurrentValue = false, Callback = function(v) cfg.autoKill = v end})
T:CreateToggle({Name = "Auto Pickup монет", CurrentValue = false, Callback = function(v) cfg.autoPickup = v end})

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
