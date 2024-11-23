warn('[TEMPEST HUB] Loading Ui')
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
local selectedMacro = nil
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
    if (not selectedMacro or selectedMacro == "None") then
        Library:Notify("Please select a macro before recording", 3)
        Toggles.RecordMacro:SetValue(false)
        return
    end

    if (not selectedTypeOfRecord or selectedTypeOfRecord == "None") then
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

    if selectedTypeOfRecord == "Time" then
        remoteData.time = tick() - startTime
    end

    if args[2] then
        for key, value in pairs(args[2]) do
            if typeof(value) == "CFrame" then
                remoteData.arguments[2][key] = tostring(value)
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

function playMacro(macroName)
    isPlaying = true
    updateRecordingStatus()
    if not selectedMacro or selectedMacro == "None" then
        Library:Notify("Please select a macro to play", 3)
        return
    end

    local filePath = macrosFolder .. '/' .. macroName .. '.json'
    if not isfile(filePath) then
        Library:Notify("Macro not found: " .. macroName, 3)
        return
    end

    local macroData = game:GetService("HttpService"):JSONDecode(readfile(filePath))
    if not macroData.steps or #macroData.steps == 0 then
        Library:Notify("No steps found in macro: " .. macroName, 3)
        return
    end

    for i, step in ipairs(macroData.steps) do
        local action = step.action
        local remote = game.ReplicatedStorage.Events:FindFirstChild("Unit")
        if not remote then
            warn("Remote not found: Unit")
            return
        end

        local args = step.arguments
        local currentStep = "Step " .. i .. ": " .. action

        for key, value in pairs(args[2]) do
            if typeof(value) == "string" then
                if value:find("CFrame") then
                    args[2][key] = loadstring("return " .. value)()
                elseif value:find("Instance") then
                    args[2][key] = game.Workspace:FindFirstChild(value) or game.ReplicatedStorage:FindFirstChild(value)
                end
            end
        end

        remote:FireServer(unpack(args))
        wait(0.5)
    end

    Library:Notify("Macro execution completed: " .. macroName, 3)
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
        if not selectedMacro or selectedMacro == "None" then
            Library:Notify("Please select a macro before playing", 3)
            return
        end
        playMacro(selectedMacro)
    end
})

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