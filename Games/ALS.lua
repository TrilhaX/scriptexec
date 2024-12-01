warn('[TEMPEST HUB] Loading Ui')
wait()
local repo = 'https://raw.githubusercontent.com/TrilhaX/tempestHubUI/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
Library:Notify('Welcome to Tempest Hub', 5)

local Window = Library:CreateWindow({ 
    Title = 'Tempest Hub | Anime Last Stand',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Anime Last Stand Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait()
warn('[TEMPEST HUB] Loading Toggles')
wait()
warn('[TEMPEST HUB] Last Checking')
wait()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local speed = 1000
local selectedUnitRoll = nil
local selectedtech = nil
local slots = game:GetService("Players").LocalPlayer.Slots
local quirkInfoModule = require(game:GetService("ReplicatedStorage").Modules.QuirkInfo)

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

function joinInfCastle()
    while getgenv().joinInfCastle do
        repeat task.wait() until game:IsLoaded()
        wait(1)

        local function fireCastleRequests(room)
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local manager = replicatedStorage.Remotes.InfiniteCastleManager

            manager:FireServer("GetGlobalData")
            wait(0.1)
            manager:FireServer("GetData")
            wait(0.1)
            manager:FireServer("Play", tonumber(room), "True")
        end

        local function teleportToNPC(npcName)
            local npc = workspace.Lobby.Npcs:FindFirstChild(npcName)
            if npc then
                local teleportCFrame = GetCFrame(npc)
                local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
                tween:Play()
                tween.Completed:Wait()
            else
                warn("NPC " .. npcName .. " não encontrado!")
            end
        end

        if getgenv().autoRRSMethod then
            if getgenv().joinMethod == 'Method 1' then
                fireCastleRequests(5)
            elseif getgenv().joinMethod == "Method 2" then
                teleportToNPC("Asta")
                fireCastleRequests(5)
            end
        else
            if getgenv().joinMethod == 'Method 1' then
                fireCastleRequests(selectedRoomInfCastle)
            elseif getgenv().joinMethod == "Method 2" then
                teleportToNPC("Asta")
                fireCastleRequests(selectedRoomInfCastle)
            end
        end

        wait(1)
    end
end

function autoNext()
    local player = game.Players.LocalPlayer

    while getgenv().autoRetry do
        local uiEndGame = player:FindFirstChild("PlayerGui"):FindFirstChild("EndGameUI")

        if uiEndGame then
            wait(1)
            local button
            local playerGui = player:WaitForChild("PlayerGui")
            local endGameUI = playerGui:WaitForChild("EndGameUI")
            local bg = endGameUI:WaitForChild("BG")
            local buttons = bg:WaitForChild("Buttons")
            button = buttons:FindFirstChild("Next")

            if button then
                GuiService.SelectedObject = button
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                break
            else
                warn("Botão 'Next' não encontrado!")
            end
        else
            warn("UI EndGame não encontrada!")
        end

        wait(.5)
    end
end

function autoRetry()
    local player = game.Players.LocalPlayer
    while getgenv().autoRetry do
        local uiEndGame = player:FindFirstChild("PlayerGui"):FindFirstChild("EndGameUI")
        if uiEndGame then
            wait(1)
            local button = uiEndGame.BG.Buttons:FindFirstChild("Retry")
            if button then
                while getgenv().autoRetry do
                    GuiService.SelectedObject = button
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    wait(.5)
                end
            end
        end
        wait(.5)
    end
end

function autoLeave()
    while getgenv().autoLeave do
        local uiEndGame = game.Players.LocalPlayer.PlayerGui:FindFirstChild("EndGameUI")
        if uiEndGame then
            wait(1)
            game.ReplicatedStorage.Remotes.TeleportBack:FireServer()
            break
        end
        wait(.5)
    end
end

function placeUnits()
    while getgenv().placeUnits do
        local player = game.Players.LocalPlayer
        local waveGui = player:FindFirstChild("PlayerGui")
            and player.PlayerGui:FindFirstChild("MainUI")
            and player.PlayerGui.MainUI:FindFirstChild("Top")
            and player.PlayerGui.MainUI.Top:FindFirstChild("Wave")
        
        local waveValue = waveGui and waveGui.Value.Layered.Text or nil
        local beforeSlash = waveValue and string.match(waveValue, "^(.-)/") or waveValue
        
        if not waveValue then
            warn("Wave não encontrado!")
            wait(1)
        end

        if getgenv().onlyPlaceinwaveX and beforeSlash ~= tostring(selectedWaveXToPlace) then
            print("Aguardando wave específica:", selectedWaveXToPlace)
            wait(1)
        end

        local path = workspace:FindFirstChild("Map")
            and workspace.Map:FindFirstChild("Waypoints")
            and workspace.Map.Waypoints:FindFirstChild(tostring(selectedWaypointToPlaceUnits))

        if not path then
            warn("Path ou CornerStart não encontrado!")
            wait(1)
        end

        local basePosition = path.Position
        local radius = tonumber(selectedRadius) or 10
        local slots = player:FindFirstChild("Slots")

        if not slots then
            warn("Slots não encontrados!")
            wait(1)
        end

        local placeTower = game.ReplicatedStorage:FindFirstChild("Remotes")
            and game.ReplicatedStorage.Remotes:FindFirstChild("PlaceTower")
        
        if not placeTower then
            warn("Remote PlaceTower não encontrado!")
            wait(1)
        end

        for i = 1, selectedMaxSlot do
            local slot = slots:FindFirstChild("Slot" .. i)
            if slot and slot.Value then
                local angle = (i - 1) * (math.pi * 2 / selectedMaxSlot)
                local offsetX = math.cos(angle) * radius
                local offsetZ = math.sin(angle) * radius
                local newPosition = basePosition + Vector3.new(offsetX, 0, offsetZ)

                local towers = workspace:FindFirstChild("Towers")
                local unitExists = false
                if towers then
                    for _, child in ipairs(towers:GetChildren()) do
                        if child.Name == slot.Value then
                            unitExists = true
                            break
                        end
                    end
                end

                if not unitExists then
                    placeTower:FireServer(slot.Value, CFrame.new(newPosition))
                    wait(0.5)
                end
            end
        end
        wait(1)
    end
end

function sellUnit()
    while getgenv().sellUnit do
        local waveValue = game.Players.LocalPlayer.PlayerGui.MainUI.Top.Wave.Value.Layered.Text
        local beforeSlash = string.match(waveValue, "^(.-)/") or waveValue

        if getgenv().onlysellinwaveX and beforeSlash ~= selectedWaveXToSell then
            wait(1)
        end

        print("Vendendo unidades na wave", beforeSlash)
        wait(1)
    end
end

function upgradeUnit()
    while getgenv().upgradeUnit do
        local waveValue = game.Players.LocalPlayer.PlayerGui.MainUI.Top.Wave.Value.Layered.Text
        local beforeSlash = string.match(waveValue, "^(.-)/") or waveValue

        if getgenv().onlyupgradeinwaveX and beforeSlash ~= selectedWaveXToUpgrade then
            wait(1)
        end

        local towers = workspace:FindFirstChild("Towers")
        if towers then
            for _, unit in ipairs(towers:GetChildren()) do
                local upgradeLevel = unit:FindFirstChild("Upgrade") and unit.Upgrade.Value or 0
                local upgradeRemote = game.ReplicatedStorage.Remotes:FindFirstChild("Upgrade")
                if upgradeRemote then
                    while upgradeLevel < maxUpgradeLevel do
                        upgradeRemote:InvokeServer(unit)
                        wait(.5)
                        upgradeLevel = unit:FindFirstChild("Upgrade") and unit.Upgrade.Value or upgradeLevel
                    end
                end
            end
        end
        wait(1)
    end
end

function autoJoinRaid()
    while getgenv().autoJoinRaid == true do
        local raidFolder = workspace:FindFirstChild("TeleporterFolder")
        if raidFolder and raidFolder:FindFirstChild("Raids") then
            local door = raidFolder.Raids.Teleporter:FindFirstChild("Door")
            if door then
                local doorCFrame = GetCFrame(door)
                local tween = tweenModel(game.Players.LocalPlayer.Character, doorCFrame)
                tween:Play()
                tween.Completed:Wait()

                wait(1)
                local argsRaid = {
                    [1] = selectedRaidMap,
                    [2] = selectedFaseRaid,
                    [3] = "Nightmare",
                    [4] = false
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Raids"):WaitForChild("Select"):InvokeServer(unpack(argsRaid))

                wait(.5)
                local argsTeleporter = {
                    [1] = "Skip"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleporter"):WaitForChild("Interact"):FireServer(unpack(argsTeleporter))

                wait(10)
            else
                warn("Porta do raid não encontrada!")
                wait()
            end
        else
            warn("TeleporterFolder ou Raids não encontrado!")
            wait()
        end
    end
end

function autoGamespeed()
    while getgenv().autoGamespeed == true do
        local success, remotes = pcall(function()
            return game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        end)

        if success and remotes then
            local voteChange = remotes:FindFirstChild("VoteChangeTimeScale")
            if voteChange then
                voteChange:FireServer(true)
                break
            end
        else
            warn("Remotes not found!")
        end

        wait(1)
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
                obj.Color = Color3.new(.5, .5, .5)
                obj.Transparency = 0
                obj.CanCollide = true
            elseif obj:IsA("Mesh") or obj:IsA("SpecialMesh") or obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end

        for _, effect in pairs(game.Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then
                effect.Enabled = false
            end
        end
    end
end

function HPI()
    if getgenv().HPI == true then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Head") then
            local overhead = player.Character.Head:FindFirstChild("Overhead")
            if overhead then
                overhead:Destroy()
            end
        else
            warn("Player or Head not found!")
        end
    end
end

function deleteNotErro()
    while getgenv().deleteNotErro == true do
        local player = game.Players.LocalPlayer
        if player then
            local gui = player:FindFirstChild("PlayerGui")
            if gui then
                local erroNot = gui:FindFirstChild("MessageUI")
                if erroNot and erroNot:FindFirstChild("ErrorHolder") then
                    erroNot.ErrorHolder:Destroy()
                    break
                end
            end
        else
            warn("Player not found!")
        end
        wait(.5)
    end
end

function deleteMap()
    if getgenv().deleteMap == true then
        local map = workspace:FindFirstChild("Map")
        if map and map:FindFirstChild("Map") then
            for _, obj in ipairs(map.Map:GetChildren()) do
                if obj.Name:lower():find("model") or obj.Name:lower():find("building%d") then
                    obj:Destroy()
                end
            end
        else
            warn("Map or nested Map not found!")
        end
    end
end

function autoJoinChallenge()
    while getgenv().autoJoinChallenge == true do
        local Teleporter = workspace.TeleporterFolder.Challenge.Teleporter.ChallengeInfo
        local challenge = workspace.TeleporterFolder.Challenge.Teleporter.Door

        if challenge then
            local ignoreChallenge = false
            for _, ignore in ipairs(selectedIgnoreChallenge) do
                if Teleporter.Challenge.Value == ignore then
                    ignoreChallenge = true
                    break
                end
            end

            if not ignoreChallenge and Teleporter.MapName.Value == selectedChallengeMap and Teleporter.MapNum.Value == selectActChallenge then
                local challengeCFrame = GetCFrame(challenge)
                local tween = tweenModel(game.Players.LocalPlayer.Character, challengeCFrame)
                tween:Play()
                tween.Completed:Wait()
                break
            end
        end
        wait()
    end
end

function autoJoinStory()
    while getgenv().autoJoinStory == true do
        local Teleporter = workspace.TeleporterFolder.Story.Teleporter.StoryInfo
        local story = workspace.TeleporterFolder.Story.Teleporter.Door

        if story then
            local args = {
                [1] = selectedStoryMap,
                [2] = selectedActStory,
                [3] = selectedDifficultyStory,
                [4] = false
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Story"):WaitForChild("Select"):InvokeServer(unpack(args))
            
        else
            wait()
        end
    end
end

function autoJoinPortal()
    while getgenv().autoJoinPortal == true do
        print("W.I.P")
        wait()
    end
end

function autoGetBattlepass()
    while getgenv().autoGetBattlepass == true do
        wait(1)
        local args = {
            [1] = "All"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimBattlePass"):FireServer(unpack(args))
        wait(1)
    end
end   

function autoFeed()
    while getgenv().autoFeed == true do
        local args = {
            [1] = selectedUnitToFeed,
            [2] = {
                [selectedFeed] = 1
            }
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Feed"):FireServer(unpack(args))        
        wait()
    end
end

function autoUniversalSkill()
    while getgenv().autoUniversalSkill == true do
        if getgenv().onlyBoss == true then
            local bossHealth = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.BarHolder.Boss

            if bossHealth then
                local slots = game:GetService("Players").LocalPlayer.Slots

                for i, v in pairs(slots:GetChildren()) do
                    local success, tower = pcall(function()
                        return workspace:WaitForChild("Towers"):WaitForChild(tostring(v.Value), 5)
                    end)
                
                    if success and tower then
                        local args = { [1] = tower, [2] = 1 }
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetAbilityCd"):InvokeServer(unpack(args))
                        wait(.1)
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Ability"):InvokeServer(unpack(args))
                        wait(1)
                    else
                        wait()
                    end
                end
            else
                wait()
            end
        else
            local slots = game:GetService("Players").LocalPlayer.Slots

            for i, v in pairs(slots:GetChildren()) do
                local success, tower = pcall(function()
                    return workspace:WaitForChild("Towers"):WaitForChild(tostring(v.Value), 5)
                end)
            
                if success and tower then
                    local args = { [1] = tower, [2] = 1 }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetAbilityCd"):InvokeServer(unpack(args))
                    wait(.1)
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Ability"):InvokeServer(unpack(args))
                    wait(1)
                else
                    wait()
                end
            end
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
            local formattedName = "||" .. name .. "||"
            local elapsedTimeText = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.ElapsedTime.Text
            local timeOnly = string.sub(elapsedTimeText, 13)
            
            local Rerolls1 = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Rewards.Holder:FindFirstChild("Rerolls")
            local formattedAmount = "N/A"
            
            if Rerolls1 then
                local Amount = Rerolls1:FindFirstChild("Amount")
                if Amount and Amount.Text then
                    formattedAmount = Amount.Text
                end
            end

            local args = {
                [1] = game.Players.LocalPlayer,
            }
            
            local retorno = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData"):InvokeServer(unpack(args))
            
            local keys = {"Rerolls", "Jewels", "RaidTokens", "Gold", "Emeralds", "Halloween_Currency"}
            local playerStats = ""
            
            for _, key in ipairs(keys) do
                local value = retorno[key]
                if value ~= nil then
                    playerStats = playerStats .. key .. ": " .. tostring(value) .. "\n"
                else
                    playerStats = playerStats .. key .. ": nil (chave não encontrada)\n"
                end
            end

            local args = {
                [1] = game.Players.LocalPlayer,
            }
            
            local retorno = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData"):InvokeServer(unpack(args))
            
            local keys2 = {"Level", "EXP", "MaxEXP"}
            
            local levelValue, expValue, maxExpValue
            
            for _, key2 in ipairs(keys2) do
                local value = retorno[key2]
                
                if key2 == "Level" then
                    if value then
                        levelValue = string.match(value, "%d+")
                    else
                        levelValue = "N/A"
                    end
                elseif key2== "EXP" then
                    expValue = value or 0
                elseif key2 == "MaxEXP" then
                    maxExpValue = value or 0
                end
                
                if value ~= nil then
                    wait()
                else
                    wait()
                end
            end
            
            local formattedLevel = string.format("%s [%s/%s]", levelValue, expValue, maxExpValue)
            
            local pingContent = ""
            if getgenv().pingUser and getgenv().pingUserId then
                pingContent = "<@" .. getgenv().pingUserId .. ">"
            elseif getgenv().pingUser then
                pingContent = "@"
            end

            local Wave = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.EndWave.Text
            local elapsedTimeText = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.ElapsedTime.Text

            local timeParts = string.split(elapsedTimeText, ":")
            
            local totalSeconds = 0
            
            if #timeParts == 3 then
                local hours = tonumber(timeParts[1]) or 0
                local minutes = tonumber(timeParts[2]) or 0
                local seconds = tonumber(timeParts[3]) or 0
                totalSeconds = (hours * 3600) + (minutes * 60) + seconds
            elseif #timeParts == 2 then
                local minutes = tonumber(timeParts[1]) or 0
                local seconds = tonumber(timeParts[2]) or 0
                totalSeconds = (minutes * 60) + seconds
            elseif #timeParts == 1 then
                totalSeconds = tonumber(timeParts[1]) or 0
            end
            
            local hours = math.floor(totalSeconds / 3600)
            local minutes = math.floor((totalSeconds % 3600) / 60)
            local seconds = totalSeconds % 60
            
            local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)           
            
            local waveOnly = string.sub(Wave, 15)
            
            local teleportData = game:GetService("ReplicatedStorage").Remotes.GetTeleportData:InvokeServer()
            
            local mapName = teleportData.MapName or "Unknown Map"
            local mapDifficulty = teleportData.Difficulty or "Unknown Difficulty"
            local mapType = teleportData.Type or "Unknown Type"
            
            local result = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.Result.Text
            local resultOnly = string.sub(result, 7)
            
            if resultOnly == "cleared!" then
                resultOnly = "Victory"
            else
                resultOnly = "Defeat"
            end
            
            mapName = tostring(mapName)
            mapDifficulty = tostring(mapDifficulty)
            mapType = tostring(mapType)
            waveOnly = tostring(waveOnly)
            resultOnly = tostring(resultOnly)
            
            local formattedResult = string.format("%s - Wave %s\n %s - %s[%s] - %s", formattedTime, waveOnly, mapType, mapName, mapDifficulty, resultOnly)

            local formattedAmount = ""
            local item = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Rewards.Holder
            
            local blacklist = {UIGridLayout = true, UIPadding = true}
            
            for i, v in pairs(item:GetChildren()) do
                if not blacklist[v.ClassName] then
                    if v:FindFirstChild("ItemName") and v:FindFirstChild("Amount") then
                        local textOnly = v.ItemName.Text
                        local amountOnly = v.Amount.Text
                        formattedAmount = formattedAmount .. string.format("%s: %s\n", textOnly, amountOnly)
                    end
                end
            end

            local slots = game:GetService("Players").LocalPlayer.Slots

            local formattedUnit = ""

            for _, slot in ipairs(slots:GetChildren()) do
                if slot:FindFirstChild("Value") and slot.Value ~= "" then
                    if slot:FindFirstChild("Level") and slot.Level.Value ~= "" and slot.Level.Value ~= 1 then
                        formattedUnit = string.format("[%s] - %s", tostring(slot.Level.Value, slot.Value))
                    end
                end
            end                

            local payload = {
                content = pingContent,
                embeds = {
                    {
                        description = string.format("User: %s\nLevel: %s\n\nPlayer Stats:\n%s\n\n++++++++++++++\n\nRewards:\n%s\n++++++++++++++\nUnits:\n %s\n\nMatch Result:\n %s", formattedName, formattedLevel, playerStats, formattedAmount, formattedUnit, formattedResult),
                        color = 7995647,
                        fields = {
                            {
                                name = "Discord",
                                value = "https://discord.gg/ey83AwMvAn"
                            }
                        },
                        author = {
                            name = "Anime Last Stand"
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
        else
            wait()
        end

        wait(1)
    end
end

local blacklist = blacklist or {}

local module2 = require(game:GetService("ReplicatedStorage").Modules.ChallengeInfo)

local valuesChallenge = {}
local function challengeNamesByType(tbl, typeName)
    if type(tbl) == "table" then
        for key, value in pairs(tbl) do
            if type(value) == "table" then
                table.insert(valuesChallenge, key)
            end
        end
    end
    return valuesChallenge
end

local ValuesChallengeInfo = challengeNamesByType(module2, "challenge")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local portals = ReplicatedStorage:FindFirstChild("Portals")
local ValuesPortalMap = {}
local ValuesPortalTier = {}

if portals and portals:IsA("Folder") then
    for _, item in pairs(portals:GetChildren()) do
        if item:IsA("Instance") and item.Name ~= "PackageLink" and not item.Name:match("^Tier %d$") then
            table.insert(ValuesPortalMap, item.Name)
        end
    end

    for _, item2 in pairs(portals:GetChildren()) do
        if item2:IsA("Instance") and item2.Name:match("^Tier %d$") then
            table.insert(ValuesPortalTier, item2.Name)
        end
    end
end

local mapDataModule = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("MapData")
local ValuesMaps = {}
if mapDataModule and mapDataModule:IsA("ModuleScript") then
    local mapData = require(mapDataModule)
    if type(mapData) == "table" then
        for key, value in pairs(mapData) do
            if type(value) == "table" then
                table.insert(ValuesMaps, key)
            end
        end
    else
        warn("mapData is not a valid table!")
    end
else
    warn("MapData module is missing or invalid!")
end

local player = game:GetService("Players").LocalPlayer
local scroll = player.PlayerGui:FindFirstChild("Inventory") and player.PlayerGui.Inventory:FindFirstChild("BG") and player.PlayerGui.Inventory.BG:FindFirstChild("Scroll")
local ValuesUnitId = {}
if scroll then
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Instance") then
            local unitName = child:FindFirstChild("UnitName")
            local level = child:FindFirstChild("Level")
            if unitName and level and unitName:IsA("TextLabel") and level:IsA("TextLabel") then
                table.insert(ValuesUnitId, unitName.Text .. " | " .. level.Text .. " | " .. child.Name)
            end
        end
    end
else
    warn("Scroll GUI not found!")
end

local ValuesItemsToFeed = {}
local selection = player.PlayerGui:FindFirstChild("Feed") and player.PlayerGui.Feed:FindFirstChild("BG") and player.PlayerGui.Feed.BG:FindFirstChild("Content") and player.PlayerGui.Feed.BG.Content:FindFirstChild("Items") and player.PlayerGui.Feed.BG.Content.Items:FindFirstChild("Selection")
if selection then
    for _, child in ipairs(selection:GetChildren()) do
        if not (child:IsA("UIListLayout") or child:IsA("UIPadding") or child.Name == "Padding") then
            table.insert(ValuesItemsToFeed, child.Name)
        end
    end
else
    warn("Feed selection GUI not found!")
end

Library:Notify('Place the unit you will use in the first slot', 5)

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
	Text = "Delete Error Notifications", 
	Default = false,
	Callback = function(Value)
        getgenv().deleteNotErro = Value
		deleteNotErro()
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

LeftGroupBox:AddToggle("AIG", {
	Text = "Auto Increase Gamespeed",
	Default = false,
	Callback = function(Value)
		getgenv().autoGamespeed = Value
		autoGamespeed()
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

RightGroupbox:AddToggle("AGB", {
	Text = "Auto Get Battlepass",
	Default = false,
	Callback = function(Value)
		getgenv().autoGetBattlepass = Value
		autoGetBattlepass()
	end,
})

local MyButton2 = RightGroupbox:AddButton({
    Text = 'Reedem Codes',
    Func = function()
        local codes = {
            "Thegrammyisbacky",
            "ThrillerBark",
            "100RRLIMITEDTIMECODE",
            "Raffle",
            "Nomoredelay",
            "ThrillerNext",
            "BugsFixed",
            "BossStudio4Life",
            "500MVISITS!",
            "Spooky",
            "Dracula",
            "CLANWARS",
            "TheFixesAreHere",
            "Lagfixes",
            "SorryForBugs",
            "theGramALS",
            "Bleach2",
            "MakeYourClan",
            "PodcastyCodeBois",
            "NewGODLY",
            "2xPOINTS",
            "SorryForBugs2",
            "300KLIKES!",
            "JointheGram",
            "10KAGAIN??",
            "ZankaNoTachi",
            "TheOne",
            "ShinigamiVsQuincy",
            "QOLpart2Next",
            "TYBW",
            "NewBUNDLES",
            "BOBAKISBACK",
            "Goodluck",
            "Welcome",
            "FollowDalG",
            "10KFR!",
            "OverHeaven",
            "JOJOUpdate",
            "HeavenUpdateHYPE",
            "SLIME",
            "SecretCodeFR",
            "Event",
            "TensuraSlime",
            "UPDTIME",
            "BPReset"
        }        
        
        for _, code in ipairs(codes) do
            local args = {
                [1] = codes
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimCode"):InvokeServer(unpack(args))            
            wait()
        end               
    end,
    DoubleClick = false,
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

local TabBox = Tabs.Main:AddRightTabbox()

local Tab1 = TabBox:AddTab('Passive')

Tab1:AddLabel('W.I.P')

local Tab2 = TabBox:AddTab('Feed')

Tab2:AddDropdown('FeedUnit', {
    Values = ValuesUnitId,
    Default = "None",
    Multi = false,
    Text = 'Select Unit',

    Callback = function(value)
        selectedUnitToFeed = value:match(".* | .* | (.+)")
    end
})

Tab2:AddDropdown('dropdownSelectItemsToFeed', {
    Values = ValuesItemsToFeed,
    Default = "None",
    Multi = false,
    Text = 'Select Unit to Feed',
    Callback = function(Value)
        selectedFeed = Value
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

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Portal")

LeftGroupBox:AddLabel('W.I.P')

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Story")

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
    Values = {'Normal', "Nightmare", "Purgatory"},
    Default = "None",
    Multi = true,

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

LeftGroupBox:AddToggle("AJS", {
	Text = "Auto Join Story",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinStory = Value
		autoJoinStory()
	end,
})

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Raid")

RightGroupbox:AddDropdown('dropdownRaidMap', {
    Values = ValuesMaps,
    Default = "None",
    Multi = false,

    Text = 'Select Raid Map',

    Callback = function(Value)
        selectedRaidMap = Value
    end
})

RightGroupbox:AddDropdown('dropdownSelectFaseRaid', {
    Values = {1, 2, 3, 4, 5, 6},
    Default = "None",
    Multi = false,

    Text = 'Select Act Raid',

    Callback = function(Value)
        selectedFaseRaid = Value
    end
})

RightGroupbox:AddToggle("AJR", {
	Text = "Auto Join Raid",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinRaid = Value
		autoJoinRaid()
	end,
})

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Challenges")

RightGroupbox:AddDropdown('dropdownChallengeMap', {
    Values = ValuesMaps,
    Default = "None",
    Multi = false,

    Text = 'Select Challenge Map',

    Callback = function(Value)
        selectedChallengeMap = Value
    end
})

RightGroupbox:AddDropdown('dropdownSelectChallengeInfo', {
    Values = ValuesChallengeInfo,
    Default = {},
    Multi = true,

    Text = 'Ignore Difficulty',

    Callback = function(Values)
        selectedIgnoreChallenge = Values
    end
})

RightGroupbox:AddDropdown('dropdownSelectActChallenge', {
    Values = {1, 2, 3, 4, 5, 6},
    Default = "None",
    Multi = false,

    Text = 'Select Act',

    Callback = function(Value)
        selectActChallenge = Value
    end
})

RightGroupbox:AddToggle("AJC", {
	Text = "Auto Join Challenge",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinChallenge = Value
		autoJoinChallenge()
	end,
})

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Inf Castle")

RightGroupbox:AddDropdown('dropdownMethod', {
    Values = {'Method 1', 'Method 2',},
    Default = "None",
    Multi = false,

    Text = 'Method To Join in Inf Castle',

    Callback = function(Value)
        getgenv().joinMethod = Value
    end
})

RightGroupbox:AddInput('CICR', {
    Default = '',
    Text = "Choose Inf Castle Room",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedRoomInfCastle = Value
    end
})

RightGroupbox:AddToggle("AIC", {
	Text = "Auto Join Inf Castle",
	Default = false,
	Callback = function(Value)
		getgenv().joinInfCastle = Value
		joinInfCastle()
	end,
})

RightGroupbox:AddToggle("ARRSM", {
	Text = "Auto RRS Method",
	Default = false,
	Callback = function(Value)
		getgenv().autoRRSMethod = Value
	end,
})

local Tabs = {
    Units = Window:AddTab('Other'),
}

local LeftGroupBox = Tabs.Units:AddLeftGroupbox("Place & Upgrade")

LeftGroupBox:AddDropdown('dropdownAutoPlaceWaypoint', {
    Values = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25"},
    Default = "None",
    Multi = false,
    Text = 'Select Waypoint to place units',
    Callback = function(Value)
        selectedWaypointToPlaceUnits = Value
    end
})

LeftGroupBox:AddDropdown('dropdownSlot', {
    Values = {'1', '2', '3', '4', '5', '6'},
    Default = "None",
    Multi = false,

    Text = 'Select Max Slot To Put',

    Callback = function(Value)
        selectedMaxSlot = tonumber(Value)
    end
})

LeftGroupBox:AddInput('inputAutoPlaceWaveX', {
    Default = '',
    Text = "Start Place at x Wave",
    Numeric = true,
    Finished = true,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveXToPlace = Value
    end
})

LeftGroupBox:AddInput('inputRadiusToAutoPlaceUnit', {
    Default = '',
    Text = "Put Radius Of Auto Place",
    Numeric = true,
    Finished = true,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedRadius = Value
    end
})

LeftGroupBox:AddToggle("APUUPAJFK", {
    Text = "Auto Place Unit",
    Default = false,
    Callback = function(Value)
        getgenv().placeUnits = Value
        getgenv().placeUnits = true
        placeUnits()
    end,
})

LeftGroupBox:AddToggle("OPU", {
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
    Finished = true,
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

LeftGroupBox:AddToggle("OUU", {
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
    Finished = true,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveXToSell = Value
    end
})

LeftGroupBox:AddToggle("ASU", {
	Text = "Auto Sell Unit (W.I.P)",
	Default = false,
	Callback = function(Value)
		getgenv().sellUnit = Value
		sellUnit()
	end,
})

LeftGroupBox:AddToggle("OSU", {
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

RightGroupbox:AddToggle("OUSIB", {
	Text = "Only use skills in boss",
	Default = false,
	Callback = function(Value)
		getgenv().onlyBoss = Value
	end,
})

RightGroupbox:AddSlider('Slot1', {
    Text = 'Slot 1',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        selectedSlot1 = Value
    end
})

RightGroupbox:AddSlider('Slot2', {
    Text = 'Slot 2',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        selectedSlot2 = Value
    end
})

RightGroupbox:AddSlider('Slot3', {
    Text = 'Slot 3',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        selectedSlot3 = Value
    end
})

RightGroupbox:AddSlider('Slot4', {
    Text = 'Slot 4',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        selectedSlot4 = Value
    end
})

RightGroupbox:AddSlider('Slot5', {
    Text = 'Slot 5',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        selectedSlot5 = Value
    end
})

RightGroupbox:AddSlider('Slot6', {
    Text = 'Slot 6',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        selectedSlot6 = Value
    end
})

RightGroupbox:AddToggle("MaxUpgrade", {
	Text = "Max Upgrade",
	Default = false,
	Callback = function(Value)
		getgenv().maxupgradeUnit = Value
	end,
})

local Tabs = {
    Shop = Window:AddTab('Shop'),
}

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
