warn('[TEMPEST HUB] Loading UI')
wait(1)

local repo = 'https://raw.githubusercontent.com/TrilhaX/tempestHubUI/main/'
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
wait(3)

local macros = {}
local selectedMacro
local isRecording = false
local isPlaying = false
local recordingData = {}
local Options = {}
local selectedTypeOfRecord = "None"
local startTime = tick()

local macrosFolder = 'Tempest Hub/_Anime_Reborn_/Macros'
if not isfolder(macrosFolder) then
    makefolder(macrosFolder)
end

function updateDropdown()
    macros = {}
    for _, file in ipairs(listfiles(macrosFolder)) do
        if file:match("%.json$") then
            table.insert(macros, file:match("([^/]+)%.json$"))
        end
    end

    if Options.SelectedMacro then
        Options.SelectedMacro:SetValues(macros)
    else
        warn("Options.SelectedMacro is nil")
    end
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
    updateDropdown()
    Library:Notify('Macro created: ' .. fileName, 3)
end

function toggleRecording()
    if not selectedMacro or selectedMacro == "None" then
        Library:Notify("Please select a macro before recording", 3)
        Toggles.RecordMacro:SetValue(false)
        return
    end

    if not selectedTypeOfRecord or selectedTypeOfRecord == "None" then
        Library:Notify("Please select a type of record before recording", 3)
        Toggles.RecordMacro:SetValue(false)
        return
    end

    isRecording = not isRecording
    updateRecordingStatus()

    if isRecording then
        recordingData = { steps = {}, currentStepIndex = 0 }
    else
        table.sort(recordingData.steps, function(a, b)
            return a.index < b.index
        end)

        local filePath = macrosFolder .. '/' .. selectedMacro .. '.json'
        writefile(filePath, game:GetService("HttpService"):JSONEncode(recordingData))
    end
end

function collectRemoteInfo(remoteName, args)
    local remoteData = { 
        action = args[1], 
        arguments = { [1] = args[1], [2] = {} }, 
        index = recordingData.currentStepIndex + 1
    }

    recordingData.currentStepIndex = remoteData.index

    if selectedTypeOfRecord == "Time" or selectedTypeOfRecord == "Hybrid" then
        remoteData.time = tick() - startTime
    end

    if selectedTypeOfRecord == "Money" or selectedTypeOfRecord == "Hybrid" then
        local money = game.Players.LocalPlayer.notSavable.money
        if money then
            remoteData.money = money.Value
        end     
    end

    if args[2] then
        for key, value in pairs(args[2]) do
            if typeof(value) == "CFrame" then
                remoteData.arguments[2][key] = {X = value.X, Y = value.Y, Z = value.Z}            
            elseif typeof(value) == "Instance" then
                remoteData.arguments[2][key] = value.Name or tostring(value)
            else
                remoteData.arguments[2][key] = tostring(value)
            end
        end
    end

    table.insert(recordingData.steps, remoteData)
    print("Collected remote info:", remoteData)
end

function handleUnitRemote(args)
    if not isRecording then return end

    local action = args[1]
    print("Received action:", action, "with arguments:", args)

    if action == "Place" then
        collectRemoteInfo("PlaceUnit", args)
    elseif action == "Upgrade" then
        collectRemoteInfo("UpgradeUnit", args)
    elseif action == "Sell" then
        collectRemoteInfo("SellUnit", args)
    elseif action == "Skill" and getgenv().recordSkill == true then
        collectRemoteInfo("SkillUse", args)
    else
        warn("Unknown action:", action)
    end
end

function updateRecordingStatus()
    if isRecording then
        RecordingStatusLabel:SetText("Recording Status: Recording...")
    elseif isPlaying then
        RecordingStatusLabel:SetText("Playing Status: " .. selectedMacro)
    else
        RecordingStatusLabel:SetText("Recording Status: Not Recording or Playing")
    end
end

function updateSlotStatus(selectedSlot, selectedUnit)
    updateStatus("Selected Slot: " .. selectedSlot .. " | Unit: " .. selectedUnit)
end

function playMacro(macroName)
    local filePath = macrosFolder .. '/' .. macroName .. '.json'
    print("Verificando o arquivo da macro:", filePath)
    if not isfile(filePath) then
        Library:Notify("Macro não encontrada: " .. macroName, 3)
        print("Macro não encontrada: " .. macroName)
        return
    end
    
    local macroData = game:GetService("HttpService"):JSONDecode(readfile(filePath))
    print("Macro carregada com sucesso:", macroName)
    print("Número de etapas da macro:", #macroData.steps)
    local currentStepIndex = 1

    local function checkConditions(step)
        print("Verificando condições da etapa:", currentStepIndex)
        local conditionsMet = true

        if step.time then
            print("Condição de tempo detectada:", step.time)
            if tick() - startTime < step.time then
                conditionsMet = false
            end
        end

        if step.money then
            local money = game.Players.LocalPlayer.notSavable.money
            print("Verificando dinheiro:", money.Value)
            if money and money.Value < step.money then
                conditionsMet = false
            end
        end

        print("Condições atendidas para a etapa:", conditionsMet)
        return conditionsMet
    end

    local function executeStep(step)
        print("Executando a etapa:", step.action)  -- Imprime a ação da etapa
        local remote = game.ReplicatedStorage.Events.Unit
        if remote then
            if type(step.arguments) == "table" then
                print("Argumentos da etapa (tabela): ", unpack(step.arguments))
                if step.arguments[2] and step.arguments[2].position then
                    local pos = step.arguments[2].position
                    if pos.X and pos.Y and pos.Z then
                        remote:FireServer(step.action, {
                            rot = step.arguments[2].rot,
                            slot = step.arguments[2].slot,
                            position = CFrame.new(pos.X, pos.Y, pos.Z)
                        })
                    else
                        warn("Position data is incomplete!")
                    end
                else
                    warn("Position is missing or nil!")
                end                
            else
                print("Argumentos da etapa (não tabela):", step.arguments)
                remote:FireServer(step.action, step.arguments)
            end
        else
            warn("Remote não encontrado para a ação: " .. step.action)
        end
    end     

    while currentStepIndex <= #macroData.steps do
        local step = macroData.steps[currentStepIndex]
        print("Processando a etapa:", currentStepIndex)

        if checkConditions(step) then
            executeStep(step)
            currentStepIndex = currentStepIndex + 1
        else
            print("Condições não atendidas, esperando 1 segundo...")
            wait(1)
        end
    end
    Library:Notify("Macro " .. macroName .. " executada com sucesso!", 3)
    print("Macro executada com sucesso:", macroName)
end

local originalFireServer
originalFireServer = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and self.Name == "Unit" and self.Parent == game.ReplicatedStorage.Events then
        handleUnitRemote(args)
    end
    
    return originalFireServer(self, ...)
end)

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Macro")

Options.SelectedMacro = LeftGroupBox:AddDropdown('SelectedMacro', {
    Values = macros,
    Default = "None",
    Text = 'Select Macro',
    Callback = function(Value)
        selectedMacro = Value
        SelectedMacroLabel:SetText("Selected Macro: " .. (selectedMacro or "None"))
    end
})

LeftGroupBox:AddInput('MacroName', {
    Default = '',
    Text = "Macro Name",
    Finished = true,
    Placeholder = 'Enter Macro Name',
    Callback = createJsonFile
})

local MyButton = LeftGroupBox:AddButton({
    Text = 'Delete Macro',
    Func = function()
        if selectedMacro and selectedMacro ~= "None" then
            local filePath = macrosFolder .. '/' .. selectedMacro .. '.json'
            if isfile(filePath) then
                delfile(filePath)
                updateDropdown()
                Library:Notify('Macro deleted: ' .. selectedMacro, 3)
            else
                Library:Notify("Macro not found: " .. selectedMacro, 3)
            end
        else
            Library:Notify("Please select a macro before deleting", 3)
        end
    end
})

LeftGroupBox:AddToggle("RecordMacro", {
    Text = 'Record Macro',
    Callback = function(Value)
        if Value then
            if not isRecording then
                toggleRecording()
            end
        else
            if isRecording then
                toggleRecording()
            end
        end
    end
})

LeftGroupBox:AddToggle("PlayMacro",{
    Text = "Play Macro",
    Func = function()
        print("Macro selecionada:", selectedMacro)
        if not selectedMacro or selectedMacro == "None" then
            Library:Notify("Please select a macro before playing", 3)
            return
        end
        playMacro(selectedMacro)
    end    
})

playMacro("Sla")

Options.SelectedRecordingMethod = LeftGroupBox:AddDropdown('SelectedRecordingMethod', {
    Values = {"Time", "Money", "Hybrid"},
    Default = "None",
    Text = 'Select Type of Record',
    Callback = function(Value)
        selectedTypeOfRecord = Value
        RecordingMethodLabel:SetText("Recording Method: " .. selectedTypeOfRecord)
        if selectedTypeOfRecord == "Time" then
            startTime = tick()
        end
    end
})

LeftGroupBox:AddToggle("RecordSkillMacro", {
    Text = 'Record Skill in Macro',
    Callback = function(Value)
        getgenv().recordSkill = Value
    end
})

LeftGroupBox:AddDivider()

RecordingStatusLabel = LeftGroupBox:AddLabel('Recording Status: Not Recording', true)
SelectedMacroLabel = LeftGroupBox:AddLabel('Selected Macro: None', true)
RecordingMethodLabel = LeftGroupBox:AddLabel('Recording Method: None', true)

updateDropdown() 

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

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('Tempest Hub')
SaveManager:SetFolder('Tempest Hub/_MACRO_')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_MACRO_'
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