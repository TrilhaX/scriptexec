warn('[TEMPEST HUB] Loading Bypass')
wait(1)
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
    while getgenv().joinInfCastle do 
        repeat task.wait() until game:IsLoaded()
        game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetGlobalData")
        wait(0.4)
        game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetData")
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", 0, "True")
        wait(1)
    end
end

function quitInfCastle()
    while getgenv().quitInfCastle == true do
        local uiEndGame = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("EndGameUI")
        if uiEndGame.visible == true then
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
        if unit then
            wait(.5)
            local args = {
                [1] = unit.Value,
                [2] = CFrame.new(-164.9412384033203, 197.93942260742188, 15.210136413574219)
            }
            game:GetService("ReplicatedStorage").Remotes.PlaceTower:FireServer(unpack(args))    
            wait(1)
        else
            wait(.5)
        end
        wait()
    end
end

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook

        -- Construindo o payload para enviar para o webhook
        local payload = {
            content = "Tempest Hub",
            embeds = {
                {
                    title = "Account Situation",
                    description = string.format("Name: %s\nLevel: %s\nYen: %s\nRC: %s\nReputation: %s\nTotal Focus Point: %s\nFocus: %s\nEto Yoshimura KIlls: %s\nKoutarou Amon Kills: %s\nNishiki Nishio Kills: %s\nTouka Kirishima Kills: %s\nGya Sacs: %s\nExperience: %s\n2x Exp Time: %s\nDurability: %s\n\n------------------------------------", name, level, yen, rc, rp, TotalFocusPoints, Focus, EtoYoshimuraKills, KoutarouAmonKills, NishikiNishioKills, ToukaKirishimaKills, GyaSacs, Experience, ExpTime2x, Durability),
                    color = 10098630,
                    fields = {
                        {
                            name = "Discord",
                            value = "https://discord.gg/tvQqnYKF7j"
                        }
                    },
                    author = {
                        name = "ALS INF CASTLE"
                    },
                    image = {
                        url = "https://cdn.discordapp.com/attachments/1060039153494007900/1234607717549740062/Imagem_do_WhatsApp_de_2024-04-22_as_22.38.07_6779880f.jpg?ex=6632ab09&is=66315989&hm=a8e2e1b059838b45701b6959ba8e257413b2a099ef79a8c6bba056669a9f8c4b&"
                    },
                    thumbnail = {
                        url = "https://tr.rbxcdn.com/2a201e67272f350e2478d8fdf1c4d9af/150/150/Image/Webp"
                    }
                }
            }
        }

        -- Convertendo a tabela para JSON
        local payloadJson = game:GetService("HttpService"):JSONEncode(payload)

        -- Enviando a requisição POST para o webhook do Discord
        local response = syn.request({
            Url = discordWebhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payloadJson
        })

        if response.Success then
            print("A")
        else
            warn("Erro ao enviar mensagem para o Discord:", response.StatusCode, response.Body)
        end
        wait(.5)
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

LeftGroupBox:AddInput('WebhookURL', {
    Default = '',
    Numeric = false,
    Finished = false,
    Placeholder = 'Put ur Webhook URL here',
    Callback = function(Value)
        urlwebhook = Value
    end
})

LeftGroupBox:AddToggle("Webhook", {
    Text = "Send Webhook when finish game",
    Default = false,
    Callback = function(Value)
        getgenv().webhook = Value
        if Value then
            local uiEndGame = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("EndGameUI")
            if uiEndGame and uiEndGame.Visible then
                webhook()
            else
                wait(1)
            end            
        end
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
