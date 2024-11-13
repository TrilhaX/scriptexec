warn('[TEMPEST HUB] Loading Ui')
wait(1)
local repo = 'https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/'

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
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
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

    if #players:GetPlayers() >= 2 then
        local player1 = players:GetPlayers()[1]
        local targetPlaceId = 12886143095

        if game.PlaceId ~= targetPlaceId and not isPlaceIdIgnored(game.PlaceId) then
            game:GetService("TeleportService"):Teleport(targetPlaceId, player1)
        end
    end
end

function joinInfCastle()
    while getgenv().joinInfCastle == true do 
        if getgenv().autoRRSMethod == true then
            if getgenv().joinMethod == 'Method 1' then
                repeat task.wait() until game:IsLoaded()
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetGlobalData")
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetData")
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", 5, "True")
                wait()
                break
            elseif getgenv().joinMethod == "Method 2" then
                repeat task.wait() until game:IsLoaded()
                wait(1)
                local asta = workspace.Lobby.Npcs.Asta
                if asta then
                    local TeleportCFrame = GetCFrame(asta)
                    local tween = tweenModel(game.Players.LocalPlayer.Character, TeleportCFrame)
                    tween:Play()
                    tween.Completed:Wait()
                    game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetGlobalData")
                    wait(.1)
                    game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetData")
                    wait(.1)
                    game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", 5, "True")
                    wait()
                    break
                else
                    wait()
                end
            end
        else
            if getgenv().joinMethod == 'Method 1' then
                repeat task.wait() until game:IsLoaded()
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetGlobalData")
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetData")
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", selectedRoomInfCastle, "True")
                wait()
                break
            elseif getgenv().joinMethod == "Method 2" then
                repeat task.wait() until game:IsLoaded()
                wait(1)
                local asta = workspace.Lobby.Npcs.Asta
                if asta then
                    local TeleportCFrame = GetCFrame(asta)
                    local tween = tweenModel(game.Players.LocalPlayer.Character, TeleportCFrame)
                    tween:Play()
                    tween.Completed:Wait()
                    game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetGlobalData")
                    wait(.1)
                    game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetData")
                    wait(.1)
                    game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", selectedRoomInfCastle, "True")
                    wait()
                    break
                else
                    wait()
                end
            end
        end
        wait()
    end
end

function autoNext()
    while getgenv().autoRetry == true do
        local uiEndGame = player:FindFirstChild("PlayerGui"):FindFirstChild("EndGameUI")
        
        if uiEndGame then
            wait(1)
            local button
            local playerGui = player:WaitForChild("PlayerGui")
            local endGameUI = playerGui:WaitForChild("EndGameUI")
            local bg = endGameUI:WaitForChild("BG")
            local buttons = bg:WaitForChild("Buttons")
            button = buttons:WaitForChild("Next")
            GuiService.SelectedObject = button
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            break
        end
        wait()
    end
end

function autoRetry()
    local player = Players.LocalPlayer
    
    while getgenv().autoRetry == true do
        local uiEndGame = player:FindFirstChild("PlayerGui"):FindFirstChild("EndGameUI")
        
        if uiEndGame then
            wait(1)
            local button
            local playerGui = player:WaitForChild("PlayerGui")
            local endGameUI = playerGui:WaitForChild("EndGameUI")
            local bg = endGameUI:WaitForChild("BG")
            local buttons = bg:WaitForChild("Buttons")
            button = buttons:WaitForChild("Retry")
            
            while getgenv().autoRetry == true do
                GuiService.SelectedObject = button
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

                wait(0.3)
            end

            break
        end
        wait()
    end
end

function autoLeave()
    while getgenv().autoLeave == true do
        local uiEndGame = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("EndGameUI")
        if uiEndGame then
            wait(1)
            game:GetService("ReplicatedStorage").Remotes.TeleportBack:FireServer()
            break
        else
            wait(.5)
        end
        wait()
    end
end

function placeUnits()
    while getgenv().placeUnits == true do
        local player = game:GetService("Players").LocalPlayer
        local slots = player:FindFirstChild("Slots")
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local placeTower = remotes and remotes:FindFirstChild("PlaceTower")

        if not placeTower then
            warn("PlaceTower RemoteEvent não encontrado.")
            return
        end

        local function placeUnit(unit, position)
            local towers = workspace:FindFirstChild("Towers")
            if not towers then
                warn("Workspace 'Towers' não encontrado.")
                return
            end

            local unitExists = false
            for _, child in ipairs(towers:GetChildren()) do
                if child.Name == unit then
                    unitExists = true
                    break
                end
            end

            if not unitExists then
                wait(.1) 
                local args = { unit, position }
                placeTower:FireServer(unpack(args))
                wait(.5)
            else
                wait()
            end
        end

        local basePosition = CFrame.new(-164.9412384033203, 197.93942260742188, 15.210136413574219)

        while not selectedMaxSlot do
            wait(.1)
        end

        for i = 1, selectedMaxSlot do
            local slot = slots and slots:FindFirstChild("Slot" .. i)
            if slot and slot.Value then
                local newPosition = basePosition + Vector3.new(i * 2, 0, 0)
                placeUnit(slot.Value, newPosition)
            else
                wait()
            end
        end
        wait()
    end
end

function upgradeUnit()
    while getgenv().upgradeUnit == true do
        if getgenv().maxupgradeUnit then
            local UpgradeUnitAtual = workspace.Towers

            for i, v in pairs(UpgradeUnitAtual:GetChildren()) do
                local unitUpgradeLevel = v:FindFirstChild("Upgrade").Value
                local unitName = v.Name

                for slot = 1, 6 do
                    local sliderValue = _G["selectedSlot" .. slot]

                    while sliderValue == nil do
                        wait(.1)
                    end

                    if unitName == "Slot" .. slot and unitUpgradeLevel < sliderValue then
                        local Remotes = game:GetService("ReplicatedStorage").Remotes
                        local UpgradeRemote = Remotes:FindFirstChild("Upgrade")

                        if UpgradeRemote then
                            local args = { v }
                            
                            while unitUpgradeLevel < sliderValue do
                                UpgradeRemote:InvokeServer(unpack(args))
                                wait(.5)
                                unitUpgradeLevel = v.Upgrade.Value
                            end
                        end
                    end
                end
            end
        else
            while not selectedMaxSlot do
                wait(.1)
            end

            for slot = 1, selectedMaxSlot do
                local unit = game:GetService("Players")[game.Players.LocalPlayer.Name].Slots["Slot"..slot]
                local Remotes = game:GetService("ReplicatedStorage").Remotes
                if unit then
                    local PlaceTower = Remotes.PlaceTower
                    if PlaceTower then
                        local args = {
                            [1] = workspace:WaitForChild("Towers"):WaitForChild(unit.Value)
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Upgrade"):InvokeServer(unpack(args))                    
                        wait(.5)
                    end
                else
                    wait()
                end
            end
        end
        wait()
    end
end

function autoJoinRaid()
    while getgenv().autoJoinRaid == true do
        local door = workspace.TeleporterFolder.Raids.Teleporter.Door
        if door then
            local doorCFrame = GetCFrame(door)
            local tween = tweenModel(game.Players.LocalPlayer.Character, doorCFrame)
            tween:Play()
            tween.Completed:Wait()
            wait(.5)
            local args = {
                [1] = selectedRaidMap,
                [2] = selectedFaseRaid,
                [3] = "Nightmare",
                [4] = false
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Raids"):WaitForChild("Select"):InvokeServer(unpack(args))
            wait(.5)
            local args = {
                [1] = "Skip"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleporter"):WaitForChild("Interact"):FireServer(unpack(args))
            wait(10)
        else
            wait()
        end
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

function extremeFpsBoost()
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
end

function HPI()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Head") then
        local overhead = player.Character.Head:FindFirstChild("Overhead")
        if overhead then
            overhead:Destroy()
        end
    end
end

function deleteNotErro()
    while getgenv().deleteNotErro == true do
        local player = game:GetService("Players").LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
            local erroNot = player.PlayerGui:FindFirstChild("MessageUI")
            if erroNot and erroNot:FindFirstChild("ErrorHolder") then
                erroNot.ErrorHolder:Destroy()
                break
            end
        end
        wait(0.5)
    end
end

function deleteMap()
    local map = workspace:FindFirstChild("Map")
    if map and map:FindFirstChild("Map") then
        local objetos = map.Map:GetChildren()
        for _, objeto in ipairs(objetos) do
            if string.find(string.lower(objeto.Name), "model") or string.find(string.lower(objeto.Name), "building%d") then
                objeto:Destroy()
                wait()
            end
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
        Library:Notify("W.I.P", 5)
        break
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

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local uiEndGame = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("EndGameUI")
        
        if uiEndGame then
            local result = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.Result.Text
            local name = game:GetService("Players").LocalPlayer.Name
            local formattedName = "||" .. name .. "||"
            local elapsedTimeText = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.ElapsedTime.Text
            local timeOnly = string.sub(elapsedTimeText, 13) -- After "Total Time: "
            
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

            local timeOnly = string.sub(elapsedTimeText, 13)
            local waveOnly = string.sub(Wave, 15)

            local teleportData = game:GetService("ReplicatedStorage").Remotes.GetTeleportData:InvokeServer()

            if teleportData.MapName then
                teleportData.MapName = mapName
            end

            if teleportData.Difficulty then
                teleportData.Difficulty = mapDifficulty
            end

            if teleportData.Type then
                teleportData.Type = mapType
            end


            local result = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.Result.Text
            local resultOnly = string.sub(result, 7)

            if resultOnly == "cleared!" then
                resultOnly = "Victory"
            else
                resultOnly = "Defeat"
            end

            local formattedResult = string.format("%s - Wave %s\n %s - %s[%s] = %s", timeOnly, waveOnly, mapType, mapName, mapDifficulty, resultOnly)

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

            local unitsID = game:GetService("Players").LocalPlayer.PlayerGui.Inventory.BG.Scroll

            for i, v in pairs(unitsID:GetChildren()) do
                if not blacklist[v.ClassName] then
                    local unit = v:GetAttribute("Unit")
                    local level = v:GetAttribute("Level")

                    if unitID then
                        local formattedUnits = string.format("[%s] - %s", level, unit)
                    end
                end
            end

            local payload = {
                content = pingContent,
                embeds = {
                    {
                        description = string.format("User: %s\nLevel: %s\n\nPlayer Stats:\n%s\n\n++++++++++++++\n\nRewards:\n%s\n++++++++++++++\nUnits:\n %s\nMatch Result:\n %s", formattedName, formattedLevel, playerStats, formattedAmount, formattedUnits, formattedResult),
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
                        image = {
                            url = "https://chat.google.com/u/4/api/get_attachment_url?url_type=FIFE_URL&content_type=image%2Fwebp&attachment_token=AOo0EEV8DVZ%2FbiHfWTX8ivM5jrUXQG0FVL3BEElW%2F%2BCwyFI%2BISbjPni7bSCtp8q%2FGoH4y87sv474SE4VqXomfqOED4j57GOdCvDvEJr4N7aOXXg9kRsKApiVI%2BaS3pd7ay%2BjTHhAKSPXFJWAeAw5Txd4Kb2rk1WGdcTekGbxPo5KIf1swO04EK5jsaw0WY8p15Vara6DFDUgPxokws8HgxkKkRzWB6Z6pKc%2FlrQwU8Jqw7qodrjI20hg3mxPRJtOuEsjCuCUlJCV%2F4UwyTVRiTJKJe7d2hEX%2FF72HSmUAkFZ5mJ7c6hzVj2EF7L7%2B6%2BVt%2BsYxEl6KWMZUgLVb3shm849QBxPmBiSdcuyMbW%2BqezGqaUZpUM9fu7eOdxGN%2FDM5y50Hf6dypW6tGo%2FC80cK%2F%2FklVbnCmyeB09%2BV8SpLNxrNgxIWgkofoTWMaIZ%2B%2BZGJL2DiN80YCcouq%2Fu%2F7O42jkrW%2BevcSwRYWYd78i6bwkux1%2Fvcx4GR%2B4lTD4Mn%2FlGATOAN%2FAlfYBZPDcAs8Uwy5JYyOWjkEivFuQyB1KuFB4aZ2U6mVjhuH%2Bh0%2B5tfv7HHrOuqRTU4CIOyBhZ3RXlbyx1IrMCEqt%2BhOitRAseL81tcWaJOjPmv3TXY%2BGvaQu2z%2BjLjApgRqCRKqJYz7z6MmNoDHs0ryd2rujviS2IWYLukMUzhF4Wplt5ZngifHU1q0bk3axI5UYfUU4yI8EQRCpFjOJ6MDrAPnfg0oLyAn16lgwYjGuYo7vNC%2BZzL%2BB%2BbcDABr5Jjx2xcaWNHw8ZGDqML3Qm5e1Dhb3nr5k7RHZwZCidcQ%3D%3D&sz=w512&authuser=4"
                        },
                        thumbnail = {
                            url = "https://tr.rbxcdn.com/180DAY-0c006580562aa816037e176633b7235c/256/256/Image/Webp/noFilter"
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

        wait()
    end
end

local module2 = require(game:GetService("ReplicatedStorage").Modules.ChallengeInfo)

local function challengeNamesByType(tbl, typeName)
    local valuesChallenge = {}
    
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
local portals = ReplicatedStorage:WaitForChild("Portals")
local ValuesPortalMap = {}
local ValuesPortalTier = {}

if portals and portals:IsA("Folder") then
    for _, item in pairs(portals:GetChildren()) do
        if item.Name ~= "PackageLink" and not item.Name:match("^Tier %d$") then
            table.insert(ValuesPortalMap, item.Name)
        end
    end

    for _, item2 in pairs(portals:GetChildren()) do
        if item2.Name:match("^Tier %d$") then
            table.insert(ValuesPortalTier, item2.Name)
        end
    end
end

local raidMaps = game:GetService("Players").LocalPlayer.PlayerGui.Raids.BG.Content.Left.Maps
local blacklist = {UIGridLayout = true, UIListLayout = true, UIPadding = true, Padding = true}
local ValuesRaidMap = {}

if raidMaps then
    for i, v in pairs(raidMaps:GetChildren()) do
        if not blacklist[v.ClassName] and not blacklist[v.Name] and not v:FindFirstChildOfClass("UIPadding") then
            table.insert(ValuesRaidMap, v.Name)
        end
    end
end

local storyMaps = game:GetService("Players").LocalPlayer.PlayerGui.Story.BG.Content.Left.Maps
local ValuesStoryMap = {}

if storyMaps then
    for i, v in pairs(storyMaps:GetChildren()) do
        if not blacklist[v.ClassName] and not blacklist[v.Name] and not v:FindFirstChildOfClass("UIPadding") then
            table.insert(ValuesStoryMap, v.Name)
        end
    end
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
		extremeFpsBoost()
	end,
})

LeftGroupBox:AddToggle("DeleteMap", {
	Text = "Delete Map",
	Default = false,
	Callback = function(Value)
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

local Tabs = {
    Farm = Window:AddTab('Farm'),
}

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Portal")

LeftGroupBox:AddDropdown('dropdownStoryMap', {
    Values = ValuesPortalMap,
    Default = "None",
    Multi = false,

    Text = 'Select Portal',

    Callback = function(Value)
        selectedPortalMap = Value
    end
})

LeftGroupBox:AddDropdown('dropdownSelectDifficultyStory', {
    Values = ValuesPortalTier,
    Default = "None",
    Multi = true,

    Text = 'Select Tier',

    Callback = function(Values)
        selectedTierPortal = Values
    end
})

LeftGroupBox:AddDropdown('dropdownSelectMapPortal', {
    Values = {"W.I.P"},
    Default = "None",
    Multi = false,

    Text = 'Ignore map',

    Callback = function(Value)
        selectedIgnoreMapPortal = Value
    end
})

LeftGroupBox:AddToggle("AJS", {
	Text = "Auto Join Story",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinPortal = Value
		autoJoinPortal()
	end,
})

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Story")

LeftGroupBox:AddDropdown('dropdownStoryMap', {
    Values = ValuesStoryMap,
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
    Values = {'1', '2', '3', '4', '5', '6'},
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
    Values = ValuesRaidMap,
    Default = "None",
    Multi = false,

    Text = 'Select Raid Map',

    Callback = function(Value)
        selectedRaidMap = Value
    end
})

RightGroupbox:AddDropdown('dropdownSelectFaseRaid', {
    Values = {'1', '2', '3', '4', '5', '6'},
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
    Values = ValuesStoryMap,
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
    Values = {'1', '2', '3', '4', '5', '6'},
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
    Numeric = false,
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
    Units = Window:AddTab('Units'),
}

local LeftGroupBox = Tabs.Units:AddLeftGroupbox("Place & Upgrade")

LeftGroupBox:AddDropdown('dropdownSlot', {
    Values = {'1', '2', '3', '4', '5', '6'},
    Default = "None",
    Multi = false,

    Text = 'Select Max Slot To Put',

    Callback = function(Value)
        selectedMaxSlot = tonumber(Value)
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
	Text = "Auto Upgrade Unit",
	Default = false,
	Callback = function(Value)
		getgenv().upgradeUnit = Value
		upgradeUnit()
	end,
})

LeftGroupBox:AddSlider('Slot1', {
    Text = 'Slot 1',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        selectedSlot1 = Value
    end
})

LeftGroupBox:AddSlider('Slot2', {
    Text = 'Slot 2',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        selectedSlot2 = Value
    end
})

LeftGroupBox:AddSlider('Slot3', {
    Text = 'Slot 3',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        selectedSlot3 = Value
    end
})

LeftGroupBox:AddSlider('Slot4', {
    Text = 'Slot 4',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        selectedSlot4 = Value
    end
})

LeftGroupBox:AddSlider('Slot5', {
    Text = 'Slot 5',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        selectedSlot5 = Value
    end
})

LeftGroupBox:AddSlider('Slot6', {
    Text = 'Slot 6',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        selectedSlot6 = Value
    end
})

LeftGroupBox:AddToggle("MaxUpgrade", {
	Text = "Max Upgrade",
	Default = false,
	Callback = function(Value)
		getgenv().maxupgradeUnit = Value
	end,
})

local RightGroupbox = Tabs.Units:AddRightGroupbox("Skills")

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