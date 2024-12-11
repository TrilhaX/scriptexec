warn('[TEMPEST HUB] Loading Ui')
wait()
local repo = 'https://raw.githubusercontent.com/TrilhaX/tempestHubUI/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
Library:Notify('Welcome to Tempest Hub', 5)

local Window = Library:CreateWindow({ 
    Title = 'Tempest Hub | Anime Shadow',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Anime Shadow Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait()
warn('[TEMPEST HUB] Loading Toggles')
wait()
warn('[TEMPEST HUB] Last Checking')
wait()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local speed = 1000

function hideUIExec()
    if getgenv().hideUIExec then
        local windowFrame = game:GetService("CoreGui").LinoriaGui.windowFrame
        windowFrame.Visible = false
        wait()
    end
end

function aeuat()
    if getgenv().aeuat == true then
        local teleportQueued = false
        game.Players.LocalPlayer.OnTeleport:Connect(function(State)
            if (State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress) and not teleportQueued then
                teleportQueued = true
                
                queue_on_teleport([[ 
                    if getgenv().executed then return end    
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/TempestHubMain/main/Main"))()
                ]])
                
                getgenv().executed = true
                wait(10)
                teleportQueued = false
            end
        end)
        wait()
    end
end

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

function autoClicker()
    while getgenv().autoClicker == true do
        local args = {
            [1] = "Enemies",
            [2] = "World",
            [3] = "Click"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))        
        wait()
    end
end

function autoFarm()
    while getgenv().autoFarm == true do
        local pets = game:GetService("Players").LocalPlayer.PlayerGui.UI.Frames.Pets.Background.Frame.List
        local world = workspace.Client.Maps

        for i, v in pairs(pets:GetChildren()) do
            if v.Name ~= "UIGridLayout" then
                for j, k in pairs(world:GetChildren()) do
                    local args = {
                        [1] = "General",
                        [2] = "Pets",
                        [3] = "Attack",
                        [4] = tostring(v.Name),
                        [5] = workspace:WaitForChild("Server"):WaitForChild("Enemies"):WaitForChild(tostring(k.Name)):WaitForChild(tostring(selectedMobFarm))
                    }

                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
                    wait()
                end
            else
                wait()
            end
        end
        wait()
    end
end

function autoCollect()
    while getgenv().autoCollect == true do
        local coins = workspace.Client.Drops

        for i, v in pairs(coins:GetChildren()) do
            local args = {
                [1] = "General",
                [2] = "Drops",
                [3] = "Collect",
                [4] = tostring(coins)
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
            wait()
        end
        wait()
    end
end

function autoRoll()
    while getgenv().autoRoll == true do
        local args = {
            [1] = "General",
            [2] = "Stars",
            [3] = "Open",
            [4] = selectedMapRoll,
            [5] = selectRollType
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
        wait()
    end 
end

function autoTpPetsForMob()
    while getgenv().autoTpPetsForMob == true do
        local pets = workspace.Server.Pets
        local playerName = game.Players.LocalPlayer.Name

        for _, pet in pairs(pets:GetChildren()) do
            local splitName = string.split(pet.Name, "---")[1]
            if splitName == playerName then
                local TeleportCFrame = GetCFrame(selectedMobFarm)
                print(TeleportCFrame)
                print(pet)
                local tween = tweenModel(pet, TeleportCFrame)
                tween:Play()
            end
        end
        wait()
    end
end

function autoPassive()
    while getgenv().autoPassive == true do
        print("W.I.P")
        wait()
    end
end

function autoDungeon()
    while getgenv().autoDungeon == true do
        local dungeonDoor = workspace.Server.Trial.Lobby.Dungeon_Door

        if dungeonDoor then
            local attributes = dungeonDoor:GetAttributes()
            if next(attributes) then
                for attributeName, attributeValue in pairs(attributes) do
                    local args = {
                        [1] = "Enemies",
                        [2] = "Trial_Dungeon",
                        [3] = "Join"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))                    
                end
            end
        else
            warn("Dungeon_Door não encontrado no caminho especificado.")
        end
        wait()
    end
end

function autoTrial()
    while getgenv().autoTrial == true do
        local trialDoor = workspace.Server.Trial.Lobby.Easy_Door

        if trialDoor then
            local attributes = trialDoor:GetAttributes()
            if next(attributes) then
                for attributeName, attributeValue in pairs(attributes) do
                    local args = {
                        [1] = "Enemies",
                        [2] = "Trial_Easy",
                        [3] = "Join"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))                    
                end
            end
        else
            warn("Dungeon_Door não encontrado no caminho especificado.")
        end
        wait()
    end
end

function cancelUlt()
    while getgenv().cancelUlt == true do
        local pets = workspace.Server.Pets
        local playerName = game.Players.LocalPlayer.Name
        
        for _, v in pairs(pets:GetChildren()) do
            local splitName = string.split(v.Name, "---")[1]
            if splitName == playerName then
                local Ult = v.Info.Ult_Enemy
                if Ult and (Ult.Value ~= "" and Ult.Value ~= " " and Ult.Value ~= nil) then
                    local pets2 = game:GetService("Players").LocalPlayer.PlayerGui.UI.Frames.Pets.Background.Frame.List
                    local world = workspace.Client.Maps
            
                    for j, k in pairs(pets2:GetChildren()) do
                        if k.Name ~= "UIGridLayout" then
                            local args = {
                                [1] = "General",
                                [2] = "Pets",
                                [3] = "Retreat"
                            }
                            
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
                        end
                    end
                end
            end
        end
        wait(5)
    end
end

local pets = game:GetService("Players").LocalPlayer.PlayerGui.UI.Frames.Pets.Background.Frame.List
local ValuesUnitUser = {}

for i, v in pairs(pets:GetChildren()) do
    if v.Name ~= "UIGridLayout" then
        table.insert(ValuesUnitUser, v.Frame.Title.Text .. " | " .. v.Frame.Level.Text .. " | " .. v.Name)
    end
end

local enemies = workspace.Client.Enemies
local printedNames = {}
local ValuesEnemiesWorld = {}

for i, v in pairs(enemies:GetChildren()) do
    local name = v.Name
    if not printedNames[name] then
        table.insert(ValuesEnemiesWorld, name)
        printedNames[name] = true
    end
end

local world = workspace.Server.Stars
local ValuesWorldMapas = {}

for i, v in pairs(world:GetChildren()) do
    table.insert(ValuesWorldMapas, v.Name)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Passives = require(Shared:WaitForChild("Passives"))
local ValuesPassivesToRoll = {}

for key, value in pairs(Passives) do
    table.insert(ValuesPassivesToRoll, key)
end

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Player")

LeftGroupBox:AddToggle("ACR", {
	Text = "Auto Clicker",
	Default = false,
	Callback = function(Value)
        getgenv().autoClicker = Value
		autoClicker()
	end,
})

LeftGroupBox:AddToggle("AC", {
	Text = "Auto Collect",
	Default = false,
	Callback = function(Value)
        getgenv().autoCollect = Value
		autoCollect()
	end,
})

LeftGroupBox:AddToggle("TP", {
	Text = "Teleport Pets To Mob",
	Default = false,
	Callback = function(Value)
        getgenv().autoTpPetsForMob = Value
		autoTpPetsForMob()
	end,
})

LeftGroupBox:AddToggle("CU", {
	Text = "Cancel Ult",
	Default = false,
	Callback = function(Value)
        getgenv().cancelUlt = Value
		cancelUlt()
	end,
})

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Pets")

LeftGroupBox:AddDropdown('Roll', {
    Values = ValuesWorldMapas,
    Default = "None",
    Multi = false,
    Text = 'Select Map',

    Callback = function(Value)
        selectedMapRoll = Value
    end
})

LeftGroupBox:AddDropdown('Roll', {
    Values = {"Coins", "Tickets"},
    Default = "None",
    Multi = false,
    Text = 'Select Type',

    Callback = function(Value)
        selectRollType = Value
    end
})

LeftGroupBox:AddToggle("AR", {
    Text = "Auto Roll",
    Default = false,
    Callback = function(Value)
        getgenv().autoRoll = Value
        autoRoll()
    end,
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddDropdown('PassiveRoll', {
    Values = ValuesPassivesToRoll,
    Default = "None",
    Multi = false,
    Text = 'Select Passive',

    Callback = function(Value)
        selectRollType = Value
    end
})

LeftGroupBox:AddToggle("AP", {
    Text = "Auto Passive",
    Default = false,
    Callback = function(Value)
        getgenv().autoPassive = Value
        autoPassive()
    end,
})

local RightGroupbox = Tabs.Main:AddRightGroupbox("Farm")

RightGroupbox:AddDropdown('MobFarm', {
    Values = ValuesEnemiesWorld,
    Default = "None",
    Multi = false,
    Text = 'Select Mob Farm',

    Callback = function(Value)
        selectedMobFarm = Value
    end
})

RightGroupbox:AddToggle("AF", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(Value)
        getgenv().autoFarm = Value
        autoFarm()
    end,
})

local MyButton = RightGroupbox:AddButton({
    Text = 'Refresh Enemies Dropdown',
    Func = function()
        Options.MobFarm:SetValue(ValuesEnemiesWorld)
    end,
    DoubleClick = false,
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

MenuGroup:AddToggle('huwe', {
    Text = 'Hide UI When Execute',
    Default = false,
    Callback = function(Value)
        getgenv().hideUIExec = Value
		hideUIExec()
    end
})

MenuGroup:AddToggle('aeuat', {
    Text = 'Auto Execute',
    Default = false,
    Callback = function(Value)
        getgenv().aeuat = Value
		aeuat()
    end
})


MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('Tempest Hub')
SaveManager:SetFolder('Tempest Hub/_ALS_')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_ALS_'
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