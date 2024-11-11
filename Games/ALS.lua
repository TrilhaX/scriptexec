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
            wait(.4)
            game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("GetData")
            wait(1)
            game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", 0, "True")
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
                game:GetService("ReplicatedStorage").Remotes.InfiniteCastleManager:FireServer("Play", 0, "True")
                wait()
                break
            else
                wait(.5)
            end
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
            break
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
                local UnitPlaced = workspace.Towers
                local unitExists = false
                for _, child in ipairs(UnitPlaced:GetChildren()) do
                    if child == unit.Value then
                        unitExists = true
                        break
                    end
                end

                if not unitExists then
                    wait(0.5)
                    local args = {
                        [1] = unit.Value,
                        [2] = CFrame.new(-164.9412384033203, 197.93942260742188, 15.210136413574219)
                    }
                    PlaceTower:FireServer(unpack(args))    
                    wait(0.5)
                else
                    break
                end
            end
        else
            wait(0.5)
        end
        wait()
    end
end

function upgradeUnit()
    while getgenv().upgradeUnit == true do
        local unit = game:GetService("Players")[game.Players.LocalPlayer.Name].Slots.Slot1
        local Remotes = game:GetService("ReplicatedStorage").Remotes
        if unit then
            local PlaceTower = Remotes.PlaceTower
            if PlaceTower then
                wait(.5)
                local args = {
                    [1] = workspace:WaitForChild("Towers"):WaitForChild(unit.Value)
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Upgrade"):InvokeServer(unpack(args))                
                wait(.5)
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

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local uiEndGame = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("EndGameUI")
        if uiEndGame then
            local result = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.Result.Text
            local name = game:GetService("Players").LocalPlayer.Name

            local formattedName = "||" .. name .. "||"

            local elapsedTimeText = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Stats.ElapsedTime.Text
            local timeOnly = string.sub(elapsedTimeText, 13) -- A partir do 13º caractere (ignora "Total Time: ")

            local Rerolls1 = game:GetService("Players").LocalPlayer.PlayerGui.EndGameUI.BG.Container.Rewards.Holder:FindFirstChild("Rerolls")
            local formattedAmount = "N/A"
            
            if Rerolls1 then
                local Amount = Rerolls1:FindFirstChild("Amount")
                if Amount and Amount.Text then
                    formattedAmount = Amount.Text
                end
            end

            local args = {
                [1] = game:GetService("Players"):WaitForChild("TempestGpo2"),
            }
            
            local retorno = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData"):InvokeServer(unpack(args))
            
            local rerollsValue = "N/A"
            
            if type(retorno) == "table" then
                local chaveDesejada = "Rerolls"
                if retorno[chaveDesejada] then
                    rerollsValue = retorno[chaveDesejada]
                end
            end            

            local pingContent = ""
            if getgenv().pingUser and getgenv().pingUserId then
                pingContent = "<@" .. getgenv().pingUserId .. ">"
            elseif getgenv().pingUser and not getgenv().pingUserId then
                pingContent = "@"
            else
                pingContent = ""
            end

            local payload = {
                content = pingContent,
                embeds = {
                    {
                        title = "Tempest Hub",
                        description = string.format("------------------------------------\nName: %s\nResult: %s\nElapsed Time: %s\nRewards: Rerolls %s\nRerolls: %s\n------------------------------------", formattedName, result, timeOnly, formattedAmount, rerollsValue),
                        color = 10098630,
                        author = {
                            name = "ALS INF CASTLE"
                        },
                    }
                }
            }

            local payloadJson = game:GetService("HttpService"):JSONEncode(payload)

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
            wait(.5)
        end

        wait(.5)
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

Library:SetWatermarkVisibility(true)

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
