--Checking if game is loaded
repeat task.wait() until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()

--Starting Script
local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled
local pcSize = UDim2.fromOffset(868, 650)
local mobileSize = UDim2.fromOffset(800, 550)
local currentSize = isMobile and mobileSize or pcSize

local Window = MacLib:Window({
    Title = "Tempest Hub",
    Subtitle = "Anime Last Stand",
    Size = currentSize,
    DragStyle = 1,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
})

function changeUISize(scale)
    if Window then
        if scale < 0.1 then
            scale = 0.1
        elseif scale > 1.5 then
            scale = 1.5
        end

        local newWidth = pcSize.X.Offset * scale
        local newHeight = pcSize.Y.Offset * scale

        Window:SetSize(UDim2.fromOffset(newWidth, newHeight))
        Window:Notify({
            Title = "UI Resized",
            Description = "New size scale: " .. scale,
            Lifetime = 3
        })
    end
end

wait(.1)

local macros = {}
local selectedMacro
local isRecording = false
local isPlaying = false
local recordingData = {}
local Options = {}
local selectedTypeOfRecord = "None"
local startTime = tick()
local printedNames = {}
local mapNames = {}
local dropdowns = {}
local macroName
local delayMacro

local macrosFolder = 'Tempest Hub/_ALS_/Macros'
if not isfolder(macrosFolder) then
    print("[DEBUG] Pasta de macros não encontrada. Criando:", macrosFolder)
    makefolder(macrosFolder)
else
    print("[DEBUG] Pasta de macros encontrada:", macrosFolder)
end

function updateDropdown()
    print("[DEBUG] Entrou em updateDropdown()")
    local newMacros = {"None"}
    
    if isfolder(macrosFolder) then
        for _, file in ipairs(listfiles(macrosFolder)) do
            local name = file:match("([^/]+)%.json$") or file:match("([^\\]+)%.json$")
            if name then
                table.insert(newMacros, name)
                print("[DEBUG] Macro encontrada:", name)
            end
        end
    else
        print("[DEBUG] A pasta de macros não existe!")
    end
    
    macros = newMacros
    print("[DEBUG] Macros atualizadas:", table.concat(macros, ", "))

    if SelectedMacro then
        SelectedMacro:SetValues(macros)
        SelectedMacro:SetValue("None")
        print("[DEBUG] SelectedMacro atualizada com os novos valores")
    end
    print("[DEBUG] updateDropdown() finalizado")
end

function createJsonFile(fileName)
    print("[DEBUG] Entrou em createJsonFile() com fileName:", fileName)
    if fileName == '' or not fileName then
        Window:Notify({
            Title = "Error",
            Description = "Please enter a macro name",
            Lifetime = 3
        })
        print("[DEBUG] Nome da macro inválido")
        return
    end

    local filePath = macrosFolder .. '/' .. fileName .. '.json'
    if isfile(filePath) then
        Window:Notify({
            Title = "Error",
            Description = "Macro already exists",
            Lifetime = 3
        })
        print("[DEBUG] Macro já existe:", fileName)
        return
    end

    writefile(filePath, "{}")
    updateDropdown()
    Window:Notify({
        Title = "Success",
        Description = "Macro created: " .. fileName,
        Lifetime = 3
    })
    print("[DEBUG] Macro criada com sucesso:", fileName)
end

function recordingMacro()
    print("[DEBUG] Entrou em recordingMacro()")
    if not selectedMacro or selectedMacro == "None" then
        RecordMacro:SetValue(false)
        print("[DEBUG] Macro selecionada inválida ou 'None'")
        return
    end

    if not selectedTypeOfRecord or selectedTypeOfRecord == "None" then
        RecordMacro:SetValue(false)
        print("[DEBUG] Tipo de gravação inválido ou 'None'")
        return
    end

    isRecording = not isRecording
    updateRecordingStatus()
    print("[DEBUG] isRecording alterado para:", isRecording)

    if isRecording then
        recordingData = { steps = {}, currentStepIndex = 0 }
        print("[DEBUG] Dados de gravação reiniciados")
    else
        table.sort(recordingData.steps, function(a, b)
            return a.index < b.index
        end)
        local filePath = macrosFolder .. '/' .. selectedMacro .. '.json'
        writefile(filePath, game:GetService("HttpService"):JSONEncode(recordingData))
        print("[DEBUG] Gravação finalizada e salva em:", filePath)
    end
end

function collectRemoteInfo(remoteName, args)
    print("[DEBUG] Entrou em collectRemoteInfo() para action:", remoteName)
    local remoteData = { 
        action = remoteName, 
        arguments = args,
        index = recordingData.currentStepIndex + 1
    }

    recordingData.currentStepIndex = remoteData.index
    print("[DEBUG] Novo step index:", remoteData.index)

    if selectedTypeOfRecord == "Time" or selectedTypeOfRecord == "Hybrid" then
        remoteData.time = tick() - startTime
        print("[DEBUG] Tempo registrado:", remoteData.time)
    end

    if selectedTypeOfRecord == "Money" or selectedTypeOfRecord == "Hybrid" then
        local player = game.Players.LocalPlayer
        local money = player:FindFirstChild("Cash")
        if money then
            remoteData.money = money.Value
            print("[DEBUG] Valor de dinheiro registrado:", remoteData.money)
        end     
    end

    if #args > 1 then
        remoteData.arguments = {}
        for i = 1, #args do
            local arg = args[i]
            
            if typeof(arg) == "table" then
                local serializedTable = {}
                for k, v in pairs(arg) do
                    if typeof(v) == "CFrame" then
                        serializedTable[tostring(k)] = {CFrame = {v:GetComponents()}}
                    elseif typeof(v) == "Vector3" then
                        serializedTable[tostring(k)] = {Vector3 = {X = v.X, Y = v.Y, Z = v.Z}}
                    elseif typeof(v) == "Instance" then
                        serializedTable[tostring(k)] = {Instance = v:GetFullName()}
                    else
                        serializedTable[tostring(k)] = v
                    end
                end
                remoteData.arguments[i] = serializedTable
            else
                remoteData.arguments[i] = arg
            end
        end
        print("[DEBUG] Argumentos processados para tabela")
    end

    table.insert(recordingData.steps, remoteData)
    print("[DEBUG] Step adicionado:", remoteData.action, "com index", remoteData.index)
end

function getUnitRemote(remoteName, args)
    if not isRecording then 
        print("[DEBUG] getUnitRemote chamado, mas não está gravando.")
        return 
    end

    local action = remoteName
    print("[DEBUG] getUnitRemote processando ação:", action)
    
    if action == "PlaceTower" or action == "Upgrade" or action == "Sell" or action == "ChangeTargeting" then
        collectRemoteInfo(action, args)
    elseif action == "SpecialAbility" and getgenv().recordSkill == true then
        collectRemoteInfo(action, args)
    else
        warn("Ação desconhecida:", action)
    end
end

function updateRecordingStatus()
    if isRecording then
        RecordingStatusLabel:UpdateName("Recording Status: Recording...")
        print("[DEBUG] Status atualizado: Gravando")
    elseif isPlaying then
        RecordingStatusLabel:UpdateName("Playing Status: " .. selectedMacro)
        print("[DEBUG] Status atualizado: Reproduzindo macro", selectedMacro)
    else
        RecordingStatusLabel:UpdateName("Recording Status: Not Recording or Playing")
        print("[DEBUG] Status atualizado: Parado")
    end
end

function updateSlotStatus(selectedSlot, selectedUnit)
    updateStatus("Selected Slot: " .. selectedSlot .. " | Unit: " .. selectedUnit)
    print("[DEBUG] Slot e unidade atualizados para:", selectedSlot, selectedUnit)
end

function stringToCFrame(str)
    print("[DEBUG] Convertendo string para CFrame:", str)
    local parts = {}
    for num in str:gmatch("[%d%.%-]+") do
        table.insert(parts, tonumber(num))
    end
    
    if #parts >= 3 then
        return CFrame.new(parts[1], parts[2], parts[3])
    end
    print("[DEBUG] Falha ao converter string para CFrame")
    return nil
end

function playMacro(macroName)
    print("[DEBUG] Iniciando reprodução da macro:", macroName)
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local bottomGui = playerGui:WaitForChild("Bottom")
    local frame = bottomGui:WaitForChild("Frame")

    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("Frame") then
            local textButtonCount = 0
            for _, subChild in ipairs(child:GetChildren()) do
                if subChild:IsA("TextButton") then
                    textButtonCount = textButtonCount + 1
                end
            end
            
            if textButtonCount == 2 then
                print("[DEBUG] Frame encontrado:", child.Name)
                if child.Visible == true then
                    wait(0.1)
                end
            end
        end
    end

    if not macrosFolder then
        warn("macrosFolder not defined!")
        return
    end

    if not macroName or macroName == "None" then
        print("[DEBUG] Macro não selecionada para reprodução")
        return
    end

    local filePath = macrosFolder .. '/' .. macroName .. '.json'
    
    if not isfile(filePath) then
        print("[DEBUG] Arquivo da macro não encontrado:", filePath)
        return
    end

    local fileContent
    local success, err = pcall(function()
        fileContent = readfile(filePath)
    end)
    
    if not success then
        warn("Erro ao ler arquivo da macro:", err)
        return
    end

    local success, macroData = pcall(function()
        return game:GetService("HttpService"):JSONDecode(fileContent)
    end)
    
    if not success then
        warn("Erro ao decodificar JSON da macro")
        return
    end
    
    if not macroData or not macroData.steps then
        print("[DEBUG] Dados da macro inválidos ou sem steps")
        return
    end

    if not isPlaying then isPlaying = false end
    if not updateRecordingStatus then 
        updateRecordingStatus = function() end 
        warn("updateRecordingStatus not defined - using dummy function")
    end

    isPlaying = true
    updateRecordingStatus()
    
    local startTime = tick()
    local moneyCheckTimeout = 10
    local moneyCheckInterval = 0.1

    for i, step in ipairs(macroData.steps) do
        if not isPlaying then 
            print("[DEBUG] Macro interrompida manualmente no step", i)
            break 
        end

        if not step.action and not step.time and not step.money then
            warn("Invalid step format at index " .. i .. ": " .. tostring(step))
            break
        end

        if (selectedTypeOfRecord == "Time" or selectedTypeOfRecord == "Hybrid") and step.time then
            local elapsed = tick() - startTime
            local waitTime = step.time - elapsed
            
            if waitTime > 0 then
                print("[DEBUG] Aguardando", waitTime, "segundos (baseado em tempo)")
                wait(waitTime)
            end
        end
        
        if (selectedTypeOfRecord == "Money" or selectedTypeOfRecord == "Hybrid") and step.money then
            local player = game.Players.LocalPlayer
            local money = player.Cash
            if money then
                local startWait = tick()
                while isPlaying and money.Value < step.money and (tick() - startWait) < moneyCheckTimeout do
                    print("[DEBUG] Aguardando dinheiro... Atual:", money.Value, "Necessário:", step.money)
                    wait(moneyCheckInterval)
                end
                
                if money.Value < step.money then
                    print("[DEBUG] Tempo de espera para dinheiro esgotado")
                    break
                end
            else
                warn("moneyValue not found!")
            end
        end

        if step.action then
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            if not remotes then
                warn("[DEBUG] Remotes não encontrado!")
                break
            end
            
            local args = step.arguments or {}
            print("[DEBUG] Executando step", i, "Action:", step.action, "Args:", unpack(args or {}))
            
            if step.action == "PlaceTower" and #args >= 2 then
                local remote = remotes:FindFirstChild("PlaceTower")
                if not remote then
                    warn("PlaceTower remote not found!")
                    return
                end
            
                local towerName = tostring(args[1])
                local position = args[2]
            
                if typeof(position) == "string" then
                    position = stringToCFrame(position)
                    if not position then
                        warn("Formato de posição inválido:", args[2])
                        return
                    end
                elseif typeof(position) ~= "CFrame" then
                    warn("Tipo de posição inválido (esperado CFrame ou string):", typeof(position))
                    return
                end
            
                remote:FireServer(towerName, position)
                print("[DEBUG] Torre colocada:", towerName, "em", position)
            elseif step.action == "Upgrade" and #args >= 1 then
                local remote = remotes:FindFirstChild("Upgrade")
                local tower = workspace.Towers:FindFirstChild(args[1])
                if remote and tower then
                    remote:InvokeServer(tower)
                    print("[DEBUG] Torre atualizada:", args[1])
                else
                    warn("Upgrade falhou: Remote ou torre não encontrada")
                end
            elseif step.action == "Sell" and #args >= 1 then
                local remote = remotes:FindFirstChild("Sell")
                local tower = workspace.Towers:FindFirstChild(args[1])
                if remote and tower then
                    remote:InvokeServer(tower)
                    print("[DEBUG] Torre vendida:", args[1])
                else
                    warn("Sell falhou: Remote ou torre não encontrada")
                end
            elseif step.action == "ChangeTargeting" and #args >= 1 then
                local remote = remotes:FindFirstChild("ChangeTargeting")
                local tower = workspace.Towers:FindFirstChild(args[1])
                if remote and tower then
                    remote:InvokeServer(tower)
                    print("[DEBUG] Targeting alterado para:", args[1])
                else
                    warn("ChangeTargeting falhou: Remote ou torre não encontrada")
                end
            elseif step.action == "SpecialAbility" and #args >= 1 then
                local remote = remotes:FindFirstChild("SpecialAbility")
                local tower = workspace.Towers:FindFirstChild(args[1])
                if remote and tower then
                    remote:InvokeServer(tower)
                    print("[DEBUG] Habilidade especial acionada para:", args[1])
                else
                    warn("SpecialAbility falhou: Remote ou torre não encontrada")
                end
            else
                warn("Unknown action or missing arguments:", step.action)
            end
            
            wait(delayMacro)
        end
    end
    
    isPlaying = false
    updateRecordingStatus()
    print("[DEBUG] Reprodução da macro finalizada")
end

local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local remoteName = self.Name
    
    if isRecording and not checkcaller() then
        if method == "FireServer" and remoteName == "PlaceTower" and self.Parent == game.ReplicatedStorage.Remotes then
            print("[DEBUG][RECORD] PlaceTower:", args[1], args[2])
            local processedArgs = {
                tostring(args[1]),
                tostring(args[2])
            }
            getUnitRemote("PlaceTower", processedArgs)
        
        elseif method == "InvokeServer" and self.Parent == game.ReplicatedStorage.Remotes then
            if remoteName == "Upgrade" or remoteName == "Sell" or remoteName == "ChangeTargeting" or remoteName == "SpecialAbility" then
                print("[DEBUG][RECORD]", remoteName..":", args[1])
                getUnitRemote(remoteName, {tostring(args[1])})
            end
        end
    end

    return originalNamecall(self, ...)
end)

local tabGroups = {
	TabGroup1 = Window:TabGroup()
}

--UI Tabs

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
	Farm = tabGroups.TabGroup1:Tab({ Name = "Farm", Image = "rbxassetid://10734950309" }),
    AutoPlay = tabGroups.TabGroup1:Tab({ Name = "Auto Play", Image = "rbxassetid://10734950309" }),
    Macro = tabGroups.TabGroup1:Tab({ Name = "Macro", Image = "rbxassetid://10734950309" }),
    Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" }),
}

--UI Sections

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
    MainSection2 = tabs.Main:Section({ Side = "Left" }),
    MainSection3 = tabs.Main:Section({ Side = "Right" }),
    MainSection4 = tabs.Main:Section({ Side = "Right" }),
    MainSection10 = tabs.Farm:Section({ Side = "Left" }),
    MainSection11 = tabs.Farm:Section({ Side = "Right" }),
    MainSection12 = tabs.Farm:Section({ Side = "Right" }),
    MainSection13 = tabs.Farm:Section({ Side = "Right" }),
    MainSection15 = tabs.AutoPlay:Section({ Side = "Left" }),
    MainSection16 = tabs.AutoPlay:Section({ Side = "Right" }),
    MainSection17 = tabs.AutoPlay:Section({ Side = "Right" }),
    MainSection18 = tabs.AutoPlay:Section({ Side = "Right" }),
    MainSection22 = tabs.Macro:Section({ Side = "Left" }),
    MainSection25 = tabs.Settings:Section({ Side = "Right" }),
}

sections.MainSection22:Header({
	Name = "Macro"
})

RecordingMethodLabel= sections.MainSection22:Label({
	Text = 'Recording Status: Not Recording'
})

SelectedMacroLabel= sections.MainSection22:Label({
	Text = "Selected Macro: None"
})

RecordingStatusLabel = sections.MainSection22:Label({
	Text = "Recording Method: None"
})

sections.MainSection22:Divider()

updateDropdown()

local SelectedMacro = sections.MainSection22:Dropdown({
	Name = "Select Macro",
	Multi = false,
	Required = true,
	Options = macros,
	Default = "None",
	Callback = function(Value)
        selectedMacro = Value:gsub(".json$", ""):gsub(".*/", ""):gsub(".*\\", "")
        if selectedMacro == "None" then selectedMacro = nil end
        SelectedMacroLabel:UpdateName("Selected Macro: " .. (selectedMacro or "None"))
	end,
}, "SelectedMacro")

local MacroName = sections.MainSection22:Input({
    Name = "Macro Name",
    Placeholder = "Enter Macro Name",
    AcceptedCharacters = "All",
    Callback = function(value)
        macroName = value
    end,
    onChanged = function(value)
        macroName = value
    end,
}, "MacroName")

sections.MainSection22:Button({
	Name = "Create Macro",
	Callback = function(Value)
        if macroName and macroName ~= "" then
            createJsonFile(macroName)
            updateDropdown()
            if SelectedMacroLabel then
                SelectedMacroLabel:UpdateName("Selected Macro: " .. (macroName or "None"))
            end
        else
            Window:Notify({
                Title = "Error",
                Description = "Please enter a macro name first",
                Lifetime = 3
            })
        end
	end,
})

sections.MainSection22:Button({
	Name = "Delete Macro",
	Callback = function()
        if selectedMacro and selectedMacro ~= "None" then
            local filePath = macrosFolder .. '/' .. selectedMacro .. '.json'
            if isfile(filePath) then
                delfile(filePath)
                updateDropdown()
                selectedMacro = nil
                if SelectedMacroLabel then
                    SelectedMacroLabel:UpdateName("Selected Macro: None")
                end
            end
        else
            Window:Notify({
                Title = "Error",
                Description = "Please select a macro to delete",
                Lifetime = 3
            })
        end
	end,
})

local RecordMacro = sections.MainSection22:Toggle({
    Name = "Record Macro",
    Default = false,
    Callback = function(value)
        if value then
            if not selectedMacro or selectedMacro == "None" then
                Window:Notify({
                    Title = "Error",
                    Description = "Please select a macro first",
                    Lifetime = 3
                })
                RecordMacro:SetValue(false)
                return
            end
            if not selectedTypeOfRecord or selectedTypeOfRecord == "None" then
                Window:Notify({
                    Title = "Error",
                    Description = "Please select a recording method first",
                    Lifetime = 3
                })
                RecordMacro:SetValue(false)
                return
            end
        end
        recordingMacro()
    end,
}, "RecordMacro")

local PlayMacro = sections.MainSection22:Toggle({
	Name = "Play Macro",
	Default = false,
	Callback = function(value)
        if Value then
            if not selectedMacro or selectedMacro == "None" then
                
                PlayMacro:SetValue(false)
                return
            end
            playMacro(selectedMacro)
        end
	end,
}, "PlayMacro")

sections.MainSection22:Slider({
	Name = "Delay Macro",
	Default = 0,
	Minimum = 0,
	Maximum = 1,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		delayMacro = Value
	end
}, "delayMacro")

local SelectedRecordingMethod = sections.MainSection22:Dropdown({
	Name = "Select Type of Record",
	Multi = false,
	Required = true,
	Options = {"Time", "Money", "Hybrid"},
	Default = "None",
	Callback = function(Value)
        selectedTypeOfRecord = Value
        RecordingMethodLabel:UpdateName("Recording Method: " .. selectedTypeOfRecord)
        if selectedTypeOfRecord == "Time" then
            startTime = tick()
        end
	end,
}, "SelectedRecordingMethod")

sections.MainSection22:Toggle({
	Name = "Record Skill in Macro",
	Default = false,
	Callback = function(value)
        getgenv().recordSkill = Value
	end,
}, "RecordSkillMacro")

updateDropdown() 

MacLib:SetFolder("Maclib")
tabs.Settings:InsertConfigSection("Left")

sections.MainSection25:Slider({
    Name = "Change UI Size",
    Default = 0.8,
    Minimum = 0.1,
    Maximum = 1.5,
    Increment = 0.05,
    DisplayMethod = "Round", 
    Precision = 1,
    Callback = function(value)
        changeUISize(value)
    end
}, "changeUISize")

Window.onUnloaded(function()
	print("Unloaded!")
end)

tabs.Main:Select()

MacLib:SetFolder("Tempest Hub")
MacLib:SetFolder("Tempest Hub/_ALS_")
local GameConfigName = "_ALS_"
local player = game.Players.LocalPlayer
MacLib:LoadConfig(player.Name .. GameConfigName)
spawn(function()
	while task.wait(1) do
		MacLib:SaveConfig(player.Name .. GameConfigName)
	end
end)

--Anti AFK
for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end
warn("[TEMPEST HUB] Loaded")