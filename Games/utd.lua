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
    Title = 'Tempest Hub | Ultimate Tower Defense',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Ultimate Tower Defense Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

function autorollbaner()
    while getgenv().autorollbaner == true do
        local args = {
            [1] = "Quests",
            [2] = 0
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSetNotifications"):FireServer(unpack(args))        
        local args = {
            [1] = selectednumberoll
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerBuyTower"):FireServer(unpack(args))
        wait()
    end
end

function autojoinmap()
    while getgenv().autojoinmap == true do
        local teleporter = workspace.Lobby.ClassicPartyTeleporters.Teleporter3.Collider
        local TweenService = game:GetService("TweenService")
        local speed = 1000

        -- Function to tween a model to a target CFrame
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

        -- Function to get a CFrame based on different types of input
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

            -- Apply height and angle adjustments
            if height then
                cframe = cframe + Vector3.new(0, height, 0)
            end
            if angle then
                cframe = cframe * CFrame.Angles(0, math.rad(angle), 0)
            end
            
            return cframe
        end

        local teleporterframe = GetCFrame(teleporter)
        local tween = tweenModel(game.Players.LocalPlayer.Character, teleporterframe)
        tween.Completed:Wait()
        
        local args = {
            [1] = selectedMapJoin
        }
    
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSelectedMap"):FireServer(unpack(args))
        
        args = {
            [1] = selectedMapDifficultyJoin
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSelectedGamemode"):FireServer(unpack(args))
        
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerQuickstartTeleport"):FireServer()
        
        wait()
    end
end

function autojoindg()
    while getgenv().autojoindg == true do
        local teleporterDG = workspace.Lobby.DungeonTeleporters.Teleporter1.DungeonCollider
        local TweenService = game:GetService("TweenService")
        local speed = 10000

        -- Function to tween a model to a target CFrame
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

        -- Function to get a CFrame based on different types of input
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

            -- Apply height and angle adjustments
            if height then
                cframe = cframe + Vector3.new(0, height, 0)
            end
            if angle then
                cframe = cframe * CFrame.Angles(0, math.rad(angle), 0)
            end
            
            return cframe
        end

        local teleporterframe = GetCFrame(teleporterDG)
        local tween = tweenModel(game.Players.LocalPlayer.Character, teleporterframe)
        tween.Completed:Wait()
        local args = {
            [1] = selectedDungeonDifficulty
        }
            
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSelectedGamemode"):FireServer(unpack(args))
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerQuickstartTeleport"):FireServer()
        wait()
    end
end

function autobuydgstore()
    while getgenv().autobuydgstore == true do
        local args = {
            [1] = selectedItemDGSTOre
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerPurchaseDungeonItem"):FireServer(unpack(args))        
        wait()
    end
end


function autostartmatch()
    while getgenv().autostartmatch == true do
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerVoteToStartMatch"):FireServer()
        wait()
    end
end

function autoleave()
    while getgenv().autoleave == true do
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerVoteReturn"):FireServer()
        wait()
    end
end

function autoskipwave()
    while getgenv().autoskipwave == true do
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerReadyForNextWave"):FireServer()
        wait()
    end 
end

function autorep()
    while getgenv().autorep == true do
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerVoteReplay"):FireServer()
        wait()
    end
end

function autofish()
    while getgenv().autofish == true do
        local args = {
            [1] = "Quests",
            [2] = 0
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSetNotifications"):FireServer(unpack(args))        
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerCatchFish"):FireServer()
        wait()
    end
end

function hideplayerinfo()
    while getgenv().hideplayerinfo == true do
        local barradexp = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.HUD.Toolbox.LevelBar
        local currencies = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.HUD.Currencies
        local gold = currencies.Gold
        local gem = currencies.Gem
        local xp = barradexp.Exp
        local level = barradexp.Level
        local fill = barradexp.Fill
        
        if xp and level and fill and gold and gem then
            xp.Text = "TempestHubOnTop"
            level.Text = "TempestHubOnTop"
            fill.Size = UDim2.new(1, 0, fill.Size.Y.Scale, fill.Size.Y.Offset)
            gem.amount.Text = 9999999999
            gold.amount.Text = 9999999999
        else
            wait()
        end
        
        local player = game.Players.LocalPlayer
        local Character = player.Character
        local Billboard = Character.HumanoidRootPart.PlayerOverheadGui.Frame

        -- Espera as partes específicas do personagem carregarem
        local Head = Character:WaitForChild("Head")
        local Hair = Character:FindFirstChild("Hair")

        -- Verifica se as partes existem antes de tentar alterá-las
        if Character:FindFirstChild("Pants") then
            Character.Pants.PantsTemplate = "rbxassetid://1"
        end

        if Character:FindFirstChild("Shirt") then
            Character.Shirt.ShirtTemplate = "rbxassetid://1"
        end

        if Hair and Hair:FindFirstChildOfClass("SpecialMesh") then
            local mesh = Hair:FindFirstChildOfClass("SpecialMesh")
            mesh.MeshId = "rbxassetid://1"
            mesh.TextureId = "rbxassetid://1"
        end

        if Head:FindFirstChildOfClass("Decal") then
            local face = Head:FindFirstChildOfClass("Decal")
            face.Texture = "rbxassetid://1"
        end

        if Billboard then
            Billboard.GroupRank.Text = "TempestHubOnTop"
            Billboard.Level.Text = "999999999999999999"
            Billboard.Username.Text = "TempestHubOnTop"
            Billboard.Misc.Text = "TempestHubOnTop"
        else
            wait()
        end

        if Character then
           Character.NarutoHair:Destroy() 
        end

        local hotbar = player.PlayerGui.MainGui.HUD.Toolbox.Hotbar
        local blacklist = {
            "UIListLayout",
            "Template",
            "TowerSlotTemplate"
        }

-- Função para verificar se um item está na blacklist
    local function isBlacklisted(itemName)
        for _, blacklistedName in ipairs(blacklist) do
            if itemName == blacklistedName then
                return true
            end
        end
        return false
    end

-- Iterando por todas as crianças do hotbar
        for _, child2 in ipairs(hotbar:GetChildren()) do
            if not isBlacklisted(child2.Name) then
                child2.ImageLabel.Image = "rbxassetid://1"
            end
        end
        wait()
    end
end

function autoupgrade()
    while getgenv().autoupgrade == true do
        local ValuesUnitGameID = {}
        local units = workspace.EntityColliders.Towers
        local children = units:GetChildren()

        for _, child4 in ipairs(children) do
            local unitsvalue = child4.entityId
            local text = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainFrames.Wave.WaveIndex.Text
            local waveNumber = string.match(text, "(%d+)/")
            if waveNumber == waveSelectedUpgrade then
                local args = {
                    [1] = unitsvalue.Value
                }
            
                game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerUpgradeTower"):FireServer(unpack(args))
            else
                wait()
            end
        end
        wait()
    end
end

function autoSellUnitGAMe()
    while getgenv().autoSellUnitGAMe == true do
        local ValuesUnitGameID = {}
        local units = workspace.EntityColliders.Towers
        local children = units:GetChildren()

        for _, child4 in ipairs(children) do
            local unitsvalue = child4.entityId
            local text = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainFrames.Wave.WaveIndex.Text
            local waveNumber = string.match(text, "(%d+)/")
            if waveNumber == waveSelectedSell then
                local args = {
                    [1] = unitsvalue.Value
                }
            
                game:GetService("ReplicatedStorage"):WaitForChild("GenericModules"):WaitForChild("Service"):WaitForChild("Network"):WaitForChild("PlayerSellTower"):FireServer(unpack(args))
            else
                wait()
            end
        end
        wait()
    end
end

function autoLeaveGame()
    while getgenv().autoLeaveGame == true do
        local ValuesUnitGameID = {}
        local units = workspace.EntityColliders.Towers
        local children = units:GetChildren()

        for _, child4 in ipairs(children) do
            local text = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainFrames.Wave.WaveIndex.Text
            local waveNumber = string.match(text, "(%d+)/")
            if waveNumber == waveSelectedLeave then
                game:GetService("TeleportService"):Teleport(5902977746, LocalPlayer)
            else
                wait()
            end
        end
        wait()
    end
end

local Valuesmapsjoin = {}
local maps = game:GetService("ReplicatedStorage").Modules.Item.Map
local children = maps:GetChildren()

for _, child in ipairs(children) do
    table.insert(Valuesmapsjoin, child.Name)
end

-- Definindo tabelas para armazenar os valores
local ValuesIDUnit = {}
local ValuesLevelUnit = {}
local ValuesNameUnit = {}

-- Obter o jogador e a barra de ferramentas
local player = game:GetService("Players").LocalPlayer
local hotbar = player.PlayerGui.MainGui.MainFrames.Inventory.Content.Grid.ScrollingFrame

-- Definindo a blacklist
local blacklist = {
    "UIGridLayout",
}

-- Função para verificar se um item está na blacklist
local function isBlacklisted(itemName)
    for _, blacklistedName in ipairs(blacklist) do
        if itemName == blacklistedName then
            return true
        end
    end
    return false
end

-- Iterando por todas as crianças do hotbar
for _, child2 in ipairs(hotbar:GetChildren()) do
    if not isBlacklisted(child2.Name) then
        local levelunit = child2.Level.Text
        local nameunit = child2.NameLabel.Text
        table.insert(ValuesIDUnit, child2.Name)
        table.insert(ValuesLevelUnit, levelunit)
        table.insert(ValuesNameUnit, nameunit)
    else
        wait()
    end
end

local ValuesTrait = {}
local maps = game:GetService("ReplicatedStorage").Modules.Item.Trait
local children = maps:GetChildren()

for _, child3 in ipairs(children) do
    table.insert(ValuesTrait, child3.Name)
end


local unitOptions = {}
for i = 1, #ValuesNameUnit do
    local unitName = ValuesNameUnit[i]
    table.insert(unitOptions, unitName .. " | Level: " .. ValuesLevelUnit[i] .. " | ID: " .. ValuesIDUnit[i])
end

function autorolltrait()
    while getgenv().autorolltrait == true do
        if selectedUnit then
            local index = nil
            for i, name in ipairs(ValuesNameUnit) do
                if name == selectedUnit then
                    index = i
                    break
                end
            end
            
            local textWithTags = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainFrames.Inventory.RerollTraitFrame.Main.Info.CurrentTrait.Text
            local cleanedText = textWithTags:gsub("<[^>]+>", ""):match("^%s*(.-)%s*%(")
            local rerolltraitgui = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainFrames.Inventory.RerollTraitFrame
            rerolltraitgui.Visible = true

            if index and selectedTrait ~= cleanedText then
                local IDUnit = ValuesIDUnit[index]
                local args = {
                    [1] = IDUnit
                }
            
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerRerollTower"):FireServer(unpack(args))
            elseif index and selectedTrait == cleanedText then
                print("Pegou")
            else
                print("Iiiih rapaz")
            end
        else
            print("No selected unit.")
        end
        
        wait() -- Espera um pouco antes de verificar novamente
    end
end

local ValuesStoreDG = {}
local DungeonStore = game:GetService("ReplicatedStorage").Modules.Item.DungeonStoreItems
local children = DungeonStore:GetChildren()

for _, child5 in ipairs(children) do
    table.insert(ValuesStoreDG, child5.Name)
end

function webhook()
    while getgenv().webhook == true do
    local discordWebhookUrl = "https://discord.com/api/webhooks/1248829666899267686/LOJd3WY18Hu1fQRo-z_yLVxHzMgnTAmMu6Wt-78UK3LlRYI-bES5O-0l7-VHfHO8_1Wz"
    local players = game:GetService("Players")
    local httpService = game:GetService("HttpService")
    local localPlayer = players.LocalPlayer

    local leaderstats = localPlayer:FindFirstChild("leaderstats")
    local fishpity = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.HUD.CatchesToday.Text
    local StarPass = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainFrames.Battlepass.MainFrame.TopFrame.Experience.Level

    if leaderstats and fishpity then
        local elo = leaderstats:FindFirstChild("Elo").Value
        local gold = leaderstats:FindFirstChild("Gold").Value
        local level = leaderstats:FindFirstChild("Level").Value
        local FishPity2 = fishpity.Text
        local StarPassText = StarPass.TextLabel.Text

        

        -- Constructing the payload to send to the webhook
        local payload = {
            content = "Tempest Hub",
            embeds = {
                {
                    title = "Account Situation",
                    description = string.format("Name: %s\nLevel: %s\nElo: %s\nGold: %s\nFish Pity: %s) \nStarPass Level: %s\n\n------------------------------------", localPlayer.Name, level, elo, gold, FishPity2, StarPassText),
                    color = 10098630,
                    fields = {
                        {
                            name = "Discord",
                            value = "https://discord.gg/tvQqnYKF7j"
                        }
                    },
                    author = {
                        name = "Ultimate Tower Defense"
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

        -- Converting the table to JSON
        local payloadJson = httpService:JSONEncode(payload)

        -- Sending the POST request to the Discord webhook
        local response = request({
            Url = discordWebhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payloadJson
        })

        if response.Success then
            print("Message sent to Discord successfully.")
        else
            warn("Error sending message to Discord:", response.StatusCode, response.Body)
        end
    else
        warn("Leaderstats not found.")
    end
    wait(delaywebhook)
end
end

function webhookGame()
    while getgenv().webhookGame == true do
    local discordWebhookUrl = "https://discord.com/api/webhooks/1248829666899267686/LOJd3WY18Hu1fQRo-z_yLVxHzMgnTAmMu6Wt-78UK3LlRYI-bES5O-0l7-VHfHO8_1Wz"
    local players = game:GetService("Players")
    local httpService = game:GetService("HttpService")
    local localPlayer = players.LocalPlayer
    
    local FinishGui = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainFrames.RoundOver

    if  FinishGui then
        local Status = FinishGui.Victory.Text
        local time = FinishGui.RoundTime.Text
        local enemiesKilled = FinishGui.EnemiesKilled.Text
        local Rewards = FinishGui.Reward.Text

        -- Constructing the payload to send to the webhook
        local payload = {
            content = "Tempest Hub",
            embeds = {
                {
                    title = "Account Situation",
                    description = string.format("Name: %s\nStatus: %s\ntime: %s\nenemiesKilled: %s\nRewards: %s) \n------------------------------------", localPlayer.Name, Status, time, enemiesKilled, Rewards),
                    color = 10098630,
                    fields = {
                        {
                            name = "Discord",
                            value = "https://discord.gg/tvQqnYKF7j"
                        }
                    },
                    author = {
                        name = "Ultimate Tower Defense"
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

        -- Converting the table to JSON
        local payloadJson = httpService:JSONEncode(payload)

        -- Sending the POST request to the Discord webhook
        local response = request({
            Url = discordWebhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payloadJson
        })

        if response.Success then
            print("Message sent to Discord successfully.")
        else
            warn("Error sending message to Discord:", response.StatusCode, response.Body)
        end
    else
        warn("Leaderstats not found.")
    end
    wait()
    end
end

local blackScreenEnabled = false -- Variável para controlar o estado do black screen

function blackScreen()
    while true do
        if getgenv().blackScreen == true and not blackScreenEnabled then
            blackScreenEnabled = true
            -- Criar e configurar o GuiBlackScreen
            local GuiBlackScreen = Instance.new("ScreenGui")
            GuiBlackScreen.Name = "GuiBlackScreen"
            GuiBlackScreen.Parent = game.Players.LocalPlayer.PlayerGui
            
            local BlackScreen = Instance.new("Frame")
            BlackScreen.Name = "BlackScreen"
            BlackScreen.Size = UDim2.new(5, 0, 5, 0)
            BlackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
            BlackScreen.BorderSizePixel = 0
            BlackScreen.Position = UDim2.new(0, 0, -0.3, 0)
            BlackScreen.Visible = true
            
            BlackScreen.Parent = GuiBlackScreen
            
        elseif getgenv().blackScreen == false and blackScreenEnabled then
            blackScreenEnabled = false
            local guiBlackScreen = game.Players.LocalPlayer.PlayerGui:FindFirstChild("GuiBlackScreen")
            if guiBlackScreen then
                guiBlackScreen:Destroy()
            end
        end
        wait()  -- Aguarda um segundo antes de verificar novamente
    end
end


local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Player')

LeftGroupBox:AddToggle('AutoStart', {
    Text = 'Auto Start',
    Default = false,
    Callback = function(Value)
        getgenv().autostartmatch = Value
        autostartmatch()
    end
})

LeftGroupBox:AddToggle('AutoSkipWave', {
    Text = 'Auto Skip Wave',
    Default = false,
    Callback = function(Value)
        getgenv().autoskipwave = Value
        autoskipwave()
    end
})

LeftGroupBox:AddToggle('AutoReplay', {
    Text = 'Auto Replay',
    Default = false,
    Callback = function(Value)
        getgenv().autorep = Value
        autorep()
    end
})

LeftGroupBox:AddToggle('AutoLeave', {
    Text = 'Auto Leave',
    Default = false,
    Callback = function(Value)
        getgenv().autoleave = Value
        autoleave()
    end
})

LeftGroupBox:AddToggle('AutoFish', {
    Text = 'Auto Fish',
    Default = false,
    Callback = function(Value)
        getgenv().autofish = Value
        autofish()
    end
})

LeftGroupBox:AddToggle('HidePlayerInfo', {
    Text = 'Hide Player Info',
    Default = false,
    Callback = function(Value)
        getgenv().hideplayerinfo = Value
        hideplayerinfo()
    end
})

local MyButton1 = LeftGroupBox:AddButton({
    Text = 'Go To Lobby',
    Func = function()
        game:GetService("TeleportService"):Teleport(5902977746, LocalPlayer)
    end,
    DoubleClick = false,
})

local MyButton2 = LeftGroupBox:AddButton({
    Text = 'Reedem Codes',
    Func = function()
        local codes = {
            "Summer2024",
            "SoloRaidingPart2",
            "iDontLikeReading",
            "gamebrokenhugeL",
            "Arise",
            "BroleeEvolution",
            "Artifacts",
            "SorryForMapBugs",
            "SubscribeToAlopekForShinyRimuru",
            "400kLikes",
            "500kFavs",
        }
        
        for _, code in ipairs(codes) do
            local args = {
                [1] = "Twitter",
                [2] = 0
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteEvents"):WaitForChild("PlayerSetNotifications"):FireServer(unpack(args))            
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("GlobalInit"):WaitForChild("RemoteFunctions"):WaitForChild("PlayerRedeemCode"):InvokeServer(code)            
            wait()
        end               
    end,
    DoubleClick = false,
    Tooltip = ''
})

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Misc')

LeftGroupBox:AddSlider('SpamWebhook', {
    Text = 'Delay Webhook',
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        delaywebhook = Value
    end
})

LeftGroupBox:AddToggle('Webhook', {
    Text = 'Send Webhook of Acc Status',
    Default = false,
    Callback = function(Value)
        getgenv().webhook = Value
        if Value then
            webhook()
        end
    end
})

LeftGroupBox:AddToggle('Webhook', {
    Text = 'Send Webhook When Finish Game',
    Default = false,
    Callback = function(Value)
        getgenv().webhook = Value
        if Value then
            webhookGame()
        end
    end
})

LeftGroupBox:AddToggle('BS', {
    Text = 'Black Screen',
    Default = false,
    Callback = function(Value)
        getgenv().blackScreen = Value
        blackScreen()
    end
})

local RightGroupBox = Tabs.Main:AddRightGroupbox('Auto Enter')

RightGroupBox:AddDropdown('CMTJ', {
    Values = Valuesmapsjoin,
    Default = "None",
    Multi = false,
    Text = 'Choose Map To Join',
    Callback = function(value)
        selectedMapJoin = value
    end
})

RightGroupBox:AddDropdown('CDTJ', {
    Values = {"Classic", "Hard", "Infinite"},
    Default = "None",
    Multi = false,
    Text = 'Choose Difficulty To Join',
    Callback = function(value)
        selectedMapDifficultyJoin = value
    end
})

RightGroupBox:AddToggle('AutoJoinMap', {
    Text = 'Auto Join Map',
    Default = false,
    Callback = function(Value)
        getgenv().autojoinmap = Value
        autojoinmap()
    end
})

RightGroupBox:AddDropdown('CDTJ', {
    Values = {"Dungeon", "DungeonHardcore"},
    Default = "None",
    Multi = false,
    Text = 'Choose Difficulty To Join',
    Callback = function(value)
        selectedDungeonDifficulty = value
    end
})

RightGroupBox:AddToggle('AutoJoinMap', {
    Text = 'Auto Join Dungeon',
    Default = false,
    Callback = function(Value)
        getgenv().autojoindg = Value
        autojoindg()
    end
})

local RightGroupBox = Tabs.Main:AddRightGroupbox('Game')

RightGroupBox:AddInput('WaveUpgrade', {
    Default = '',
    Numeric = true, 
    Finished = true,

    Text = 'Select Wave To Auto Upgrade Units',

    Placeholder = 'Press Enter To Save',

    Callback = function(Value)
        waveSelectedUpgrade = Value
    end
})

RightGroupBox:AddToggle('AutoUpgradeUnit', {
    Text = 'Auto Upgrade Unit At Wave X',
    Default = false,
    Callback = function(Value)
        getgenv().autoupgrade = Value
        autoupgrade()
    end
})

RightGroupBox:AddInput('WaveSell', {
    Default = '',
    Numeric = true, 
    Finished = true,

    Text = 'Select Wave To Auto Sell Units',

    Placeholder = 'Press Enter To Save',

    Callback = function(Value)
        waveSelectedSell = Value
    end
})


RightGroupBox:AddToggle('AutoSellUnit', {
    Text = 'Auto Sell Unit At Wave X',
    Default = false,
    Callback = function(Value)
        getgenv().autoSellUnitGAMe = Value
        autoSellUnitGAMe()
    end
})

RightGroupBox:AddInput('WaveLeave', {
    Default = '',
    Numeric = true, 
    Finished = true,

    Text = 'Select Wave To Auto Leave',

    Placeholder = 'Press Enter To Save',

    Callback = function(Value)
        waveSelectedLeave = Value
    end
})


RightGroupBox:AddToggle('AutoLeave', {
    Text = 'Auto Leave At Wave X',
    Default = false,
    Callback = function(Value)
        getgenv().autoLeaveGame = Value
        autoLeaveGame()
    end
})

local Tabs = {
    Main = Window:AddTab('Shop'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Summon')

LeftGroupBox:AddDropdown('CQTS', {
    Values = {1, 10},
    Default = "None",
    Multi = false,
    Text = 'Choose Quantity To Summon',
    Callback = function(value)
        selectednumberoll = value
    end
})

LeftGroupBox:AddToggle('AutoRollBanner', {
    Text = 'Auto Roll',
    Default = false,
    Callback = function(Value)
        getgenv().autorollbaner = Value
        autorollbaner()
    end
})

LeftGroupBox:AddDropdown('CITB', {
    Values = ValuesStoreDG,
    Default = "None",
    Multi = false,
    Text = 'Choose Item To Buy(DG Store)',
    Callback = function(value)
        selectedItemDGSTOre = value
    end
})

LeftGroupBox:AddToggle('AutoBuyDGStore', {
    Text = 'Auto Buy',
    Default = false,
    Callback = function(Value)
        getgenv().autobuydgstore = Value
        autobuydgstore()
    end
})

local RightGroupBox = Tabs.Main:AddRightGroupbox('Unit')

RightGroupBox:AddDropdown('CRPU', {
    Values = unitOptions,
    Default = "None",
    Multi = false,
    Text = 'Choose Unit To Roll',
    Callback = function(value)
        -- Extrair apenas o nome da unidade
        local unitName = value:match("^(.-) | Level:")
        selectedUnit = unitName
    end
})

RightGroupBox:AddDropdown('CTTR', {
    Values = ValuesTrait,
    Default = "None",
    Multi = false,
    Text = 'Choose Trait To Roll',
    Callback = function(value)
        selectedTrait = value
    end
})

RightGroupBox:AddToggle('AutoRollTrait', {
    Text = 'Auto Roll Trait',
    Default = false,
    Callback = function(Value)
        getgenv().autorolltrait = Value
        autorolltrait()
    end
})

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection

-- Create a function to update FPS and ping information
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

-- Connect the function to the RenderStepped event
WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(UpdateWatermark)

-- Create tabs for UI settings
local TabsUI = {
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Unload function
local function Unload()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end

-- UI Settings
local MenuGroup = TabsUI['UI Settings']:AddLeftGroupbox('Menu')

-- Add an unload button
MenuGroup:AddButton('Unload', Unload)

-- Add a label and key picker for the menu keybind
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

-- Define the ToggleKeybind variable
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('Tempest Hub')
SaveManager:SetFolder('Tempest Hub/_U_T_D')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_U_T_D'
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

-- Disable player idling
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
warn('[TEMPEST HUB] Loaded')