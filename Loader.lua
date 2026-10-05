-- SnowFall Hub Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SnowFall Hub",
    LoadingTitle = "SnowFall Hub",
    LoadingSubtitle = "SnowFall",
    ConfigurationSaving = { Enabled = true, FolderName = "SnowFallHub", FileName = "config" }
})

local function loadModule(name)
    local url = "https://raw.githubusercontent.com/sashapromax278-maker/SnowFallHub/refs/heads/main/Games/" .. name .. ".lua"
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then
        Rayfield:Notify({Title = "Ошибка", Content = "Модуль " .. name .. " не загрузился", Duration = 5})
    end
end

local MainTab = Window:CreateTab("Главная", 4483362458)

MainTab:CreateSection("Популярные игры")
MainTab:CreateButton({Name = "Doors", Callback = function() loadModule("Doors") end})
MainTab:CreateButton({Name = "Build a Boat", Callback = function() loadModule("BuildABoat") end})
MainTab:CreateButton({Name = "Rivals", Callback = function() loadModule("Rivals") end})
MainTab:CreateButton({Name = "Blox Fruits", Callback = function() loadModule("BloxFruits") end})
MainTab:CreateButton({Name = "MM2", Callback = function() loadModule("MM2") end})
MainTab:CreateButton({Name = "Steal a Brainrot", Callback = function() loadModule("StealABrainrot") end})
MainTab:CreateButton({Name = "Ink Game", Callback = function() loadModule("InkGame") end})
MainTab:CreateButton({Name = "Blade Ball", Callback = function() loadModule("BladeBall") end})
MainTab:CreateButton({Name = "Grow a Garden", Callback = function() loadModule("GrowAGarden") end})

MainTab:CreateSection("Универсальное")
MainTab:CreateButton({Name = "Universal", Callback = function() loadModule("Universal") end})

Rayfield:LoadConfiguration()
