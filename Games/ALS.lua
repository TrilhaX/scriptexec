--Checking if game is loaded
repeat task.wait() until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()

--Starting Script
local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled
local pcSize = UDim2.fromOffset(868, 650)
local mobileSize = UDim2.fromOffset(800, 550)
local currentSize = isMobile and mobileSize or pcSize

local Window = MacLib:Window({
    Title = "Tempest Hub",
    Subtitle = "Anime Last Stand",
    Size = currentSize,
    DragStyle = 1,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
})

function changeUISize(scale)
    if Window then
        if scale < 0.1 then
            scale = 0.1
        elseif scale > 1.5 then
            scale = 1.5
        end

        local newWidth = pcSize.X.Offset * scale
        local newHeight = pcSize.Y.Offset * scale

        Window:SetSize(UDim2.fromOffset(newWidth, newHeight))
        Window:Notify({
            Title = "UI Resized",
            Description = "New size scale: " .. scale,
            Lifetime = 3
        })
    end
end

function findGuiRecursive(parent, targetName)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == targetName then
            return child
        end
        local found = findGuiRecursive(child, targetName)
        if found then
            return found
        end
    end
    return nil
end

function hideUI()
    local UICorner1 = Instance.new("UICorner")
    local backgroundFrame = Instance.new("Frame")
    local tempestButton = Instance.new("TextButton")
    local UIPadding = Instance.new("UIPadding")

    local coreGui = game:GetService("CoreGui")
    local maclibGui = findGuiRecursive(coreGui, "MaclibGui")

    if not maclibGui then
        warn("MaclibGui not found in CoreGui.")
        return
    end

    backgroundFrame.Name = "backgroundFrame"
    backgroundFrame.Parent = maclibGui
    backgroundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    backgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backgroundFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Position = UDim2.new(0.98, 0, 0.5, 0)
    backgroundFrame.Size = UDim2.new(0, 100, 0, 100)

    UICorner1.Parent = backgroundFrame

    tempestButton.Name = "tempestButton"
    tempestButton.Parent = backgroundFrame
    tempestButton.AnchorPoint = Vector2.new(0.5, 0.5)
    tempestButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tempestButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tempestButton.BorderSizePixel = 0
    tempestButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    tempestButton.Size = UDim2.new(1, 0, 1, 0)
    tempestButton.Font = Enum.Font.PermanentMarker
    tempestButton.Text = "Tempest Hub"
    tempestButton.TextColor3 = Color3.fromRGB(75, 0, 130)
    tempestButton.TextScaled = true
    tempestButton.TextSize = 14.000
    tempestButton.TextWrapped = true

    UIPadding.Parent = backgroundFrame
    UIPadding.PaddingTop = UDim.new(0.1, 0)
    UIPadding.PaddingLeft = UDim.new(0.1, 0)
    UIPadding.PaddingRight = UDim.new(0.1, 0)
    UIPadding.PaddingBottom = UDim.new(0.1, 0)

    tempestButton.Activated:Connect(function()
        local maclib = maclibGui
        if maclib then
            maclib.Base.Visible = not maclib.Base.Visible
            maclib.Notifications.Visible = not maclib.Notifications.Visible
        else
            warn("MaclibGui not found in CoreGui.")
        end
    end)
end

local globalSettings = {
	UIBlurToggle = Window:GlobalSetting({
		Name = "UI Blur",
		Default = Window:GetAcrylicBlurState(),
		Callback = function(bool)
			Window:SetAcrylicBlurState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
				Lifetime = 5
			})
		end,
	}),
	NotificationToggler = Window:GlobalSetting({
		Name = "Notifications",
		Default = Window:GetNotificationsState(),
		Callback = function(bool)
			Window:SetNotificationsState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " Notifications",
				Lifetime = 5
			})
		end,
	}),
	ShowUserInfo = Window:GlobalSetting({
		Name = "Show User Info",
		Default = Window:GetUserInfoState(),
		Callback = function(bool)
			Window:SetUserInfoState(false)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Showing" or "Redacted") .. " User Info",
				Lifetime = 5
			})
		end,
	})
}
warn("[TEMPEST HUB] Loading Function")
wait()
warn("[TEMPEST HUB] Loading Toggles")
wait()
warn("[TEMPEST HUB] Last Checking")
wait()

--Locals
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

--General Functions

function safeWaitForChild(parent, childName, timeout)
    local child = parent:FindFirstChild(childName)
    local elapsedTime = 0
    while not child and elapsedTime < timeout do
        wait(0.1)
        elapsedTime = elapsedTime + 0.1
        child = parent:FindFirstChild(childName)
    end
    return child
end

function hideUIExec()
	while getgenv().hideUIExecGG do
        if getgenv().loadedallscript == true then
            local coreGui = game:GetService("CoreGui").RobloxGui
            local Base = nil
            
            if coreGui:FindFirstChild("MaclibGui") then
                Base = coreGui.MaclibGui:FindFirstChild("Base")
            end            
            
            if Base then
                Base.Visible = false
            else
                warn("Base não encontrado.")
            end	
        end	
        wait()
	end
end

function aeuat()
	while getgenv().aeuatGG == true do
        if getgenv().loadedallscript == true then
            local teleportQueued = false
            game.Players.LocalPlayer.OnTeleport:Connect(function(State)
                if
                    (State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress) and not teleportQueued
                then
                    teleportQueued = true

                    queue_on_teleport([[         
                        repeat task.wait() until game:IsLoaded()
                        if getgenv().executed then return end    
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/TempestHubMain/main/Main"))()
                    ]])

                    getgenv().executed = true
                    wait(1)
                    teleportQueued = false
                end
            end)
        end
		wait()
	end
end

function firebutton(Button, method)
    if not Button then
        warn("firebutton: Botão inválido ou não encontrado.")
        return
    end

    local a = Button
    if getconnections and method == "getconnections" then
        if Button.Activated then
            for i, v in pairs(getconnections(Button.Activated)) do
                wait()
                v.Function()
            end
        else
            warn("firebutton: O botão não tem um evento 'Activated'.")
        end
    elseif firesignal and method == "firesignal" then
        local events = { 'MouseButton1Click', 'MouseButton1Down', 'Activated' }
        for _, v in pairs(events) do
            if Button[v] then
                firesignal(Button[v])
            end
        end
    elseif VirtualInputManager and method == "VirtualInputManager" then
        game:GetService("GuiService").SelectedObject = Button
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        game:GetService("GuiService").SelectedObject = nil
    else
        print("Unsupported method")
    end
end

function removeTexturesAndHeavyObjects(object)
	for _, child in ipairs(object:GetDescendants()) do
		if child:IsA("Texture") or child:IsA("Decal") then
			child:Destroy()
		elseif child:IsA("MeshPart") then
			child:Destroy()
		elseif child:IsA("ParticleEmitter") or child:IsA("Trail") then
			child:Destroy()
		elseif child:IsA("Model") or child:IsA("Folder") then
			removeTexturesAndHeavyObjects(child)
		end
	end
end

function fpsBoost()
	while getgenv().fpsBoostGG == true do
		if getgenv().loadedallscript == true then
			removeTexturesAndHeavyObjects(workspace)
		end
        break
	end
end

function betterFpsBoost()
	while getgenv().betterFpsBoostGG == true do
		if getgenv().loadedallscript == true then
			removeTexturesAndHeavyObjects(workspace)
			local enemiesAndUnits = workspace:FindFirstChild("_UNITS")

			if enemiesAndUnits then
				for i,v in pairs(enemiesAndUnits:GetChildren())do
					v:Destroy()
				end
			end
		end
        break
	end
end

function extremeFpsBoost()
    while getgenv().extremeFpsBoostGG == true do
		if getgenv().loadedallscript == true then
			removeTexturesAndHeavyObjects(workspace)
			local enemiesAndUnits = workspace:FindFirstChild("_UNITS")

			if enemiesAndUnits then
				for i,v in pairs(enemiesAndUnits:GetChildren())do
					v:Destroy()
				end
			end
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
        break
    end
end

function autoWalk()
	while getgenv().autoWalkGG == true do
		if getgenv().loadedallscript == true then
			game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
			wait(1)
			game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.S, false, game)
			wait(1)
		end
		wait()
	end
end

function tweenModel(model, targetCFrame)
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

function GetCFrame(obj, height, angle)
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

function blackScreen()
	local screenGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("BlackScreenTempestHub")
	if screenGui then
        screenGui.Enabled = not screenGui.Enabled
    end
end

function createBC()
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    if playerGui:FindFirstChild("BlackScreenTempestHub") then
        return
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlackScreenTempestHub"
    screenGui.Parent = playerGui
    screenGui.Enabled = false

    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Parent = screenGui
    backgroundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    backgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    backgroundFrame.Size = UDim2.new(1, 0, 2, 0)

    local statFrame = Instance.new("Frame")
    statFrame.Name = "statFrame"
    statFrame.Parent = backgroundFrame
    statFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    statFrame.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
    statFrame.BorderSizePixel = 0
    statFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    statFrame.Size = UDim2.new(0, 850, 0, 550)

    local border = Instance.new("UICorner")
    border.Parent = statFrame

    local function createLabel(name, positionY)
        local label = Instance.new("TextLabel")
        label.Name = name
        label.Parent = statFrame
        label.AnchorPoint = Vector2.new(0.5, 0.5)
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0.5, 0, positionY, 0)
        label.Size = UDim2.new(0, 850, 0, 60)
        label.Font = Enum.Font.SourceSans
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextScaled = true
        label.TextWrapped = true
        return label
    end

    local nameLabel = createLabel("nameLabel", 0.1)
    nameLabel.Text = "Tempest Hub"

    local levelLabel = createLabel("levelLabel", 0.25)

    local gemsLabel = createLabel("gemsLabel", 0.4)
    gemsLabel.AnchorPoint = Vector2.new(0.5, 0)
    gemsLabel.Position = UDim2.new(0.5, 0, 0.31, 0)
    gemsLabel.Size = UDim2.new(1, 0, 0, 380)

    local function updateStats()
        local player = game.Players.LocalPlayer
        local level = player:FindFirstChild("Level")
        local jewels = player:FindFirstChild("Jewels")
        local emeralds = player:FindFirstChild("Emeralds")
        local gold = player:FindFirstChild("Gold")
        local expAtual = player:FindFirstChild("EXP")
        local maxExp = player:FindFirstChild("MaxEXP")
        local rerolls = player:FindFirstChild("Rerolls")

        if level and jewels and emeralds and gold and expAtual and maxExp and rerolls then
            local playerLevel = "Level: " .. tostring(level.Value) .. " [" .. tostring(expAtual.Value) .. "/" .. tostring(maxExp.Value) .. "]"
            local currencyInfo = "Jewels: " .. tostring(jewels.Value) .. "\n" ..
                                 "Emeralds: " .. tostring(emeralds.Value) .. "\n" ..
                                 "Gold: " .. tostring(gold.Value) .. "\n" ..
                                 "Rerolls: " .. tostring(rerolls.Value)

            levelLabel.Text = playerLevel
            gemsLabel.Text = currencyInfo
        end
    end

    game:GetService("RunService").RenderStepped:Connect(updateStats)
end

function deleteNotErro()
    while getgenv().deleteNotErroGG == true do
        if getgenv().loadedallscript == true then
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
        end
        wait(1)
    end
end

function HidePlayer()
    while getgenv().HidePlayerGG == true do
        if getgenv().loadedallscript == true then
            local player = game.Players.LocalPlayer
            local character = player.Character
            local playerGui = player.PlayerGui
            local overhead = character and character:FindFirstChild("Head") and character.Head:FindFirstChild("Overhead")
            
            if overhead then
                overhead:Destroy()
            end
            for _, obj in ipairs(character:GetChildren()) do
				if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") then
					obj:Destroy()
				end
			end
        end
        wait(1)
    end
end

function webhook()
    while getgenv().webhookGG == true do
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

--Function in Game

function autoStart()
    while getgenv().autoStartGG == true do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlayerReady"):FireServer()
        wait()
    end
end

function autoSkipWave()
    while getgenv().autoSkipWaveGG == true do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("VoteSkip"):FireServer()
        wait()
    end
end

function autoRetry()
    while getgenv().autoRetryGG == true do
        if getgenv().loadedallscript == true then
            local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
            if prompt then
                local button2 = prompt.TextButton.TextButton
                if button2 then
                    firebutton(button2, "getconnections")
                end
            end
            local uiEndGame = player:FindFirstChild("PlayerGui"):FindFirstChild("EndGameUI")
            if uiEndGame then
                local button = uiEndGame.BG.Buttons:FindFirstChild("Retry")
                if button then
                    firebutton(button, "VirtualInputManager")
                end
            end
        end
        wait()
    end
end

function autoLeave()
    while getgenv().autoLeaveGG == true do
        if getgenv().loadedallscript == true then
            local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
            if prompt then
                local button2 = prompt.TextButton.TextButton
                if button2 then
                    firebutton(button2, "getconnections")
                end
            end
            local uiEndGame = player:FindFirstChild("PlayerGui"):FindFirstChild("EndGameUI")
            if uiEndGame then
                local button = uiEndGame.BG.Buttons:FindFirstChild("Leave")
                if button then
                    firebutton(button, "VirtualInputManager")
                end
            end
        end
        wait()
    end
end

function autoNext()
    while getgenv().autoNextGG == true do
        if getgenv().loadedallscript == true then
            local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
            if prompt then
                local button2 = prompt.TextButton.TextButton
                if button2 then
                    firebutton(button2, "getconnections")
                end
            end
            local uiEndGame = player:FindFirstChild("PlayerGui"):FindFirstChild("EndGameUI")
            if uiEndGame then
                local button = uiEndGame.BG.Buttons:FindFirstChild("Next")
                if button then
                    firebutton(button, "VirtualInputManager")
                end
            end
        end
        wait()
    end
end

function deleteMap()
    while getgenv().deleteMapGG == true do
        if getgenv().loadedallscript == true then
            local map = workspace:FindFirstChild("Map")
            if map and map:FindFirstChild("Map") then
                for _, obj in ipairs(map.Map:GetChildren()) do
                    if obj.Name:lower():find("model") or obj.Name:lower():find("building%d") then
                        obj:Destroy()
                    end
                end
            end
        wait(1)
        end
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

    while getgenv().securityModeGG do
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
    while getgenv().upgradeUnitGG do
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

function autoGameSpeed()
    while getgenv().autoGameSpeedGG == true do

        wait()
    end
end
--Function To Join Game

function autoJoinChallenge()
    while getgenv().autoJoinChallengeGG == true do
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
    while getgenv().autoJoinStoryGG == true do
        local story = workspace.TeleporterFolder.Story.Teleporter.Door

        if story then
            local doorCFrame = GetCFrame(story)
            local tween = tweenModel(game.Players.LocalPlayer.Character, doorCFrame)
            tween:Play()
            tween.Completed:Wait()
            wait(1)     
            local args = {
                [1] = tostring(selectedStoryMap),
                [2] = tonumber(selectedActStory),
                [3] = tostring(selectedDifficultyStory),
                [4] = false
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Story"):WaitForChild("Select"):InvokeServer(unpack(args))    
        else
            wait()
        end
    end
end

function autoJoinRaid()
    while getgenv().autoJoinRaidGG == true do
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

function fireCastleRequests(room)
end

function teleportToNPC(npcName)
    local npc = workspace.Lobby.Npcs:FindFirstChild(npcName)
    if npc then
        local teleportCFrame = GetCFrame(npc)
        if teleportCFrame then
            local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
            if tween then
                tween:Play()
                tween.Completed:Wait()
            end
        end
    else
        warn("NPC " .. npcName .. " não encontrado!")
    end
end

function joinInfCastle()
    while getgenv().joinInfCastleGG == true do
        repeat task.wait() until game:IsLoaded()
        wait(1)

        if getgenv().joinMethod == "Method 1" then
            if selectedRoomInfCastle then
                local args = { "GetGlobalData" }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("InfiniteCastleManager"):FireServer(unpack(args))
            
                print("Entrando no quarto:", room)
                local args = { "Play", tonumber(selectedRoomInfCastle) or 0, false }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("InfiniteCastleManager"):FireServer(unpack(args))
                print("Teleportando")
            else
                warn("Nenhum quarto selecionado para Infinite Castle!")
            end

        elseif getgenv().joinMethod == "Method 2" then
            teleportToNPC("Asta")
            if selectedRoomInfCastle then
                local args = { "GetGlobalData" }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("InfiniteCastleManager"):FireServer(unpack(args))
            
                print("Entrando no quarto:", room)
                local args = { "Play", tonumber(selectedRoomInfCastle) or 0, false }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("InfiniteCastleManager"):FireServer(unpack(args))
            else
                warn("Nenhum quarto selecionado para Infinite Castle!")
            end
        end

        wait(1)
    end
end

--Function in Lobby

function autoFeed()
    while getgenv().autoFeedGG == true do
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

function autoGetBattlepass()
    while getgenv().autoGetBattlepassGG == true do
        wait(1)
        local args = {
            [1] = "All"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimBattlePass"):FireServer(unpack(args))
        wait(1)
    end
end

-- Info Dropdown

local blacklist = blacklist or {}
local valuesChallengeInfo = {}
local challengeInfo = game:GetService("ReplicatedStorage").Modules.ChallengeInfo
for i, v in pairs(challengeInfo:GetChildren()) do
    if v.Name ~= "PackageLink" then
        table.insert(valuesChallengeInfo, tostring(v.Name))
    end 
end

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

local ValuesMaps = {}
local MapData = require(game:GetService("ReplicatedStorage").Modules.MapData)
for key, value in pairs(MapData) do
    table.insert(ValuesMaps, tostring(key)) 
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

--UI TabGroups

local tabGroups = {
	TabGroup1 = Window:TabGroup()
}

--UI Tabs

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
	Farm = tabGroups.TabGroup1:Tab({ Name = "Farm", Image = "rbxassetid://10734950309" }),
    AutoPlay = tabGroups.TabGroup1:Tab({ Name = "Auto Play", Image = "rbxassetid://10734950309" }),
    Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" }),
}

--UI Sections

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
    MainSection2 = tabs.Main:Section({ Side = "Left" }),
    MainSection3 = tabs.Main:Section({ Side = "Right" }),
    MainSection4 = tabs.Main:Section({ Side = "Right" }),
    MainSection10 = tabs.Farm:Section({ Side = "Left" }),
    MainSection11 = tabs.Farm:Section({ Side = "Right" }),
    MainSection12 = tabs.Farm:Section({ Side = "Right" }),
    MainSection13 = tabs.Farm:Section({ Side = "Right" }),
    MainSection15 = tabs.AutoPlay:Section({ Side = "Left" }),
    MainSection16 = tabs.AutoPlay:Section({ Side = "Right" }),
    MainSection25 = tabs.Settings:Section({ Side = "Right" }),
}

sections.MainSection1:Header({
	Name = "Player"
})

sections.MainSection1:Toggle({
	Name = "Hide Player",
	Default = false,
	Callback = function(value)
		getgenv().HidePlayerGG = value
		HidePlayer()
	end,
}, "HidePlayerInfo")

sections.MainSection1:Toggle({
	Name = "Auto Walk",
	Default = false,
	Callback = function(value)
		getgenv().autoWalkGG = value
		autoWalk()
	end,
}, "AutoWalk")

sections.MainSection1:Toggle({
	Name = "Security Mode",
	Default = false,
	Callback = function(value)
		getgenv().securityModeGG = value
		securityMode()
	end,
}, "SecurityMode")

sections.MainSection1:Toggle({
	Name = "Delete Map",
	Default = false,
	Callback = function(value)
		getgenv().deleteMapGG = value
		deleteMap()
	end,
}, "DeleteMap")

sections.MainSection1:Toggle({
	Name = "Delete Notifications",
	Default = false,
	Callback = function(value)
		getgenv().deleteNotErroGG = value
		deleteNotErro()
	end,
}, "DeleteNotErro")

sections.MainSection1:Toggle({
	Name = "Auto Leave",
	Default = false,
	Callback = function(value)
		getgenv().autoLeaveGG = value
		autoLeave()
	end,
}, "AutoLeave")

sections.MainSection1:Toggle({
	Name = "Auto Replay",
	Default = false,
	Callback = function(value)
		getgenv().autoRetryGG = value
		autoRetry()
	end,
}, "AutoReplay")

sections.MainSection1:Toggle({
	Name = "Auto Next",
	Default = false,
	Callback = function(value)
		getgenv().autoNextGG = value
		autoNext()
	end,
}, "AutoNext")

sections.MainSection2:Header({
	Name = "Webhook"
})

sections.MainSection2:Input({
	Name = "Webhook URL",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "All",
	Callback = function(value)
		urlwebhook = value
	end,
	onChanged = function(value)
        urlwebhook = value
	end,
}, "WebhookURL")

sections.MainSection2:Input({
	Name = "User ID",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        getgenv().pingUserId = value
	end,
	onChanged = function(value)
        getgenv().pingUserId = value
	end,
}, "pingUser@")

sections.MainSection2:Toggle({
	Name = "Send Webhook when finish game",
	Default = false,
	Callback = function(value)
        getgenv().webhookGG = value
        webhook()
	end,
}, "SendWebhook")

sections.MainSection2:Toggle({
	Name = "Ping User",
	Default = false,
	Callback = function(value)
        getgenv().pingUser = value
	end,
}, "PingUser")

sections.MainSection3:Header({
	Name = "Extra"
})

sections.MainSection3:Toggle({
	Name = "Auto Get Battlepass",
	Default = false,
	Callback = function(value)
		getgenv().autoGetBattlepassGG = value
		autoGetBattlepass()
	end,
}, "autoGetBattlepass")

sections.MainSection4:Header({
	Name = "Unit"
})

local Dropdown = sections.MainSection4:Dropdown({
	Name = "Select Unit",
	Multi = false,
	Required = true,
	Options = ValuesUnitId,
	Default = None,
	Callback = function(value)
        selectedUnitToFeed = value:match(".* | .* | (.+)")
	end,
}, "dropdownSelectUnitToFeed")

local Dropdown = sections.MainSection4:Dropdown({
	Name = "Select Item To Feed",
	Multi = false,
	Required = true,
	Options = ValuesItemsToFeed,
	Default = None,
	Callback = function(value)
		selectedFeed = value
	end,
}, "dropdownSelectItemToFeed")

sections.MainSection4:Toggle({
	Name = "Auto Feed",
	Default = false,
	Callback = function(value)
		getgenv().autoFeedGG = value
		autoFeed()
	end,
}, "autoFeed")

sections.MainSection10:Header({
	Name = "Story"
})

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Story Map",
	Multi = false,
	Required = true,
	Options = ValuesMaps,
	Default = None,
	Callback = function(value)
		selectedStoryMap = value
	end,
}, "dropdownStoryMap")

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Difficulty",
	Multi = false,
	Required = true,
	Options = {'Normal', "Nightmare", "Purgatory"},
	Default = None,
	Callback = function(value)
		selectedDifficultyStory = value
	end,
}, "dropdownSelectDifficultyStory")

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = {1,2,3,4,5,6},
	Default = None,
	Callback = function(value)
		selectedActStory = value
	end,
}, "dropdownSelectActStory")

sections.MainSection10:Toggle({
	Name = "Auto Story",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinStoryGG = value
		autoJoinStory()
	end,
}, "autoJoinStory")

sections.MainSection11:Header({
	Name = "Raid"
})

local Dropdown = sections.MainSection11:Dropdown({
	Name = "Select Raid Map",
	Multi = false,
	Required = true,
	Options = ValuesMaps,
	Default = None,
	Callback = function(value)
		selectedRaidMap = value
	end,
}, "dropdownRaidMap")

local Dropdown = sections.MainSection11:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = {1,2,3,4,5,6},
	Default = None,
	Callback = function(value)
		selectedFaseRaid = value
	end,
}, "dropdownSelectFaseRaid")

sections.MainSection11:Toggle({
	Name = "Auto Raid",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinRaidGG = value
		autoJoinRaid()
	end,
}, "autoJoinRaid")

sections.MainSection12:Header({
	Name = "Challenges"
})

local Dropdown = sections.MainSection12:Dropdown({
	Name = "Select Map",
	Multi = false,
	Required = true,
	Options = ValuesMaps,
	Default = None,
	Callback = function(value)
		selectedChallengeMap = value
	end,
}, "dropdownChallengeMap")

local Dropdown = sections.MainSection12:Dropdown({
    Name = "Ignore Difficulty",
    Multi = false,
    Required = true,
    Options = valuesChallengeInfo, 
    Default = none,
    Callback = function(value)
        selectedIgnoreChallenge = value
    end,
}, "dropdownSelectChallengeInfo")

local Dropdown = sections.MainSection12:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = {1,2,3,4,5,6},
	Default = None,
	Callback = function(value)
		selectActChallenge = value
	end,
}, "dropdownSelectActChallenge")

sections.MainSection12:Toggle({
	Name = "Auto Challenge",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinChallengeGG = value
		autoJoinChallenge()
	end,
}, "autoJoinChallenge")

sections.MainSection13:Header({
	Name = "Infinite Caslte"
})

local Dropdown = sections.MainSection13:Dropdown({
	Name = "Method To Join in Inf Castle",
	Multi = false,
	Required = true,
	Options = {'Method 1', 'Method 2'},
	Default = None,
	Callback = function(value)
        getgenv().joinMethod = value
	end,
}, "dropdownMethod")

sections.MainSection13:Input({
	Name = "Choose Inf Castle Room",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        selectedRoomInfCastle = value
	end,
	onChanged = function(value)
        selectedRoomInfCastle = value
	end,
}, "InfCastleRoom")

sections.MainSection13:Toggle({
	Name = "Auto Inf Caslte",
	Default = false,
	Callback = function(value)
		getgenv().joinInfCastleGG = value
		joinInfCastle()
	end,
}, "autoInfCastle")

sections.MainSection15:Header({
	Name = "Place & Upgrade"
})

local Dropdown = sections.MainSection15:Dropdown({
	Name = "Select Max Slot To Put",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
        selectedMaxSlot = tonumber(value)
	end,
}, "dropdownSlot")

sections.MainSection15:Input({
	Name = "Start Place at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        selectedWaveXToPlace = value
	end,
	onChanged = function(value)
        selectedWaveXToPlace = value
	end,
}, "inputAutoPlaceWaveX")

sections.MainSection15:Toggle({
	Name = "Auto Place Unit",
	Default = false,
	Callback = function(value)
        getgenv().placeUnitsGG = value
        placeUnits()
	end,
}, "autoPlaceUnit")

sections.MainSection15:Toggle({
	Name = "Only Place in Wave X",
	Default = false,
	Callback = function(value)
		getgenv().onlyPlaceinwaveX = value
	end,
}, "onlyPlaceInWaveX")

sections.MainSection15:Input({
	Name = "Start Upgrade at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        selectedWaveXToUpgrade = value
	end,
	onChanged = function(value)
        selectedWaveXToUpgrade = value
	end,
}, "inputAutoUpgradeWaveX")

sections.MainSection15:Toggle({
	Name = "Auto Upgrade Unit",
	Default = false,
	Callback = function(value)
		getgenv().upgradeUnitGG = value
		upgradeUnit()
	end,
}, "autoUpgradeUnit")

sections.MainSection15:Toggle({
	Name = "Only Upgrade in Wave X",
	Default = false,
	Callback = function(value)
		getgenv().onlyupgradeinwaveX = value
	end,
}, "onlyUpgradeInWaveX")

sections.MainSection16:Header({
	Name = "Skills"
})

sections.MainSection16:Toggle({
	Name = "Auto Universal Skill",
	Default = false,
	Callback = function(value)
		getgenv().autoUniversalSkillGG = value
        autoUniversalSkill()
	end,
}, "autoUniversalSkill")

sections.MainSection16:Toggle({
	Name = "Only use skills in boss",
	Default = false,
	Callback = function(value)
		getgenv().onlyBoss = value
	end,
}, "onlyUseSkillsInBoss")

--UI IMPORTANT THINGS

MacLib:SetFolder("Maclib")
tabs.Settings:InsertConfigSection("Left")

sections.MainSection25:Toggle({
	Name = "Hide UI when Execute",
	Default = false,
	Callback = function(value)
		getgenv().hideUIExecGG = value
		hideUIExec()
	end,
}, "HideUiWhenExecute")

sections.MainSection25:Toggle({
	Name = "Auto Execute",
	Default = false,
	Callback = function(value)
		getgenv().aeuatGG = value
		aeuat()
	end,
}, "AutoExecute")

sections.MainSection25:Toggle({
	Name = "Blackscreen",
	Default = false,
	Callback = function(value)
		blackScreen()
	end,
}, "BlackScreen")

sections.MainSection25:Toggle({
	Name = "FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().fpsBoostGG = value
		fpsBoost()
	end,
}, "FPSBoost")

sections.MainSection25:Toggle({
	Name = "Better FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().betterFpsBoostGG = value
		betterFpsBoost()
	end,
}, "BetterFPSBoost")

sections.MainSection25:Toggle({
	Name = "REALLY Better FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().extremeFpsBoostGG = value
		extremeFpsBoost()
	end,
}, "REALLYBetterFPSBoost")

sections.MainSection25:Slider({
    Name = "Change UI Size",
    Default = 0.8,
    Minimum = 0.1,
    Maximum = 1.5,
    Increment = 0.05,
    DisplayMethod = "Round", 
    Precision = 1,
    Callback = function(value)
        changeUISize(value)
    end
}, "changeUISize")

Window.onUnloaded(function()
	print("Unloaded!")
end)

tabs.Main:Select()

MacLib:SetFolder("Tempest Hub")
MacLib:SetFolder("Tempest Hub/_ALS_")
local GameConfigName = "_ALS_"
local player = game.Players.LocalPlayer
MacLib:LoadConfig(player.Name .. GameConfigName)
spawn(function()
	while task.wait(1) do
		MacLib:SaveConfig(player.Name .. GameConfigName)
	end
end)

--Anti AFK
for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end
warn("[TEMPEST HUB] Loaded")
hideUI()
createBC()
getgenv().loadedallscript = true