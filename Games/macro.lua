warn('[TEMPEST HUB] Loading Bypass')
wait(1)
warn('[TEMPEST HUB] Loading Ui')
wait(1)
local repo = 'https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
Library:Notify('Welcome to Tempest Hub', 5)

local Window = Library:CreateWindow({
    Title = 'Tempest Hub | Ultimate Tower Defense',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Ultimate Tower Defense Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

local SaveNameFiles = {}

local Tabs = {
    Main = Window:AddTab('Macro'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Macro Options')

LeftGroupBox:AddDropdown('FilesName', {
    Values = SaveNameFiles,
    Default = "None",
    Multi = false,
    Text = 'Choose Macro',
    Callback = function(value)
        print("Callback do Dropdown")
    end
})

LeftGroupBox:AddInput('NameFile', {
    Default = '',
    Numeric = false,
    Finished = true,
    Text = 'Put Name File',
    Placeholder = 'Press Enter To Save Name',
    Callback = function(Value)
        local HttpService = game:GetService("HttpService")
        local usernamefile = tostring(Value)  -- Captura o valor digitado e converte para string
        local JSON = HttpService:JSONEncode(Settings)
        local success, errorMessage = pcall(function()
            writefile("Tempest_Hub\\_U_T_D\\Macro\\".. usernamefile .. ".json", JSON)
        end)
        if not success then
            warn("Failed to save settings: " .. errorMessage)
        end
    end
})

-- Function to print SaveNameFiles for testing purposes
local function printSaveNameFiles()
    print("Saved Files:")
    for _, name in ipairs(SaveNameFiles) do
        print(name)
    end
end

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection

-- Create a function to update FPS and ping information
local function UpdateWatermark()
    FrameCounter = FrameCounter + 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    Library:SetWatermark(('Tempest Hub | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end

-- Connect the function to the RenderStepped event
WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(UpdateWatermark)

-- Create tabs for UI settings
local TabsUI = {
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Unload function
local function Unload()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end

-- UI Settings
local MenuGroup = TabsUI['UI Settings']:AddLeftGroupbox('Menu')

-- Add an unload button
MenuGroup:AddButton('Unload', Unload)

-- Add a label and key picker for the menu keybind
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

-- Define the ToggleKeybind variable
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('Tempest Hub')
SaveManager:SetFolder('Tempest Hub/_U_T_D')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_U_T_D'
local player = game.Players.LocalPlayer
SaveManager:Load(player.Name .. GameConfigName)
spawn(function()
    while task.wait(1) do
        if Library.Unloaded then
            break
        end
        SaveManager:Save(player.Name .. GameConfigName)
    end
end)

-- Disable player idling
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
warn('[TEMPEST HUB] Loaded')