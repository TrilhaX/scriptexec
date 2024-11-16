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

function autoJoinStory()
    while getgenv().autoJoinStory == true do
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
                    ["GameType"] = "Story"
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

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local endGameUI = game:GetService("Players").LocalPlayer.PlayerGui.Main.Victory.Page.InfoDisplay.List.Options
        if endGameUI then

        
            local name = game:GetService("Players").LocalPlayer.Name
            local formattedName = "||" .. name .. "||"

            local payload = {
                content = pingContent,
                embeds = {
                    {
                        description = string.format("User: %s", formattedName),
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
                            url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png?ex=6739154c&is=6737c3cc&hm=7fba054f0cf178525c659c9b8ea22381f9dd38a84664e61a8e80cc1a2cd53d90&"
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
            wait(.3)
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

LeftGroupBox:AddLabel('W.I.P')

local RightGroupbox = Tabs.Main:AddRightGroupbox("Others")

RightGroupbox:AddToggle("AL", {
	Text = "Auto Leave",
	Default = false,
	Callback = function(Value)
		getgenv().autoRetry = Value
		autoRetry()
	end,
})

RightGroupbox:AddLabel('W.I.P')

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

local MyButton2 = RightGroupbox:AddButton({
    Text = 'Reedem Codes',
    Func = function()
        local codes = {
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
                [1] = codes
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimCode"):InvokeServer(unpack(args))            
            wait()
        end               
    end,
    DoubleClick = false,
})

local Tabs = {
    Farm = Window:AddTab('Farm'),
}

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

LeftGroupBox:AddToggle("OFE", {
	Text = "Only Friends enable",
	Default = false,
	Callback = function(Value)
		getgenv().friendsOnly = Value
	end,
})

LeftGroupBox:AddToggle("AJS", {
	Text = "Auto Join Story",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinStory = Value
		autoJoinStory()
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

    Text = 'Select Act',

    Callback = function(Value)
        selectedUnitToSummon = Value
    end
})

LeftGroupBox:AddDropdown('dropdownSelectQuantityToSummon', {
    Values = {"1", "10"},
    Default = "None",
    Multi = false,

    Text = 'Select quantity',

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