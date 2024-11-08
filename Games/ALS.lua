warn('[TEMPEST HUB] Loading Ui')
wait(1)
local repo = 'https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
Library:Notify('Welcome to Tempest Hub', 5)

local Window = Library:CreateWindow({
    Title = 'Tempest Hub | INF CASTLE',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading INF CASTLE Script', 5)
Library:Notify('Script made thanks to JustLevel', 5)
warn('[TEMPEST HUB] Loading Function')
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

function joinInfCastle()
    while getgenv().joinInfCastle == true do 
        repeat task.wait() until game:IsLoaded()
        local asta = workspace.Lobby.Npcs.Asta
        if asta then
            wait(.5)
            game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetGlobalData")
            wait(.4)
            game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetData")
            wait(1)
            game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", 0, "True")
            wait(1)
        else
            wait(.5)
        end
        wait()
    end
end

function quitInfCastle()
    while getgenv().quitInfCastle == true do
        local uiEndGame = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("EndGameUI")
        if uiEndGame then
            wait(1)
            game:GetService("ReplicatedStorage").Remotes.TeleportBack:FireServer()
            wait(1)
        else
            wait(.5)
        end
        wait()
    end
end

function placeUnit()
    while getgenv().placeUnit == true do
        local unit = game:GetService("Players")[game.Players.LocalPlayer.Name].Slots.Slot1
        local Remotes = game:GetService("ReplicatedStorage").Remotes
        if unit then
            local PlaceTower = Remotes.PlaceTower
            if PlaceTower then
                wait(.5)
                local args = {
                    [1] = unit.Value,
                    [2] = CFrame.new(-164.9412384033203, 197.93942260742188, 15.210136413574219)
                }
                game:GetService("ReplicatedStorage").Remotes.PlaceTower:FireServer(unpack(args))    
                wait(1)
            end
        else
            wait(.5)
        end
        wait()
    end
end

function autoGamespeed()
    while getgenv().autoGamespeed == true do
        local Remotes = game:GetService("ReplicatedStorage").Remotes
        if Remotes then
            local VoteChangeTimeScale = Remotes.VoteChangeTimeScale
            if VoteChangeTimeScale then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("VoteChangeTimeScale"):FireServer(true)
                break
            end
        else
            wait(1)
        end
        wait()
    end
end

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local uiEndGame = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("EndGameUI")
        if uiEndGame then
            local result = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.Result.Text
            local name = game:GetService("Players").LocalPlayer.Name

            local payload = {
                content = "Tempest Hub",
                embeds = {
                    {
                        title = "Account Situation",
                        description = string.format("Name: %s\nResult: %s\n\n------------------------------------", name, result),
                        color = 10098630,
                        author = {
                            name = "ALS INF CASTLE"
                        },
                    }
                }
            }

            local payloadJson = game:GetService("HttpService"):JSONEncode(payload)

            local response = syn.request({
                Url = discordWebhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = payloadJson
            })

            if response.Success then
                print("Webhook sent successfully!")
                break
            else
                warn("Error sending message to Discord:", response.StatusCode, response.Body)
            end
        else
            wait(.5)
        end

        wait(0.5)
    end
end

Library:Notify('Place the unit you will use in the first slot', 5)

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("FARM")

LeftGroupBox:AddToggle("AEIC", {
	Text = "Auto Enter Inf Castle",
	Default = false,
	Callback = function(Value)
		getgenv().joinInfCastle = Value
		joinInfCastle()
	end,
})

LeftGroupBox:AddToggle("ALIC", {
	Text = "Auto Leave Inf Castle",
	Default = false,
	Callback = function(Value)
		getgenv().quitInfCastle = Value
		quitInfCastle()
	end,
})

LeftGroupBox:AddToggle("APU", {
	Text = "Auto Place Unit",
	Default = false,
	Callback = function(Value)
		getgenv().placeUnit = Value
		placeUnit()
	end,
})

LeftGroupBox:AddToggle("AIG", {
	Text = "Auto Increase Gamespeed",
	Default = false,
	Callback = function(Value)
		getgenv().autoGamespeed = Value
		autoGamespeed()
	end,
})

LeftGroupBox:AddInput('WebhookURL', {
    Default = '',
    Text = "Webhook URL",
    Numeric = false,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        urlwebhook = Value
    end
})

LeftGroupBox:AddToggle("Webhook", {
    Text = "Send Webhook when finish game",
    Default = false,
    Callback = function(Value)
        getgenv().webhook = Value
        webhook()
    end,
})

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection

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
SaveManager:SetFolder('Tempest Hub/_ALS_INF_CASTLE_')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_ALS_INF_CASTLE_'
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
