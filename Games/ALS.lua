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

function joinInfCastle()
    while getgenv().joinInfCastle == true do 
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
                wait(.2)
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetData")
                wait(.3)
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", 5, "True")
                wait()
                break
            else
                wait()
            end
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
    local overhead = game.Players.LocalPlayer.Character.Head.Overhead
    overhead:Destroy()
end

function deleteMap()
    local objetos = workspace.Map.Map:GetChildren()

    for _, objeto in ipairs(objetos) do
        if string.find(string.lower(objeto.Name), "model") or string.find(string.lower(objeto.Name), "building%d") then
            objeto:Destroy()
            wait()
        end
    end
end

function deleteNotErro()
    while getgenv().deleteNotErro == true do
        local erroNot = game:GetService("Players").LocalPlayer.PlayerGui.MessageUI.ErrorHolder
        if erroNot then
            erroNot:Destroy()
            break
        else
            wait(.5)
        end
        wait()
    end
end

local HttpService = game:GetService("HttpService")

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
            local mapName = workspace.Map.MapName.Value
            local mapDifficulty = workspace.Map.MapDifficulty.Value

            local result = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.Result.Text
            local resultOnly = string.sub(result, 7)

            if resultOnly == "Cleared!" then
                resultOnly = "Victory"
            else
                resultOnly = "Defeat"
            end

            local formattedResult = string.format("%s - Wave %s\n %s[%s] - %s", timeOnly, waveOnly, mapName, mapDifficulty, resultOnly)

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

            local payload = {
                content = pingContent,
                embeds = {
                    {
                        description = string.format("User: %s\nLevel: %s\n\nPlayer Stats:\n%s\n\n++++++++++++++\n\nRewards:\n%s\n++++++++++++++\nMatch Result:\n %s", formattedName, formattedLevel, playerStats, formattedAmount, formattedResult),
                        color = 7995647,
                        fields = {
                            {
                                name = "Discord",
                                value = "https://discord.gg/tvQqnYKF7j"
                            }
                        },
                        author = {
                            name = "Anime Last Stand"
                        },
                        image = {
                            url = "https://lh3.googleusercontent.com/chat_attachment/AP1Ws4sqkwvdiS1ntDZiWU29LbV0qpaERLtC3XIiJBrI5GMlm_UYjw_hul5vMUZnLyYQ75QoDdQKGPrJwsDKQqnoE1sD7xPhjIi0hyOHdLb6ItVq39L8Y8-IiEgvjBHVCT20pkY07yUoZxYsK2ZyPsU3aNU6824eZr_JvYwKED0fTUEFRzbsaY-0geqtAF21uDMZumkdYlWFYAI4NP_kmMQraOE932ry74SFzHknLLxTqnSoEo8eq6vkoek5dgNXOThoLAl6fpQiCJfJ9SdgZ0U7Blh-PlFEJXt8MthN06Uzvf2akgNT365deXl-HNBRMw8htGE=w512"
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

Library:Notify('Place the unit you will use in the first slot', 5)

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Farm")

LeftGroupBox:AddDropdown('MyDropdown', {
    Values = {'None', 'Method 1', 'Method 2',},
    Default = "None",
    Multi = false,

    Text = 'Method To Join in Inf Castle',

    Callback = function(Value)
        getgenv().joinMethod = Value
    end
})

LeftGroupBox:AddToggle("AIC", {
	Text = "Auto Inf Castle",
	Default = false,
	Callback = function(Value)
		getgenv().joinInfCastle = Value
		joinInfCastle()
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

LeftGroupBox:AddDropdown('MyDropdown', {
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

local RightGroupbox = Tabs.Main:AddRightGroupbox("Player")

RightGroupbox:AddToggle("HPI", {
	Text = "Hide Player Info",
	Default = false,
	Callback = function(Value)
		HPI()
	end,
})

RightGroupbox:AddToggle("DEN", {
	Text = "Delete Error Notifications", 
	Default = false,
	Callback = function(Value)
        getgenv().deleteNotErro = Value
		deleteNotErro()
	end,
})

RightGroupbox:AddToggle("FPSBoost", {
	Text = "FPS Boost",
	Default = false,
	Callback = function(Value)
		extremeFpsBoost()
	end,
})

RightGroupbox:AddToggle("DeleteMap", {
	Text = "Delete Map",
	Default = false,
	Callback = function(Value)
		deleteMap()
	end,
})

local RightGroupbox = Tabs.Main:AddRightGroupbox("Max Upgrade")

RightGroupbox:AddSlider('Slot1', {
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

RightGroupbox:AddSlider('Slot2', {
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

RightGroupbox:AddSlider('Slot3', {
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

RightGroupbox:AddSlider('Slot4', {
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

RightGroupbox:AddSlider('Slot5', {
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

RightGroupbox:AddSlider('Slot6', {
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

RightGroupbox:AddToggle("MaxUpgrade", {
	Text = "Max Upgrade",
	Default = false,
	Callback = function(Value)
		getgenv().maxupgradeUnit = Value
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

MenuGroup:AddButton('Unload', Unload)
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
