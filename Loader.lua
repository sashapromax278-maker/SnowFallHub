-- SnowFall Hub Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SnowFall Hub",
    LoadingTitle = "SnowFall Hub",
    LoadingSubtitle = "by SnowFall",
    ConfigurationSaving = { Enabled = true, FolderName = "SnowFallHub", FileName = "config" }
})

local function loadModule(name)
    local url = "https://raw.githubusercontent.com/sashapromax278-maker/SnowFallHub/main/Games/" .. name .. ".lua"
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then
        Rayfield:Notify({Title = "Ошибка", Content = "Модуль " .. name .. " не загрузился", Duration = 5})
    end
end

local MainTab = Window:CreateTab("Главная", 4483362458)

MainTab:CreateButton({Name = "Doors", Callback = function() loadModule("Doors") end})
MainTab:CreateButton({Name = "Build a Boat", Callback = function() loadModule("BuildABoat") end})
MainTab:CreateButton({Name = "Blade Ball", Callback = function() loadModule("BladeBall") end})
MainTab:CreateButton({Name = "Pet Sim", Callback = function() loadModule("PetSim") end})

Rayfield:LoadConfiguration()
