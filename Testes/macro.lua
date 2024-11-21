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
local unitsUsed = {}
local Options = {}

local macrosFolder = 'Tempest Hub/_Anime_Reborn_/Macros'
if not isfolder(macrosFolder) then
    makefolder(macrosFolder)
end

function createJsonFile(fileName)
    if fileName == '' then
        Library:Notify("Please enter a valid macro name", 3)
        return
    end

    local filePath = macrosFolder .. '/' .. fileName .. '.json'
    if isfile(filePath) then
        Library:Notify("Macro already exists: " .. fileName, 3)
        return
    end

    writefile(filePath, "{}")
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
            local filePath = macrosFolder .. '/' .. selectedMacro .. '.json'
            writefile(filePath, game:GetService("HttpService"):JSONEncode(recordingData))
            Library:Notify('Recording saved for: ' .. selectedMacro, 3)
        end
    else
        if selectedMacro then
            isRecording = true
            recordingData = {
                steps = {},
                units = {}
            }
            Library:Notify('Recording started for: ' .. selectedMacro, 3)
        end
    end
end

-- Função para coletar e salvar informações dos remotes
local function collectRemoteInfo(remoteName, args)
    -- Coletar as informações dos remotes
    local remoteData = {
        remote = remoteName,
        arguments = args
    }
    
    -- Adicionar unidades ao registro (caso não tenha sido registrada)
    for _, arg in ipairs(args) do
        if typeof(arg) == 'Instance' and arg:IsA('Model') then
            if not table.find(recordingData.units, arg.Name) then
                table.insert(recordingData.units, arg.Name)
            end
        end
    end

    table.insert(recordingData.steps, remoteData)
end

-- Função para capturar dados do remoto de Upgrade
local function handleUpgradeRemote(args)
    local upgradeData = {
        [1] = "Upgrade",
        [2] = {
            ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(args[1].Name)
        }
    }
    collectRemoteInfo("UpgradeUnit", upgradeData)
end

-- Função para capturar dados do remoto de Sell
local function handleSellRemote(args)
    local sellData = {
        [1] = "Sell",
        [2] = {
            ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(args[1].Name)
        }
    }
    collectRemoteInfo("SellUnit", sellData)
end

-- Função para capturar dados do remoto de Place
local function handlePlaceRemote(args)
    local placeUnitData = {
        [1] = "Place",
        [2] = {
            ["rot"] = math.deg(args[1]),  -- exemplo de ângulo de rotação
            ["slot"] = args[2],           -- exemplo de slot
            ["position"] = CFrame.new(args[3])  -- posição em CFrame
        }
    }
    collectRemoteInfo("PlaceUnit", placeUnitData)
end

-- Função para capturar dados do remoto de Skill (exemplo)
local function handleSkillRemote(args)
    local skillData = {
        [1] = "Skill",
        [2] = {
            ["unit"] = args[1].Name,  -- Exemplo de Skill Unit
            ["skillType"] = args[2]   -- Tipo de habilidade
        }
    }
    collectRemoteInfo("SkillUse", skillData)
end

-- Hooking os remotes para capturar as informações de cada um
local remoteFunctions = {
    ["PlaceUnitRemote"] = handlePlaceRemote,
    ["UpgradeUnitRemote"] = handleUpgradeRemote,
    ["SellUnitRemote"] = handleSellRemote,
    ["SkillUseRemote"] = handleSkillRemote
}

for remoteName, callback in pairs(remoteFunctions) do
    local remote = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild(remoteName)
    
    if remote and remote:IsA("RemoteEvent") then
        local originalFunction = remote.FireServer
        
        setreadonly(remote, false)
        remote.FireServer = function(self, ...)
            local args = {...}
            callback(args)
            return originalFunction(self, ...)
        end
        setreadonly(remote, true)
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