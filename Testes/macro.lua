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
wait(3)

local macros = {}
local selectedMacro = nil
local isRecording = false
local recordingData = {}
local Options = {}

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
        return
    end

    isRecording = not isRecording

    if isRecording then
        recordingData = { steps = {} }
        Library:Notify('Recording started for: ' .. selectedMacro, 3)
    else
        local filePath = macrosFolder .. '/' .. selectedMacro .. '.json'
        writefile(filePath, game:GetService("HttpService"):JSONEncode(recordingData))
        Library:Notify('Recording saved for: ' .. selectedMacro, 3)
    end
end

function collectRemoteInfo(remoteName, args)
    local remoteData = { action = args[1], arguments = { [1] = args[1], [2] = {} } }

    if args[2] and typeof(args[2]) == "table" then
        remoteData.arguments[2] = {
            position = tostring(args[2].position), -- Armazena como string
            rot = math.deg(args[2].rot), -- Converte para graus antes de armazenar
            slot = args[2].slot or "DefaultSlot"
        }
    else
        warn("Invalid or missing args[2] for PlaceUnit")
        return
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
    elseif action == "Skill" then
        collectRemoteInfo("SkillUse", args)
    else
        warn("Unknown action:", action)
    end
end

function playMacro(macroName)
    if not macroName or macroName == "None" then
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

    Library:Notify("Playing macro: " .. macroName, 3)

    for _, step in ipairs(macroData.steps) do
        local action = step.action
        local remote = game.ReplicatedStorage.Events:FindFirstChild("Unit")
        if not remote then
            warn("Remote not found: Unit")
        end

        local args = step.arguments

        -- Convertendo valores armazenados de volta para os formatos esperados
        for key, value in pairs(args[2]) do
            if key == "position" then
                args[2][key] = loadstring("return " .. value)()
            elseif key == "rot" then
                args[2][key] = math.rad(value) -- Convertendo graus de volta para radianos
            end
        end

        -- Chama o RemoteEvent com os argumentos convertidos
        remote:FireServer(unpack(args))
        wait(0.5) -- Delay entre cada execução
    end

    Library:Notify("Macro execution completed: " .. macroName, 3)
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

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Farm")

LeftGroupBox:AddInput('MacroName', {
    Default = '',
    Text = "Macro Name",
    Finished = true,
    Placeholder = 'Enter Macro Name',
    Callback = createJsonFile
})

Options.SelectedMacro = LeftGroupBox:AddDropdown('SelectedMacro', {
    Values = macros,
    Default = "None",
    Text = 'Select Macro',
    Callback = function(Value)
        selectedMacro = Value
    end
})

LeftGroupBox:AddToggle("RecordMacro", {
    Text = 'Record Macro',
    Callback = toggleRecording
})

-- Adiciona a opção de executar o macro no UI
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

updateDropdown() 

Library:SetWatermarkVisibility(true)

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    Library:SetWatermark(('Tempest Hub | %s fps | %s ms | %s'):format(
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()),
        math.floor(tick() % 60),
        os.date("%X")
    ))
end)

local function Unload()
    WatermarkConnection:Disconnect()
    Library:Notify("Tempest Hub Unloaded", 3)
end

local TabsUI = {
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local MenuGroup = TabsUI['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', Unload)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', Text = 'Menu Keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetFolder('Tempest Hub/_Anime_Reborn_')
ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local player = game.Players.LocalPlayer
SaveManager:Load(player.Name .. "_Anime_Reborn_")
spawn(function()
    while task.wait(1) do
        if Library.Unloaded then break end
        SaveManager:Save(player.Name .. "_Anime_Reborn_")
    end
end)

for _, conn in ipairs(getconnections(game.Players.LocalPlayer.Idled)) do
    conn:Disable()
end

warn('[TEMPEST HUB] Loaded')