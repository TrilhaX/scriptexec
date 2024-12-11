warn('[TEMPEST HUB] Loading Ui')
wait(1)
local repo = 'https://raw.githubusercontent.com/TrilhaX/tempestHubUI/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
Library:Notify('Welcome to Tempest Hub', 5)

local Window = Library:CreateWindow({ 
    Title = 'Tempest Hub | Anime Realms',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Anime Realms Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

local HttpService = game:GetService("HttpService")

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
                    repeat task.wait() until game:IsLoaded()
                    wait(1)
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

function instantSkipWave()
    while getgenv().instantSkipWave == true do
        repeat task.wait() until game:IsLoaded()
        wait(1)
        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("vote_wave_skip"):InvokeServer()
        wait()
    end
end

function removeEnemies()
    while getgenv().removeEnemies == true do
        local enemies = workspace._UNITS

        for i,v in pairs(enemies:GetChildren())do
            v:Destroy()
        end
        wait(.5)
    end
end

function retry()
    while getgenv().retry == true do
        local ResultsUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
        if ResultsUI then
            local finished = ResultsUI:FindFirstChild("Finished")
            if finished.Visible then
                local player = game:GetService("Players").LocalPlayer
                local button = player.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Finished"):WaitForChild("NextRetry")

                if button then
                    local GuiService = game:GetService("GuiService")
                    local VirtualInputManager = game:GetService("VirtualInputManager")
                    GuiService.SelectedObject = button
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    task.wait(0.5)
                else
                    warn("Botão 'Next' não encontrado.")
                end
            end
        end
        wait(1)
    end
end

function autoStartGame()
    while getgenv().autoStartGame == true do
        local voteStart = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("VoteStart")
        if voteStart then
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("vote_start"):InvokeServer()
        end
        wait(1)
    end
end

function autoLeave()
    while getgenv().autoLeave == true do
        local players = game:GetService("Players")
        local ignorePlaceIds = {84188796720288}
    
        local function isPlaceIdIgnored(placeId)
            for _, id in ipairs(ignorePlaceIds) do
                if id == placeId then
                    return true
                end
            end
            return false
        end
        if getgenv().leaveAtSelectedWave then
            local wave = workspace:FindFirstChild("_wave_num")
            if wave then
                if selectedWaveXToLeave == wave.Value then
                    local targetPlaceId = 84188796720288

                    if game.PlaceId ~= targetPlaceId and not isPlaceIdIgnored(game.PlaceId) then
                        game:GetService("TeleportService"):Teleport(targetPlaceId, player1)
                    end
                end
            end
        else
            local ResultsUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
            if ResultsUI then
                local finished = ResultsUI:FindFirstChild("Finished")
                if finished.Visible then
                    local player = game:GetService("Players").LocalPlayer
                    local button = player.PlayerGui:WaitForChild("ResultsUI"):WaitForChild("Finished"):WaitForChild("Next")

                    if button then
                        local GuiService = game:GetService("GuiService")
                        local VirtualInputManager = game:GetService("VirtualInputManager")
                        GuiService.SelectedObject = button
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        task.wait(0.5)
                    else
                        warn("Botão 'Next' não encontrado.")
                    end
                end
            end
        end
        wait(1)
    end
end

function autoSell()
    while getgenv().autoSell == true do

        wait()
    end
end

function placeUnit()
    while getgenv().placeUnit == true do

        wait()
    end
end

function deleteMap()
    while getgenv().deleteMap == true do
        local assets = workspace:FindFirstChild("_map")
        if assets then
            assets:Destroy()
        end
        wait(1)
    end
end

function securityMode()
    local players = game:GetService("Players")
    local ignorePlaceIds = {12886143095, 18583778121}

    local function isPlaceIdIgnored(placeId)
        for _, id in ipairs(ignorePlaceIds) do
            if id == placeId then
                return true
            end
        end
        return false
    end

    while getgenv().securityMode do
        if #players:GetPlayers() >= 2 then
            local player1 = players:GetPlayers()[1]
            local targetPlaceId = 12886143095

            if game.PlaceId ~= targetPlaceId and not isPlaceIdIgnored(game.PlaceId) then
                game:GetService("TeleportService"):Teleport(targetPlaceId, player1)
            end
        end
        wait(1)
    end
end

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Player")

LeftGroupBox:AddToggle("SM", {
	Text = "Security Mode",
	Default = false,
	Callback = function(Value)
        getgenv().securityMode = Value
		securityMode()
	end,
})

LeftGroupBox:AddToggle("AR", {
	Text = "Auto Retry",
	Default = false,
	Callback = function(Value)
        getgenv().retry = Value
		retry()
	end,
})

LeftGroupBox:AddToggle("AL", {
	Text = "Auto Leave",
	Default = false,
	Callback = function(Value)
        getgenv().autoLeave = Value
		autoLeave()
	end,
})

LeftGroupBox:AddInput('inputAutoLeaveWaveX', {
    Default = '',
    Text = "Leave at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveXToLeave = Value
    end
})

LeftGroupBox:AddToggle("OLISW", {
	Text = "Only leave in selected Wave",
	Default = false,
	Callback = function(Value)
        getgenv().leaveAtSelectedWave = Value
	end,
})

LeftGroupBox:AddToggle("AT", {
	Text = "Auto Start",
	Default = false,
	Callback = function(Value)
        getgenv().autoStartGame = Value
        autoStartGame()
	end,
})

LeftGroupBox:AddToggle("ISW", {
	Text = "Insta Skip Wave",
	Default = false,
	Callback = function(Value)
        getgenv().instantSkipWave = Value
        instantSkipWave()
	end,
})

LeftGroupBox:AddToggle("DM", {
	Text = "Delete Map",
	Default = false,
	Callback = function(Value)
        getgenv().deleteMap = Value
        deleteMap()
	end,
})

LeftGroupBox:AddToggle("RE", {
	Text = "Remove Enemies",
	Default = false,
	Callback = function(Value)
        getgenv().removeEnemies = Value
        removeEnemies()
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
SaveManager:SetFolder('Tempest Hub/_Anime_Realms_')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_Anime_Realms_'
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