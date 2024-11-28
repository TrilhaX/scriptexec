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

local TweenService = game:GetService("TweenService")
local speed = 1000

local function tweenModel(model, targetCFrame)
    if not model.PrimaryPart then
        warn("PrimaryPart is not set for the model")
        return
    end
    
    local duration = (model.PrimaryPart.Position - targetCFrame.Position).Magnitude / speed
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    
    local cframeValue = Instance.new("CFrameValue")
    cframeValue.Value = model:GetPrimaryPartCFrame()
    
    cframeValue:GetPropertyChangedSignal("Value"):Connect(function()
        model:SetPrimaryPartCFrame(cframeValue.Value)
    end)
    
    local tween = TweenService:Create(cframeValue, info, {
        Value = targetCFrame,
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        cframeValue:Destroy()
    end)
    
    return tween
end

local function GetCFrame(obj, height, angle)
    local cframe = CFrame.new()

    if typeof(obj) == "Vector3" then
        cframe = CFrame.new(obj)
    elseif typeof(obj) == "table" then
        cframe = CFrame.new(unpack(obj))
    elseif typeof(obj) == "string" then
        local parts = {}
        for val in obj:gmatch("[^,]+") do
            table.insert(parts, tonumber(val))
        end
        if #parts >= 3 then
            cframe = CFrame.new(unpack(parts))
        end
    elseif typeof(obj) == "Instance" then
        if obj:IsA("Model") then
            local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            if rootPart then
                cframe = rootPart.CFrame
            end
        elseif obj:IsA("Part") then
            cframe = obj.CFrame
        end
    end

    if height then
        cframe = cframe + Vector3.new(0, height, 0)
    end
    if angle then
        cframe = cframe * CFrame.Angles(0, math.rad(angle), 0)
    end
    
    return cframe
end

local ValuesTechnique = {}
local ValuesUnitId = {} or "none"
local selectedUnitRoll = nil
local selectedtech = nil

local slots = game:GetService("Players").LocalPlayer.Slots
local quirkInfoModule = require(game:GetService("ReplicatedStorage").Modules.QuirkInfo)

function autoRoll()
    while getgenv().autoRoll do
        if selectedtech and #selectedtech > 0 and selectedUnitRoll then
            print("Selected passives: " .. table.concat(selectedtech, ", "))
            local slots = game:GetService("Players").LocalPlayer.Slots

            for _, slot in pairs(slots:GetChildren()) do
                if slot.Value == selectedUnitName then
                    local unitPassive = slot:FindFirstChild("Passive") and slot.Passive.Value
                    if unitPassive and table.find(selectedtech, unitPassive) then
                        Library:Notify('You got the passive: ' .. unitPassive .. ' for ' .. selectedUnitName, 5)
                        print("You got the passive: " .. unitPassive)
                        return -- Finaliza o loop ao encontrar o resultado
                    else
                        local replicatedStorage = game:GetService("ReplicatedStorage")
                        local quirksRemotes = replicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Quirks")
                        
                        if quirksRemotes then
                            -- Inicia o processo
                            local quirksStartRemote = quirksRemotes:FindFirstChild("Start")
                            if quirksStartRemote then
                                quirksStartRemote:InvokeServer()
                                wait(0.1)
                            end

                            -- Finaliza o processo
                            local quirksFinishRemote = quirksRemotes:FindFirstChild("Finish")
                            if quirksFinishRemote then
                                quirksFinishRemote:FireServer(tostring(selectedUnitRoll))
                            end
                            
                            wait(1)

                            -- Rola novamente
                            local quirksRollRemote = quirksRemotes:FindFirstChild("Roll")
                            if quirksRollRemote then
                                quirksRollRemote:InvokeServer()
                                print("Rolando novamente para buscar técnicas selecionadas.")
                            else
                                warn("Quirks:Roll remote not found.")
                            end
                        else
                            warn("Quirks remotes not found.")
                        end
                    end
                end
            end
        else
            wait(0.5)
        end
    end
end

for key, value in pairs(quirkInfoModule) do
    if type(value) == "table" then
        table.insert(ValuesTechnique, key)
    end
end

for i, v in pairs(slots:GetChildren()) do
    if v.Value ~= nil and v.Value ~= "" then
        local args = {
            [1] = game.Players.LocalPlayer,
            [2] = v.Value
        }

        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 1)
        if remotes then
            local getSpecificPlayerData = remotes:WaitForChild("GetSpecificPlayerData", 1)
            if getSpecificPlayerData then
                local retorno = getSpecificPlayerData:InvokeServer(unpack(args))

                if type(retorno) == "table" then
                    local valueString = ""
                    
                    if retorno["Value"] then
                        valueString = retorno["Value"]
                    else
                        valueString = "A chave 'Value' não está presente."
                    end

                    local unitIdString = ""
                    if retorno["UnitID"] then
                        unitIdString = retorno["UnitID"]
                    else
                        unitIdString = "A chave 'UnitID' não está presente."
                    end

                    local levelString = ""
                    if retorno["Level"] then
                        levelString = retorno["Level"]
                    else
                        levelString = "A chave 'Level' não está presente."
                    end
                    table.insert(ValuesUnitId, valueString .. " | Level " .. levelString .. " | " .. unitIdString)
                else
                    print("O retorno não é uma tabela:", retorno)
                end
            else
                print("GetSpecificPlayerData não foi encontrado dentro do limite de tempo.")
            end
        else
            print("Remotes não foi encontrado dentro do limite de tempo.")
        end
    end
end

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Farm")

LeftGroupBox:AddDropdown('TechRollUnit', {
    Values = ValuesUnitId,
    Default = "None",
    Multi = false,
    Text = 'Select Unit',
    Tooltip = '',
    Callback = function(value)
        selectedUnitName = value:match("^(.-) |")
        selectedUnitRoll = value:match(".* | .* | (.+)")
        print(selectedUnitName)
        print(selectedUnitRoll)
    end
})

LeftGroupBox:AddDropdown('TechRoll', {
    Values = ValuesTechnique,
    Default = {},
    Multi = true,
    Text = 'Select Passive',
    Tooltip = '',
    Callback = function(values)
        selectedtech = values
        print(selectedtech)
    end
})

LeftGroupBox:AddToggle('Auto Roll Technique', {
    Text = 'Auto Roll Technique',
    Default = false,
    Callback = function(Value)
        getgenv().autoRoll = Value
        if Value then
            autoRoll()
        end
    end
})

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