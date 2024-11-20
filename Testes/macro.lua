warn('[TEMPEST HUB] Loading Ui')
wait(1)
local repo = 'https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
Library:Notify('Welcome to Tempest Hub', 5)

local Window = Library:CreateWindow({
    Title = 'Tempest Hub | Anime Reborn',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Anime Reborn Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

local macros = {}
local selectedMacro = nil
local isRecording = false
local recordingData = {}
local Options = {}

local macrosFolder = 'TempestHub/_Anime_Reborn_/Macros'
if not isfolder(macrosFolder) then
    makefolder(macrosFolder)
end

function createJsonFile(fileName)
    if fileName == '' then
        Library:Notify("Please enter a valid macro name", 3)
        return
    end

    local filePath = macrosFolder .. '/' .. fileName .. '.json' -- Caminho para a nova pasta de macros
    if not isfile(filePath) then
        writefile(filePath, "{}") -- Cria um arquivo JSON vazio se não existir
    end
    table.insert(macros, fileName)
    updateDropdown()
    Library:Notify('Macro created: ' .. fileName, 3)
end

function updateDropdown()
    local dropdownValues = {}
    for _, name in ipairs(macros) do
        table.insert(dropdownValues, name)
    end
    if Options.SelectedMacro then
        Options.SelectedMacro:SetValues(dropdownValues)
    else
        warn("Options.SelectedMacro is nil")
    end    
end

function toggleRecording()
    if isRecording then
        isRecording = false
        if selectedMacro then
            local filePath = macrosFolder .. '/' .. selectedMacro .. '.json' -- Salva o arquivo na pasta de macros
            writefile(filePath, game:GetService("HttpService"):JSONEncode(recordingData))
            Library:Notify('Recording saved for: ' .. selectedMacro, 3)
        end
    else
        if selectedMacro then
            isRecording = true
            recordingData = {}
            Library:Notify('Recording started for: ' .. selectedMacro, 3)
        end
    end
end

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Farm")

LeftGroupBox:AddInput('MacroName', {
    Default = '',
    Text = "Macro Name",
    Numeric = false,
    Finished = true,
    Placeholder = 'Enter Macro Name',
    Callback = function(Value)
        createJsonFile(Value)
    end
})

Options.SelectedMacro = LeftGroupBox:AddDropdown('SelectedMacro', {
    Values = macros,
    Default = "None",
    Multi = false,
    Text = 'Select Macro',
    Callback = function(Value)
        selectedMacro = Value
    end
})

LeftGroupBox:AddToggle("RecordMacro", {
    Text = 'Record/Stop Macro',
    Default = false,
    Callback = function(Value)
        if selectedMacro == nil or selectedMacro == "None" then
            Library:Notify("Please select a macro before recording", 3)
            Options.RecordMacro:SetState(false)
        else
            toggleRecording()
        end
    end,
})

LeftGroupBox:AddToggle("PlayMacro", {
    Text = "Execute Macro",
    Default = false,
    Callback = function(Value)
        if selectedMacro == nil or selectedMacro == "None" then
            Library:Notify("Please select a macro before executing", 3)
            Options.PlayMacro:SetState(false)
        else
            Library:Notify("Executing macro: " .. selectedMacro, 3)
        end
    end,
})

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local StartTime = tick()

local WatermarkConnection

local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function UpdateWatermark()
    FrameCounter = FrameCounter + 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    local activeTime = tick() - StartTime

    Library:SetWatermark(('Tempest Hub | %s fps | %s ms | %s'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()),
        FormatTime(activeTime)
    ))
end

WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(UpdateWatermark)

local TabsUI = {
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local function Unload()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end

local MenuGroup = TabsUI['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', Unload)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('Tempest Hub')
SaveManager:SetFolder('Tempest Hub/_Anime_Reborn_')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_Anime_Reborn_'
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

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
warn('[TEMPEST HUB] Loaded')