--Checking if game is loaded
repeat
	task.wait()
until game:IsLoaded()
task.wait(1)
warn("[TEMPEST HUB] Loading Ui")
wait()

--Starting Script
local MacLib =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled
local pcSize = UDim2.fromOffset(850, 650)
local mobileSize = UDim2.fromOffset(650, 400)
local currentSize = isMobile and mobileSize or pcSize

local Window = MacLib:Window({
	Title = "Tempest Hub",
	Subtitle = "Anime Last Stand",
	Size = currentSize,
	DragStyle = 1,
	DisabledWindowControls = {},
	ShowUserInfo = false,
	Keybind = Enum.KeyCode.RightControl,
	AcrylicBlur = true,
})

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

local globalSettings = {
	UIBlurToggle = Window:GlobalSetting({
		Name = "UI Blur",
		Default = Window:GetAcrylicBlurState(),
		Callback = function(bool)
			Window:SetAcrylicBlurState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
				Lifetime = 5,
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
				Lifetime = 5,
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
				Lifetime = 5,
			})
		end,
	}),
}
warn("[TEMPEST HUB] Loading Function")
wait()
warn("[TEMPEST HUB] Loading Toggles")
wait()
warn("[TEMPEST HUB] Last Checking")
wait()

--Locals
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local originalSizes = {}
local pcSize2 = Vector2.new(850, 650)
local mobileSize2 = Vector2.new(750, 500)
local speed = 1000
local selectedUnitRoll = nil
local selectedtech = nil
local selectedUIMacro = nil
local DropdownUnitPassive = nil
local RecordMacro = nil
local PlayMacro = nil
local upgradeUnitsToggle = nil
local sellFarmUnitsToggle = nil
local sellUnitsToggle = nil
local placeUnits = nil
local autoNextToggle = nil
local autoRetryToggle = nil
local alreadySentWebhook = true
local passivaPlayerGot = ""
local personagemWhoGotThePassive = ""
local retornoRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData")
local initialData = retornoRemote:InvokeServer(player)
local rerollsIniciais = initialData.Rerolls or 0
local rerollsGastos = 0
local traitStats = {}
local slots = game:GetService("Players").LocalPlayer.Slots
local waitTime = 1
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player.PlayerGui
local character = player.Character
local restartMatch = false
local selectedStoryYet = false
local startedGame = false
local allRanks = {
	"C-",
	"C",
	"C+",
	"B-",
	"B",
	"B+",
	"A-",
	"A",
	"A+",
	"S-",
	"S",
	"S+",
	"SS",
	"SSS",
}

selectedPortalMap = ""
selectedPortalTier = {}
selectedPortalModifier = {}
selectedPassive = {}
selectedUnitToRollPassive = ""
selectedUnitToRollStat = ""
selectedStatToGet = {}
cardPriorities = {}
cardPriorities2 = {}
selectedDungeon = ""
selectedDungeonDebuff = {}
selectedSurvivalDebuff = {}
selectedSkillToUse = {}

function isFarmUnit(unit)
	local unitsFarm = {
		"AI Hoshino",
		"AiHoshinoEvo",
		"Escanor (Night)",
		"Speedwagon",
		"Escanor (Bar)",
		"Robin",
		"RobinEvo",
		"Beast",
		"Girl Speedwagon",
		"Yoo Jinho",
	}
	for i, v in pairs(unitsFarm) do
		if unit == v then
			return true
		end
	end
	return false
end

local unitsToSell = {
	"AI Hoshino",
	"AiHoshinoEvo",
	"Escanor (Night)",
	"Speedwagon",
	"Escanor (Bar)",
	"Robin",
	"RobinEvo",
	"Beast",
	"Girl Speedwagon",
	"Yoo Jinho",
}

--General Functions

function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function getBaseSize()
	return isMobile() and mobileSize2 or pcSize2
end

function storeOriginalFrameSizes(guiObject)
	for _, obj in ipairs(guiObject:GetDescendants()) do
		if obj:IsA("Frame") then
			if not originalSizes[obj] then
				originalSizes[obj] = obj.Size
			end
		end
	end
end

function resizeFrames(scale)
	local gui = game:GetService("CoreGui"):FindFirstChild("MaclibGui")
	if not gui then
		return
	end

	storeOriginalFrameSizes(gui)

	local baseSize = getBaseSize()
	local widthScale = (baseSize.X * scale) / baseSize.X
	local heightScale = (baseSize.Y * scale) / baseSize.Y

	for frame, originalSize in pairs(originalSizes) do
		if frame and frame.Parent then
			frame.Size = UDim2.new(
				originalSize.X.Scale,
				math.floor(originalSize.X.Offset * widthScale),
				originalSize.Y.Scale,
				math.floor(originalSize.Y.Offset * heightScale)
			)
		end
	end
end

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

function fireproximityprompt55(Obj, Amount, Skip)
	if not Obj then
		return
	end
	local Obj = Obj:IsA("ProximityPrompt55") and Obj or Obj:FindFirstChildWhichIsA("ProximityPrompt55")
	if Obj and Obj.ClassName == "ProximityPrompt55" then
		Obj.Enabled = true
		Amount = Amount or 1
		local PromptTime = Obj.HoldDuration
		if typeof(Skip) == "boolean" and Skip then
			Obj.HoldDuration = 0
		end
		for i = 1, Amount do
			Obj:InputHoldBegin()
			if typeof(Skip) == "boolean" and not Skip then
				task.wait(Obj.HoldDuration)
			elseif typeof(Skip) == "number" then
				task.wait(Skip)
			end
			Obj:InputHoldEnd()
		end
		Obj.HoldDuration = PromptTime
	else
		return
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

function hideUIExecFunction()
	while getgenv().hideUIExecEnabled == true do
		local coreGui = game:GetService("CoreGui")
		local Base = nil

		if coreGui:FindFirstChild("MaclibGui") then
			Base = coreGui.MaclibGui:FindFirstChild("Base")
		elseif coreGui:FindFirstChild("RobloxGui") and coreGui.RobloxGui:FindFirstChild("MaclibGui") then
			Base = coreGui.RobloxGui.MaclibGui:FindFirstChild("Base")
		end

		if Base then
			Base.Visible = false
		end
		break
	end
end

function aeuatFunction()
	while getgenv().aeuatEnabled == true do
		local teleportQueued = false
		game.Players.LocalPlayer.OnTeleport:Connect(function(State)
			if
				(State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress) and not teleportQueued
			then
				teleportQueued = true

				queue_on_teleport([[         
                        repeat task.wait() until game:IsLoaded()
                        if getgenv().executedEnabled then return end    
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/TempestHubMain/main/Main"))()
                    ]])

				getgenv().executedEnabled = true
				wait(1)
				teleportQueued = false
			end
		end)
		wait()
	end
end

function firebutton(Button, method)
	if not Button then
		return
	end

	local a = Button

	if getconnections and method == "getconnections" then
		if Button.Activated then
			for i, v in pairs(getconnections(Button.Activated)) do
				wait()
				v.Function()
			end
		end
	elseif firesignal and method == "firesignal" then
		local events = { "MouseButton1Click", "MouseButton1Down", "Activated" }
		for _, v in pairs(events) do
			if Button[v] then
				firesignal(Button[v])
			end
		end
	elseif VirtualInputManager and method == "VirtualInputManager" then
		local GuiService = game:GetService("GuiService")
		repeat
			GuiService.GuiNavigationEnabled = true
			GuiService.SelectedObject = Button
			task.wait()
		until GuiService.SelectedObject == Button
		VirtualInputManager:SendKeyEvent(true, "Return", false, nil)
		VirtualInputManager:SendKeyEvent(false, "Return", false, nil)
		task.wait(0.05)
		GuiService.GuiNavigationEnabled = false
		GuiService.SelectedObject = nil
		wait(1)
	end
end

function fpsBoostFunction()
	local Lighting = game:GetService("Lighting")
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local function optimizeGame()
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Texture") or obj:IsA("Decal") then
				obj:Destroy()
			elseif obj:IsA("BasePart") then
				obj.Material = Enum.Material.SmoothPlastic
				obj.Color = Color3.new(0.5, 0.5, 0.5)
			end
		end

		if Lighting:FindFirstChildOfClass("Sky") then
			Lighting:FindFirstChildOfClass("Sky"):Destroy()
		end

		for _, player in pairs(Players:GetPlayers()) do
			if player.Character then
				for _, obj in pairs(player.Character:GetChildren()) do
					if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Accessory") then
						obj:Destroy()
					end
				end
			end
		end
	end

	optimizeGame()
end

function tweenModel(model, targetCFrame)
	if not model.PrimaryPart then
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

function blackScreenFunction()
	if getgenv().createBCEnabled == true then
		game:GetService("RunService"):Set3dRenderingEnabled(false)
	elseif getgenv().createBCEnabled == false then
		game:GetService("RunService"):Set3dRenderingEnabled(true)
	end
end

function HidePlayerFunction()
	while getgenv().HidePlayerEnabled == true do
		local player = game.Players.LocalPlayer
		local character = player.Character

		if character then
			local head = character.Head
			local humanoidrootpart = character.HumanoidRootPart
			for i, v in pairs(head:GetChildren()) do
				if v.ClassName == "BillboardGui" or v.ClassName == "Decal" then
					v:Destroy()
				end
			end
			for i, v in pairs(humanoidrootpart:GetChildren()) do
				if v.ClassName == "BillboardGui" or v.ClassName == "Decal" then
					v:Destroy()
				end
			end
			for _, obj in ipairs(character:GetChildren()) do
				if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") then
					obj:Destroy()
				end
			end
		end
		wait()
	end
end


function webhookFunction()
	if not alreadySentWebhook then return end
	alreadySentWebhook = false
	task.spawn(function()
		while true do
			task.wait()
			if not alreadySentWebhook and restartMatch == true then
			end
			local discordWebhookUrl = urlwebhook
			local player = game:GetService("Players").LocalPlayer

			local uiEndGame = player:WaitForChild("PlayerGui"):WaitForChild("EndGameUI")

			if not alreadySentWebhook and restartMatch == true and getgenv().autoRestartEnabled == true then
				local retorno = game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("GetPlayerData")
					:InvokeServer(player)

				local name = player.Name
				local formattedName = "||" .. name .. "||"

				local emeralds = retorno.Emeralds or 0
				local jewels = retorno.Jewels or 0
				local rerolls = retorno.Rerolls or 0
				local gold = retorno.Gold or 0
				local LargeEasterEgg = retorno.LargeEasterEgg or 0
				local SmallEasterEgg = retorno.SmallEasterEgg or 0
				local raidTokens = retorno.RaidTokens or 0
				local titantRushTokens = retorno.TitanRushTokens or 0
				local bossRushTokens = retorno.BossRushTokens or 0
				local duskPearl = retorno.ItemData.DuskPearl
				local amountDuskPearl = 0
				local amountPearl = 0
				if duskPearl ~= nil then
					amountDuskPearl = duskPearl.Amount
				end

				local pearl = retorno.ItemData.Pearl
				if pearl ~= nil then
					amountPearl = pearl.Amount
				end

				local levelValue = retorno.Level and string.match(retorno.Level, "%d+") or "N/A"
				local expValue = retorno.EXP or 0
				local maxExpValue = retorno.MaxEXP or 0
				local formattedLevel = string.format("%s [%s/%s]", levelValue, expValue, maxExpValue)

				local formattedUnit = ""
				local unitData = retorno.UnitData
				if typeof(unitData) == "table" then
					for _, unitInfo in pairs(unitData) do
						if unitInfo.Equipped == true then
							formattedUnit = formattedUnit
								.. "[ "
								.. unitInfo.Level
								.. " ] = "
								.. unitInfo.UnitName
								.. " [ "
								.. unitInfo.Worthiness
								.. "% ]⚔️\n"
						end
					end
				end
				if formattedUnit == "" then
					formattedUnit = "None"
				end

				local teleportData = game:GetService("ReplicatedStorage").Remotes.GetTeleportData:InvokeServer()
				local mapName = tostring(teleportData.MapName or "Unknown Map")
				local mapDifficulty = tostring(teleportData.Difficulty or "Unknown Difficulty")
				local mapType = tostring(teleportData.Type or "Unknown Type")

				local matchResultString = "**RESTARTING MATCH**\n"
					.. string.format("%s - %s [%s]", mapType, mapName, mapDifficulty)

				local pingContent = ""
				if getgenv().pingUserEnabled and getgenv().pingUserIdEnabled then
					pingContent = "<@" .. getgenv().pingUserIdEnabled .. ">"
				elseif getgenv().pingUserEnabled then
					pingContent = "@everyone"
				end

				local payload = {
					content = pingContent,
					embeds = {
						{
							description = "User: " .. formattedName .. "\nLevel: " .. formattedLevel,
							color = 16776960,
							fields = {
								{
									name = "Player Stats",
									value = string.format(
										"<:emeraldALS:1357830472167719024> Emeralds: %d\n"
											.. "<:Jewel:1357831800063262813> Jewels: %d\n"
											.. "<:rerollShardALS:1357830474352951436> Rerolls: %d\n"
											.. "<:Gold:1357833327817658388> Gold: %d\n"
											.. "<:LargeEasterEgg:1363585587948425370> LargeEasterEgg: %d\n"
											.. "<:SmallEasterEgg:1363586043617742990> SmallEasterEgg: %d\n"
											.. "<:RaidTokenALS:1357832545202344028> Raid Tokens: %d\n"
											.. "<:titanbossrush:1360300733282517134> Boss Rush Tokens: %d\n"
											.. "<:godlybossrush:1360300746691575909> Titan Rush Tokens: %d\n"
											.. "<:Pearl:1361859005944696902> Pearl: %d\n"
											.. "<:DuskPearl:1361858992233644082> Dusk Pearl: %d\n",
										emeralds,
										jewels,
										rerolls,
										gold,
										LargeEasterEgg,
										SmallEasterEgg,
										raidTokens,
										bossRushTokens,
										titantRushTokens,
										amountPearl,
										amountDuskPearl
									),
									inline = true,
								},
								{
									name = "Units",
									value = formattedUnit,
								},
								{
									name = "Match Restart Info",
									value = matchResultString,
								},
							},
							author = {
								name = "Anime Last Stand",
							},
							footer = {
								text = "https://discord.gg/MfvHUDp5XF - Tempest Hub",
							},
							timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
							thumbnail = {
								url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png",
							},
						},
					},
					attachments = {},
				}

				local HttpService = game:GetService("HttpService")
				local payloadJson = HttpService:JSONEncode(payload)

				local response
				if syn and syn.request then
					response = syn.request({
						Url = discordWebhookUrl,
						Method = "POST",
						Headers = {
							["Content-Type"] = "application/json",
						},
						Body = payloadJson,
					})
				elseif http_request then
					response = http_request({
						Url = discordWebhookUrl,
						Method = "POST",
						Headers = {
							["Content-Type"] = "application/json",
						},
						Body = payloadJson,
					})
				else
				end

				if response and response.Success then
					alreadySentWebhook = true
					break
				elseif response then
					alreadySentWebhook = true
					break
				end
			elseif uiEndGame and not alreadySentWebhook then
				local resultText = uiEndGame:FindFirstChild("BG")
				if resultText then
					local name = player.Name
					local formattedName = "||" .. name .. "||"
					local retorno = game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("GetPlayerData")
						:InvokeServer(player)

					local emeralds = retorno.Emeralds or 0
					local jewels = retorno.Jewels or 0
					local rerolls = retorno.Rerolls or 0
					local gold = retorno.Gold or 0
					local LargeEasterEgg = retorno.LargeEasterEgg or 0
					local SmallEasterEgg = retorno.SmallEasterEgg or 0
					local raidTokens = retorno.RaidTokens or 0
					local titantRushTokens = retorno.TitanRushTokens or 0
					local bossRushTokens = retorno.BossRushTokens or 0

					local levelValue = retorno.Level and string.match(retorno.Level, "%d+") or "N/A"
					local expValue = retorno.EXP or 0
					local maxExpValue = retorno.MaxEXP or 0

					local formattedLevel = string.format("%s [%s/%s]", levelValue, expValue, maxExpValue)

					local rewards = uiEndGame.BG.Container.Rewards:FindFirstChild("Holder")
					local formattedResultFR = ""

					if rewards then
						local realRewards = rewards:GetChildren()
						for _, v in pairs(realRewards) do
							if v.Name ~= "UIListLayout" and v.Name ~= "UIPadding" then
								local amount = v:FindFirstChild("Amount")
								local item = v:FindFirstChild("ItemName")

								if amount and item and amount.Text ~= "" and item.Text ~= "" then
									formattedResultFR = formattedResultFR .. amount.Text .. " " .. item.Text .. "\n"
								end
							end
						end
					end

					if formattedResultFR == "" then
						formattedResultFR = "No rewards"
					end

					local formattedUnit = ""
					local unitData = retorno.UnitData
					if typeof(unitData) == "table" then
						for _, unitInfo in pairs(unitData) do
							if unitInfo.Equipped == true then
								formattedUnit = formattedUnit
									.. "[ "
									.. unitInfo.Level
									.. " ] = "
									.. unitInfo.UnitName
									.. " [ "
									.. unitInfo.Worthiness
									.. "% ]⚔️\n"
							end
						end
					end

					if formattedUnit == "" then
						formattedUnit = "None"
					end

					local elapsedTimeText = uiEndGame.BG.Container.Stats.ElapsedTime.Text
					local timeParts = string.split(elapsedTimeText, ":")
					local totalSeconds = 0

					if #timeParts == 3 then
						local h, m, s = tonumber(timeParts[1]), tonumber(timeParts[2]), tonumber(timeParts[3])
						totalSeconds = (h or 0) * 3600 + (m or 0) * 60 + (s or 0)
					elseif #timeParts == 2 then
						local m, s = tonumber(timeParts[1]), tonumber(timeParts[2])
						totalSeconds = (m or 0) * 60 + (s or 0)
					elseif #timeParts == 1 then
						totalSeconds = tonumber(timeParts[1]) or 0
					end

					local hours = math.floor(totalSeconds / 3600)
					local minutes = math.floor((totalSeconds % 3600) / 60)
					local seconds = totalSeconds % 60
					local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)

					local waveText = uiEndGame.BG.Container.Stats.EndWave.Text
					local waveOnly = string.sub(waveText, 15)

					local teleportData = game:GetService("ReplicatedStorage").Remotes.GetTeleportData:InvokeServer()
					local mapName = tostring(teleportData.MapName or "Unknown Map")
					local mapDifficulty = tostring(teleportData.Difficulty or "Unknown Difficulty")
					local mapType = tostring(teleportData.Type or "Unknown Type")

					local resultText =
						game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("EndGameUI").BG.Container.Stats.Result.Text
					local resultOnly = nil
					if resultText:lower() == "defeat" then
						resultOnly = "Defeat"
					else
						resultOnly = "Victory"
					end

					local matchResultString = string.format(
						"%s - Wave %s\n%s - %s [%s] - %s",
						tostring(formattedTime),
						tostring(waveOnly),
						mapType,
						mapName,
						mapDifficulty,
						resultOnly
					)

					local pingContent = ""
					if getgenv().pingUserEnabled and getgenv().pingUserIdEnabled then
						pingContent = "<@" .. getgenv().pingUserIdEnabled .. ">"
					elseif getgenv().pingUserEnabled then
						pingContent = "@everyone"
					end

					local color = 7995647
					if resultOnly == "Defeat" then
						color = 16711680
					elseif resultOnly == "Victory" then
						color = 65280
					end

					local payload = {
						content = pingContent,
						embeds = {
							{
								description = "User: " .. formattedName .. "\nLevel: " .. formattedLevel,
								color = color,
								fields = {
									{
										name = "Player Stats",
										value = string.format(
											"<:emeraldALS:1357830472167719024> Emeralds: %d\n"
												.. "<:Jewel:1357831800063262813> Jewels: %d\n"
												.. "<:rerollShardALS:1357830474352951436> Rerolls: %d\n"
												.. "<:Gold:1357833327817658388> Gold: %d\n"
												.. "<:LargeEasterEgg:1363585587948425370> LargeEasterEgg: %d\n"
												.. "<:SmallEasterEgg:1363586043617742990> SmallEasterEgg: %d\n"
												.. "<:RaidTokenALS:1357832545202344028> Raid Tokens: %d\n"
												.. "<:titanbossrush:1360300733282517134> Boss Rush Tokens: %d\n"
												.. "<:godlybossrush:1360300746691575909> Titan Rush Tokens: %d\n",
											emeralds,
											jewels,
											rerolls,
											gold,
											LargeEasterEgg,
											SmallEasterEgg,
											raidTokens,
											bossRushTokens,
											titantRushTokens
										),
										inline = true,
									},
									{
										name = "Rewards",
										value = formattedResultFR,
										inline = true,
									},
									{
										name = "Units",
										value = formattedUnit,
									},
									{
										name = "Match Result",
										value = matchResultString,
									},
								},
								author = {
									name = "Anime Last Stand",
								},
								footer = {
									text = "https://discord.gg/MfvHUDp5XF - Tempest Hub",
								},
								timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
								thumbnail = {
									url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png",
								},
							},
						},
						attachments = {},
					}

					local HttpService = game:GetService("HttpService")
					local payloadJson = HttpService:JSONEncode(payload)

					local response
					if syn and syn.request then
						response = syn.request({
							Url = discordWebhookUrl,
							Method = "POST",
							Headers = {
								["Content-Type"] = "application/json",
							},
							Body = payloadJson,
						})
					elseif http_request then
						response = http_request({
							Url = discordWebhookUrl,
							Method = "POST",
							Headers = {
								["Content-Type"] = "application/json",
							},
							Body = payloadJson,
						})
					else
					end

					if response and response.Success then 
						alreadySentWebhook = true
						break
					elseif response then
						alreadySentWebhook = true
						break


					end

				end
			end
			wait(1)
		end
	end)	
	
end
function testWebhookFunction()
	local discordWebhookUrl = urlwebhook
	local pingContent = ""

	if getgenv().pingUserEnabled and getgenv().pingUserIdEnabled then
		pingContent = "<@" .. getgenv().pingUserIdEnabled .. ">"
	elseif getgenv().pingUserEnabled then
		pingContent = "@"
	end

	local payload = {
		content = pingContent,
		embeds = {
			{
				description = "Test Webhook LMAO\n\n```REWARDS:\n+Nothing LMAO\n```",
				color = 8716543,
				author = {
					name = "Anime Adventures",
				},
			},
		},
		attachments = {},
	}

	local payloadJson = HttpService:JSONEncode(payload)

	if syn and syn.request then
		local response = syn.request({
			Url = discordWebhookUrl,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
			},
			Body = payloadJson,
		})

		if response.Success then
			wait()
		else
			wait()
		end
	elseif http_request then
		local response = http_request({
			Url = discordWebhookUrl,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
			},
			Body = payloadJson,
		})

		if response.Success then
		else
			wait()
		end
	end
end

function verifyRerolls()
	local player = game.Players.LocalPlayer
	local retornoRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData")
	local currentData = retornoRemote:InvokeServer(player)
	local rerollsAtuais = currentData.Rerolls
	rerollsGastos = rerollsIniciais - rerollsAtuais
	return -rerollsGastos
end

function rerollAtual()
	local player = game.Players.LocalPlayer
	local retornoRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData")
	local initialData = retornoRemote:InvokeServer(player)
	rerollsAtuais = initialData.Rerolls or 0
	return rerollsAtuais
end

function webhookTraitRerollFunction(passivaConseguida, personagem)
	while getgenv().webhookTraitRerollEnabled == true do
		local discordWebhookUrl = urlwebhook
		local pingContent = ""
		passivaPlayerGot = passivaConseguida
		if passivaPlayerGot and passivaPlayerGot ~= "" then
			traitStats[passivaPlayerGot] = (traitStats[passivaPlayerGot] or 0) + 1
		end
		personagemWhoGotThePassive = personagem

		local rerollsGastos = verifyRerolls() or 0
		local rerollAtual = rerollAtual() or 0

		if getgenv().pingUserEnabled and getgenv().pingUserIdEnabled then
			pingContent = "<@" .. getgenv().pingUserIdEnabled .. ">"
		elseif getgenv().pingUserEnabled then
			pingContent = "@"
		end

		local title = ""
		if passivaConseguida then
			title = "Got **"
				.. passivaPlayerGot
				.. "** on **"
				.. personagemWhoGotThePassive
				.. "** in "
				.. rerollsGastos
				.. " rolls"
		else
			title = "❌ Didn't get desired passive on **" .. personagemWhoGotThePassive .. "**"
			if ultimaPassiva then
				title = title .. ". Last passive: **" .. passivaPlayerGot .. "**"
			end
		end

		local images = {
			["Glitched"] = "https://cdn.discordapp.com/attachments/1356784961688043572/1362638434715435179/latest.png?ex=68031f6f&is=6801cdef&hm=738b8389884cf75f7706bc8c05ca93e112e4beecd0c9611ebd99099b64b4958d&",
			["Avatar"] = "https://cdn.discordapp.com/attachments/1356784961688043572/1362638206872453222/latest.png?ex=68031f39&is=6801cdb9&hm=e334ee0d9d08bbf6f2087e5f51e3cd738aff7b0cd2bd4d43f3d846a4ee9624fa&",
			["Overlord"] = "https://cdn.discordapp.com/attachments/1356784961688043572/1362638220999004201/latest.png?ex=68031f3c&is=6801cdbc&hm=2d88e6129f3c9db207b06a5e8edcba37154e922aa4f957c27c47bd2391835db5&",
			["Entrepreneur"] = "https://cdn.discordapp.com/attachments/1356784961688043572/1362638213335744704/latest.png?ex=68031f3a&is=6801cdba&hm=55418049253fcbc57e0a914add8d5155f4d6943b72907ea68f0df2c1c4147e4f&",
		}
		local payload = {
			content = pingContent,
			embeds = {
				{
					title = title,
					color = passivaConseguida and 0x9D00FF or 0xD62F2F,
					fields = {
						{
							name = "Total Player Reroll Count",
							value = tostring(rerollAtual or "0"),
						},
						{
							name = "Traits Rolled Off This Session",
							value = table.concat(
								(function()
									local t = {}
									for trait, count in pairs(traitStats) do
										table.insert(t, trait .. ": " .. count)
									end
									return t
								end)(),
								"\n"
							),
						},
					},
				},
			},
			attachments = {},
		}

		if images[passivaPlayerGot] then
			payload.embeds[1].thumbnail = {
				url = images[passivaPlayerGot],
			}
		else
			return;
		end

		local payloadJson = HttpService:JSONEncode(payload)

		local requestFunc = syn and syn.request or http_request
		if requestFunc then
			pcall(function()
				requestFunc({
					Url = discordWebhookUrl,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = payloadJson,
				})
			end)
			break
		end
		task.wait(0.5)
	end
end

--Function in Game

function autoGetEscanorAxeFunction()
	while getgenv().autoGetEscanorAxeEnabled == true do
		local collectibles = workspace.Map:FindFirstChild("Collectibles")

		if collectibles then
			for i, v in pairs(collectibles:GetChildren()) do
				if v:IsA("BasePart") then
					fireproximityprompt55(v, 1, true)
				end
			end
		end
		wait(1)
	end
end

function autoVolcanoFunction()
	local waitTime = 1
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

	local mapFolder = workspace:WaitForChild("Map", 60)
	if not mapFolder then
		return
	end

	local volcanoesFolder = mapFolder:WaitForChild("Volcanoes", 60)
	if not volcanoesFolder then
		return
	end

	function interactWithVolcanoPrompt(volcano)
		local prompt = volcano:FindFirstChildWhichIsA("ProximityPrompt")
		if not prompt then
			return
		end

		if prompt.Enabled and prompt.MaxActivationDistance > 0 then
			local originalDistance = prompt.MaxActivationDistance
			prompt.MaxActivationDistance = math.huge

			fireproximityprompt(prompt, prompt.HoldDuration + 0.1)

			prompt.MaxActivationDistance = originalDistance

			return true
		end
		return false
	end

	while true do
		local currentVolcanoes = volcanoesFolder:GetChildren()

		for _, volcano in ipairs(currentVolcanoes) do
			if volcano:IsDescendantOf(volcanoesFolder) then
				local success = interactWithVolcanoPrompt(volcano)
				if success then
					task.wait(waitTime)
				end
			end
		end

		task.wait(waitTime)
	end
end

function startFrameFind()
	local bottom = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Bottom")
	local frameCount = 0

	if bottom then
		local bottomGui = bottom:FindFirstChild("Frame")
		for i, v in pairs(bottomGui:GetChildren()) do
			if v.Name == "Frame" then
				frameCount = frameCount + 1
			end
		end

		if frameCount == 3 then
			return false
		else
			return true
		end
	end
end

function autoStartFunction()
	while getgenv().autoStartEnabled == true do
		if selectedStoryYet == true then
			wait(1)
			local argsTeleporter = {
				[1] = "Skip",
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("Teleporter")
				:WaitForChild("Interact")
				:FireServer(unpack(argsTeleporter))
			startedGame = true
		end
		wait()
	end
end

function autoReadyFunction()
	while getgenv().autoReadyEnabled == true do
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlayerReady"):FireServer()
		break
	end
end

function autoSkipWaveFunction()
	while getgenv().autoSkipWaveEnabled == true do
		local skipWaveScreenGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("SkipWave")
		if skipWaveScreenGui then
			local button = skipWaveScreenGui.BG.Yes
			firebutton(button, "VirtualInputManager")
		end
		wait(1)
	end
end

function autoRetryFunction()
	while getgenv().autoRetryEnabled == true do
		local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
		if prompt then
			local button2 = prompt.TextButton:FindFirstChild("TextButton")
			if button2 then
				firebutton(button2, "VirtualInputManager")
				wait(1) 
			end
		end
		local uiEndGame = player:FindFirstChild("PlayerGui"):WaitForChild("EndGameUI")
		if uiEndGame then
			local button = uiEndGame.BG.Buttons:FindFirstChild("Retry")
			if button then
				webhookFunction()
				wait(3) 
				firebutton(button, "VirtualInputManager")
				wait(2) 
			end
		end
		wait(1) 
	end
end

function autoLeaveFunction()
	while getgenv().autoLeaveEnabled == true do
		local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
		if prompt then
			local button2 = prompt.TextButton.TextButton
			if button2 then
				firebutton(button2, "VirtualInputManager")
			end
		end
		local uiEndGame = player:FindFirstChild("PlayerGui"):WaitForChild("EndGameUI")
		if uiEndGame then
			local button = uiEndGame.BG.Buttons:FindFirstChild("Leave")
			if button then
				wait(1)
				firebutton(button, "VirtualInputManager")
			end
		end
		wait(1)
	end
end

function autoNextFunction()
	while getgenv().autoNextEnabled == true do
		local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
		if prompt then
			local button2 = prompt.TextButton.TextButton
			if button2 then
				firebutton(button2, "VirtualInputManager")
			end
		end
		local uiEndGame = player:FindFirstChild("PlayerGui"):WaitForChild("EndGameUI")
		if uiEndGame then
			local button = uiEndGame.BG.Buttons:FindFirstChild("Next")
			if button then
	
				webhookFunction()
				wait(1)
				firebutton(button, "VirtualInputManager")
			end
		end
		wait(1)
	end
end

function sellUnitFunction()
	while getgenv().sellUnitEnabled == true do
		local mainUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local selectedWave = MacLib.Options.SellUnitAtWaveXToggle.Value
			local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value
			if  tonumber(waveValue) >= tonumber(selectedWave) then
				local towers = workspace:FindFirstChild("Towers")
				if towers then
					for _, unit in ipairs(towers:GetChildren()) do
						local args = {
							[1] = workspace:WaitForChild("Towers"):WaitForChild(tostring(unit)),
						}

						game:GetService("ReplicatedStorage")
							:WaitForChild("Remotes")
							:WaitForChild("Sell")
							:InvokeServer(unpack(args))
					end
				end
			end
		end
		wait(1)
	end
end

function sellUnitFarmFunction()
	local unitsToSell = {
		"AI Hoshino",
		"AiHoshinoEvo",
		"Escanor (Night)",
		"Speedwagon",
		"Escanor (Bar)",
		"Robin",
		"RobinEvo",
		"Beast",
		"Girl Speedwagon",
		"Yoo Jinho",
	}
	while getgenv().sellUnitFarmEnabled do
		local mainUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local selectedWave = MacLib.Options.selectedWaveXToSellFarmToggle.Value
			local waveValue = game:GetService("ReplicatedStorage").Wave.Value

			if tonumber(waveValue) == tonumber(selectedWave) then
				local towers = workspace.Towers
				if towers then
					for _, unit in ipairs(towers:GetChildren()) do
						if table.find(unitsToSell, unit.Name) then
							game:GetService("ReplicatedStorage").Remotes.Sell:InvokeServer(unit)
						end
					end
				end
			end
		end
		task.wait(1)
	end
end

function upgradeUnitFunction()
	local player = game.Players.LocalPlayer
	local repStorage = game:GetService("ReplicatedStorage")
	local towersFolder = workspace:WaitForChild("Towers")

	while getgenv().upgradeUnitEnabled do
		local mainUI = player.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local waveValue = tonumber(repStorage:WaitForChild("Wave").Value) or 0
			local slots = player:FindFirstChild("Slots")

			if slots then
				local farmCandidates = {}
				local otherCandidates = {}
				for i = 1, 6 do
					local slotInst = slots:FindFirstChild("Slot" .. i)
					local unitName = slotInst and slotInst.Value
					local maxUpgrade = MacLib.Options["Unit" .. i .. "Up"].Value
					local requiredWave = tonumber(MacLib.Options["waveUnit" .. i .. "Slider"].Value) or 0

					if getgenv().onlyupgradeinwaveXEnabled then
						local minWaveX = tonumber(MacLib.Options.inputAutoUpgradeWaveX.Value) or 0
						if waveValue < minWaveX then
							break
						end
					end

					if unitName and waveValue >= requiredWave then
						for _, unitInst in ipairs(towersFolder:GetChildren()) do
							if unitInst.Name == unitName then
								local upgradeValue = unitInst:FindFirstChild("Upgrade")
								if upgradeValue and upgradeValue.Value < maxUpgrade then
									if isFarmUnit(unitInst.Name) then
										table.insert(farmCandidates, unitInst)
									else
										table.insert(otherCandidates, unitInst)
									end
								end
							end
						end
					end
				end

				local processList = next(farmCandidates) and farmCandidates or otherCandidates

				local endUI = player.PlayerGui:WaitForChild("EndGameUI")
				if not endUI then
					for _, unitInst in ipairs(processList) do
						repStorage.Remotes.Upgrade:InvokeServer(unitInst)
						task.wait(0.1)
					end
				end
			end
		end
		task.wait(1)
	end
end

function autoGameSpeedFunction()
	while getgenv().autoGameSpeedEnabled == true do
		local startButton = startFrameFind()
		if startButton == true then
			local args = {
				[1] = 3,
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("ChangeTimeScale")
				:FireServer(unpack(args))
			break
		end
		wait()
	end
end

function getWaypointByPercentageFunction(waypoints, percentage)
	local n = #waypoints
	if n == 0 then
		return nil
	end
	local segment = 100 / n
	local index = percentage >= 100 and n or math.floor(percentage / segment) + 1
	return waypoints[index]
end

local lastPlacementAngles = {}

function getPositionsAroundPointFunction(center, radius, nPositions)
	local positions = {}
	local angleStep = (2 * math.pi) / nPositions
	local baseAngle = math.random() * 2 * math.pi

	if #lastPlacementAngles >= nPositions then
		local similar = true
		for i = 1, nPositions do
			local newAngle = (baseAngle + (i - 1) * angleStep) % (2 * math.pi)
			if math.abs(newAngle - lastPlacementAngles[i]) > 0.2 then
				similar = false
				break
			end
		end
		if similar then
			baseAngle = (baseAngle + math.pi / 2) % (2 * math.pi)
		end
	end

	lastPlacementAngles = {}

	for i = 0, nPositions - 1 do
		local angle = (baseAngle + i * angleStep) % (2 * math.pi)
		local x = center.X + radius * math.cos(angle)
		local z = center.Z + radius * math.sin(angle)
		local y = center.Y + 1
		local pos = Vector3.new(x, y, z)
		table.insert(positions, pos)
		table.insert(lastPlacementAngles, angle)
	end

	return positions
end

function placeEquippedUnitsFunction(positions, equippedUnits)
	local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlaceTower")

	for i, unitInfo in ipairs(equippedUnits) do
		local pos = positions[i]
		if pos and unitInfo.UnitName then
			local cf = CFrame.new(pos)
			remote:FireServer(unitInfo.UnitName, cf)
		end
	end
end

function placeUnitsFunction()
	local player = game.Players.LocalPlayer
	local remote = game:GetService("ReplicatedStorage").Remotes.PlaceTower
	local waveTag = game:GetService("ReplicatedStorage").Wave
	local bottomGui = player.PlayerGui:WaitForChild("Bottom")
	local slotsFolder = player:WaitForChild("Slots")
	if getgenv().isPlacingUnits then return end
	getgenv().isPlacingUnits = true
	while getgenv().placeUnitsEnabled do
		local uiEndGame = player.PlayerGui:FindFirstChild("EndGameUI")
		if uiEndGame and uiEndGame.Enabled then
			task.wait(1)
			continue
		end
		local opts           = MacLib.Options
		local distPercent    = opts.selectedDistancePercentage.Value
		local groundPercent  = opts.selectedGroundPercentage.Value

		local placeMax, waveThreshold = {}, {}
		for i = 1, 6 do
			placeMax[i]      = opts["Unit"..i].Value
			waveThreshold[i] = tonumber(opts["waveUnit"..i.."Slider"].Value) or 0
		end

		-- 2) Coleta e ordenação de waypoints
		local waypoints = {}
		local map = workspace:FindFirstChild("Map")
		if map then
			local wpFolder = map:FindFirstChild("Waypoints")
			if wpFolder then
				for _, wp in ipairs(wpFolder:GetChildren()) do
					table.insert(waypoints, wp)
				end
				table.sort(waypoints, function(a, b)
					return (tonumber(a.Name:match("%d+")) or 0) < (tonumber(b.Name:match("%d+")) or 0)
				end)
			end
		end

		local selectedWp = getWaypointByPercentageFunction(waypoints, distPercent)
		if selectedWp then
			-- 3) Extrai custos dos botões (procura o primeiro frame com 6 TextButtons)
			local costs = {}
			if bottomGui then
				for _, frame in ipairs(bottomGui:GetDescendants()) do
					if frame:IsA("Frame") then
						local btns = {}
						for _, c in ipairs(frame:GetChildren()) do
							if c:IsA("TextButton") then table.insert(btns, c) end
						end
						if #btns == 6 then
							for idx, btn in ipairs(btns) do
								local lbl = btn:FindFirstChild("Cost", true)
								if not lbl then
									costs[idx] = 0
									continue;
								end
								local _ = lbl and lbl.Text:gsub("[$,]","") or nil
								costs[idx] = lbl and tonumber(_) or 0
							end
							break
						end
					end
				end
			end

			-- 4) Conta torres existentes
			local towerCounts = {}
			local towers = workspace:FindFirstChild("Towers")
			if towers then
				for _, t in ipairs(towers:GetChildren()) do
					towerCounts[t.Name] = (towerCounts[t.Name] or 0) + 1
				end
			end

			-- 5) Seleciona unidades para equipar
			local waveValue = waveTag.Value
			local cash      = player:FindFirstChild("Cash")
			local equippedUnits = {}

			-- 5.1) . PRIORIDADE (slots 1→6)
			for i = 6, 1, -1 do
				if waveValue >= waveThreshold[i] then
					local slot = slotsFolder:FindFirstChild("Slot"..i)
					local name = slot and slot.Value or ""
					if name ~= ""
						and (towerCounts[name] or 0) < placeMax[i]
						and cash and cash.Value >= (costs[i] or 0) then
						table.insert(equippedUnits, { UnitName = name; Slot = i })
						break
					end
				end
			end

			-- 5.2) . FALLBACK: todos os slots
			if #equippedUnits == 0 then
				for i = 1, 6 do
					if waveValue >= waveThreshold[i] then
						local slot = slotsFolder:FindFirstChild("Slot"..i)
						local name = slot and slot.Value or ""
						if name ~= ""
							and (towerCounts[name] or 0) < placeMax[i]
							and cash and cash.Value >= (costs[i] or 0) then
							table.insert(equippedUnits, { UnitName = name; Slot = i })
						end
					end
				end
			end

			-- 6) Dispara PlaceTower para cada unidade selecionada
			if #equippedUnits > 0 then
				table.sort(equippedUnits, function(a, b)
					return isFarmUnit(a.UnitName) and not isFarmUnit(b.UnitName) 
				end)

				local radius    = (groundPercent / 100) * 15
				local positions = getPositionsAroundPointFunction(selectedWp.Position, radius, #equippedUnits)
				for idx, info in ipairs(equippedUnits) do
					local pos = positions[idx]
					if pos and info.UnitName then
						remote:FireServer(info.UnitName, CFrame.new(pos))
						task.wait(0.8)
					end
				end
			end
		end

		task.wait(2)
	end
end
function autoUniversalSkillFunction()
	while getgenv().autoUniversalSkillEnabled == true do
		local mainUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local bossHealth = mainUI.BarHolder:FindFirstChild("Boss")
			local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value
			local remoteHandler = game:GetService("Players").LocalPlayer.PlayerScripts.Visuals
				:FindFirstChild("RemoteHandler")
			local towersFolder = workspace:WaitForChild("Towers")

			if getgenv().onlyUseSkillsInBossEnabled and bossHealth then
				for _, pastaBixo in ipairs(remoteHandler:GetChildren()) do
					local bixoName = pastaBixo.Name
					if towersFolder:FindFirstChild(bixoName) then
						for _, item in ipairs(pastaBixo:GetChildren()) do
							local skillNumber = item.Name:match("^Skill(%d+)$")
							local args = {
								[1] = towersFolder:WaitForChild(bixoName),
								[2] = tonumber(skillNumber) or item.Name,
							}
							game:GetService("ReplicatedStorage")
								:WaitForChild("Remotes")
								:WaitForChild("Ability")
								:InvokeServer(unpack(args))
						end
					end
				end
			elseif
				getgenv().onlyUseSkillsInWaveXEnabled and tonumber(waveValue) == tonumber(selectedWaveXToUseSKill)
			then
				for _, pastaBixo in ipairs(remoteHandler:GetChildren()) do
					local bixoName = pastaBixo.Name
					if towersFolder:FindFirstChild(bixoName) then
						for _, item in ipairs(pastaBixo:GetChildren()) do
							local skillNumber = item.Name:match("^Skill(%d+)$")
							local args = {
								[1] = towersFolder:WaitForChild(bixoName),
								[2] = tonumber(skillNumber) or item.Name,
							}
							game:GetService("ReplicatedStorage")
								:WaitForChild("Remotes")
								:WaitForChild("Ability")
								:InvokeServer(unpack(args))
						end
					end
				end
			else
				for _, pastaBixo in ipairs(remoteHandler:GetChildren()) do
					local bixoName = pastaBixo.Name
					if towersFolder:FindFirstChild(bixoName) then
						for _, item in ipairs(pastaBixo:GetChildren()) do
							local skillNumber = item.Name:match("^Skill(%d+)$")
							local args = {
								[1] = towersFolder:WaitForChild(bixoName),
								[2] = tonumber(skillNumber) or item.Name,
							}
							game:GetService("ReplicatedStorage")
								:WaitForChild("Remotes")
								:WaitForChild("Ability")
								:InvokeServer(unpack(args))
						end
					end
				end
			end
		end
		wait(1)
	end
end

function autoKurumiSkillFunction()
	while getgenv().autoKurumiSkillEnabled == true do
		local map = workspace:FindFirstChild("Map")

		if map then
			local KurumiInMap = workspace:FindFirstChild("Towers"):FindFirstChild("KurumiEvo")
			local remoteKurumi =
				game:GetService("ReplicatedStorage").Remotes:FindFirstChild("AbilityRemotes"):FindFirstChild("Zaphkol")
			local remoteAbility = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")

			if KurumiInMap and remoteKurumi and remoteAbility then
				local ohInstance1 = workspace.Towers.KurumiEvo
				local ohNumber2 = 1

				remoteAbility:InvokeServer(ohInstance1, ohNumber2)
				wait(1)
				local ohString1 = tostring(selectedKurumiSkillType)

				remoteKurumi:FireServer(ohString1)
			end
		end
		wait(1)
	end
end

function autoGarouSkillFunction()
	while getgenv().autoGarouSkillEnabled == true do
		local map = workspace:FindFirstChild("Map")

		if map then
			local KurumiInMap = workspace:FindFirstChild("Towers"):FindFirstChild("CosmicGarou")
			local remoteGarou = game:GetService("ReplicatedStorage").Remotes
				:FindFirstChild("AbilityRemotes")
				:FindFirstChild("Mode Swap")
			local remoteAbility = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")

			if KurumiInMap and remoteGarou and remoteAbility then
				local ohInstance1 = workspace.Towers.CosmicGarou
				local ohNumber2 = 1

				remoteAbility:InvokeServer(ohInstance1, ohNumber2)
				wait(1)
				local ohString1 = tostring(selectedGarouSkillType)

				remoteGarou:FireServer(ohString1)
			end
		end
		wait(1)
	end
end

function autoRestartAfterXMatchFunction()
	while getgenv().autoRestartAfterXMatchEnabled == true do
		repeat
			task.wait()
		until game:IsLoaded() and game:GetService("Players").LocalPlayer

		local SCRIPT_ENABLED = true
		local MATCH_LIMIT = MacLib.Options.selectedMatchXToRestartSlider.Value
		local MATCH_DELAY = 2

		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local RestartMatch = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("RestartMatch")

		local matchCounter = 0
		local matchEnded = false
		local player = game.Players.LocalPlayer
		local finishPart = workspace:WaitForChild("Map"):WaitForChild("Finish")

		repeat
			task.wait()
		until finishPart and finishPart:FindFirstChild("Humanoid")

		local BaseHumanoid = finishPart.Humanoid

		function onHealthChanged()
			if BaseHumanoid.Health <= 0 and not matchEnded then
				matchEnded = true
				matchCounter = matchCounter + 1

				if matchCounter == MATCH_LIMIT then
					task.wait(MATCH_DELAY)

					if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Finish") then
						RestartMatch:FireServer()
					end

					SCRIPT_ENABLED = false
				end
			elseif BaseHumanoid.Health > 0 then
				matchEnded = false
			end
		end

		BaseHumanoid.HealthChanged:Connect(onHealthChanged)

		onHealthChanged()
		wait(1)
	end
end

function autoLeaveInstaFunction()
	while getgenv().autoLeaveInstaEnabled == true do
		local mainUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then

			local selectedWave = MacLib.Options.OnlyLeaveinWave.Value
			local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value

			OnlyLeaveinWave = MacLib.Options.OnlyLeaveinWave.Value

			if selectedwaveXToLeave and tonumber(waveValue) == tonumber(selectedWave) then
			
				webhookFunction()
				wait(1)
				game:GetService("ReplicatedStorage").Remotes.TeleportBack:FireServer()
				break
			end
		end
		wait()
	end
end

function autoRestartFunction()
	while getgenv().autoRestartEnabled == true do
		local mainUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local selectedWave = MacLib.Options.RestartinWave.Value
			local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value

			selectedWaveXToRestart = MacLib.Options.selectedWaveXToRestartSlider.Value

			if selectedWaveXToRestart and tonumber(waveValue) == tonumber(selectedWave) then
				restartMatch = true
				webhookFunction()
				wait(1)
				game:GetService("ReplicatedStorage").Remotes.RestartMatch:FireServer()
				break
			end
		end
		wait(1)
	end
end

function autoCannonFunction()
	while getgenv().autoCannonEnabled == true do
		local mapa = workspace:FindFirstChild("Map")
		if mapa then
			local canhoes = workspace.Map.Map.Cannons

			for _, cannonModel in pairs(canhoes:GetChildren()) do
				local part = cannonModel:FindFirstChild("Meshes/cannon_Plane.001 (3)")

				if part then
					local hasSomethingInside = false
					for _, child in pairs(part:GetChildren()) do
						hasSomethingInside = true
					end

					if hasSomethingInside then
						local args = { [1] = cannonModel }
						game:GetService("ReplicatedStorage").Remotes.FireCannon:FireServer(unpack(args))
					end
				end
			end
		end
		wait(1)
	end
end

function autoCardFunction()
	while getgenv().autoCardEnabled == true do
		local player = game:GetService("Players").LocalPlayer
		local playerGui = player:FindFirstChild("PlayerGui")

		if playerGui then
			local promptGui = playerGui:FindFirstChild("Prompt")

			if promptGui then
				local textButton = promptGui:FindFirstChild("TextButton")

				if textButton then
					local mainFrame = textButton:FindFirstChild("Frame")

					if mainFrame then
						local availableCards = {}
						local cardPositions = {}
						local cardButtons = {}

						for _, childFrame in ipairs(mainFrame:GetChildren()) do
							if childFrame:IsA("Frame") then
								local textButtons = {}

								for pos, subChild in ipairs(childFrame:GetChildren()) do
									if subChild:IsA("TextButton") then
										table.insert(textButtons, subChild)
									end
								end

								if #textButtons == 4 then
									for pos, button in ipairs(textButtons) do
										local innerFrame = button:FindFirstChild("Frame")
										if innerFrame then
											local textLabel = innerFrame:FindFirstChild("TextLabel")
											if textLabel and textLabel.Text then
												table.insert(availableCards, textLabel.Text)
												cardPositions[textLabel.Text] = pos
												cardButtons[textLabel.Text] = button
											end
										end
									end
									break
								end
							end
						end

						local highestPriorityCard = nil
						local highestPriorityValue = -math.huge

						for _, cardName in ipairs(availableCards) do
							if cardPriorities[cardName] and cardPriorities[cardName] > highestPriorityValue then
								highestPriorityValue = cardPriorities[cardName]
								highestPriorityCard = cardName
							end
						end

						if highestPriorityCard then
							local cardPosition = cardPositions[highestPriorityCard]
							local selectedButtonCardNormal = cardButtons[highestPriorityCard]

							firebutton(selectedButtonCardNormal, "VirtualInputManager")
							wait(1)
						end
					end
				end
			end
		end
		wait(1)
	end
end

function autoBossRushCardFunction()
	while getgenv().autoBossRushCardEnabled == true do
		local player = game:GetService("Players").LocalPlayer
		local playerGui = player:FindFirstChild("PlayerGui")

		if playerGui then
			local promptGui = playerGui:FindFirstChild("Prompt")

			if promptGui and promptGui:IsA("ScreenGui") then
				local button = promptGui:FindFirstChildOfClass("TextButton")

				if button then
					local mainFrame = button:FindFirstChild("Frame")

					if mainFrame and mainFrame:IsA("Frame") then
						local availableCards = {}
						local cardPositions = {}
						local cardButtons = {}

						for _, childFrame in ipairs(mainFrame:GetChildren()) do
							if childFrame:IsA("Frame") then
								local textButtons = {}
								for pos, subChild in ipairs(childFrame:GetChildren()) do
									if subChild:IsA("TextButton") then
										table.insert(textButtons, subChild)
									end
								end

								if #textButtons == 4 then
									for pos, button in ipairs(textButtons) do
										local innerFrame = button:FindFirstChild("Frame")
										if innerFrame then
											local textLabel = innerFrame:FindFirstChild("TextLabel")
											if textLabel and textLabel.Text then
												table.insert(availableCards, textLabel.Text)
												cardPositions[textLabel.Text] = pos
												cardButtons[textLabel.Text] = button
											end
										end
									end
									break
								end
							end
						end

						local highestPriorityCard = nil
						local highestPriorityValue = -math.huge

						for _, cardName in ipairs(availableCards) do
							if cardPriorities2[cardName] and cardPriorities2[cardName] > highestPriorityValue then
								highestPriorityValue = cardPriorities2[cardName]
								highestPriorityCard = cardName
							end
						end

						if highestPriorityCard then
							local cardPosition = cardPositions[highestPriorityCard]
							local selectedButtonBossRushCard = cardButtons[highestPriorityCard]

							firebutton(selectedButtonBossRushCard, "VirtualInputManager")
							wait(1)
							local buttonConfirm =
								game:GetService("Players").LocalPlayer.PlayerGui.Prompt.TextButton.Frame
								:GetChildren()[5].TextButton
							firebutton(buttonConfirm, "VirtualInputManager")
						end
					end
				end
			end
		end
		wait(1)
	end
end

function autoJoinChallengeFunction()
	while getgenv().autoJoinChallengeEnabled == true do
		local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
		local challenge = workspace:FindFirstChild("TeleporterFolder")
			and workspace.TeleporterFolder.Challenge.Teleporter.Door

		if challenge then
			local ignoreChallenge = false
			for _, ignore in ipairs(selectedIgnoreChallenge) do
				if Teleporter.Challenge.Value == ignore then
					ignoreChallenge = true
					break
				end
			end

			if
				not ignoreChallenge
				and Teleporter.MapName.Value == selectedChallengeMap
				and Teleporter.MapNum.Value == selectActChallenge
			then
				task.wait(tonumber(selectedDelay))
				local challengeCFrame = GetCFrame(challenge)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(challengeCFrame)
				wait(1)
				local args = {
					[1] = "Select",
					[2] = "Challenge",
					[3] = 1,
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Teleporter")
					:WaitForChild("Interact")
					:FireServer(unpack(args))
				break
			end
		end
		wait()
	end
end

function autoJoinStoryFunction()
	while getgenv().autoJoinStoryEnabled == true do
		local story = workspace:FindFirstChild("TeleporterFolder") and workspace.TeleporterFolder.Story.Teleporter.Door
		local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
		if story then
			task.wait(tonumber(selectedDelay))
			local doorCFrame = GetCFrame(story)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
			wait(1)
			if getgenv().OnlyFriends == true then
				local args = {
					[1] = tostring(selectedStoryMap),
					[2] = selectedActStory,
					[3] = tostring(selectedDifficultyStory),
					[4] = true,
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Story")
					:WaitForChild("Select")
					:InvokeServer(unpack(args))
				selectedStoryYet = true
			else
				local args = {
					[1] = tostring(selectedStoryMap),
					[2] = selectedActStory,
					[3] = tostring(selectedDifficultyStory),
					[4] = false,
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Story")
					:WaitForChild("Select")
					:InvokeServer(unpack(args))
				selectedStoryYet = true
			end
			wait(1)
			local argsTeleporter = {
				[1] = "Skip",
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("Teleporter")
				:WaitForChild("Interact")
				:FireServer(unpack(argsTeleporter))
			break
		end
		wait()
	end
end

function autoJoinBreachAct1Function()
	selectedDelay = MacLib.Options.selectedDelay.Value
	task.wait(selectedDelay)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local enterBattle = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Easter2025"):WaitForChild("EnterBattle")
	
	enterBattle:FireServer()
end


function autoJoinBreachAct2Function()
	local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
	task.wait(tonumber(selectedDelay))
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local enterBreach = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Breach"):WaitForChild("Enter")
	local lobbyFolder = workspace:WaitForChild("Lobby", 60)
	local breachesFolder = lobbyFolder:WaitForChild("Breaches", 60)
	while true do
    
		local enteredAny = false
    for _, breachPart in ipairs(breachesFolder:GetChildren()) do
        if breachPart:IsA("BasePart") and #breachPart:GetChildren() > 0 then
            enterBreach:FireServer(breachPart)
            enteredAny = true
        end
        task.wait(0.1)    
	end
	task.wait(1)
	end
end


function autoJoinBreachesFunction()
	local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
	task.wait(tonumber(selectedDelay))
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local enterBreach = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Breach"):WaitForChild("Enter")
	local enterBattle = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Easter2025"):WaitForChild("EnterBattle")
	local lobbyFolder = workspace:WaitForChild("Lobby", 60)
	local breachesFolder = lobbyFolder:WaitForChild("Breaches", 60)
	while true do
    local enteredAny = false
    for _, breachPart in ipairs(breachesFolder:GetChildren()) do
        if breachPart:IsA("BasePart") and #breachPart:GetChildren() > 0 then
            enterBreach:FireServer(breachPart)
            enteredAny = true
        end
        task.wait(0.1)
    end
    if not enteredAny then
        enterBattle:FireServer()
    end
    task.wait(5)
	end
end
	
function autoCollectEggsFunction()
	local Map = workspace:WaitForChild("Map", 30)
	local lp = game:GetService("Players").LocalPlayer
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	if not Map then return end
	local function fireProximityPrompts()
    for _, egg in ipairs(workspace:GetChildren()) do
        local num = tonumber(egg.Name)
        if num and egg:IsA("Model") then
            local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                hrp.CFrame = egg:FindFirstChild("HumanoidRootPart").CFrame
                fireproximityprompt(prompt)
            	end
        	end
    	end
	end

		while true do
    	fireProximityPrompts()
    	task.wait(1)
	end
end

function autoJoinRaidFunction()
	while getgenv().autoJoinRaidEnabled == true do
		local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
		local raidFolder = workspace:FindFirstChild("TeleporterFolder")
		if raidFolder and raidFolder:FindFirstChild("Raids") then
			local door = raidFolder.Raids.Teleporter:FindFirstChild("Door")
			if door then
				task.wait(tonumber(selectedDelayT))
				local doorCFrame = GetCFrame(door)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
				wait(1)
				if getgenv().OnlyFriends == true then
					local argsRaid = {
						[1] = selectedRaidMap,
						[2] = selectedFaseRaid,
						[3] = "Nightmare",
						[4] = true,
					}
					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("Raids")
						:WaitForChild("Select")
						:InvokeServer(unpack(argsRaid))
				else
					local argsRaid = {
						[1] = selectedRaidMap,
						[2] = selectedFaseRaid,
						[3] = "Nightmare",
						[4] = false,
					}
					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("Raids")
						:WaitForChild("Select")
						:InvokeServer(unpack(argsRaid))
				end
				wait(1)
				local argsTeleporter = {
					[1] = "Skip",
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Teleporter")
					:WaitForChild("Interact")
					:FireServer(unpack(argsTeleporter))
				break
			end
		end
		wait(1)
	end
end

function fireCastleRequests(room) end

function teleportToNPC(npcName)
	local npc = workspace.Lobby.Npcs:FindFirstChild(npcName)
	if npc then
		local teleportCFrame = GetCFrame(npc)
		if teleportCFrame then
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
			wait(1)
		end
	end
end

function joinInfCastleFunction()
	while getgenv().joinInfCastleEnabled == true do
		local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
		task.wait(tonumber(selectedDelay))
		teleportToNPC("Asta")

		if selectedRoomInfCastle then
			wait(1)
			local args = { "GetGlobalData" }
			game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("InfiniteCastleManager")
				:FireServer(unpack(args))
			local args = { "Play", tonumber(selectedRoomInfCastle), false }
			game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("InfiniteCastleManager")
				:FireServer(unpack(args))
			break
		end
		wait(1)
	end
end

function autoPortalFunction()
	while getgenv().autoPortalEnabled == true do
		local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
		local playerData = game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("GetPlayerData")
			:InvokeServer(game.Players.LocalPlayer)

		for portalID, portalEntry in pairs(playerData.PortalData) do
			if not portalEntry or type(portalEntry) ~= "table" then
				wait()
			end

			local portalName = portalEntry.PortalName or "N/A"
			local portalId = portalEntry.PortalID
			local portalData = portalEntry.PortalData or {}
			local challenges = portalData.Challenges or "Nenhum"
			local portalTierFormatted = portalData.Tier and ("Tier " .. tostring(portalData.Tier)) or "N/A"

			local mapMatch = selectedPortalMap == "None" or selectedPortalMap == portalName

			local tierMatch = false
			if not selectedPortalTier or #selectedPortalTier == 0 then
				tierMatch = true
			else
				for _, selectedTier in ipairs(selectedPortalTier) do
					if tostring(selectedTier) == portalTierFormatted then
						tierMatch = true
					end
				end
			end

			local modifierMatch = true
			if selectedPortalModifier and #selectedPortalModifier > 0 then
				for _, ignoredModifier in ipairs(selectedPortalModifier) do
					if tostring(ignoredModifier) == tostring(challenges) then
						modifierMatch = false
					end
				end
			end

			if mapMatch and tierMatch and modifierMatch == false then
				local map = workspace:FindFirstChild("Map")

				if not map then
					task.wait(tonumber(selectedDelay))
					local args = {
						[1] = tostring(portalId),
					}

					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("Portals")
						:WaitForChild("Activate")
						:InvokeServer(unpack(args))
					wait(1)
					local PortalUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("PortalUI")
					if PortalUI then
						local button = PortalUI.BG.Bottom.Start
						firebutton(button, "VirtualInputManager")
						local argsTeleporter = {
							[1] = "Start",
						}
						game:GetService("ReplicatedStorage")
							:WaitForChild("Remotes")
							:WaitForChild("Teleporter")
							:WaitForChild("Interact")
							:FireServer(unpack(argsTeleporter))
					end
				end
			end
		end
		wait(1)
	end
end

function autoNextPortalFunction()
	while getgenv().autoNextPortalEnabled == true do
		local playerData = game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("GetPlayerData")
			:InvokeServer(game.Players.LocalPlayer)

		for portalID, portalEntry in pairs(playerData.PortalData) do
			if not portalEntry or type(portalEntry) ~= "table" then
				wait()
			end

			local portalName = portalEntry.PortalName or "N/A"
			local portalId = portalEntry.PortalID
			local portalData = portalEntry.PortalData or {}
			local challenges = portalData.Challenges or "Nenhum"
			local portalTierFormatted = portalData.Tier and ("Tier " .. tostring(portalData.Tier)) or "N/A"

			local mapMatch = selectedPortalMap == "None" or selectedPortalMap == portalName

			local tierMatch = false
			if not selectedPortalTier or #selectedPortalTier == 0 then
				tierMatch = true
			else
				for _, selectedTier in ipairs(selectedPortalTier) do
					if tostring(selectedTier) == portalTierFormatted then
						tierMatch = true
					end
				end
			end

			local modifierMatch = true
			if selectedPortalModifier and #selectedPortalModifier > 0 then
				for _, ignoredModifier in ipairs(selectedPortalModifier) do
					if tostring(ignoredModifier) == tostring(challenges) then
						modifierMatch = false
					end
				end
			end

			if mapMatch and tierMatch and modifierMatch == false then
				local uiEndGame = player:WaitForChild("PlayerGui"):WaitForChild("EndGameUI")
				if uiEndGame and uiEndGame.Enabled == true then
					wait(1)
	
					webhookFunction()
					wait(6)
					local args = {
						[1] = tostring(portalId),
					}

					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("Portals")
						:WaitForChild("Activate")
						:InvokeServer(unpack(args))
				end
			end
		end
		wait(1)
	end
end

local sucess, erro = pcall(function()
	local portalSelection = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("PortalSelection")
	if portalSelection then
		portalSelection.OnClientEvent:Connect(function(tb)
			while getgenv().autoGetRewardPortalEnabled == true do
				for i, v in pairs(tb) do
					local button = nil
					local Position = i
					local PortalData = v.PortalData
					local PortalName = v.PortalName

					local prompt = safeWaitForChild(playerGui, "Prompt", 5)
					if not prompt then
						return
					end

					for challenge, portal in pairs(selectedPortalModifier) do
						if PortalData.Challenges == portal then
							local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
							local button2 = prompt.TextButton:FindFirstChild("TextButton")
							if button2 then
								firebutton(button2, "getconnections")
							end

							local textButton = safeWaitForChild(prompt, "TextButton", 5)
							if not textButton then
								return
							end

							local frame = safeWaitForChild(textButton, "Frame", 5)
							if not frame then
								return
							end

							local children = frame:GetChildren()

							if Position == 1 then
								local frameChild = children[4]
								local button1 = frameChild and safeWaitForChild(frameChild, "TextButton", 3)
								local button2 = children[5] and safeWaitForChild(children[5], "TextButton", 3)

								if button1 and button2 then
									firebutton(button1, "VirtualInputManager")
									wait(1)
									firebutton(button2, "VirtualInputManager")
									wait(2)
								end
							elseif Position == 2 then
								local subChildren = children[4] and children[4]:GetChildren()
								local button1 = subChildren
									and subChildren[3]
									and safeWaitForChild(subChildren[3], "TextButton", 3)
								local button2 = children[5] and safeWaitForChild(children[5], "TextButton", 3)

								if button1 and button2 then
									firebutton(button1, "VirtualInputManager")
									wait(1)
									firebutton(button2, "VirtualInputManager")
									wait(2)
								end
							else
								local subChildren = children[4] and children[4]:GetChildren()
								local button1 = subChildren
									and subChildren[2]
									and safeWaitForChild(subChildren[2], "TextButton", 3)
								local button2 = children[5] and safeWaitForChild(children[5], "TextButton", 3)

								if button1 and button2 then
									firebutton(button1, "VirtualInputManager")
									wait(1)
									firebutton(button2, "VirtualInputManager")
									wait(2)
								end
							end
						end
					end
				end
				wait(1)
			end
		end)
	end
end)
if not sucess then
end

function autoBossRushFunction()
	local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
	while getgenv().autoBossRushEnabled == true do
		task.wait(tonumber(selectedDelay))
		local remote = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Snej")
		if remote then
			remote.StartBossRush:FireServer(selectedBossRush)
		end
		wait(1)
	end
end

function autoElementalCavernFunction()
	local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
	while getgenv().autoElementalCavernEnabled == true do
		local raidFolder = workspace:FindFirstChild("TeleporterFolder")
		if raidFolder and raidFolder:FindFirstChild("ElementalCaverns") then
			local door = raidFolder.ElementalCaverns.Teleporter:FindFirstChild("Door")
			if door then
				task.wait(tonumber(selectedDelay))
				local doorCFrame = GetCFrame(door)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
				wait(1)
				if getgenv().OnlyFriends == true then
					local args = {
						[1] = tostring(selectedCavern),
						[2] = tostring(selectedDifficultyCavern),
						[3] = true,
					}

					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("ElementalCaverns")
						:WaitForChild("Select")
						:InvokeServer(unpack(args))
				else
					local args = {
						[1] = tostring(selectedCavern),
						[2] = tostring(selectedDifficultyCavern),
						[3] = false,
					}

					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("ElementalCaverns")
						:WaitForChild("Select")
						:InvokeServer(unpack(args))
				end
				wait(1)
				local argsTeleporter = {
					[1] = "Skip",
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Teleporter")
					:WaitForChild("Interact")
					:FireServer(unpack(argsTeleporter))
				break
			end
		end
		wait(1)
	end
end

local ExtremeBoosts = nil
local chances = game:GetService("ReplicatedStorage"):FindFirstChild("Chances")
if chances then
	ExtremeBoosts = chances:FindFirstChild("ExtremeBoosts")
end

function checkForToken(tbl, tokenName)
	for key, value in pairs(tbl) do
		if typeof(value) == "table" then
			if checkForToken(value, tokenName) then
				return true
			end
		elseif key == "Name" and value == tokenName then
			return true
		end
	end
	return false
end

function autoJoinExtremeBoostFunction()
	local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
	local retorno =
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData"):InvokeServer(player)
	while getgenv().autoJoinExtremeBoostEnabled == true do
		task.wait(tonumber(selectedDelay))
		local infernalBoost = retorno.ExtremeBoostsProgress["Wanderniech"]
		local divineBoost = retorno.ExtremeBoostsProgress["Dragon Heaven"]
		local Act = (Mapa or 0) + 1
		local remoteExtremeBoosts =
			game:GetService("ReplicatedStorage").Remotes:FindFirstChild("ExtremeBoosts"):FindFirstChild("Enter")

		if selectedExtremeBoost == "Infernal Boost" then
			local Act = (infernalBoost or 0) + 1
			remoteExtremeBoosts:FireServer("Wanderniech", tonumber(Act))
		elseif selectedExtremeBoost == "Divine Boost" then
			local Act = (divineBoost or 0) + 1
			remoteExtremeBoosts:FireServer("Dragon Heaven", tonumber(Act))
		end
		wait(1)
	end
end

function getCardPositionByY(scrollingFrame, card)
	local cards = {}
	for _, v in ipairs(scrollingFrame:GetChildren()) do
		if v:IsA("TextButton") then
			table.insert(cards, v)
		end
	end
	table.sort(cards, function(a, b)
		return a.AbsolutePosition.Y < b.AbsolutePosition.Y
	end)
	for idx, v in ipairs(cards) do
		if v == card then
			return idx
		end
	end
	return nil
end

function getCardPositionByY(scrollingFrame, card)
	local cards = {}
	for _, v in ipairs(scrollingFrame:GetChildren()) do
		if v:IsA("TextButton") then
			table.insert(cards, v)
		end
	end
	table.sort(cards, function(a, b)
		return a.AbsolutePosition.Y < b.AbsolutePosition.Y
	end)
	for idx, v in ipairs(cards) do
		if v == card then
			return idx
		end
	end
	return nil
end

function deselectAllDebuffs(dungeonEntry)
	local scrollingFrame = dungeonEntry.Frame.Frame:GetChildren()[3].Frame.ScrollingFrame

	for _, v in pairs(scrollingFrame:GetChildren()) do
		if v:IsA("TextButton") then
			local lvl1 = v:FindFirstChild("Frame")
			if not lvl1 then
				continue
			end
			local folder = lvl1:FindFirstChild("Folder")
			if not folder then
				continue
			end
			local sel = folder:FindFirstChild("Frame")
			if not sel then
				continue
			end

			if sel then
				local pos = getCardPositionByY(scrollingFrame, v)
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Dungeon")
					:WaitForChild("ToggleModifier")
					:FireServer(selectedDungeon, pos)
			end
		end
	end
end

function selectDebuffs(dungeonEntry, debuffsList)
	local scrollingFrame = dungeonEntry.Frame.Frame:GetChildren()[3].Frame.ScrollingFrame
	for _, debuffChoosed in pairs(debuffsList) do
		for _, v in pairs(scrollingFrame:GetChildren()) do
			if v:IsA("TextButton") then
				local lvl1 = v:FindFirstChild("Frame")
				if not lvl1 then
					continue
				end
				local lvl2 = lvl1:FindFirstChild("Frame")
				if not lvl2 then
					continue
				end
				local txt = lvl2:FindFirstChild("TextLabel")
				if not txt then
					continue
				end

				if txt.Text == debuffChoosed then
					local pos = getCardPositionByY(scrollingFrame, v)
					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("Dungeon")
						:WaitForChild("ToggleModifier")
						:FireServer(selectedDungeon, pos)
				end
			end
		end
	end
end

function autoDungeonFunction()
	local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
	local canTeleport = true
	while getgenv().autoDungeonEnabled == true do
		task.wait(tonumber(selectedDelay))
		local teleFolder = workspace:FindFirstChild("TeleporterFolder")
		local door = teleFolder
			and teleFolder.Dungeon
			and teleFolder.Dungeon.Teleporter
			and teleFolder.Dungeon.Teleporter.Door
		if door and canTeleport then
			local cf = GetCFrame(door)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(cf)
		end
		wait(2)
		canTeleport = false

		local dungeonEntry = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("DungeonEntry")
		if not dungeonEntry then
			break
		end

		local btnOpen
		if selectedDungeon == "Giant's Dungeon" then
			btnOpen = dungeonEntry.Frame:GetChildren()[5].Frame.TextButton
		else
			btnOpen = dungeonEntry.Frame:GetChildren()[5].Frame:GetChildren()[4]
		end
		firebutton(btnOpen, "getconnections")
		wait(1)
		deselectAllDebuffs(dungeonEntry)
		wait(1)
		selectDebuffs(dungeonEntry, selectedDungeonDebuff)
		wait(1)
		local btnConfirm = dungeonEntry.Frame.Frame.Frame:GetChildren()[6].TextButton
		firebutton(btnConfirm, "VirtualInputManager")
		wait(1)
		game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("Teleporter")
			:WaitForChild("Interact")
			:FireServer("Skip")
		task.wait(1)
	end
end

function getCardPositionByY(scrollingFrame, card)
	local cards = {}
	for _, v in ipairs(scrollingFrame:GetChildren()) do
		if v:IsA("TextButton") then
			table.insert(cards, v)
		end
	end
	table.sort(cards, function(a, b)
		return a.AbsolutePosition.Y < b.AbsolutePosition.Y
	end)
	for idx, v in ipairs(cards) do
		if v == card then
			return idx -- 1 = topo, 6 = último
		end
	end
	return nil
end

function autoSurvivalFunction()
	local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
	local canTeleport = true
	while getgenv().autoSurvivalEnabled do
		task.wait(tonumber(selectedDelay))
		local teleFolder = workspace:FindFirstChild("TeleporterFolder")
		local door = teleFolder
			and teleFolder.Survival
			and teleFolder.Survival.Teleporter
			and teleFolder.Survival.Teleporter.Door
		if door and canTeleport then
			local doorCFrame = GetCFrame(door)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
		end
		wait(2)
		canTeleport = false

		local survivalEntry = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("SurvivalEntry")
		if not survivalEntry then
			warn("SurvivalEntry não encontrado")
			break
		end

		local frame4 = survivalEntry.Frame and survivalEntry.Frame.Frame and survivalEntry.Frame.Frame:GetChildren()[4]
		local qtdDebuffJaEscolhido
		if
			frame4
			and frame4.Frame
			and frame4.Frame.Frame
			and frame4.Frame.Frame.Frame
			and frame4.Frame.Frame.Frame.Frame
		then
			qtdDebuffJaEscolhido = frame4.Frame.Frame.Frame.Frame.TextLabel.Text
		end

		function handleSelection(debuffChoosed)
			local scrollingFrame = frame4.Frame.ScrollingFrame
			for _, v in pairs(scrollingFrame:GetChildren()) do
				if v:IsA("TextButton") then
					local posicao = getCardPositionByY(scrollingFrame, v)
					local lvl1 = v:FindFirstChild("Frame")
					if not lvl1 then
						continue
					end
					local lvl2 = lvl1:FindFirstChild("Frame")
					if not lvl2 then
						continue
					end
					local txt = lvl2:FindFirstChild("TextLabel")
					if not txt then
						continue
					end

					if txt.Text == debuffChoosed then
						game:GetService("ReplicatedStorage")
							:WaitForChild("Remotes")
							:WaitForChild("Survival")
							:WaitForChild("ToggleModifier")
							:FireServer(selectedSurvival, posicao)

						local btnConfirm = survivalEntry.Frame.Frame:GetChildren()[3]:GetChildren()[7].TextButton
						firebutton(btnConfirm, "VirtualInputManager")
						wait(1)
						local argsTeleporter = {
							[1] = "Skip",
						}
						game:GetService("ReplicatedStorage")
							:WaitForChild("Remotes")
							:WaitForChild("Teleporter")
							:WaitForChild("Interact")
							:FireServer(unpack(argsTeleporter))
					end
				end
			end
		end

		function handleAlreadySelected()
			local scrollingFrame = frame4.Frame.ScrollingFrame
			for _, v in pairs(scrollingFrame:GetChildren()) do
				if v:IsA("TextButton") then
					local posicao = getCardPositionByY(scrollingFrame, v)
					local lvl1 = v:FindFirstChild("Frame")
					if not lvl1 then
						continue
					end
					local folder = lvl1:FindFirstChild("Folder")
					if not folder then
						continue
					end
					local sel = folder:FindFirstChild("Frame")
					if not sel then
						continue
					end

					if sel then
						game:GetService("ReplicatedStorage")
							:WaitForChild("Remotes")
							:WaitForChild("Survival")
							:WaitForChild("ToggleModifier")
							:FireServer(selectedSurvival, posicao)
					end
				end
			end
		end

		if selectedDifficultySurvival == "Normal" then
			local btnOpen = survivalEntry.Frame.Frame.Frame.Frame.TextButton
			firebutton(btnOpen, "getconnections")

			if qtdDebuffJaEscolhido ~= "1/1 Selected" then
				for _, debuffChoosed in pairs(selectedSurvivalDebuff) do
					handleSelection(debuffChoosed)
				end
			else
				handleAlreadySelected()
			end
		elseif selectedDifficultySurvival == "Nightmare" then
			local btnOpen = survivalEntry.Frame.Frame.Frame.Frame:GetChildren()[4]
			firebutton(btnOpen, "getconnections")

			if qtdDebuffJaEscolhido ~= "1/2 Selected" and qtdDebuffJaEscolhido ~= "2/2 Selected" then
				for _, debuffChoosed in pairs(selectedSurvivalDebuff) do
					handleSelection(debuffChoosed)
				end
			else
				handleAlreadySelected()
			end
		else
			local btnOpen = survivalEntry.Frame.Frame.Frame.Frame:GetChildren()[5]
			firebutton(btnOpen, "getconnections")

			if
				qtdDebuffJaEscolhido ~= "1/3 Selected"
				and qtdDebuffJaEscolhido ~= "2/3 Selected"
				and qtdDebuffJaEscolhido ~= "3/3 Selected"
			then
				for _, debuffChoosed in pairs(selectedSurvivalDebuff) do
					handleSelection(debuffChoosed)
				end
			else
				handleAlreadySelected()
			end
		end
		task.wait(1)
	end
end

function autoJoinLegendFunction()
	local selectedDelay = MacLib.Options.SelectedDelayToJoinGamemodes.Value
	while getgenv().autoJoinLegendEnabled == true do
		task.wait(tonumber(selectedDelay))
		local door = workspace:FindFirstChild("TeleporterFolder") and workspace.TeleporterFolder.Story.Teleporter.Door
		local doorCFrame = GetCFrame(door)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
		wait(1)
		if getgenv().OnlyFriends == true then
			local args = {
				[1] = tostring(selectedLegendMap),
				[2] = tonumber(selectedActLegend),
				[3] = "Purgatory",
				[4] = true,
				[5] = true,
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("Story")
				:WaitForChild("Select")
				:InvokeServer(unpack(args))
		else
			local args = {
				[1] = tostring(selectedLegendMap),
				[2] = tonumber(selectedActLegend),
				[3] = "Purgatory",
				[4] = false,
				[5] = true,
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("Story")
				:WaitForChild("Select")
				:InvokeServer(unpack(args))
		end
		wait(1)
		local argsTeleporter = {
			[1] = "Skip",
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("Teleporter")
			:WaitForChild("Interact")
			:FireServer(unpack(argsTeleporter))
		break
	end
end

--Function in Lobby

function autoFeedFunction()
	while getgenv().autoFeedEnabled == true do
		local args = {
			[1] = selectedUnitToFeed,
			[2] = {
				[selectedFeed] = 1,
			},
		}

		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Feed"):FireServer(unpack(args))
		wait()
	end
end

function autoTraitFunction()
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local retornoRemote = Remotes:WaitForChild("GetPlayerData")
	local QuirksRoll = Remotes:WaitForChild("Quirks"):WaitForChild("Roll")
	local player = Players.LocalPlayer

	local selectedUnitStr = tostring(selectedUnitToRollPassive)
	local selectedPassiveSet = {}

	if typeof(selectedPassive) == "table" then
		for _, passive in ipairs(selectedPassive) do
			selectedPassiveSet[passive] = true
		end
	end

	while getgenv().autoTraitEnabled == true do
		local retorno = retornoRemote:InvokeServer()
		local unitData = retorno and retorno["UnitData"]
		if typeof(unitData) == "table" then
			for _, unitInfo in pairs(unitData) do
				if typeof(unitInfo) == "table" and tostring(unitInfo["UnitID"]) == selectedUnitStr then
					local personagemName = unitInfo["UnitName"]
					local quirk = unitInfo["Quirk"]
					local quirkName = quirk or "None"
					if selectedPassiveSet[quirkName] then
						Window:Notify({
							Title = "Passive Roll",
							Description = "You got one of the selected Passives: " .. quirkName,
							Lifetime = 3,
						})
						webhookTraitRerollFunction(quirkName, tostring(personagemName))
						return;
					else
						if quirkName == nil or quirkName == "None" then
							QuirksRoll:InvokeServer(selectedUnitStr)
						else
							QuirksRoll:InvokeServer(selectedUnitStr, quirkName)
						end
					end
					webhookTraitRerollFunction(quirkName, tostring(personagemName))
					break;
				end
			end
		end
		task.wait()
	end
end

local borders = {
	["RangeAndSpeedBorders"] = {
		["C-"] = { -10, -7.5 },
		["C"] = { -7.4, -5 },
		["C+"] = { -4.9, -2.5 },
		["B-"] = { -2.4, 0 },
		["B"] = { 0.1, 1 },
		["B+"] = { 1.1, 2 },
		["A-"] = { 2.1, 3 },
		["A"] = { 3.1, 4 },
		["A+"] = { 4.1, 5 },
		["S-"] = { 5.1, 6.5 },
		["S"] = { 6.6, 8 },
		["S+"] = { 8.1, 9.5 },
		["SS"] = { 9.6, 11 },
		["SSS"] = { 11.1, 12.5 },
	},
	["DamageBorders"] = {
		["C-"] = { -10, -6 },
		["C"] = { -3, -5.9 },
		["C+"] = { 0, -2.9 },
		["B-"] = { 0.1, 3 },
		["B"] = { 3.1, 6 },
		["B+"] = { 6.1, 9 },
		["A-"] = { 9.1, 12 },
		["A"] = { 12.1, 15 },
		["A+"] = { 15.1, 18 },
		["S-"] = { 18.1, 19.5 },
		["S"] = { 19.6, 21 },
		["S+"] = { 21.1, 22.5 },
		["SS"] = { 22.6, 23.8 },
		["SSS"] = { 23.9, 25 },
	},
}

function getStatRankFunction(value, category)
	for rank, range in pairs(borders[category]) do
		local min, max = range[1], range[2]
		if value >= min and value <= max then
			return rank
		end
	end
	return "Unknown"
end

function autoStatFunction()
	while getgenv().autoStatEnabled == true do
		local player = game.Players.LocalPlayer
		local retorno = game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("GetPlayerData")
			:InvokeServer(player)

		if typeof(retorno) == "table" then
			local unitData = retorno["UnitData"]
			if typeof(unitData) == "table" then
				for _, unitInfo in pairs(unitData) do
					if typeof(unitInfo) == "table" then
						local unitID = unitInfo["UnitID"]
						if tostring(unitID) == tostring(selectedUnitToRollStat) then
							local stats = unitInfo["StatInfo"]
							if stats then
								local speed = stats.Speed
								local range = stats.Range
								local damage = stats.Damage

								local speedRank = getStatRankFunction(speed, "RangeAndSpeedBorders")
								local rangeRank = getStatRankFunction(range, "RangeAndSpeedBorders")
								local damageRank = getStatRankFunction(damage, "DamageBorders")

								local matched = false

								if selectedTypeOfRollStat == "All Stats" then
									if
										table.find(selectedStatToGet, speedRank)
										and table.find(selectedStatToGet, rangeRank)
										and table.find(selectedStatToGet, damageRank)
									then
										matched = true
									end
								else
									if
										selectedTypeOfRollStat == "Speed" and table.find(selectedStatToGet, speedRank)
									then
										matched = true
									elseif
										selectedTypeOfRollStat == "Range" and table.find(selectedStatToGet, rangeRank)
									then
										matched = true
									elseif
										selectedTypeOfRollStat == "Damage"
										and table.find(selectedStatToGet, damageRank)
									then
										matched = true
									end
								end

								if matched then
									Window:Notify({
										Title = "Passive Roll",
										Description = "You got it: " .. quirkName .. " Desgraça",
										Lifetime = 3,
									})
									break
								else
									if selectedTypeOfRollStat == "All Stats" then
										game:GetService("ReplicatedStorage").Remotes.RerollStatsFunc
											:InvokeServer(tostring(selectedUnitToRollStat))
									elseif
										selectedTypeOfRollStat == "Damage"
										or selectedTypeOfRollStat == "Range"
										or selectedTypeOfRollStat == "Speed"
									then
										game:GetService("ReplicatedStorage").Remotes.RerollStatsFunc:InvokeServer(
											tostring(selectedUnitToRollStat),
											tostring(selectedTypeOfRollStat)
										)
									end
								end
							end
						end
					end
				end
			end
		end
		wait(1)
	end
end

function autoGetBattlepassFunction()
	while getgenv().autoGetBattlepassEnabled == true do
		wait(1)
		local args = {
			[1] = "All",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("ClaimBattlePass")
			:FireServer(unpack(args))
		wait(1)
	end
end

if not LPH_OBFUSCATED then
	LPH_NO_UPVALUES = function(f)
		return f
	end
	LPH_NO_VIRTUALIZE = function(...)
		return ...
	end
end
LPH_NO_VIRTUALIZE(function()
	task.spawn(function()
		for _, v in pairs(getgc()) do
			if typeof(v) == "function" and debug.info(v, "n") == "Place" then
				local old
				old = hookfunction(
					v,
					function(...)
						if getgenv().placeAnywhereEnabled then
							debug.setupvalue(old, 2, true)
						end
						return old(...)
					end)
				break
			end
		end
	end)
end)()
-- Macro

local macrosFolder = "Tempest Hub/_ALS_/Macros"

if not isfolder(macrosFolder) then
	makefolder(macrosFolder)
else
end

function updateDropdownFunction()
	local newMacros = {}

	if isfolder(macrosFolder) then
		for _, file in ipairs(listfiles(macrosFolder)) do
			local name = file:match("([^/\\]+)%.json$")
			if name then
				table.insert(newMacros, name)
			end
		end
	end

	macros = newMacros

	if selectedUIMacro then
		selectedUIMacro:ClearOptions()
		selectedUIMacro:InsertOptions(macros)
		selectedMacro = nil
	end
end

function createJsonFileFunction(fileName)
	if not fileName or fileName == "" or fileName == "None" then
		Window:Notify({
			Title = "Error",
			Description = "Please enter a valid macro name",
			Lifetime = 3,
		})
		return
	end

	local filePath = macrosFolder .. "/" .. fileName .. ".json"
	if isfile(filePath) then
		Window:Notify({
			Title = "Error",
			Description = "Macro already exists",
			Lifetime = 3,
		})
		return
	end

	writefile(filePath, "{}")

	Window:Notify({
		Title = "Success",
		Description = "Macro created: " .. fileName,
		Lifetime = 3,
	})
end

function recordingMacroFunction()
	if not selectedMacro or selectedMacro == "None" then
		RecordMacro:UpdateState(false)
		return
	end

	if not selectedTypeOfRecord or selectedTypeOfRecord == "None" then
		RecordMacro:UpdateState(false)
		return
	end

	isRecording = not isRecording

	updateRecordingStatus()

	if isRecording then
		recordingData = { steps = {}, currentStepIndex = 0 }
		startTime = tick()
		getgenv().macroRecordControlEnabled = true

		task.spawn(function()
			while getgenv().macroRecordControlEnabled and isRecording do
				local uiEndGame = player.PlayerGui:WaitForChild("EndGameUI")

				if uiEndGame and uiEndGame.Enabled then
					isRecording = false
				end
				if not isRecording then
					if recordingData and #recordingData.steps > 0 then
						local filePath = macrosFolder .. "/" .. selectedMacro .. ".json"
						local jsonData = game:GetService("HttpService"):JSONEncode(recordingData)
						writefile(filePath, jsonData)
					end

					getgenv().macroRecordControlEnabled = false
					RecordMacro:UpdateState(false)
					updateRecordingStatus()
					break
				end

				task.wait(0.1)
			end
		end)
	else
		local filePath = macrosFolder .. "/" .. selectedMacro .. ".json"
		local jsonData = game:GetService("HttpService"):JSONEncode(recordingData)
		writefile(filePath, jsonData)
		getgenv().macroRecordControlEnabled = false
	end
end

function macroRecordControlFunction()
	while getgenv().macroRecordControlEnabled and isRecording do
		local uiEndGame = player.PlayerGui:WaitForChild("EndGameUI")
		if uiEndGame and uiEndGame.Enabled then
			isRecording = false
			getgenv().macroRecordControlEnabled = false

			table.sort(recordingData.steps, function(a, b)
				return a.index < b.index
			end)

			local filePath = macrosFolder .. "/" .. selectedMacro .. ".json"

			local jsonData = game:GetService("HttpService"):JSONEncode(recordingData)

			writefile(filePath, jsonData)

			RecordMacro:UpdateState(false)
			updateRecordingStatus()

			Window:Notify({
				Title = "Finished Record",
				Description = "Macro Saved",
				Lifetime = 3,
			})

			break
		end
		task.wait(0.1)
	end
end

function collectRemoteInfoFunction(remoteName, args)
	if not recordingData then
		recordingData = { steps = {}, currentStepIndex = 0 }
	end

	local remoteData = {
		action = remoteName,
		arguments = args,
		index = (recordingData.currentStepIndex or 0) + 1,
	}

	recordingData.currentStepIndex = remoteData.index

	if selectedTypeOfRecord == "Time" or selectedTypeOfRecord == "Hybrid" then
		remoteData.time = tick() - startTime
	end

	if selectedTypeOfRecord == "Money" or selectedTypeOfRecord == "Hybrid" then
		local player = game.Players.LocalPlayer
		local money = player:FindFirstChild("Cash")
		if money then
			remoteData.money = money.Value
		end
	end

	if #args > 1 then
		local serializedArgs = {}
		for i = 1, #args do
			local arg = args[i]
			if typeof(arg) == "table" then
				local serializedTable = {}
				for k, v in pairs(arg) do
					if typeof(v) == "CFrame" then
						serializedTable[tostring(k)] = { CFrame = { v:GetComponents() } }
					elseif typeof(v) == "Vector3" then
						serializedTable[tostring(k)] = { Vector3 = { X = v.X, Y = v.Y, Z = v.Z } }
					elseif typeof(v) == "Instance" then
						serializedTable[tostring(k)] = { Instance = v:GetFullName() }
					else
						serializedTable[tostring(k)] = v
					end
				end
				serializedArgs[i] = serializedTable
			else
				serializedArgs[i] = arg
			end
		end
		remoteData.arguments = serializedArgs
	end

	table.insert(recordingData.steps, remoteData)
end

function getUnitRemoteFunction(remoteName, args)
	if not isRecording then
		return
	end

	local action = remoteName

	if
		action == "PlaceTower"
		or action == "Upgrade"
		or action == "Sell"
		or action == "ChangeTargeting"
		or action == "Ability"
	then
		if action == "Ability" and not getgenv().recordSkillEnabled then
			return
		end
		collectRemoteInfoFunction(action, args)
	else
	end
end

function updateRecordingStatus()
	if isRecording then
		RecordingStatusLabel:UpdateName("Status: Recording...")
	elseif isPlaying then
		RecordingStatusLabel:UpdateName("Status: " .. selectedMacro)
	else
		RecordingStatusLabel:UpdateName("Status: Not Recording or Playing")
	end
end

function updateSlotStatus(selectedSlot, selectedUnit)
	updateStatus("Selected Slot: " .. selectedSlot .. " | Unit: " .. selectedUnit)
end

function stringToCFrame(str)
	local parts = {}
	for num in str:gmatch("[%d%.%-]+") do
		table.insert(parts, tonumber(num))
	end

	if #parts >= 3 then
		return CFrame.new(parts[1], parts[2], parts[3])
	end
	return nil
end

function stopRecordingMacro()
	if isRecording then
		isRecording = false
		updateRecordingStatus()
	end
	if recordingData and #recordingData.steps > 0 then
		local filePath = macrosFolder .. "/" .. selectedMacro .. ".json"
		local jsonData = game:GetService("HttpService"):JSONEncode(recordingData)
		writefile(filePath, jsonData)
	else
	end
	RecordMacro:UpdateState(false)
	getgenv().macroRecordControlEnabled = false
end

function playMacro(macroName)
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local bottomGui = playerGui:WaitForChild("Bottom")
	local frame = bottomGui:WaitForChild("Frame")

	if not macrosFolder then
		return
	end

	while not startFrameFind() do
		wait()
	end

	if not macroName or macroName == "None" then
		return
	end

	local filePath = macrosFolder .. "/" .. macroName .. ".json"

	if not isfile(filePath) then
		return
	end

	local fileContent
	local success, err = pcall(function()
		fileContent = readfile(filePath)
	end)

	if not success then
		return
	end

	local success, macroData = pcall(function()
		return game:GetService("HttpService"):JSONDecode(fileContent)
	end)

	if not success then
		return
	end

	if not macroData or not macroData.steps then
		return
	end

	isPlaying = true
	updateRecordingStatus()

	local startTime = tick()
	local moneyCheckTimeout = 10
	local moneyCheckInterval = 0.1
	selectedDelayMacro = MacLib.Options.selectedDelayMacroSlider.Value
	local delayMacro = selectedDelayMacro

	for i, step in ipairs(macroData.steps) do
		if not isPlaying then
			break
		end

		if not step.action then
			break
		end

		if step.money or step.time then
			local playerCash = player:WaitForChild("Cash")
			local sastify = false
			while isPlaying and not sastify do
				if step.money and (playerCash.Value >= step.money) then
					sastify = true
				end

				if step.fr == nil and step.time and (step.time - (tick() - startTime)) <= 0 then
					sastify = true
				end

				warn(
					("You Money: %s | Money: %s ||| You Time: %s | Time: %s"):format(
						playerCash.Value,
						step.money and step.money or 0,
						step.time and (tick() - startTime) or 0,
						step.time or 0
					)
				)
				wait(moneyCheckInterval)
			end
		end

		local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
		if not remotes then
			break
		end

		function stringToCFrame(str)
			return CFrame.new(unpack(HttpService:JSONDecode("[" .. str .. "]")))
		end

		function checkCframe(cf1, cf2)
			cf1 = typeof(cf1) == "string" and stringToCFrame(cf1) or cf1
			cf2 = typeof(cf2) == "string" and stringToCFrame(cf2) or cf2

			local cX, cY, cZ = math.floor(cf1.X + 0.5), math.floor(cf1.Y + 0.5), math.floor(cf1.Z + 0.5)
			local cX2, cY2, cZ2 = math.floor(cf2.X + 0.5), math.floor(cf2.Y + 0.5), math.floor(cf2.Z + 0.5)

			return cX == cX2 and cY == cY2 and cZ == cZ2
		end

		function findUnit()
			local path = workspace.Towers
			for _, tower in ipairs(path:GetChildren()) do
				if tower:IsA("Model") and tower:FindFirstChild("UnitHighlight") then
					if checkCframe(tower.UnitHighlight.Position, step.arguments[2]) then
						return tower
					end
				end
			end
		end

		if step.action == "PlaceTower" then
			local remote = remotes:FindFirstChild("PlaceTower")
			if not remote then
				break
			end

			local towerName = step.arguments[1]
			local positionData = step.arguments[2]
			local cframe

			if type(positionData) == "string" then
				local components = {}
				for num in positionData:gmatch("[%-%d%.]+") do
					table.insert(components, tonumber(num))
				end

				if #components >= 12 then
					cframe = CFrame.new(unpack(components))
				else
					break
				end
			elseif type(positionData) == "table" then
				cframe = CFrame.new(unpack(positionData))
			else
				break
			end

			if towerName and cframe then
				remote:FireServer(towerName, cframe)
				task.wait(math.max(1 - delayMacro, 0))
			else
			end
		elseif step.action == "Upgrade" then
			local remote = remotes:FindFirstChild("Upgrade")
			local tower = findUnit()
			print("Verificando se o remote e a unidade estão presentes")
			print(remote:GetFullName())
			print(tower)
			if remote and tower then
				print("Colocando a unidade")
				remote:InvokeServer(tower)
				print("Remote foi usado")
			end
		elseif step.action == "Sell" then
			local remote = remotes:FindFirstChild("Sell")
			local tower = findUnit()
			if remote and tower then
				remote:InvokeServer(tower)
			end
		elseif step.action == "Ability" then
			local remote = remotes:FindFirstChild("Ability")
			local tower = findUnit()
			if remote and tower then
				remote:InvokeServer(tower)
			end
		else
		end

		task.wait(delayMacro)
	end

	isPlaying = false
	updateRecordingStatus()
end

local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	local args = { ... }
	local remoteName = self.Name

	if isRecording and not checkcaller() then
		if method == "FireServer" and remoteName == "PlaceTower" and self.Parent == game.ReplicatedStorage.Remotes then
			local processedArgs = {
				tostring(args[1]),
				tostring(args[2]),
			}
			task.spawn(function()
				getUnitRemoteFunction("PlaceTower", processedArgs)
			end)
		elseif method == "InvokeServer" and self.Parent == game.ReplicatedStorage.Remotes then
			if
				remoteName == "Upgrade"
				or remoteName == "Sell"
				or remoteName == "ChangeTargeting"
				or remoteName == "Ability"
			then
				task.spawn(function()
					getUnitRemoteFunction(
						remoteName,
						{ tostring(args[1]), tostring(args[1]:WaitForChild("UnitHighlight").Position) }
					)
				end)
			end
		end
	end

	return originalNamecall(self, ...)
end)

task.spawn(function()
	local wave = game:GetService("ReplicatedStorage"):FindFirstChild("Wave")
	if wave then
		local old = wave.Value
		wave:GetPropertyChangedSignal("Value"):Connect(function()
			local new = wave.Value

			if new < old then
				if PlayMacro:GetState() == true then
					PlayMacro:UpdateState(false)
					PlayMacro:UpdateState(true)
				end
				if placeUnitsToggle:GetState() == true then
					placeUnitsToggle:UpdateState(false)
					placeUnitsToggle:UpdateState(true)
				end
				if upgradeUnitsToggle:GetState() == true then
					upgradeUnitsToggle:UpdateState(false)
					upgradeUnitsToggle:UpdateState(true)
				end
				if sellUnitsToggle:GetState() == true then
					sellUnitsToggle:UpdateState(false)
					sellUnitsToggle:UpdateState(true)
				end
				if sellFarmUnitsToggle:GetState() == true then
					sellFarmUnitsToggle:UpdateState(false)
					sellFarmUnitsToggle:UpdateState(true)
				end
				if autoRetryToggle:GetState() == true then
					autoRetryToggle:UpdateState(false)
					autoRetryToggle:UpdateState(true)
				end
				if autoNextToggle:GetState() == true then
					autoNextToggle:UpdateState(false)
					autoNextToggle:UpdateState(true)
				end
			end
			old = new
		end)
	end
end)

task.spawn(function()
	local playerCash = player:FindFirstChild("Cash")
	if playerCash then
		local old = playerCash.Value
		local oldIndex = -1
		playerCash:GetPropertyChangedSignal("Value"):Connect(function()
			local new = playerCash.Value
			if new == 600 then
				old = new
				return
			end
			if new < old then
				local index = recordingData and recordingData.currentStepIndex
				if isRecording and index then
					if oldIndex == index then
						index = index + 1
					end
					local step = recordingData.steps[index]
					while not step do
						step = recordingData.steps[index]
						task.wait()
					end
					if step and (selectedTypeOfRecord == "Hybrid" or selectedTypeOfRecord == "Money") then
						warn("Gastou Money: " .. tostring(old - new))
						recordingData.steps[index].money = (old - new)
						recordingData.steps[index].fr = true
					end
				end
			end
			old = new
		end)
	end
end)

function equipMacroFunction()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local filePath = macrosFolder .. "/" .. selectedMacro .. ".json"
	local JSON = readfile(filePath)
	local data = HttpService:JSONDecode(JSON)

	local uniqueNames = {}

	if data and data.steps then
		for _, step in ipairs(data.steps) do
			if step.arguments and type(step.arguments) == "table" then
				local unitName = step.arguments[1]
				if unitName and not table.find(uniqueNames, unitName) then
					table.insert(uniqueNames, unitName)
				end
			end
		end
	end

	Remotes:WaitForChild("UnequipAll"):FireServer()

	local retorno = Remotes:FindFirstChild("GetPlayerData"):InvokeServer()

	local unitData = retorno["UnitData"]
	if typeof(unitData) == "table" then
		for _, name in ipairs(uniqueNames) do
			for _, unitInfo in pairs(unitData) do
				if unitInfo["UnitName"] == name then
					local args = {
						[1] = tostring(unitInfo["UnitID"]),
					}
					Remotes:WaitForChild("Equip"):InvokeServer(unpack(args))
					break
				end
			end
		end
	end
end

-- Info Dropdown

local blacklist = blacklist or {}
local valuesChallengeInfo = { "None" }
local challengeInfo = game:GetService("ReplicatedStorage").Modules.ChallengeInfo
for i, v in pairs(challengeInfo:GetChildren()) do
	if v.Name ~= "PackageLink" then
		table.insert(valuesChallengeInfo, tostring(v.Name))
	end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local portals = ReplicatedStorage:FindFirstChild("Portals")
local ValuesPortalMap = { "None" }
local ValuesPortalTier = { "None" }

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
	table.insert(ValuesPortalTier, "Tier 6")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MapData = require(ReplicatedStorage.Modules.MapData)

local typeCategories = {
	Story = {},
	Infinite = {},
	Challenge = {},
	Portal = {},
	LegendaryStages = {},
	Raids = {},
	BossRush = {},
	Dungeon = {},
	Survival = {},
	Unknown = {},
}

local typeNames = {
	[1] = "Story",
	[2] = "Infinite",
	[3] = "Challenge",
	[4] = "Portal",
	[5] = "LegendaryStages",
	[6] = "Raids",
	[7] = "BossRush",
	[8] = "Dungeon",
	[9] = "Survival",
}

function addToTypeTables(mapName, types)
	for _, typeName in ipairs(types) do
		if typeCategories[typeName] then
			table.insert(typeCategories[typeName], mapName)
		else
			table.insert(typeCategories.Unknown, mapName)
		end
	end
end

for mapName, mapInfo in pairs(MapData) do
	if type(mapInfo) == "table" then
		local types = {}

		if type(mapInfo.Type) == "table" then
			for num, name in pairs(mapInfo.Type) do
				if type(num) == "number" then
					table.insert(types, name or typeNames[num] or "Unknown")
				end
			end
		elseif mapInfo.Type ~= nil then
			table.insert(types, typeNames[mapInfo.Type] or "Unknown")
		else
			table.insert(types, "Unknown")
		end

		addToTypeTables(tostring(mapName), types)
	else
		table.insert(typeCategories.Unknown, tostring(mapName))
	end
end

for typeName, maps in pairs(typeCategories) do
	local uniqueMaps = {}
	local added = {}
	for _, map in ipairs(maps) do
		if not added[map] then
			table.insert(uniqueMaps, map)
			added[map] = true
		end
	end

	table.sort(uniqueMaps)
	typeCategories[typeName] = uniqueMaps
end

local player = game.Players.LocalPlayer
local retorno =
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData"):InvokeServer(player)
local ValuesUnitId = {}

if typeof(retorno) == "table" then
	local unitData = retorno["UnitData"]
	if typeof(unitData) == "table" then
		for _, unitInfo in pairs(unitData) do
			if typeof(unitInfo) == "table" then
				local unitName = unitInfo["UnitName"]
				local level = unitInfo["Level"]
				local unitID = unitInfo["UnitID"]

				if unitName and level and unitID then
					table.insert(ValuesUnitId, unitName .. " | Level: " .. tostring(level) .. " | " .. tostring(unitID))
				end
			end
		end
	end
end

function updateDropdownUnits()
	local player = game.Players.LocalPlayer
	local retorno =
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData"):InvokeServer(player)
	local newUnits = {}

	if typeof(retorno) == "table" then
		local unitData = retorno["UnitData"]
		if typeof(unitData) == "table" then
			for _, unitInfo in pairs(unitData) do
				if typeof(unitInfo) == "table" then
					local unitName = unitInfo["UnitName"]
					local level = unitInfo["Level"]
					local unitID = unitInfo["UnitID"]

					if unitName and level and unitID then
						table.insert(newUnits, unitName .. " | Level: " .. tostring(level) .. " | " .. tostring(unitID))
					end
				end
			end
		end
	end

	Units = newUnits
	if selectedUIMacro and DropdownUnitPassive and DropdownUnitStat then
		DropdownUnitPassive:ClearOptions()
		DropdownUnitPassive:InsertOptions(Units)
		DropdownUnitStat:ClearOptions()
		DropdownUnitStat:InsertOptions(Units)
		selectedUnitToRollPassive = nil
		selectedUnitToRollStat = nil
	end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ItemInfo = require(Modules:WaitForChild("ItemInfo"))
local ValuesItemsToFeed = {}

for itemName, _ in pairs(ItemInfo) do
	table.insert(ValuesItemsToFeed, itemName)
end

local quirkInfoModule = require(game:GetService("ReplicatedStorage").Modules.QuirkInfo)
local ValuesPassive = {}

for key, value in pairs(quirkInfoModule) do
	table.insert(ValuesPassive, key)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modifiersModule = ReplicatedStorage:WaitForChild("Events")
	:WaitForChild("Anniversary1")
	:WaitForChild("Constants")
	:WaitForChild("Modifiers")
local valuesDebuffDungeon = {}

if modifiersModule:IsA("ModuleScript") then
	local modifiers = require(modifiersModule)

	function extractDebuffNames(data)
		local debuffNames = {}

		if data.Name then
			table.insert(debuffNames, data.Name)
		end

		for key, value in pairs(data) do
			if type(value) == "table" then
				if value.Name then
					table.insert(debuffNames, value.Name)
				end
			end
		end

		return debuffNames
	end

	local debuffNames = extractDebuffNames(modifiers)

	if #debuffNames > 0 then
		for _, name in ipairs(debuffNames) do
			table.insert(valuesDebuffDungeon, name)
		end
	end
end

local modifiersSurvival =
	require(game:GetService("ReplicatedStorage").FusionPackage.TestStories["Survival.story"].Modifiers)
local ValuesModifiersSurvival = {}

for Modifiers, Name in pairs(modifiersSurvival) do
	for name, debuffs in pairs(Name) do
		if typeof(debuffs) ~= "table" and debuffs ~= "true" then
			table.insert(ValuesModifiersSurvival, tostring(debuffs))
		end
	end
end

local tabGroups = {
	TabGroup1 = Window:TabGroup(),
}

--UI Tabs

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
	Event = tabGroups.TabGroup1:Tab({ Name = "Event", Image = "rbxassetid://18821914323" }),
	AutoJoin = tabGroups.TabGroup1:Tab({ Name = "Auto Join", Image = "rbxassetid://10734950309" }),
	AutoPlay = tabGroups.TabGroup1:Tab({ Name = "Auto Play", Image = "rbxassetid://10734950309" }),
	AutoCard = tabGroups.TabGroup1:Tab({ Name = "Auto Card", Image = "rbxassetid://10734950309" }),
	Macro = tabGroups.TabGroup1:Tab({ Name = "Macro", Image = "rbxassetid://10734950309" }),
	Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" }),
}

--UI Sections

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
	MainSection2 = tabs.Main:Section({ Side = "Left" }),
	MainSection3 = tabs.Main:Section({ Side = "Right" }),
	MainSection4 = tabs.Main:Section({ Side = "Right" }),
	MainSection9 = tabs.AutoJoin:Section({ Side = "Left" }),
	MainSection10 = tabs.AutoJoin:Section({ Side = "Left" }),
	MainSection11 = tabs.AutoJoin:Section({ Side = "Right" }),
	MainSection12 = tabs.AutoJoin:Section({ Side = "Right" }),
	MainSection13 = tabs.AutoJoin:Section({ Side = "Right" }),
	MainSection14 = tabs.AutoJoin:Section({ Side = "Left" }),
	MainSection30 = tabs.AutoJoin:Section({ Side = "Right" }),
	MainSection31 = tabs.AutoJoin:Section({ Side = "Left" }),
	MainSection32 = tabs.AutoJoin:Section({ Side = "Right" }),
	MainSection33 = tabs.AutoJoin:Section({ Side = "Right" }),
	MainSection15 = tabs.AutoPlay:Section({ Side = "Left" }),
	MainSection16 = tabs.AutoPlay:Section({ Side = "Right" }),
	MainSection17 = tabs.AutoPlay:Section({ Side = "Right" }),
	MainSection18 = tabs.AutoPlay:Section({ Side = "Right" }),
	MainSection19 = tabs.AutoPlay:Section({ Side = "Left" }),
	MainSection34 = tabs.AutoPlay:Section({ Side = "Right" }),
	MainSection20 = tabs.AutoCard:Section({ Side = "Left" }),
	MainSection21 = tabs.AutoCard:Section({ Side = "Right" }),
	MainSection22 = tabs.Macro:Section({ Side = "Left" }),
	MainSection25 = tabs.Settings:Section({ Side = "Left" }),
	MainSection26 = tabs.Event:Section({ Side = "Left" }),
}

sections.MainSection1:Header({
	Name = "Player",
})

sections.MainSection1:Toggle({
	Name = "Hide Player",
	Default = false,
	Callback = function(value)
		getgenv().HidePlayerEnabled = value
		HidePlayerFunction()
	end,
}, "HidePlayerInfoToggle")

sections.MainSection1:Toggle({
	Name = "Auto Start",
	Default = false,
	Callback = function(value)
		getgenv().autoStartEnabled = value
		autoStartFunction()
	end,
}, "AutoStartToggle")

sections.MainSection1:Toggle({
	Name = "Auto Ready",
	Default = false,
	Callback = function(value)
		getgenv().autoReadyEnabled = value
		autoReadyFunction()
	end,
}, "autoReadyToggle")

sections.MainSection1:Toggle({
	Name = "Auto Skip Wave",
	Default = false,
	Callback = function(value)
		getgenv().autoSkipWaveEnabled = value
		autoSkipWaveFunction()
	end,
}, "AutoSkipWaveToggle")

sections.MainSection1:Toggle({
	Name = "Auto Leave",
	Default = false,
	Callback = function(value)
		getgenv().autoLeaveEnabled = value
		autoLeaveFunction()
	end,
}, "AutoLeaveToggle")

autoRetryToggle = sections.MainSection1:Toggle({
	Name = "Auto Replay",
	Default = false,
	Callback = function(value)
		getgenv().autoRetryEnabled = value
		autoRetryFunction()
	end,
}, "AutoReplayToggle")

autoNextToggle = sections.MainSection1:Toggle({
	Name = "Auto Next",
	Default = false,
	Callback = function(value)
		getgenv().autoNextEnabled = value
		autoNextFunction()
	end,
}, "AutoNextToggle")

sections.MainSection1:Toggle({
	Name = "Auto Gamespeed",
	Default = false,
	Callback = function(value)
		getgenv().autoGameSpeedEnabled = value
		autoGameSpeedFunction()
	end,
}, "autoGameSpeedToggle")

sections.MainSection2:Header({
	Name = "Webhook",
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
		getgenv().pingUserIdEnabled = value
	end,
	onChanged = function(value)
		getgenv().pingUserIdEnabled = value
	end,
}, "pingUser@Toggle")

sections.MainSection2:Toggle({
	Name = "Send Webhook when finish game",
	Default = false,
	Callback = function(value)
		getgenv().webhookEnabled = value
	end,
}, "SendWebhookToggle")

sections.MainSection2:Toggle({
	Name = "Ping User",
	Default = false,
	Callback = function(value)
		getgenv().pingUserEnabled = value
	end,
}, "PingUserToggle")

sections.MainSection2:Toggle({
	Name = "Send Webhook when Get Trait",
	Default = false,
	Callback = function(value)
		getgenv().webhookTraitRerollEnabled = value
	end,
}, "SendWebhookTraitToggle")

sections.MainSection2:Button({
	Name = "Test Webhook",
	Callback = function()
		testWebhookFunction()
	end,
})

sections.MainSection3:Header({
	Name = "Extra",
})

sections.MainSection3:Toggle({
	Name = "Auto Get Escanor Axe",
	Default = false,
	Callback = function(value)
		getgenv().autoGetEscanorAxeEnabled = value
		autoGetEscanorAxeFunction()
	end,
}, "autoGetEscanorAxeToggle")

sections.MainSection3:Toggle({
	Name = "Only Friends",
	Default = false,
	Callback = function(value)
		getgenv().OnlyFriends = value
	end,
}, "onlyFriends")

sections.MainSection3:Toggle({
	Name = "Place Anywhere",
	Default = false,
	Callback = function(value)
		getgenv().placeAnywhereEnabled = value
	end,
}, "placeAnywhereToggle")

sections.MainSection3:Toggle({
	Name = "Auto Get Battlepass Rewards",
	Default = false,
	Callback = function(value)
		getgenv().autoGetBattlepassEnabled = value
		autoGetBattlepassFunction()
	end,
}, "autoGetBattlepassToggle")

sections.MainSection4:Header({
	Name = "Unit",
})

local DropdownUnitPassive = sections.MainSection4:Dropdown({
	Name = "Select Unit",
	Search = true,
	Multi = false,
	Required = true,
	Options = ValuesUnitId,
	Default = None,
	Callback = function(value)
		selectedUnitToRollPassive = value:match(".* | .* | (.+)")
	end,
}, "dropdownselectedUnitToRoll")

local DropdownPassive = sections.MainSection4:Dropdown({
	Name = "Select Passive",
	Search = true,
	Multi = true,
	Required = true,
	Options = ValuesPassive,
	Default = None,
	Callback = function(value)
		table.clear(selectedPassive)
		for k, v in pairs(value) do
			if v == true then
				table.insert(selectedPassive, k)
			elseif typeof(v) == "string" then
				table.insert(selectedPassive, v)
			end
		end
	end,
}, "dropdownSelectPassiveToRoll")

sections.MainSection4:Toggle({
	Name = "Auto Trait",
	Default = false,
	Callback = function(value)
		getgenv().autoTraitEnabled = value
		if value then
			autoTraitFunction()
		end
	end,
}, "autoTraitToggle")

sections.MainSection4:Button({
	Name = "Refresh Units",
	Callback = function()
		updateDropdownUnits()
	end,
})

sections.MainSection4:Divider()

local DropdownUnitStat = sections.MainSection4:Dropdown({
	Name = "Select Unit",
	Search = true,
	Multi = false,
	Required = true,
	Options = ValuesUnitId,
	Default = None,
	Callback = function(value)
		local extractedID = value and value:match(".* | .* | (.+)")
		if extractedID then
			selectedUnitToRollStat = extractedID
		end
	end,
}, "dropdownselectedUnitToRollStat")

local DropdownPassive = sections.MainSection4:Dropdown({
	Name = "Select Stat",
	Search = true,
	Multi = true,
	Required = true,
	Options = allRanks,
	Default = nil,
	Callback = function(value)
		table.clear(selectedStatToGet)
		for k, v in pairs(value) do
			if v == true then
				table.insert(selectedStatToGet, k)
			elseif typeof(v) == "string" then
				table.insert(selectedStatToGet, v)
			end
		end
	end,
}, "dropdownSelectStatToRoll")

local DropdownPassive = sections.MainSection4:Dropdown({
	Name = "Select Type",
	Search = true,
	Multi = false,
	Required = true,
	Options = { "All Stats", "Damage", "Range", "Speed" },
	Default = nil,
	Callback = function(value)
		selectedTypeOfRollStat = value
	end,
}, "dropdownSelectTypeOfRollStat")

sections.MainSection4:Toggle({
	Name = "Auto Stat",
	Default = false,
	Callback = function(value)
		getgenv().autoStatEnabled = value
		if value then
			autoStatFunction()
		end
	end,
}, "autoStatToggle")

sections.MainSection4:Button({
	Name = "Refresh Units",
	Callback = function()
		updateDropdownUnits()
	end,
})

sections.MainSection26:Header({
	Name = "Easter Event",
})
sections.MainSection26:Toggle({
	Name = "Auto Join Breach Act 1",
	Default = false,
	Callback = function(value)
		if value then
			autoJoinBreachAct1Function()
		end
	end,
}, "AutoJoinBreachAct1")

sections.MainSection26:Toggle({
	Name = "Auto Join Breach Act 2",
	Default = false,
	Callback = function(value)
		if value then
			autoJoinBreachAct2Function()
		end
	end,
}, "AutoJoinBreachAct2")

sections.MainSection26:Toggle({
	Name = "Auto Join Breaches",
	Default = false,
	Callback = function(value)
		if value then
			autoJoinBreachesFunction()
		end
	end,
}, "AutoJoinBreaches")

sections.MainSection26:Toggle({
	Name = "Auto Collect Eggs",
	Default = false,
	Callback = function(value)
		if value then
			autoCollectEggsFunction()
		end
	end,
}, "AutoJoinBreaches")

sections.MainSection9:Header({
	Name = "Story",
})

local Dropdown = sections.MainSection9:Dropdown({
	Name = "Select Story Map",
	Search = true,
	Multi = false,
	Required = true,
	Options = typeCategories.Story,
	Default = None,
	Callback = function(value)
		selectedStoryMap = value
	end,
}, "dropdownStoryMap")

local Dropdown = sections.MainSection9:Dropdown({
	Name = "Select Difficulty",
	Multi = false,
	Required = true,
	Options = { "Normal", "Nightmare", "Purgatory" },
	Default = None,
	Callback = function(value)
		selectedDifficultyStory = value
	end,
}, "dropdownSelectDifficultyStory")

local Dropdown = sections.MainSection9:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4, 5, 6, "Infinite" },
	Default = None,
	Callback = function(value)
		selectedActStory = value
	end,
}, "dropdownSelectActStory")

sections.MainSection9:Toggle({
	Name = "Auto Story",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinStoryEnabled = value
		autoJoinStoryFunction()
	end,
}, "autoJoinStoryToggle")

sections.MainSection9:Slider({
	Name = "Delay for Auto Join",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		selectedDelay = Value
	end,
}, "selectedDelayToJoinInGamemodes")

sections.MainSection10:Header({
	Name = "Portal",
})

local DropdownMap = sections.MainSection10:Dropdown({
	Name = "Select Portal",
	Search = true,
	Multi = false,
	Required = true,
	Options = typeCategories.Portal,
	Default = nil,
	Callback = function(value)
		selectedPortalMap = value
	end,
}, "dropdownSelectPortal")

local DropdownModifier = sections.MainSection10:Dropdown({
	Name = "Select Modifier",
	Multi = true,
	Required = true,
	Options = valuesChallengeInfo,
	Default = nil,
	Callback = function(value)
		table.clear(selectedPortalModifier)
		for k, v in pairs(value) do
			if v == true then
				table.insert(selectedPortalModifier, k)
			elseif typeof(v) == "string" then
				table.insert(selectedPortalModifier, v)
			end
		end
	end,
}, "dropdownSelectIgnoreModifierPortal")

local DropdownTier = sections.MainSection10:Dropdown({
	Name = "Select Tier",
	Multi = true,
	Required = true,
	Options = ValuesPortalTier,
	Default = nil,
	Callback = function(value)
		table.clear(selectedPortalTier)
		for k, v in pairs(value) do
			if v == true then
				table.insert(selectedPortalTier, k)
			end
		end
		for _, tier in ipairs(selectedPortalTier) do
			wait(1)
		end
	end,
}, "dropdownSelectTierPortal")

sections.MainSection10:Toggle({
	Name = "Auto Portal",
	Default = false,
	Callback = function(value)
		getgenv().autoPortalEnabled = value
		if value then
			autoPortalFunction()
		end
	end,
}, "autoPortalToggle")

sections.MainSection10:Toggle({
	Name = "Auto Next Portal",
	Default = false,
	Callback = function(value)
		getgenv().autoNextPortalEnabled = value
		if value then
			autoNextPortalFunction()
		end
	end,
}, "autoNextPortalToggle")

rewardPortalToggle = sections.MainSection10:Toggle({
	Name = "Auto Get Reward",
	Default = false,
	Callback = function(value)
		getgenv().autoGetRewardPortalEnabled = value
	end,
}, "autoGetRewardPortalToggle")

sections.MainSection30:Header({
	Name = "Boss Rush",
})

local Dropdown = sections.MainSection30:Dropdown({
	Name = "Select Boss Rush",
	Search = true,
	Multi = false,
	Required = true,
	Options = typeCategories.BossRush,
	Default = nil,
	Callback = function(value)
		selectedBossRush = value
	end,
}, "dropdownSelectBossRush")

sections.MainSection30:Toggle({
	Name = "Auto Boss Rush",
	Default = false,
	Callback = function(value)
		getgenv().autoBossRushEnabled = value
		if value then
			autoBossRushFunction()
		end
	end,
}, "autoBossRushToggle")

sections.MainSection31:Header({
	Name = "Elemental Cavern",
})

local Dropdown = sections.MainSection31:Dropdown({
	Name = "Select Elemental Cavern",
	Search = true,
	Multi = false,
	Required = true,
	Options = { "Water", "Fire", "Nature", "Dark", "Light" },
	Default = nil,
	Callback = function(value)
		selectedCavern = value
	end,
}, "dropdownSelectCavern")

local Dropdown = sections.MainSection31:Dropdown({
	Name = "Select Difficulty",
	Multi = false,
	Required = true,
	Options = { "Normal", "Nightmare", "Purgatory" },
	Default = nil,
	Callback = function(value)
		selectedDifficultyCavern = value
	end,
}, "dropdownSelectCavernDifficulty")

sections.MainSection31:Toggle({
	Name = "Auto Elemental Cavern",
	Default = false,
	Callback = function(value)
		getgenv().autoElementalCavernEnabled = value
		if value then
			autoElementalCavernFunction()
		end
	end,
}, "autoElementalCavernToggle")

sections.MainSection11:Header({
	Name = "Raid",
})

local Dropdown = sections.MainSection11:Dropdown({
	Name = "Select Raid Map",
	Search = true,
	Multi = false,
	Required = true,
	Options = typeCategories.Raids,
	Default = None,
	Callback = function(value)
		selectedRaidMap = value
	end,
}, "dropdownRaidMap")

local Dropdown = sections.MainSection11:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4, 5, 6 },
	Default = None,
	Callback = function(value)
		selectedFaseRaid = value
	end,
}, "dropdownSelectActRaid")

sections.MainSection11:Toggle({
	Name = "Auto Raid",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinRaidEnabled = value
		autoJoinRaidFunction()
	end,
}, "autoJoinRaidToggle")

sections.MainSection12:Header({
	Name = "Legend Stage",
})

local Dropdown = sections.MainSection12:Dropdown({
	Name = "Select Map",
	Search = true,
	Multi = false,
	Required = true,
	Options = typeCategories.LegendaryStages,
	Default = None,
	Callback = function(value)
		selectedLegendMap = value
	end,
}, "selectedLegendMap")

local Dropdown = sections.MainSection12:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4, 5, 6 },
	Default = None,
	Callback = function(value)
		selectedActLegend = value
	end,
}, "dropdownSelectActLegend")

sections.MainSection12:Toggle({
	Name = "Auto Legend Stage",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinLegendEnabled = value
		autoJoinLegendFunction()
	end,
}, "autoJoinLegendToggle")

sections.MainSection13:Header({
	Name = "Challenges",
})

local Dropdown = sections.MainSection13:Dropdown({
	Name = "Select Map",
	Search = true,
	Multi = false,
	Required = true,
	Options = typeCategories.Challenge,
	Default = None,
	Callback = function(value)
		selectedChallengeMap = value
	end,
}, "dropdownChallengeMap")

local Dropdown = sections.MainSection13:Dropdown({
	Name = "Ignore Difficulty",
	Multi = false,
	Required = true,
	Options = valuesChallengeInfo,
	Default = none,
	Callback = function(value)
		selectedIgnoreChallenge = value
	end,
}, "dropdownSelectChallengeIgnore")

local Dropdown = sections.MainSection13:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4, 5, 6 },
	Default = None,
	Callback = function(value)
		selectActChallenge = value
	end,
}, "dropdownSelectActChallenge")

sections.MainSection13:Toggle({
	Name = "Auto Challenge",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinChallengeEnabled = value
		autoJoinChallengeFunction()
	end,
}, "autoJoinChallengeToggle")

sections.MainSection33:Header({
	Name = "Infinite Castle",
})

sections.MainSection33:Input({
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

sections.MainSection33:Toggle({
	Name = "Auto Inf Caslte",
	Default = false,
	Callback = function(value)
		getgenv().joinInfCastleEnabled = value
		joinInfCastleFunction()
	end,
}, "autoInfCastleToggle")

sections.MainSection32:Header({
	Name = "Extreme Boost",
})

local Dropdown = sections.MainSection32:Dropdown({
	Name = "Select Extreme Boost",
	Search = true,
	Multi = false,
	Required = true,
	Options = { "Infernal Boost", "Divine Boost" },
	Default = nil,
	Callback = function(value)
		selectedExtremeBoost = value
	end,
}, "dropdownSelectExtremeBoost")

sections.MainSection32:Toggle({
	Name = "Auto Extreme Boost",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinExtremeBoostEnabled = value
		if value then
			autoJoinExtremeBoostFunction()
		end
	end,
}, "autoJoinExtremeBoostToggle")

sections.MainSection14:Header({
	Name = "Dungeon",
})

local Dropdown = sections.MainSection14:Dropdown({
	Name = "Select Dungeon",
	Search = true,
	Multi = false,
	Required = true,
	Options = typeCategories.Dungeon,
	Default = nil,
	Callback = function(value)
		selectedDungeon = value
	end,
}, "dropdownSelectDungeon")

local Dropdown = sections.MainSection14:Dropdown({
	Name = "Select Debuff",
	Search = true,
	Multi = true,
	Required = true,
	Options = valuesDebuffDungeon,
	Default = nil,
	Callback = function(value)
		table.clear(selectedDungeonDebuff)
		for k, v in pairs(value) do
			if v == true then
				table.insert(selectedDungeonDebuff, k)
			end
		end
		for _, tier in ipairs(selectedDungeonDebuff) do
			wait(1)
		end
	end,
}, "dropdownSelectDungeonDebuff")

sections.MainSection14:Toggle({
	Name = "Auto Dungeon",
	Default = false,
	Callback = function(value)
		getgenv().autoDungeonEnabled = value
		if value then
			autoDungeonFunction()
		end
	end,
}, "autoDungeonToggle")

sections.MainSection14:Divider()

sections.MainSection14:Header({
	Name = "Survival",
})

local Dropdown = sections.MainSection14:Dropdown({
	Name = "Select Survival",
	Search = true,
	Multi = false,
	Required = true,
	Options = typeCategories.Survival,
	Default = nil,
	Callback = function(value)
		selectedSurvival = value
	end,
}, "dropdownSelectSurvival")

local Dropdown = sections.MainSection14:Dropdown({
	Name = "Select Debuff",
	Search = true,
	Multi = true,
	Required = true,
	Options = ValuesModifiersSurvival,
	Default = nil,
	Callback = function(value)
		table.clear(selectedSurvivalDebuff)
		for k, v in pairs(value) do
			if v == true then
				table.insert(selectedSurvivalDebuff, k)
			end
		end
		for _, tier in ipairs(selectedSurvivalDebuff) do
			wait(1)
		end
	end,
}, "dropdownSelectSurvivalDebuff")

local Dropdown = sections.MainSection14:Dropdown({
	Name = "Select Difficulty",
	Multi = false,
	Required = true,
	Options = { "Normal", "Nightmare", "Purgatory" },
	Default = nil,
	Callback = function(value)
		selectedDifficultySurvival = value
	end,
}, "dropdownSelectSurvivalDifficulty")

sections.MainSection14:Toggle({
	Name = "Auto Survival",
	Default = false,
	Callback = function(value)
		getgenv().autoSurvivalEnabled = value
		if value then
			autoSurvivalFunction()
		end
	end,
}, "autoSurvivalToggle")

sections.MainSection15:Header({
	Name = "Place & Upgrade",
})

sections.MainSection15:Input({
	Name = "Place at Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
		selectedWaveXToPlace = value
	end,
	onChanged = function(value)
		selectedWaveXToPlace = value
	end,
}, "inputAutoPlaceWaveX")

sections.MainSection15:Slider({
	Name = "Select Distance",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedDistancePercentage = Value
	end,
}, "selectedDistancePercentage")

sections.MainSection15:Slider({
	Name = "Select Ground",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedGroundPercentage = Value
	end,
}, "selectedGroundPercentage")

sections.MainSection15:Slider({
	Name = "Select Hill",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedAirPercentage = Value
	end,
}, "selectedAirPercentage")

placeUnitsToggle = sections.MainSection15:Toggle({
	Name = "Auto Place Unit",
	Default = false,
	Callback = function(value)
		getgenv().placeUnitsEnabled = value
		if not value then
		else
			selectedDistancePercentage = MacLib.Options.selectedDistancePercentage.Value
			selectedGroundPercentage = MacLib.Options.selectedGroundPercentage.Value
			selectedAirPercentage = MacLib.Options.selectedAirPercentage.Value
			_G["placeMax1"] = MacLib.Options.Unit1.Value
			_G["placeMax2"] = MacLib.Options.Unit2.Value
			_G["placeMax3"] = MacLib.Options.Unit3.Value
			_G["placeMax4"] = MacLib.Options.Unit4.Value
			_G["placeMax5"] = MacLib.Options.Unit5.Value
			_G["placeMax6"] = MacLib.Options.Unit6.Value
			placeUnitsFunction()
		end
	end,
}, "autoPlaceUnitToggle")

sections.MainSection15:Toggle({
	Name = "Only Place in Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlyPlaceinwaveXEnabled = value
	end,
}, "onlyPlaceInWaveXToggle")

sections.MainSection15:Divider()

sections.MainSection15:Slider({
	Name = "Wave Unit 1",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit1 = Value
	end,
}, "waveUnit1Slider")

sections.MainSection15:Slider({
	Name = "Wave Unit 2",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit2 = Value
	end,
}, "waveUnit2Slider")

sections.MainSection15:Slider({
	Name = "Wave Unit 3",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit3 = Value
	end,
}, "waveUnit3Slider")

sections.MainSection15:Slider({
	Name = "Wave Unit 4",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit4 = Value
	end,
}, "waveUnit4Slider")

sections.MainSection15:Slider({
	Name = "Wave Unit 5",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit5 = Value
	end,
}, "waveUnit5Slider")

sections.MainSection15:Slider({
	Name = "Wave Unit 6",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit6 = Value
	end,
}, "waveUnit6Slider")

sections.MainSection15:Divider()

upgradeUnitsToggle = sections.MainSection15:Toggle({
	Name = "Auto Upgrade Unit",
	Default = false,
	Callback = function(value)
		getgenv().upgradeUnitEnabled = value
		_G["upgradeMax1"] = MacLib.Options.Unit1Up.Value
		_G["upgradeMax2"] = MacLib.Options.Unit2Up.Value
		_G["upgradeMax3"] = MacLib.Options.Unit3Up.Value
		_G["upgradeMax4"] = MacLib.Options.Unit4Up.Value
		_G["upgradeMax5"] = MacLib.Options.Unit5Up.Value
		_G["upgradeMax6"] = MacLib.Options.Unit6Up.Value
		upgradeUnitFunction()
	end,
}, "autoUpgradeUnitToggle")

sections.MainSection15:Toggle({
	Name = "Focus Farm",
	Default = false,
	Callback = function(value)
		getgenv().focusFarmEnabled = value
	end,
}, "focusFarmToggle")

sections.MainSection15:Divider()

sections.MainSection15:Slider({
	Name = "Wave Unit 1",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit1 = Value
	end,
}, "waveUnit1UpgradeSlider")

sections.MainSection15:Slider({
	Name = "Wave Unit 2",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit2 = Value
	end,
}, "waveUnit2UpgradeSlider")

sections.MainSection15:Slider({
	Name = "Wave Unit 3",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit3 = Value
	end,
}, "waveUnit3UpgradeSlider")

sections.MainSection15:Slider({
	Name = "Wave Unit 4",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit4 = Value
	end,
}, "waveUnit4UpgradeSlider")

sections.MainSection15:Slider({
	Name = "Wave Unit 5",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit5 = Value
	end,
}, "waveUnit5UpgradeSlider")

sections.MainSection15:Slider({
	Name = "Wave Unit 6",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		selectedWaveUnit6 = Value
	end,
}, "waveUnit6UpgradeSlider")

sections.MainSection16:Header({
	Name = "Misc",
})

sections.MainSection16:Toggle({
	Name = "Auto Cannon",
	Default = false,
	Callback = function(value)
		getgenv().autoCannonEnabled = value
		autoCannonFunction()
	end,
}, "autoCannonToggle")

sections.MainSection16:Toggle({
	Name = "Auto Volcano",
	Default = false,
	Callback = function(value)
		autoVolcanoFunction()
	end,
}, "autoVolcanoToggle")

sections.MainSection17:Header({
	Name = "Skills",
})

sections.MainSection17:Slider({
	Name = "Use Skill in Wave",
	Default = 0,
	Minimum = 0,
	Maximum = 200,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		selectedWaveXToUseSKill = Value
	end,
}, "selectedWaveXToUseSKill")

sections.MainSection17:Toggle({
	Name = "Auto Universal Skill",
	Default = false,
	Callback = function(value)
		getgenv().autoUniversalSkillEnabled = value
		autoUniversalSkillFunction()
	end,
}, "autoUniversalSkillToggle")

sections.MainSection17:Toggle({
	Name = "Only use skills in boss",
	Default = false,
	Callback = function(value)
		getgenv().onlyBossEnabled = value
	end,
}, "onlyUseSkillsInBossToggle")

sections.MainSection17:Toggle({
	Name = "Only use skills in Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlyUseSkillsInWaveXEnabled = value
	end,
}, "onlyUseSkillsInWaveXToggle")

sections.MainSection4:Divider()

sections.MainSection17:Toggle({
	Name = "Auto Kurumi Skill",
	Default = false,
	Callback = function(value)
		getgenv().autoKurumiSkillEnabled = value
		autoKurumiSkillFunction()
	end,
}, "autoKurumiSkillToggle")

sections.MainSection17:Dropdown({
	Name = "Select Skill Kurumi ",
	Multi = false,
	Required = true,
	Options = { "Buff", "DPS", "Support" },
	Default = "None",
	Callback = function(Value)
		selectedKurumiSkillType = Value
	end,
}, "selectedKurumiSkill")

sections.MainSection17:Toggle({
	Name = "Auto Garou Skill",
	Default = false,
	Callback = function(value)
		getgenv().autoGarouSkillEnabled = value
		autoGarouSkillFunction()
	end,
}, "autoGarouSkillToggle")

sections.MainSection17:Dropdown({
	Name = "Select Skill Garou ",
	Multi = false,
	Required = true,
	Options = { "Cosmic", "Baldy" },
	Default = "None",
	Callback = function(Value)
		selectedGarouSkillType = Value
	end,
}, "selectedGarouSkill")

sections.MainSection18:Header({
	Name = "Place Max",
})

sections.MainSection18:Slider({
	Name = "Unit 1",
	Default = 4,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["placeMax1"] = Value
	end,
}, "Unit1")

sections.MainSection18:Slider({
	Name = "Unit 2",
	Default = 4,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["placeMax2"] = Value
	end,
}, "Unit2")

sections.MainSection18:Slider({
	Name = "Unit 3",
	Default = 4,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["placeMax3"] = Value
	end,
}, "Unit3")

sections.MainSection18:Slider({
	Name = "Unit 4",
	Default = 4,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["placeMax4"] = Value
	end,
}, "Unit4")

sections.MainSection18:Slider({
	Name = "Unit 5",
	Default = 4,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["placeMax5"] = Value
	end,
}, "Unit5")

sections.MainSection18:Slider({
	Name = "Unit 6",
	Default = 4,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["placeMax6"] = Value
	end,
}, "Unit6")

sections.MainSection34:Header({
	Name = "Upgrade Max",
})

sections.MainSection34:Slider({
	Name = "Unit 1",
	Default = 10,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["upgradeMax1"] = Value
	end,
}, "Unit1Up")

sections.MainSection34:Slider({
	Name = "Unit 2",
	Default = 10,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["upgradeMax2"] = Value
	end,
}, "Unit2Up")

sections.MainSection34:Slider({
	Name = "Unit 3",
	Default = 10,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["upgradeMax3"] = Value
	end,
}, "Unit3Up")

sections.MainSection34:Slider({
	Name = "Unit 4",
	Default = 10,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["upgradeMax4"] = Value
	end,
}, "Unit4Up")

sections.MainSection34:Slider({
	Name = "Unit 5",
	Default = 10,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["upgradeMax5"] = Value
	end,
}, "Unit5Up")

sections.MainSection34:Slider({
	Name = "Unit 6",
	Default = 10,
	Minimum = 0,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		_G["upgradeMax6"] = Value
	end,
}, "Unit6Up")

sections.MainSection19:Header({
	Name = "Other",
})

sections.MainSection19:Slider({
	Name = "Only Sell Unit in Wave",
	Default = 5,
	Minimum = 5,
	Maximum = 1000,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		MacLib.Options.SellUnitAtWaveXToggle.Value = Value
	end,
}, "SellUnitAtWaveXToggle")

sellUnitsToggle = sections.MainSection19:Toggle({
	Name = "Auto Sell Unit",
	Default = false,
	Callback = function(value)
		getgenv().sellUnitEnabled = value
		if value then
			sellUnitFunction()
		end
	end,
}, "AutoSellUnitToggle")


sections.MainSection19:Slider({
	Name = "Only Sell Farm in Wave",
	Default = 5,
	Minimum = 5,
	Maximum = 1000,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		MacLib.Options.selectedWaveXToSellFarmToggle.Value = Value
	end,
}, "selectedWaveXToSellFarmToggle")

sellFarmUnitsToggle = sections.MainSection19:Toggle({
	Name = "Auto Sell Farm",
	Default = false,
	Callback = function(value)
		getgenv().sellUnitFarmEnabled = value
		if value then
			sellUnitFarmFunction()
		end
	end,
}, "onlysellFarminwaveXToggle")


sections.MainSection19:Slider({
	Name = "Only Leave in Wave",
	Default = 5,
	Minimum = 5,
	Maximum = 1000,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		MacLib.Options.OnlyLeaveinWave.Value = Value
	end,
}, "OnlyLeaveinWave")

sections.MainSection19:Toggle({
	Name = "Auto Leave",
	Default = false,
	Callback = function(value)
		getgenv().autoLeaveInstaEnabled = value
		if value then
			autoLeaveInstaFunction()
		end
	end,
}, "AutoLeaveWaveXToggle")

sections.MainSection19:Slider({
	Name = "Restart in Wave",
	Default = 5,
	Minimum = 5,
	Maximum = 1000,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		MacLib.Options.RestartinWave.Value = Value
	end,
}, "RestartinWave")

sections.MainSection19:Toggle({
	Name = "Auto Restart",
	Default = false,
	Callback = function(value)
		getgenv().autoRestartEnabled = value
		if value then
			autoRestartFunction()
		end
	end,
}, "autoRestartInWave")

sections.MainSection19:Slider({
	Name = "Restart After Match",
	Default = 1,
	Minimum = 1,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		MacLib.Options.selectedMatchXToRestartSlider.Value = Value 
	end,
}, "selectedMatchXToRestartSlider")

sections.MainSection19:Toggle({
	Name = "Auto Restart",
	Default = false,
	Callback = function(value)
		getgenv().autoRestartAfterXMatchEnabled = value
		if value then
			autoRestartAfterXMatchFunction()
		end
	end,
}, "autoRestartafterxMatches")

sections.MainSection20:Header({
	Name = "Normal Cards",
})

sections.MainSection20:Slider({
	Name = "Iron Hand",
	Default = 0,
	Minimum = 0,
	Maximum = 8,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities["Iron Hand"] = Value
	end,
}, "Iron Hand")

sections.MainSection20:Slider({
	Name = "Concentration",
	Default = 0,
	Minimum = 0,
	Maximum = 8,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities["Concentration"] = Value
	end,
}, "Concentration")

sections.MainSection20:Slider({
	Name = "Hawk Eye",
	Default = 0,
	Minimum = 0,
	Maximum = 8,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities["Hawk Eye"] = Value
	end,
}, "Hawk Eye")

sections.MainSection20:Slider({
	Name = "Gold Coin",
	Default = 0,
	Minimum = 0,
	Maximum = 8,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities["Gold Coin"] = Value
	end,
}, "Gold Coin")

sections.MainSection20:Slider({
	Name = "Healthy",
	Default = 0,
	Minimum = 0,
	Maximum = 8,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities["Healthy"] = Value
	end,
}, "Healthy")

sections.MainSection20:Slider({
	Name = "Stone Skin",
	Default = 0,
	Minimum = 0,
	Maximum = 8,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities["Stone Skin"] = Value
	end,
}, "Stone Skin")

sections.MainSection20:Slider({
	Name = "Speedy",
	Default = 0,
	Minimum = 0,
	Maximum = 8,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities["Speedy"] = Value
	end,
}, "Speedy")

sections.MainSection20:Slider({
	Name = "Invasion",
	Default = 0,
	Minimum = 0,
	Maximum = 8,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities["Invasion"] = Value
	end,
}, "Invasion")

sections.MainSection20:Toggle({
	Name = "Auto Card",
	Default = false,
	Callback = function(value)
		getgenv().autoCardEnabled = value
		if value then
			autoCardFunction()
		end
	end,
}, "autoCardToggle")

sections.MainSection21:Header({
	Name = "Boss Rush Cards",
})

sections.MainSection21:Slider({
	Name = "Metal Skin",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Metal Skin"] = Value
	end,
}, "Metal Skin")

sections.MainSection21:Slider({
	Name = "Raging Power",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Raging Power"] = Value
	end,
}, "Raging Power")

sections.MainSection21:Slider({
	Name = "Venoshock",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Venoshock"] = Value
	end,
}, "Venoshock")

sections.MainSection21:Slider({
	Name = "Demon Takeover",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Demon Takeover"] = Value
	end,
}, "Demon Takeover")

sections.MainSection21:Slider({
	Name = "Fortune",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Fortune"] = Value
	end,
}, "Fortune")

sections.MainSection21:Slider({
	Name = "Chaos Eater",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Chaos Eater"] = Value
	end,
}, "Chaos Eater")

sections.MainSection21:Slider({
	Name = "Godspeed",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Godspeed"] = Value
	end,
}, "Godspeed")

sections.MainSection21:Slider({
	Name = "Insanity",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Insanity"] = Value
	end,
}, "Insanity")

sections.MainSection21:Slider({
	Name = "Feeding Madness",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Feeding Madness"] = Value
	end,
}, "Feeding Madness")

sections.MainSection21:Slider({
	Name = "Emotional Damage",
	Default = 0,
	Minimum = 0,
	Maximum = 10,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities2["Emotional Damage"] = Value
	end,
}, "Emotional Damage")

sections.MainSection21:Toggle({
	Name = "Auto Boss Rush Card",
	Default = false,
	Callback = function(value)
		getgenv().autoBossRushCardEnabled = value
		if value then
			cardPriorities2["Metal Skin"] = MacLib.Options["Metal Skin"].Value
			cardPriorities2["Raging Power"] = MacLib.Options["Raging Power"].Value
			cardPriorities2["Venoshock"] = MacLib.Options["Venoshock"].Value
			cardPriorities2["Demon Takeover"] = MacLib.Options["Demon Takeover"].Value
			cardPriorities2["Fortune"] = MacLib.Options["Fortune"].Value
			cardPriorities2["Chaos Eater"] = MacLib.Options["Chaos Eater"].Value
			cardPriorities2["Godspeed"] = MacLib.Options["Godspeed"].Value
			cardPriorities2["Insanity"] = MacLib.Options["Insanity"].Value
			cardPriorities2["Feeding Madness"] = MacLib.Options["Feeding Madness"].Value
			cardPriorities2["Emotional Damage"] = MacLib.Options["Emotional Damage"].Value
			autoBossRushCardFunction()
		end
	end,
}, "autoBossRushCardToggle")

sections.MainSection22:Header({
	Name = "Macro",
})

RecordingMethodLabel = sections.MainSection22:Label({
	Text = "Recording Method: Not Recording",
})

SelectedMacroLabel = sections.MainSection22:Label({
	Text = "Selected Macro: None",
})

RecordingStatusLabel = sections.MainSection22:Label({
	Text = "Status: None",
})

sections.MainSection22:Divider()

updateDropdownFunction()

selectedUIMacro = sections.MainSection22:Dropdown({
	Name = "Select Macro",
	Multi = false,
	Required = true,
	Options = macros,
	Default = "None",
	Callback = function(Value)
		selectedMacro = Value:gsub(".json$", ""):gsub(".*/", ""):gsub(".*\\", "")
		if selectedMacro == "None" then
			selectedMacro = nil
		end
		SelectedMacroLabel:UpdateName("Selected Macro: " .. (selectedMacro or "None"))
	end,
}, "selectedUIMacro")

local MacroName = sections.MainSection22:Input({
	Name = "Macro Name",
	Placeholder = "Enter Macro Name",
	AcceptedCharacters = "All",
	Callback = function(value)
		macroName = value
	end,
	onChanged = function(value)
		macroName = value
	end,
}, "MacroName")

sections.MainSection22:Button({
	Name = "Refresh Dropdown",
	Callback = function()
		updateDropdownFunction()
	end,
})

sections.MainSection22:Button({
	Name = "Create Macro",
	Callback = function(Value)
		if macroName and macroName ~= "" then
			createJsonFileFunction(macroName)
			if SelectedMacroLabel then
				SelectedMacroLabel:UpdateName("Selected Macro: " .. (macroName or "None"))
			end
		else
			Window:Notify({
				Title = "Error",
				Description = "Please enter a macro name first",
				Lifetime = 3,
			})
		end
	end,
})

sections.MainSection22:Button({
	Name = "Delete Macro",
	Callback = function()
		if selectedMacro and selectedMacro ~= "None" then
			local filePath = macrosFolder .. "/" .. selectedMacro .. ".json"
			if isfile(filePath) then
				delfile(filePath)
				selectedMacro = "None"
				if SelectedMacroLabel then
					SelectedMacroLabel:UpdateName("Selected Macro: None")
				end
			end
		else
			Window:Notify({
				Title = "Error",
				Description = "Please select a macro to delete",
				Lifetime = 3,
			})
		end
	end,
})

sections.MainSection22:Button({
	Name = "Equip Macro Units",
	Callback = function()
		equipMacroFunction()
	end,
})

RecordMacro = sections.MainSection22:Toggle({	
	Name = "Record Macro",
	Default = false,
	Callback = function(value)
		if value then
			if not selectedMacro or selectedMacro == "None" then
				Window:Notify({
					Title = "Error",
					Description = "Please select a macro first",
					Lifetime = 3,
				})
				RecordMacro:UpdateState(false)
				return
			end

			if not selectedTypeOfRecord or selectedTypeOfRecord == "None" then
				Window:Notify({
					Title = "Error",
					Description = "Please select a recording method first",
					Lifetime = 3,
				})
				RecordMacro:UpdateState(false)
				return
			end

			if not startFrameFind() then
				Window:Notify({
					Title = "Error",
					Description = "Please start the game before recording macro",
					Lifetime = 3,
				})
				RecordMacro:UpdateState(false)
				return
			end
			getgenv().macroRecordControlEnabled = true
			local filePath = macrosFolder .. "/" .. selectedMacro .. ".json"
			recordingMacroFunction()
			task.spawn(macroRecordControlFunction)
		else
			getgenv().macroRecordControlEnabled = false
			updateRecordingStatus()
			if isRecording then
				isRecording = false
				stopRecordingMacro()
			end
		end
	end,
}, "RecordMacroToggle")

PlayMacro = sections.MainSection22:Toggle({
	Name = "Play Macro",
	Default = false,
	Callback = function(value)
		if value then
			if not selectedMacro or selectedMacro == "None" then
				Window:Notify({
					Title = "Error",
					Description = "Please select a macro first",
					Lifetime = 3,
				})
				PlayMacro:UpdateState(false)
				return
			end
			playMacro(selectedMacro)
		else
			isPlaying = false
			updateRecordingStatus()
		end
	end,
}, "PlayMacroToggle")

sections.MainSection22:Slider({
	Name = "Delay Macro",
	Default = 0.2,
	Minimum = 0,
	Maximum = 1,
	DisplayMethod = "Number",
	Precision = 1,
	Callback = function(Value)
		selectedDelayMacro = Value
	end,
}, "selectedDelayMacroSlider")

local SelectedRecordingMethod = sections.MainSection22:Dropdown({
	Name = "Select Type of Record",
	Multi = false,
	Required = true,
	Options = { "Time", "Money", "Hybrid" },
	Default = "None",
	Callback = function(Value)
		selectedTypeOfRecord = Value
		RecordingMethodLabel:UpdateName("Recording Method: " .. selectedTypeOfRecord)
		if selectedTypeOfRecord == "Time" or selectedTypeOfRecord == "Hybrid" then
			startTime = tick()
		end
	end,
}, "SelectedRecordingMethod")

sections.MainSection22:Toggle({
	Name = "Record Skill in Macro",
	Default = false,
	Callback = function(value)
		getgenv().recordSkillEnabled = value
	end,
}, "RecordSkillMacroToggle")

--UI IMPORTANT THINGS

MacLib:SetFolder("Maclib")

sections.MainSection25:Toggle({
	Name = "Hide UI when Execute",
	Default = false,
	Callback = function(value)
		MacLib:HideUI(value)
	end,
}, "HideUiWhenExecuteToggle")

sections.MainSection25:Toggle({
	Name = "Low cpu usage",
	Default = false,
	Callback = function(value)
		getgenv().createBCEnabled = value
		blackScreenFunction()
	end,
}, "BlackScreenToggle")

sections.MainSection25:Toggle({
	Name = "FPS Boost",
	Default = false,
	Callback = function(value)
		getgenv().fpsBoostEnabled = value
		fpsBoostFunction()
	end,
}, "FPSBoostToggle")

Window.onUnloaded(function() end)

tabs.Main:Select()

MacLib:SetFolder("Tempest Hub")
MacLib:SetFolder("Tempest Hub/_ALS_")
local GameConfigName = "_ALS_"
local player = game.Players.LocalPlayer
MacLib:LoadConfig(player.Name .. GameConfigName)
spawn(function()
	while task.wait() do
		MacLib:SaveConfig(player.Name .. GameConfigName)	
	end
end)

local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = game:GetService("Players").LocalPlayer
LocalPlayer.Idled:Connect(function()
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end)
