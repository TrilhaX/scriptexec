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
warn('[TEMPEST HUB] Loading Function')
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local speed = 1000
local selectedPassivesToRoll = nil
local selectedUnitRoll = nil

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

function HPI()
    while getgenv().HPI == true do
        local character = game.Players.LocalPlayer.Character
        local display = character.Head.NameDisplay
        if display then
            display:Destroy()
        end
        wait()
    end
end

function deleteMap()
    local ignorePlaceIds = {17046374415}

    local function isPlaceIdIgnored(placeId)
        for _, id in ipairs(ignorePlaceIds) do
            if id == placeId then
                return true
            end
        end
        return false
    end

    if getgenv().deleteMap == true then
        if isPlaceIdIgnored(game.PlaceId) then
            print("Map will not be deleted due to ignored PlaceId.")
            return
        end

        local mapFolder = workspace:FindFirstChild("Map")
        if mapFolder then
            for _, child in pairs(mapFolder:GetChildren()) do
                if child.Name then
                    child:Destroy()
                end
            end
            print("Map deleted successfully.")
        else
            print("Map folder not found.")
        end
        wait()
    end
end

function startVote()
    while getgenv().startVote == true do
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("GameStartVote"):FireServer()
        wait()
    end
end

function autoSkipWave()
    while getgenv().autoSkipWave == true do
        local args = {
            [1] = true
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SkipWave"):FireServer(unpack(args))
        wait()
    end
end

function autoLeave()
    while getgenv().autoLeave == true do
        local player = game:GetService("Players").LocalPlayer
        local victoryUI = player.PlayerGui.Main:FindFirstChild("Victory")
        local loseUI = player.PlayerGui.Main:FindFirstChild("Lose")
        
        if (victoryUI and victoryUI.Visible) or (loseUI and loseUI.Visible) then
            local lobbyButtonLose = loseUI and loseUI.Page.InfoDisplay.List.Options.LobbyButton
            local lobbyButtonVictory = victoryUI and victoryUI.Page.InfoDisplay.List.Options.LobbyButton
            local button1 = lobbyButtonLose 
            local button2 = lobbyButtonVictory
        
            if button1 and loseUI.Visible then
                print("1")
                game:GetService("GuiService").SelectedObject = button1
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            elseif button2 and victoryUI.Visible then
                print("2")
                game:GetService("GuiService").SelectedObject = button2
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            else
                print("No Button")
            end
        else
            wait(1)
        end
        wait(1)
    end
end

function autoRetry()
    while getgenv().autoRetry == true do
        local args = {
            [1] = "GameFinish",
            [2] = "Restart"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("VoteEvent"):FireServer(unpack(args))        
        wait()
    end
end

function autoNext()
    while getgenv().autoNext == true do
        local args = {
            [1] = "GameFinish",
            [2] = "Next"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("VoteEvent"):FireServer(unpack(args))        
        wait()
    end
end

function deleteNotifications()
    while getgenv().deleteNotifications == true do
        local notifications = game:GetService("Players").LocalPlayer.PlayerGui.NotifyScreenUI
        if notifications then
            notifications:Destroy()
            print("No notifications more")
            break
        else
            print("No notifications UI")
        end
        wait()
    end
end

function securityMode()
    while getgenv().securityMode == true do
        local players = game:GetService("Players")
        local ignorePlaceIds = {17046374415}

        local function isPlaceIdIgnored(placeId)
            for _, id in ipairs(ignorePlaceIds) do
                if id == placeId then
                    return true
                end
            end
            return false
        end

        if #players:GetPlayers() >= 2 then
            local player1 = players:GetPlayers()[1]
            local targetPlaceId = 17046374415

            if game.PlaceId ~= targetPlaceId and not isPlaceIdIgnored(game.PlaceId) then
                game:GetService("TeleportService"):Teleport(targetPlaceId, player1)
            end
        end
        wait()
    end
end

function extremeFpsBoost()
    if getgenv().extremeFpsBoost == true then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        game.Lighting.GlobalShadows = false
        game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Color = Color3.new(0.5, 0.5, 0.5)
                obj.Transparency = 0
                obj.CanCollide = true
            elseif obj:IsA("Mesh") or obj:IsA("SpecialMesh") then
                obj:Destroy()
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end

            wait(.1)
        end

        for _, effect in pairs(game.Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then
                effect.Enabled = false
            end

            wait(.1)
        end
        wait()
    end
end

function autoGetQuest()
    while getgenv().autoGetQuest == true do
        local questsFolder = game:GetService("ReplicatedStorage").Registry.Quests
        local quests = questsFolder:GetChildren()

        for _, quest in ipairs(quests) do
            if quest.Name ~= "PackageLink" then
                local args = {
                    [1] = "ClaimQuest",
                    [2] = quest.Name
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Quests"):InvokeServer(unpack(args))
            end
        end
        wait()
    end
end

function autoGetBattlepass()
    while getgenv().autoGetBattlepass == true do
        local args = {
            [1] = "Battlepass/ClaimRewards"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UiCommunication"):FireServer(unpack(args))        
        wait()
    end
end

function upgradeUnit()
    while getgenv().upgradeUnit == true do
        if getgenv().onlyupgradeinwaveX == true then
            local waveCounterText = game:GetService("Players").LocalPlayer.PlayerGui.Waves.Wave.Holder.WaveCounter.WaveCounter.Text
            local waveNumber = waveCounterText:match("%d+")

            if waveNumber >= selectedWaveXToUpgrade then
                local unitsPlaced = workspace.UnitsPlaced

                for i,v in pairs(unitsPlaced:GetChildren())do
                    local args = {
                        [1] = "Upgrade",
                        [2] = {
                            ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(v.Name)                    }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                    wait()
                end
            else
                wait()
            end
        else
            local unitsPlaced = workspace.UnitsPlaced

            for i,v in pairs(unitsPlaced:GetChildren())do
                local args = {
                    [1] = "Upgrade",
                    [2] = {
                        ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(v.Name)                    }
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                wait()
            end
        end
        wait()
    end
end

function sellUnit()
    while getgenv().sellUnit == true do
        if getgenv().onlySellinwaveX == true then
            local waveCounterText = game:GetService("Players").LocalPlayer.PlayerGui.Waves.Wave.Holder.WaveCounter.WaveCounter.Text
            local waveNumber = waveCounterText:match("%d+")

            if waveNumber >= selectedWaveXToSell then
                local unitsPlaced = workspace.UnitsPlaced

                for i,v in pairs(unitsPlaced:GetChildren())do
                    local args = {
                        [1] = "Sell",
                        [2] = {
                            ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(v.Name)                    }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                    wait()
                end
            else
                wait()
            end
        else
            local unitsPlaced = workspace.UnitsPlaced

            for i,v in pairs(unitsPlaced:GetChildren())do
                local args = {
                    [1] = "Sell",
                    [2] = {
                        ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(v.Name)                    }
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                wait()
            end
        end
        wait()
    end
end

function autoUniversalSkill()
    while getgenv().autoUniversalSkill == true do
        if getgenv().onlyBoss == true then
            local bossHp = game:GetService("Players").LocalPlayer.PlayerGui.Main.BossesHPBars.BossHpBarNEW

            if bossHp then
                local unitsPlaced = workspace.UnitsPlaced

                for i,v in pairs(unitsPlaced:GetChildren())do
                    local args = {
                        [1] = "SpecialAbility",
                        [2] = {
                            ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(v.Name)
                        }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                    wait()
                end
            else
                wait()
            end
        elseif getgenv().onlyUseSkillInWaveX then
            local waveCounterText = game:GetService("Players").LocalPlayer.PlayerGui.Waves.Wave.Holder.WaveCounter.WaveCounter.Text
            local waveNumber = waveCounterText:match("%d+")

            if waveNumber == selectedWaveToStartAutoSkill then
                local unitsPlaced = workspace.UnitsPlaced

                for i,v in pairs(unitsPlaced:GetChildren())do
                    local args = {
                        [1] = "SpecialAbility",
                        [2] = {
                            ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(v.Name)
                        }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                    wait()
                end
            else
                wait()
            end
        else
            local unitsPlaced = workspace.UnitsPlaced

            for i,v in pairs(unitsPlaced:GetChildren())do
                local args = {
                    [1] = "SpecialAbility",
                    [2] = {
                        ["unit"] = workspace:WaitForChild("UnitsPlaced"):WaitForChild(v.Name)
                    }
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                wait()
            end
        end
        wait()
    end
end

function placeUnits()
    while getgenv().placeUnits == true do
        if getgenv().onlyPlaceinwaveX == true then
            local waveCounterText = game:GetService("Players").LocalPlayer.PlayerGui.Waves.Wave.Holder.WaveCounter.WaveCounter.Text
            local waveNumber = waveCounterText:match("%d+")

            if waveNumber >= selectedWaveXToPlace then
                local slots = {
                    "Slot1",
                    "Slot2",
                    "Slot3",
                    "Slot4",
                    "Slot5",
                    "Slot6",
                }
    
                local path = workspace:FindFirstChild("Path") and workspace.Path:FindFirstChild(tostring(selectedWaypointToPlaceUnits))
    
                if not path or not path:FindFirstChild("CornerStart") then
                    warn("Path or CornerStart not found!")
                end
    
                local cornerStart = path.CornerStart
                local basePosition = cornerStart.Position
                local radius = 5
                local numSlots = #slots
    
                for i, slot in ipairs(slots) do
                    local angle = (i - 1) * (math.pi * 2 / numSlots)
                    local offsetX = math.cos(angle) * radius
                    local offsetZ = math.sin(angle) * radius
                    local newPosition = basePosition + Vector3.new(offsetX, 0, offsetZ)
    
                    local args = {
                        [1] = "Place",
                        [2] = {
                            ["rot"] = math.deg(angle),
                            ["slot"] = slot,
                            ["position"] = CFrame.new(newPosition),
                        }
                    }
    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                    wait()
                end
            else
                wait()
            end
        else
            local slots = {
                "Slot1",
                "Slot2",
                "Slot3",
                "Slot4",
                "Slot5",
                "Slot6",
            }

            local path = workspace:FindFirstChild("Path") and workspace.Path:FindFirstChild(tostring(selectedWaypointToPlaceUnits))

            if not path or not path:FindFirstChild("CornerStart") then
                warn("Path or CornerStart not found!")
            end

            local cornerStart = path.CornerStart
            local basePosition = cornerStart.Position
            local radius = 5
            local numSlots = #slots

            for i, slot in ipairs(slots) do
                local angle = (i - 1) * (math.pi * 2 / numSlots)
                local offsetX = math.cos(angle) * radius
                local offsetZ = math.sin(angle) * radius
                local newPosition = basePosition + Vector3.new(offsetX, 0, offsetZ)

                local args = {
                    [1] = "Place",
                    [2] = {
                        ["rot"] = math.deg(angle),
                        ["slot"] = slot,
                        ["position"] = CFrame.new(newPosition),
                    }
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Unit"):FireServer(unpack(args))
                wait()
            end
        end
        wait()
    end
end

function autochooseCard()
    while getgenv().autochooseCard == true do
        local cards = game:GetService("Players").LocalPlayer.PlayerGui.Modifiers:FindFirstChild("ChooseCard")

        if cards then
            print("Cards Here")
            local buffCard = cards.List:FindFirstChild("BuffCard")
            local children = cards.List:GetChildren()
            local debuffCards = {}

            for _, child in ipairs(children) do
                if child.Name == "DebuffCard" then
                    table.insert(debuffCards, child)
                end
            end

            local selectedCardFound = false
            for _, selectedCard in ipairs(selectedValues) do
                for _, child in ipairs(children) do
                    local cardTitle = child.Page.Title.Text
                    if cardTitle == selectedCard then
                        print("Found selected card: " .. cardTitle)
                        selectedCardFound = true
                    end
                end
                if selectedCardFound then
                    break
                end
            end

            if not selectedCardFound then
                print("No selected cards found in the list")
            end
        else
            print("No cards")
        end
        wait()
    end
end

function autoJoin()
    while getgenv().autoJoin == true do
        local queueZones = workspace.Map.QueueZones:GetChildren()
        local door
        for _, zone in ipairs(queueZones) do
            if zone:FindFirstChild("GuiContainer") then
                door = zone.GuiContainer
                break
            end
        end
        
        if door then
            local targetCFrame = GetCFrame(door)
            local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
            tween:Play()
            tween.Completed:Wait()
            wait(1)
            local args = {
                [1] = "MapSelection/SelectMap",
                [2] = {
                    ["Difficulty"] = selectedDifficultyStory,
                    ["MapName"] = selectedStoryMap,
                    ["GameScenarioID"] = selectedActStory,
                    ["FriendsOnly"] = getgenv().friendsOnly,
                    ["GameType"] = selectedGameType
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UiCommunication"):FireServer(unpack(args))  
            wait(1) 
            local players = game:GetService("Players")
            local GuiService = game:GetService("GuiService")
            local VirtualInputManager = game:GetService("VirtualInputManager")

            local startButton = players.LocalPlayer:FindFirstChild("PlayerGui")
                and players.LocalPlayer.PlayerGui:FindFirstChild("LobbyGUI")
                and players.LocalPlayer.PlayerGui.LobbyGUI:FindFirstChild("MatchStats")
                and players.LocalPlayer.PlayerGui.LobbyGUI.MatchStats:FindFirstChild("Start")

            if startButton then
                if startButton:IsA("GuiObject") and startButton.Visible then
                    GuiService.SelectedObject = startButton
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                else
                    warn("Start button is not visible or not a valid GUI object")
                end
            else
                warn("Start button not found")
            end
            break
        else
            print("No door found")
        end
        wait()
    end
end

function autoJoinChallenge()
    while getgenv().autoJoinChallenge do
        local mapNamesChallenge = game:GetService("Players").LocalPlayer.PlayerGui.MatchStatsFolder
        local printedNames = {}
        local mapNames = {}

        for _, v in pairs(mapNamesChallenge:GetChildren()) do
            local mapName = v.Container.MapData.MapName.Text
            if mapName and not printedNames[mapName] and mapName ~= "Red Army HQ" and mapName ~= "Fujishima Island" then
                printedNames[mapName] = true
                table.insert(mapNames, mapName)
            end
        end

        if #mapNames == 0 then
            wait()
            wait(5)
        end

        local Models = workspace.Map.QueueChallengeZones:GetChildren()
        for i, model in ipairs(Models) do
            local index = ((i - 1) % #mapNames) + 1
            local mapName = mapNames[index]
            
            wait()
            
            if selectedChallengeMaps[mapName] then
                local TeleportCFrame = GetCFrame(model.Hitbox)
                if TeleportCFrame then
                    local tween = tweenModel(game.Players.LocalPlayer.Character, TeleportCFrame)
                    if tween then
                        tween:Play()
                        tween.Completed:Wait()
                    end
                else
                    wait()
                end
            else
                wait()
            end
        end
        wait()
    end
end

function autoSummon()
    while getgenv().autoSummon == true do
        if getgenv().summon10 == "10" then
            local units = game:GetService("Players").LocalPlayer.PlayerGui.LobbyGUI.Summon.Page.Template.List

            for i,v in pairs(units:GetChildren())do
                if v.Name ~= "PackageLink" and v.Name ~= "1_Documentation" then
                    if selectedUnit == v.UnitName.Text then
                        local args = {
                            [1] = "Summon10"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Summoning"):WaitForChild("SummonEvent"):FireServer(unpack(args))
                    end
                end
            end
        else 
            local units = game:GetService("Players").LocalPlayer.PlayerGui.LobbyGUI.Summon.Page.Template.List

            for i,v in pairs(units:GetChildren())do
                if v.Name ~= "PackageLink" and v.Name ~= "1_Documentation" then
                    if selectedUnit == v.UnitName.Text then
                        local args = {
                            [1] = "Summon1"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Summoning"):WaitForChild("SummonEvent"):FireServer(unpack(args))
                    end
                end
            end    
        end
        wait()
    end
end

function autoGetIndex()
    while getgenv().autoGetIndex == true do
        local args = {
            [1] = "UnitIndex/ClaimAllPrizes"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UiCommunication"):FireServer(unpack(args))
        wait()
    end
end     

function autoGetLevelRewards()
    while getgenv().autoGetLevelRewards == true do
        local args = {
            [1] = "LevelRewards/ClaimEverything"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UiCommunication"):FireServer(unpack(args))        
        wait()
    end
end

function autoFeed()
    while getgenv().autoFeed == true do
        local args = {
            [1] = "Feed",
            [2] = {
                [selectedItemToFeed] = 1
            },
            [3] = selectedUnitToFeed
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UnitActions"):FireServer(unpack(args))
        wait()
    end
end

function autoRollPassive()
    while getgenv().autoRollPassive == true do
        local traitFrame = game:GetService("Players").LocalPlayer.PlayerGui.LobbyGUI.TraitReroll.Main.Frame.Trait

        if (traitFrame and traitFrame.Visible) then
            local passiveUnitAtual = traitFrame.Main.TraitName
            if passiveUnitAtual then
                print("Current passive: ", passiveUnitAtual.Text)
                local passiveMatchFound = false
                
                for _, selectedPassive in ipairs(selectedPassivesToRoll) do
                    print("Checking passive: ", selectedPassive)
                    if passiveUnitAtual.Text == selectedPassive then
                        passiveMatchFound = true
                        break
                    end
                end
                
                if passiveMatchFound then
                    print("Match found, calling webhook")
                else
                    print("No match found, rolling...")
                    local args = {
                        [1] = "TraitReroll",
                        [2] = tostring(selectedUnitToRollPassive)
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UnitFunctions"):InvokeServer(unpack(args))        
                    wait()
                end
            else
                print("What? Trait name not found.")
            end    
        else
            local args = {
                [1] = "TraitReroll",
                [2] = tostring(selectedUnitToRollPassive)
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UnitFunctions"):InvokeServer(unpack(args))        
            wait()
            print("First Roll")
        end
        wait()
    end
end

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local player = game:GetService("Players").LocalPlayer
        local victoryUI = player.PlayerGui.Main:FindFirstChild("Victory")
        local loseUI = player.PlayerGui.Main:FindFirstChild("Lose")
        
        if (victoryUI and victoryUI.Visible) or (loseUI and loseUI.Visible) then
            local name = player.Name
            local formattedName = "||" .. name .. "||"

            local playerID = game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
            local lastLevel, formattedLevel, formattedResult, formattedRewards

            for _, v in pairs(playerID:GetChildren()) do
                local playerNameLabel = v:FindFirstChild("ChildrenFrame")
                    and v.ChildrenFrame:FindFirstChild("NameFrame")
                    and v.ChildrenFrame.NameFrame:FindFirstChild("BGFrame")
                    and v.ChildrenFrame.NameFrame.BGFrame:FindFirstChild("OverlayFrame")
                    and v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame:FindFirstChild("PlayerName")
                
                if playerNameLabel and playerNameLabel.PlayerName.Text == player.DisplayName then
                    local modifiedName = string.sub(v.Name, 3)

                    local args = {modifiedName, "SELECT *"}
                    local retorno = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PublicDataQuery"):InvokeServer(unpack(args))

                    local function findLastLevel(t)
                        local lastLevel = nil
                        if type(t) == "table" then
                            for key, value in pairs(t) do
                                if key == "Level" then
                                    lastLevel = value
                                elseif type(value) == "table" then
                                    local nestedLevel = findLastLevel(value)
                                    if nestedLevel then lastLevel = nestedLevel end
                                end
                            end
                        end
                        return lastLevel
                    end

                    lastLevel = findLastLevel(retorno)
                    if lastLevel then
                        print("Last Level found:", lastLevel)
                    else
                        print("No 'Level' found.")
                    end
                end
            end

            local playerID = game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
            local formattedPlayerStats = {}
            
            local function tableToString(t, indent)
                indent = indent or 0
                local result = {}
                
                for key, value in pairs(t) do
                    local prefix = string.rep("\n", indent)
                    
                    if type(key) == "number" then
                        table.insert(result, tableToString(value, indent + 1))
                    else
                        if type(value) == "table" then
                            table.insert(result, prefix .. key .. ":")
                            table.insert(result, tableToString(value, indent + 1))
                        else
                            table.insert(result, prefix .. key .. ": " .. tostring(value))
                        end
                    end
                end
                
                return table.concat(result)
            end
            
            for _, v in pairs(playerID:GetChildren()) do
                local playerNameLabel = v:FindFirstChild("ChildrenFrame")
                                        and v.ChildrenFrame:FindFirstChild("NameFrame")
                                        and v.ChildrenFrame.NameFrame:FindFirstChild("BGFrame")
                                        and v.ChildrenFrame.NameFrame.BGFrame:FindFirstChild("OverlayFrame")
                                        and v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame:FindFirstChild("PlayerName")
            
                if playerNameLabel then
                    local realPlayerID = playerNameLabel.PlayerName.Text
            
                    if realPlayerID == game.Players.LocalPlayer.DisplayName then
                        local modifiedName = string.sub(v.Name, 3)
            
                        local args = {
                            [1] = modifiedName,
                            [2] = "SELECT *"
                        }
            
                        local retorno = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PublicDataQuery"):InvokeServer(unpack(args))
            
                        if retorno then
                            local function findLastLevel(t)
                                local PlayerStatistics = nil
                                if type(t) == "table" then
                                    for key, value in pairs(t) do
                                        if key == "PlayerStatistics" then
                                            PlayerStatistics = value
                                        elseif type(value) == "table" then
                                            local nestedLevel = findLastLevel(value)
                                            if nestedLevel then PlayerStatistics = nestedLevel end
                                        end
                                    end
                                end
                                return PlayerStatistics
                            end
                            local playerData = findLastLevel(retorno)
            
                            if playerData then
                                table.insert(formattedPlayerStats, playerData)
                            else
                                warn("PlayerStatistics não encontrado nos dados retornados.")
                            end
            
                        else
                            warn("Nenhum dado retornado para o jogador " .. realPlayerID)
                        end
                    end
                end
            end
            
            local formattedPlayerStatsStr = tableToString(formattedPlayerStats)

            if victoryUI and victoryUI.Visible then
                local expText = victoryUI.Page.InfoDisplay.List.LevelProgressBox.EXPGained.Text
                local expValue = string.match(expText, "^(%d+/[%d]+)")
                local mapName = workspace.MapName.Value
                local waveCounterText = game:GetService("Players").LocalPlayer.PlayerGui.Waves.Wave.Holder.WaveCounter.WaveCounter.Text
                local waveNumber = waveCounterText:match("%d+")
                
                if expValue then
                    local rewards = player.PlayerGui.Main.Victory.Page.InfoDisplay.List.Rewards.RewardHolder.Frame
                    formattedRewards = ""
                    for _, v in pairs(rewards:GetChildren()) do
                        if v.Name ~= "UIListLayout" and v.Name ~= "UIPadding" then
                            formattedRewards = formattedRewards .. string.format("+%s %s\n", v.Amount.Text, v.Name)
                        end
                    end
                    formattedLevel = string.format("Level: %s [%s]", tostring(lastLevel), tostring(expValue))
                    local playtime = victoryUI.Page.InfoDisplay.List.Playtime.Stat.Text
                    formattedResult = string.format("%s - %s\n Wave %s - Victory!", tostring(playtime), tostring(waveNumber), tostring(mapName))
                end
            elseif loseUI and loseUI.Visible then
                local expText = loseUI.Page.InfoDisplay.List.LevelProgressBox.EXPGained.Text
                local expValue = string.match(expText, "^(%d+/[%d]+)")
                local mapName = workspace.MapName.Value
                local waveCounterText = game:GetService("Players").LocalPlayer.PlayerGui.Waves.Wave.Holder.WaveCounter.WaveCounter.Text
                local waveNumber = waveCounterText:match("%d+")
                
                if expValue then
                    formattedRewards = "N/A"
                    formattedLevel = string.format("Level: %s [%s]", tostring(lastLevel), tostring(expValue))
                    local playtime = loseUI.Page.InfoDisplay.List.Playtime.Stat.Text
                    formattedResult = string.format("%s - Wave %s\n %s - Lose!", tostring(playtime), tostring(waveNumber), tostring(mapName))
                end
            end

            local playerID = game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame

            local lastLevel = nil
            local pairsSequence = {}

            local function processData(retorno)
                local levels = {}
                local unitNames = {}

                local function traverseTable(tableData)
                    if type(tableData) == "table" then
                        for key, value in pairs(tableData) do
                            if key == "Level" and type(value) ~= "table" then
                                lastLevel = value
                                if #levels < 6 then
                                    table.insert(levels, value)
                                end
                            end
                            if key == "UnitName" and type(value) ~= "table" then
                                if #unitNames < 6 then
                                    table.insert(unitNames, value)
                                end
                            end
                            if type(value) == "table" then
                                traverseTable(value)
                            end
                        end
                    end
                end

                traverseTable(retorno)

                for i = 1, math.min(#levels, #unitNames) do
                    local unitName = unitNames[i]
                    if unitName and unitName ~= "" and unitName ~= " " then
                        local unidades = "[ " .. tostring(levels[i]) .. " ] " .. tostring(unitName)
                        table.insert(pairsSequence, unidades)
                    end
                end
            end

            for _, v in pairs(playerID:GetChildren()) do
                local playerNameLabel = v:FindFirstChild("ChildrenFrame") and 
                                         v.ChildrenFrame:FindFirstChild("NameFrame") and 
                                         v.ChildrenFrame.NameFrame:FindFirstChild("BGFrame") and 
                                         v.ChildrenFrame.NameFrame.BGFrame:FindFirstChild("OverlayFrame") and
                                         v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame:FindFirstChild("PlayerName")
                
                if playerNameLabel and playerNameLabel.PlayerName.Text == game.Players.LocalPlayer.DisplayName then
                    local modifiedName = string.sub(v.Name, 3)
                    local args = { [1] = modifiedName, [2] = "SELECT *" }
                    local retorno = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PublicDataQuery"):InvokeServer(unpack(args))
                    processData(retorno)
                end
            end

            local pairsSequenceStr = table.concat(pairsSequence, "\n")

            local pingContent = ""
            if getgenv().pingUser and getgenv().pingUserId then
                pingContent = "<@" .. getgenv().pingUserId .. ">"
            elseif getgenv().pingUser then
                pingContent = "@"
            end

            local payload = {
                content = pingContent,
                embeds = {
                    {
                        description = string.format("User: %s\nLevel: %s\n\nPlayer Stats:\n %s\n\n++++++++++++++++++++++++++++\n\nRewards:\n%s\n\n++++++++++++++++++++++++++++\nUnits:\n%s\n\nMatch Result:\n %s",
                            tostring(formattedName), 
                            tostring(formattedLevel),
                            tostring(formattedPlayerStatsStr),
                            tostring(formattedRewards), 
                            pairsSequenceStr,
                            tostring(formattedResult)
                        ),
                        color = 7995647,
                        fields = {
                            {
                                name = "Discord",
                                value = "https://discord.gg/ey83AwMvAn"
                            }
                        },
                        author = {
                            name = "Anime Reborn"
                        },
                        thumbnail = {
                            url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png?ex=673e5b4c&is=673d09cc&hm=1d58485280f1d6a376e1bee009b21caa0ae5cad9624832dd3d921f1e3b2217ce&"
                        }
                    }
                },
                attachments = {}
            }

            local payloadJson = HttpService:JSONEncode(payload)

            if syn and syn.request then
                local response = syn.request({
                    Url = discordWebhookUrl,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = payloadJson
                })

                if response.Success then
                    print("Webhook sent successfully")
                    break
                else
                    warn("Error sending message to Discord with syn.request:", response.StatusCode, response.Body)
                end
            elseif http_request then
                local response = http_request({
                    Url = discordWebhookUrl,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = payloadJson
                })

                if response.Success then
                    print("Webhook sent successfully")
                    break
                else
                    warn("Error sending message to Discord with http_request:", response.StatusCode, response.Body)
                end
            else
                print("Synchronization not supported on this device.")
            end
        end

        wait(.2)
    end
end

local mapsFolder = game:GetService("ReplicatedStorage").Registry.Maps
local maps = mapsFolder:GetChildren()
local ValuesMaps = {}

for _, map in ipairs(maps) do
    if map.Name ~= "PackageLink" then
        table.insert(ValuesMaps, map.Name)
    end
end

local units = game:GetService("ReplicatedStorage").Registry.Units
local ValuesUnits = {}

for i,v in pairs(units:GetChildren())do
    if v.Name ~= "PackageLink" and v.Name ~= "1_Documentation" then
        table.insert(ValuesUnits, v.Name)
    end
end

local items = game:GetService("ReplicatedStorage").Registry.Items
local ValuesItems = {}

for _, v in pairs(items:GetChildren()) do
    if v.Name ~= "PackageLink" and v.Name ~= "1" then
        table.insert(ValuesItems, v.Name)
    end
end

local playerID = game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame

if not playerID then
    warn("playerID não encontrado!")
    return
end

local ValuesUnitID = {}

for _, v in ipairs(playerID:GetChildren()) do
    local nameFrame = v:FindFirstChild("ChildrenFrame")
        and v.ChildrenFrame:FindFirstChild("NameFrame")
        and v.ChildrenFrame.NameFrame:FindFirstChild("BGFrame")
        and v.ChildrenFrame.NameFrame.BGFrame:FindFirstChild("OverlayFrame")
        and v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame:FindFirstChild("PlayerName")
    
    if nameFrame then
        local realPlayerID = nameFrame.PlayerName.Text
        if realPlayerID == game.Players.LocalPlayer.DisplayName then
            local modifiedName = string.sub(v.Name, 3)
            
            local args = {modifiedName, "SELECT *"}
            local success, retorno = pcall(function()
                return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PublicDataQuery"):InvokeServer(unpack(args))
            end)

            if success and retorno then
                local function processTable(t)
                    if type(t) == "table" then
                        local unitName, uuid, level

                        for key, value in pairs(t) do
                            if key == "UnitName" then
                                unitName = tostring(value)
                            elseif key == "UUID" then
                                uuid = tostring(value)
                            elseif key == "Level" then
                                level = value
                            elseif type(value) == "table" then
                                processTable(value)
                            end
                        end

                        if unitName and uuid then
                            local dropdownEntry = string.format("%s | Level: %s | ID: %s", unitName, tostring(level or "N/A"), uuid)
                            table.insert(ValuesUnitID, dropdownEntry)
                        end
                    end
                end

                processTable(retorno)
            else
                warn("Falha ao recuperar dados: " .. tostring(retorno))
            end
        end
    else
        warn("Label do nome do jogador não encontrado para: " .. v.Name)
    end
end


local passives = game:GetService("ReplicatedStorage").Registry.Traits
local ValuesPassive = {}

for i, v in pairs(passives:GetChildren()) do
    if v.Name ~= "PackageLink" and v.Name ~= "Folder" then
        table.insert(ValuesPassive, v.Name)
    end
end

local challenges = game:GetService("ReplicatedStorage").Registry.Challenges
local ValuesChallenges = {}

for i,v in pairs(challenges:GetChildren())do
    if v.Name ~= "PackageLink" then
        table.insert(ValuesChallenges, v.Name)
    end
end

local cardsModifiers = game:GetService("ReplicatedStorage"):FindFirstChild("Registry"):FindFirstChild("CardModifiers")
local ValuesCards = {}

if cardsModifiers then
    for i, v in pairs(cardsModifiers:GetChildren()) do
        if v.Name ~= "Empty" then
            table.insert(ValuesCards, v.Name)
        end
    end
else
    warn("CardModifiers não encontrado!")
end

local paths = workspace:FindFirstChild("Path")
local ValuesWaypoints = {}

if paths then
    for i,v in pairs(paths:GetChildren())do
        table.insert(ValuesWaypoints, v.Name)
    end
else
    wait()
end

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Player")

LeftGroupBox:AddToggle("HPI", {
	Text = "Hide Player Info",
	Default = false,
	Callback = function(Value)
        getgenv().HPI = Value
		HPI()
	end,
})

LeftGroupBox:AddToggle("SM", {
	Text = "Security Mode",
	Default = false,
	Callback = function(Value)
		getgenv().securityMode = Value
        securityMode()
	end,
})

LeftGroupBox:AddToggle("DEN", {
	Text = "Delete Notifications", 
	Default = false,
	Callback = function(Value)
        getgenv().deleteNotifications = Value
		deleteNotifications()
	end,
})

LeftGroupBox:AddToggle("FPSBoost", {
	Text = "FPS Boost",
	Default = false,
	Callback = function(Value)
        getgenv().extremeFpsBoost = Value
		extremeFpsBoost()
	end,
})

LeftGroupBox:AddToggle("DeleteMap", {
	Text = "Delete Map",
	Default = false,
	Callback = function(Value)
        getgenv().deleteMap = Value
		deleteMap()
	end,
})

LeftGroupBox:AddToggle("AGQ", {
	Text = "Auto Get Quest",
	Default = false,
	Callback = function(Value)
		getgenv().autoGetQuest = Value
		autoGetQuest()
	end,
})

LeftGroupBox:AddToggle("AGI", {
	Text = "Auto Get Index",
	Default = false,
	Callback = function(Value)
		getgenv().autoGetIndex = Value
		autoGetIndex()
	end,
})

LeftGroupBox:AddToggle("AGLR", {
	Text = "Auto Get Level Rewards",
	Default = false,
	Callback = function(Value)
		getgenv().autoGetLevelRewards = Value
		autoGetLevelRewards()
	end,
})

LeftGroupBox:AddToggle("AGB", {
	Text = "Auto Get Battlepass",
	Default = false,
	Callback = function(Value)
		getgenv().autoGetBattlepass = Value
		autoGetBattlepass()
	end,
})

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Webhook")

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

LeftGroupBox:AddInput('pingUser@', {
    Default = '',
    Text = "User ID",
    Numeric = false,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        getgenv().pingUserId = Value
    end
})

LeftGroupBox:AddToggle("WebhookFG", {
    Text = "Send Webhook when finish game",
    Default = false,
    Callback = function(Value)
        getgenv().webhook = Value
        webhook()
    end,
})

LeftGroupBox:AddToggle("pingUser", {
    Text = "Ping user",
    Default = false,
    Callback = function(Value)
        getgenv().pingUser = Value
    end,
})

local RightGroupbox = Tabs.Main:AddRightGroupbox("Others")

RightGroupbox:AddToggle("AL", {
	Text = "Auto Leave",
	Default = false,
	Callback = function(Value)
		getgenv().autoLeave = Value
		autoLeave()
	end,
})

RightGroupbox:AddToggle("AR", {
	Text = "Auto Retry",
	Default = false,
	Callback = function(Value)
		getgenv().autoRetry = Value
		autoRetry()
	end,
})

RightGroupbox:AddToggle("AN", {
	Text = "Auto Next",
	Default = false,
	Callback = function(Value)
		getgenv().autoNext = Value
		autoNext()
	end,
})

RightGroupbox:AddToggle("ASG", {
	Text = "Auto Start Game",
	Default = false,
	Callback = function(Value)
		getgenv().startVote = Value
		startVote()
	end, 
})

RightGroupbox:AddToggle("ASW", {
	Text = "Auto Skip Wave",
	Default = false,
	Callback = function(Value)
		getgenv().autoSkipWave = Value
		autoSkipWave()
	end,
})

local MyButton2 = RightGroupbox:AddButton({
    Text = 'Reedem Codes',
    Func = function()
        local codes = {
            "Eligibility",
            "Freetickets",
            "20Mvisits",
            "10MVisits",
            "SorryForFoodBug!",
            "XMEGACODE",
            "MegaZillas",
            "MegaMozKing",
            "MegaRlxSage",
            "5mVisits",
            "100kLikes",
            "2MVisits",
            "50KLikes",
            "200kMembers",
            "1MVisits",
            "Release",
            "MozKing",
            "SubtoRlxsage",
            "SubtoZillas"
        }           
        
        for _, code in ipairs(codes) do
            local args = {
                [1] = "Codes/RedeemCode",
                [2] = codes
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UiCommunication"):FireServer(unpack(args))            
            wait()
        end               
    end,
    DoubleClick = false,
})

local TabBox = Tabs.Main:AddRightTabbox()

local Tab1 = TabBox:AddTab('Passive')

Tab1:AddDropdown('dropdownUnitToRollPassive', { 
    Values = ValuesUnitID,
    Default = "None",
    Multi = false,
    Text = 'Select Unit',

    Callback = function(value)
        selectedUnitToRollPassive = value:match(".* | .* | (.+)"):gsub("ID: %d+%s*", "")
        print(selectedUnitToRollPassive)
    end
})

Tab1:AddDropdown('dropdownSelectPassive', { 
    Values = ValuesPassive,
    Default = "None",
    Multi = true,
    Text = 'Select Passives',
    Callback = function(values)
        selectedPassivesToRoll = values
        print("Selected passives: ", table.concat(selectedPassivesToRoll, ", "))
    end
})

Tab1:AddToggle("ARP", {
    Text = "Auto Roll",
    Default = false,
    Callback = function(Value)
        getgenv().autoRollPassive = Value
        autoRollPassive()
    end,
})

Tab1:AddLabel('Go to machine select unit and\n')
Tab1:AddLabel('after this use auto reroll system!')

local Tab2 = TabBox:AddTab('Feed')

Tab2:AddDropdown('FeedUnit', {
    Values = ValuesUnitID,
    Default = "None",
    Multi = false,
    Text = 'Select Unit',

    Callback = function(value)
        selectedUnitToFeed = value:match(".* | .* | (.+)")
    end
})

Tab2:AddDropdown('dropdownSelectItemsToFeed', {
    Values = ValuesItems,
    Default = "None",
    Multi = false,
    Text = 'Select Item to Feed',
    Callback = function(Value)
        selectedItemToFeed = Value
    end
})

Tab2:AddToggle("AF", {
    Text = "Auto Feed",
    Default = false,
    Callback = function(Value)
        getgenv().autoFeed = Value
        autoFeed()
    end,
})

local Tabs = {
    Farm = Window:AddTab('Farm'),
}

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Auto Enter")

LeftGroupBox:AddDropdown('dropdownStoryMap', {
    Values = ValuesMaps,
    Default = "None",
    Multi = false,

    Text = 'Select Story Map',

    Callback = function(Value)
        selectedStoryMap = Value
    end
})

LeftGroupBox:AddDropdown('dropdownSelectDifficultyStory', {
    Values = {'Normal', "Nightmare"},
    Default = "None",
    Multi = false,

    Text = 'Select a Difficulty',

    Callback = function(Values)
        selectedDifficultyStory = Values
    end
})

LeftGroupBox:AddDropdown('dropdownSelectActStory', {
    Values = {1, 2, 3, 4, 5, 6},
    Default = "None",
    Multi = false,

    Text = 'Select Act',

    Callback = function(Value)
        selectedActStory = Value
    end
})

LeftGroupBox:AddDropdown('dropdownSelectGameType', {
    Values = {"Story", "Legend"},
    Default = "None",
    Multi = false,

    Text = 'Select Type',

    Callback = function(Value)
        selectedGameType = Value
    end
})

LeftGroupBox:AddToggle("OFE", {
	Text = "Only Friends",
	Default = false,
	Callback = function(Value)
		getgenv().friendsOnly = Value
	end,
})

LeftGroupBox:AddToggle("AJS", {
	Text = "Auto Join Story",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoin = Value
		autoJoin()
	end,
})

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Auto Event")


LeftGroupBox:AddDropdown('dropdownCardModifiers', { 
    Values = ValuesCards,
    Default = {},
    Multi = true,
    Text = 'Select Cards in order',
    Callback = function(selectedValues)
        selectedCardsChoose = {}
        for _, cards in pairs(selectedValues) do
            selectedCardsChoose[cards] = true
        end
    end
})

LeftGroupBox:AddToggle("AC", {
    Text = "Auto Card",
    Default = false,
    Callback = function(Value)
        getgenv().autochooseCard = Value
        if Value then
            autochooseCard()
        end
    end,
})

LeftGroupBox:AddLabel('W.I.P')

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Auto Challenge")

RightGroupbox:AddDropdown('dropdownStoryMap', {
    Values = ValuesMaps,
    Default = {},
    Multi = true,
    Text = 'Select Challenge Maps',
    Callback = function(selectedValues)
        selectedChallengeMaps = {}
        for _, map in pairs(selectedValues) do
            selectedChallengeMaps[map] = true
        end
    end
})

RightGroupbox:AddToggle("AJS", {
    Text = "Auto Join Challenge",
    Default = false,
    Callback = function(Value)
        getgenv().autoJoinChallenge = Value
        if Value then
            autoJoinChallenge()
        end
    end,
})

local Tabs = {
    Units = Window:AddTab('Other'),
}

local LeftGroupBox = Tabs.Units:AddLeftGroupbox("Units")

LeftGroupBox:AddDropdown('dropdownAutoPlaceWaypoint', {
    Values = ValuesWaypoints,
    Default = "None",
    Multi = false,
    Text = 'Select Waypoint to place units',
    Callback = function(Value)
        selectedWaypointToPlaceUnits = Value
    end
})

LeftGroupBox:AddInput('inputAutoUpgradeWaveX', {
    Default = '',
    Text = "Start Place at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveXToPlace = Value
    end
})

LeftGroupBox:AddToggle("APU", {
	Text = "Auto Place Unit",
	Default = false,
	Callback = function(Value)
		getgenv().placeUnits = Value
		placeUnits()
	end,
})

LeftGroupBox:AddToggle("AUU", {
	Text = "Only Place in Wave X",
	Default = false,
	Callback = function(Value)
		getgenv().onlyPlaceinwaveX = Value
	end,
})

LeftGroupBox:AddInput('inputAutoUpgradeWaveX', {
    Default = '',
    Text = "Start Upgrade at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveXToUpgrade = Value
    end
})

LeftGroupBox:AddToggle("AUU", {
	Text = "Auto Upgrade Unit",
	Default = false,
	Callback = function(Value)
		getgenv().upgradeUnit = Value
		upgradeUnit()
	end,
})

LeftGroupBox:AddToggle("AUU", {
	Text = "Only Upgrade in Wave X",
	Default = false,
	Callback = function(Value)
		getgenv().onlyupgradeinwaveX = Value
	end,
})

LeftGroupBox:AddInput('inputAutoSellWaveX', {
    Default = '',
    Text = "Start Sell at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveXToSell = Value
    end
})

LeftGroupBox:AddToggle("AUU", {
	Text = "Auto Sell Unit",
	Default = false,
	Callback = function(Value)
		getgenv().sellUnit = Value
		sellUnit()
	end,
})

LeftGroupBox:AddToggle("AUU", {
	Text = "Only Sell in Wave X",
	Default = false,
	Callback = function(Value)
		getgenv().onlysellinwaveX = Value
	end,
})

local RightGroupbox = Tabs.Units:AddRightGroupbox("Skills")

RightGroupbox:AddToggle("AUS", {
	Text = "Auto Universal Skill",
	Default = false,
	Callback = function(Value)
		getgenv().autoUniversalSkill = Value
        autoUniversalSkill()
	end,
})

RightGroupbox:AddInput('USAXW', {
    Default = '',
    Text = "Use skill after x wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveToStartAutoSkill = Value
    end
})

RightGroupbox:AddToggle("OUSIB", {
	Text = "Only use skills after X Wave",
	Default = false,
	Callback = function(Value)
		getgenv().onlyUseSkillInWaveX = Value
	end,
})

RightGroupbox:AddToggle("OUSIB", {
	Text = "Only use skills in boss",
	Default = false,
	Callback = function(Value)
		getgenv().onlyBoss = Value
	end,
})

local Tabs = {
    Shop = Window:AddTab('Shop'),
}

local LeftGroupBox = Tabs.Shop:AddLeftGroupbox("Summon")

LeftGroupBox:AddDropdown('dropdownSelectUnitToSummon', {
    Values = ValuesUnits,
    Default = "None",
    Multi = false,

    Text = 'Select Unit',

    Callback = function(Value)
        selectedUnitToSummon = Value
    end
})

LeftGroupBox:AddDropdown('dropdownSelectQuantityToSummon', {
    Values = {"1", "10"},
    Default = "None",
    Multi = false,

    Text = 'Select Quantity',

    Callback = function(Value)
        selectedQuantityToSummon = Value
    end
})

LeftGroupBox:AddToggle("ASM", {
	Text = "Auto Summon",
	Default = false,
	Callback = function(Value)
		getgenv().autoSummon = Value
        autoSummon()
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
    Text = 'Auto Execute UI After Teleport',
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