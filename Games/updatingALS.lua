if game.GameId ~= 4509896324 then
	return
end

if getgenv().executedEnabled == "A" then
	return warn("Cannot Run the script more than 1 time")
end
getgenv().executedEnabled = true
repeat
	task.wait()
until game:IsLoaded()
task.wait(1)
warn("[TEMPEST HUB] Loading Ui")
task.wait()

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
task.wait()
warn("[TEMPEST HUB] Loading Toggles")
task.wait()
warn("[TEMPEST HUB] Last Checking")
task.wait()

--Locals
getgenv().selectedDelay = getgenv().selectedDelay or 5
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local originalSizes = {}
local pcSize2 = Vector2.new(850, 650)
local mobileSize2 = Vector2.new(650, 400)
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
cardPriorities3 = {}
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
	return table.find(unitsFarm, unit) ~= nil
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

local Scoped
task.spawn(function()
	local FusionPackage = game:GetService("ReplicatedStorage").FusionPackage
	local v_u_2 = require(FusionPackage.Fusion)
	local v_u_11 = require(game:GetService("ReplicatedStorage").Modules.ReplicaHolder.State)
	local l_scoped_0 = v_u_2:FindFirstChild("scoped")
	Scoped = l_scoped_0(v_u_2, v_u_11)
end)

local EquippedUnitsInSlot = {}
for _, v in pairs(initialData.Slots) do
	table.insert(EquippedUnitsInSlot, v.Value)
end
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
		task.wait(0.1)
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

local teleportQueued
game.Players.LocalPlayer.OnTeleport:Connect(function(State)
	if
		LPH_OBFUSCATED
		and (State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress)
		and not teleportQueued
	then
		teleportQueued = true
		getgenv().executedEnabled = false
		queue_on_teleport(([[         
                repeat task.wait() until game:IsLoaded()
                task.wait(5)
                if (executedEnabled) then return end
                script_key="%s";
                loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/40d75f5df50d851207c664ea09c75938.lua"))()
        ]]):format(tostring(rawget(getfenv(), "script_key"))))
	end
end)

function firebutton(Button, method)
	if not Button then
		return
	end

	local a = Button

	pcall(function()
		if getconnections and method == "getconnections" then
			if Button.Activated then
				for i, v in pairs(getconnections(Button.Activated)) do
					task.wait()
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
			task.wait(1)
		end
	end)
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

local function AddComma(value)
	local formatted = tostring(value):reverse():gsub("(%d%d%d)", "%1,"):reverse()
	if formatted:sub(1, 1) == "," then
		formatted = formatted:sub(2)
	end
	return formatted
end

function webhookFunction()
	if not alreadySentWebhook then
		return
	end
	alreadySentWebhook = false
	task.spawn(function()
		while true do
			task.wait()
			local discordWebhookUrl = urlwebhook
			local player = game:GetService("Players").LocalPlayer

			local uiEndGame = player:WaitForChild("PlayerGui"):WaitForChild("EndGameUI")
			if uiEndGame and not alreadySentWebhook then
				local resultText = uiEndGame:FindFirstChild("BG")
				if resultText then
					local name = player.Name
					local formattedName = "||" .. name .. "||"
					local retorno = game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("GetPlayerData")
						:InvokeServer(player)

					local gotUnit = false
					local droppedUnit = ""
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
					local corals = retorno.SummerCorals or 0
					local treasure = retorno.SummerTreasure or 0
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

					local rewards = uiEndGame.BG.Container.Rewards:FindFirstChild("Holder")
					local portals = uiEndGame.BG.Container.Rewards:FindFirstChild("Holder")
					local units = uiEndGame.BG.Container.Rewards:FindFirstChild("Holder")
					local formattedResultFR = ""

					local function findDataKeys(itemName, dataTable)
						local normName = itemName:gsub("%W", ""):lower()
						local matches = {}
						for key in pairs(dataTable) do
							local normKey = key:gsub("%W", ""):lower()
							if normKey:find(normName, 1, true) then
								table.insert(matches, key)
							end
						end
						return matches
					end

					if rewards then
						local realRewards = rewards:GetChildren()
						for _, v in pairs(realRewards) do
							if v.Name ~= "UIListLayout" and v.Name ~= "UIPadding" then
								local amountLabel = v:FindFirstChild("Amount")
								local itemLabel = v:FindFirstChild("ItemName")
								if amountLabel and itemLabel and amountLabel.Text ~= "" and itemLabel.Text ~= "" then
									local keys = findDataKeys(itemLabel.Text, retorno.ItemData)
									local totalAmount = 0
									local hasValidAmount = false

									for _, k in ipairs(keys) do
										local amount = retorno.ItemData[k].Amount
										if amount ~= nil then
											totalAmount = totalAmount + amount
											hasValidAmount = true
										end
									end

									formattedResultFR = formattedResultFR .. amountLabel.Text .. " " .. itemLabel.Text

									if hasValidAmount then
										formattedResultFR = formattedResultFR .. " [" .. totalAmount .. "]"
									end

									formattedResultFR = formattedResultFR .. "\n"
								end
							end
						end
					end
					if portals then
						local realRewards = rewards:GetChildren()
						for _, v in pairs(realRewards) do
							if v.Name ~= "UIListLayout" and v.Name ~= "UIPadding" then
								local Tier = v:FindFirstChild("PortalTier")
								local Name = v:FindFirstChild("PortalName")

								if Tier and Name and Tier.Text ~= "" and Name.Text ~= "" then
									formattedResultFR = formattedResultFR .. Tier.Text .. " " .. Name.Text .. "\n"
								end
							end
						end
					end
					if units then
						local realRewards = rewards:GetChildren()
						for _, v in pairs(realRewards) do
							if v.Name ~= "UIListLayout" and v.Name ~= "UIPadding" then
								local Level = v:FindFirstChild("Level")
								local UnitName = v:FindFirstChild("UnitName")

								if Level and UnitName then
									gotUnit = true
									droppedUnit = UnitName.Text
									formattedResultFR = formattedResultFR .. "1x " .. UnitName.Text .. "\n"
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
					local mapTier = teleportData.Tier
					local mapDifficulty = tostring(teleportData.Difficulty or "Unknown Difficulty")
					local mapType = tostring(teleportData.Type or "Unknown Type")
					local mapAct = teleportData.MapNum

					local resultText = game:GetService("Players").LocalPlayer.PlayerGui
						:WaitForChild("EndGameUI").BG.Container.Stats.Result.Text
					local resultOnly
					if resultText:lower() == "defeat" then
						resultOnly = "Defeat"
					else
						resultOnly = "Victory"
					end

					local mapTypeString
					if mapTier then
						mapTypeString = string.format("%s T%s", mapType, tostring(mapTier))
					elseif mapAct then
						mapTypeString = string.format("%s T%s", mapType, tostring(mapAct))
					else
						mapTypeString = mapType
					end

					local matchResultString = string.format(
						"%s - Wave %s\n%s - %s [%s] - %s",
						tostring(formattedTime),
						tostring(waveOnly),
						mapTypeString,
						mapName,
						mapDifficulty,
						resultOnly
					)

					local pingContent = ""
					if getgenv().pingUserEnabled and getgenv().pingUserIdEnabled then
						pingContent = "<@" .. getgenv().pingUserIdEnabled .. ">"
					elseif getgenv().pingUserEnabled then
						pingContent = "@"
					end

					if gotUnit and getgenv().pingUserIdEnabled and getgenv().pingUserifGetUnitEnabled then
						pingContent = "U got " .. droppedUnit .. "<@" .. getgenv().pingUserIdEnabled .. ">"
					elseif gotUnit then
						pingContent = "U got " .. droppedUnit
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
											"<:emeraldALS:1357830472167719024> Emeralds: %s\n"
												.. "<:Jewel:1357831800063262813> Jewels: %s\n"
												.. "<:rerollShardALS:1357830474352951436> Rerolls: %s\n"
												.. "<:Gold:1357833327817658388> Gold: %s\n"
												.. "<:LargeEasterEgg:1363585587948425370> LargeEasterEgg: %s\n"
												.. "<:SmallEasterEgg:1363586043617742990> SmallEasterEgg: %s\n"
												.. "<:RaidTokenALS:1357832545202344028> Raid Tokens: %s\n"
												.. "<:titanbossrush:1360300733282517134> Boss Rush Tokens: %s\n"
												.. "<:godlybossrush:1360300746691575909> Titan Rush Tokens: %s\n"
												.. "<:Pearl:1361859005944696902> Pearl: %s\n"
												.. "<:DuskPearl:1361858992233644082> Dusk Pearl: %s\n"
												.. "<:SummerCoral:1395937400617963683> Red Coral: %s\n"
												.. "<:SummerTreasure:1395936937520402503> Pirate Treasure: %s",
											AddComma(emeralds),
											AddComma(jewels),
											AddComma(rerolls),
											AddComma(gold),
											AddComma(LargeEasterEgg),
											AddComma(SmallEasterEgg),
											AddComma(raidTokens),
											AddComma(bossRushTokens),
											AddComma(titantRushTokens),
											AddComma(amountPearl),
											AddComma(amountDuskPearl)
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

					local request = syn and syn.request or http_request or request
					local response = request({
						Url = discordWebhookUrl,
						Method = "POST",
						Headers = {
							["Content-Type"] = "application/json",
						},
						Body = payloadJson,
					})

					if response then
						alreadySentWebhook = true
						break
					end
				end
			end
			task.wait(1)
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
					name = "Anime Last Stand",
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
			task.wait()
		else
			task.wait()
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
			task.wait()
		end
	end
end

function verifyRerolls()
	local player = game.Players.LocalPlayer
	local retornoRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData")
	local currentData = retornoRemote:InvokeServer(player)
	local rerollsAtuais = currentData.Rerolls
	rerollsGastos = rerollsIniciais - rerollsAtuais
	return rerollsGastos
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
			return
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
			return
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
		task.wait(1)
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

function autoAntiZoneFunction()
	while getgenv().autoAntiZoneEnabled and task.wait(0.1) do
		local character = game.Players.LocalPlayer.Character
		if not character then
			continue
		end

		local zone = workspace.EffectZones:FindFirstChild("ZoneHitbox")
		if not zone then
			continue
		end

		character:PivotTo(zone.CFrame)
	end
end

function autoAntiOrbFunction()
	task.wait(10)
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	local interactRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Interact")
	local orbFolder = workspace:WaitForChild("Map"):WaitForChild("ActiveOrbs")

	local function interactWithOrb(orbModel)
		if orbModel and orbModel:IsA("Model") and orbModel:FindFirstChild("PrimaryPart") then
			root.CFrame = orbModel.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
		else
			local part = orbModel:FindFirstChildWhichIsA("BasePart")
			if part then
				root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
			end
		end

		task.wait(0.25)

		interactRemote:FireServer(orbModel)
	end

	while true do
		for _, orb in ipairs(orbFolder:GetChildren()) do
			interactWithOrb(orb)
			task.wait(0.5)
		end
		task.wait(1)
	end
end

function startFrameFind()
	local player = game:GetService("Players").LocalPlayer
	local bottom = player:WaitForChild("PlayerGui"):FindFirstChild("Bottom")

	if bottom then
		local bottomFrame = bottom:FindFirstChild("Frame")
		if bottomFrame then
			local found = false

			for _, childFrame in ipairs(bottomFrame:GetChildren()) do
				if childFrame:IsA("Frame") and childFrame.Name == "Frame" then
					local count = 0

					for _, subChild in ipairs(childFrame:GetChildren()) do
						if subChild:IsA("Frame") and subChild.Name == "Frame" then
							count += 1
						end
					end

					if count == 3 then
						found = true
						break
					end
				end
			end

			if found then
				return false
			else
				return true
			end
		end
	end
end

function autoStartFunction()
	while getgenv().autoStartEnabled == true do
		if selectedStoryYet == true then
			task.wait(1)
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
		task.wait()
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
		task.wait(1)
	end
end

function autoRetryFunction()
	while getgenv().autoRetryEnabled == true do
		local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
		if prompt then
			local button2 = prompt.TextButton:FindFirstChild("TextButton")
			if button2 then
				firebutton(button2, "VirtualInputManager")
				task.wait(1)
			end
		end
		local uiEndGame = player:FindFirstChild("PlayerGui"):WaitForChild("EndGameUI")
		if uiEndGame then
			local button = uiEndGame.BG.Buttons:FindFirstChild("Retry")
			if button then
				task.wait(3)
				firebutton(button, "VirtualInputManager")
				task.wait(2)
			end
		end
		task.wait(1)
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
				task.wait(1)
				firebutton(button, "VirtualInputManager")
			end
		end
		task.wait(1)
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
				task.wait(1)
				firebutton(button, "VirtualInputManager")
			end
		end
		task.wait(1)
	end
end

function sellUnitFunction()
	while getgenv().sellUnitEnabled == true do
		local mainUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local selectedWave = MacLib.Options.SellUnitAtWaveXToggle.Value
			local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value
			if tonumber(waveValue) >= tonumber(selectedWave) then
				local towers = workspace:FindFirstChild("Towers")
				if towers then
					for _, unit in ipairs(towers:GetChildren()) do
						local ownerUnit = unit:FindFirstChild("Owner")
						if
							ownerUnit
							and ownerUnit.Value
							and tostring(ownerUnit.Value) == tostring(game.Players.LocalPlayer)
						then
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
		end
		task.wait(1)
	end
end

function EquipTeamByMode()
	local teleportData = game:GetService("ReplicatedStorage").Remotes.GetTeleportData:InvokeServer()
	if not teleportData then
		return
	end
	local mapType = tostring(teleportData.Type or "Unknown Type")
	local equipRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EquipTeam")

	local mapTeamMap = {
		Story = selectedTeamToStory,
		Infinite = selectedTeamToStory,
		LegendaryStages = selectedTeamToLegendStage,
		Survival = selectedTeamToSurvival,
		Dungeon = selectedTeamToDungeon,
		Raids = selectedTeamToRaid,
		BossRush = selectedTeamToBossRush,
		ExtremeBoosts = selectedTeamToExtremeBoost,
		Challenge = selectedTeamToChallenge,
		ElementalCaverns = selectedTeamToElementalCavern,
		InfiniteCastle = selectedTeamToInfiniteCastle,
		Portal = selectedTeamToPortal,
	}

	local selectedTeam = mapTeamMap[mapType]

	if selectedTeam then
		if tonumber(selectedTeam) then
			equipRemote:FireServer(tonumber(selectedTeam))
		end
	else
		warn("Unknown Mode:", mapType)
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
						local ownerUnit = unit:FindFirstChild("Owner")
						if
							ownerUnit
							and ownerUnit.Value
							and tostring(ownerUnit.Value) == tostring(game.Players.LocalPlayer)
						then
							if table.find(unitsToSell, unit.Name) then
								game:GetService("ReplicatedStorage").Remotes.Sell:InvokeServer(unit)
							end
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
	local playerCash = player:WaitForChild("Cash")
	local TowerInfos = require(game:GetService("ReplicatedStorage").Modules.TowerInfo)

	while getgenv().upgradeUnitEnabled do
		local mainUI = player.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local waveValue = tonumber(repStorage:WaitForChild("Wave").Value) or 0
			local slots = player:FindFirstChild("Slots")

			if slots then
				local farmCandidates = {}
				local otherCandidates = {}
				local costs = {}
				for i = 1, 6 do
					local slotInst = slots:FindFirstChild("Slot" .. i)
					local unitName = slotInst and slotInst.Value
					local maxUpgrade = MacLib.Options["Unit" .. i .. "Up"].Value
					local requiredWave = tonumber(MacLib.Options["waveUnit" .. i .. "Slider"].Value) or 0

					if getgenv().onlyupgradeinwaveXEnabled then
						if waveValue < requiredWave then
							break
						end
					end

					if unitName then
						for _, unitInst in ipairs(towersFolder:GetChildren()) do
							local ownerUnit = unitInst:FindFirstChild("Owner")
							if
								ownerUnit
								and ownerUnit.Value
								and tostring(ownerUnit.Value) == tostring(game.Players.LocalPlayer)
							then
								if unitInst.Name:find(unitName) then
									local upgradeValue = unitInst:FindFirstChild("Upgrade")
									if upgradeValue and upgradeValue.Value < maxUpgrade then
										local Info = TowerInfos[unitInst.Name]
										if Info then
											if not Info[upgradeValue.Value + 1] then
												continue
											end
											if not (playerCash.Value >= Info[upgradeValue.Value + 1].Cost) then
												continue
											end
										end
										table.insert(otherCandidates, unitInst)
										costs[unitInst] = Info[upgradeValue.Value + 1].Cost
									end
								end
							end
						end
					end
				end

				table.sort(otherCandidates, function(a, b)
					if a.Name == "AiHoshinoEvo" and b.Name ~= "AiHoshinoEvo" then
						return true
					end
					return isFarmUnit(a.Name) and not isFarmUnit(b.Name)
				end)

				local endUI = player.PlayerGui:FindFirstChild("EndGameUI")
				if not endUI then
					for _, unitInst in ipairs(otherCandidates) do
						if costs[unitInst] and playerCash.Value < costs[unitInst] then
							continue
						end
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
		task.wait()
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
	if getgenv().isPlacingUnits then
		return
	end
	getgenv().isPlacingUnits = true
	task.wait(2)

	while getgenv().placeUnitsEnabled do
		local uiEndGame = player.PlayerGui:FindFirstChild("EndGameUI")
		if uiEndGame and uiEndGame.Enabled then
			task.wait(1)
			continue
		end
		local opts = MacLib.Options
		local distPercent = opts.selectedDistancePercentage.Value
		local groundPercent = opts.selectedGroundPercentage.Value

		local placeMax, waveThreshold = {}, {}
		for i = 1, 6 do
			placeMax[i] = opts["Unit" .. i].Value
			waveThreshold[i] = tonumber(opts["waveUnit" .. i .. "Slider"].Value) or 0
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
							if c:IsA("TextButton") then
								table.insert(btns, c)
							end
						end
						if #btns == 6 then
							for idx, btn in ipairs(btns) do
								local lbl = btn:FindFirstChild("Cost", true)
								if not lbl then
									costs[idx] = 0
									continue
								end
								local _ = lbl and lbl.Text:gsub("[$,]", "") or nil
								costs[idx] = lbl and tonumber(_) or 0
							end
							break
						end
					end
				end
			end

			-- 4) Conta torres existentes
			local towerCounts = {}
			local maxPlacement = {}
			local towers = workspace:FindFirstChild("Towers")
			if towers then
				for _, t in ipairs(towers:GetChildren()) do
					local baseName = t:GetAttribute("UnitName") or t.Name
					if t:FindFirstChild("PlacementLimit") then
						local limit = t.PlacementLimit.Value
						if limit > 0 then
							maxPlacement[baseName] = (maxPlacement[baseName] or 0) + limit
						end
					end
					towerCounts[baseName] = (towerCounts[baseName] or 0) + 1
				end
			end
			-- 5) Seleciona unidades para equipar
			local waveValue = waveTag.Value
			local cash = player:FindFirstChild("Cash")
			local equippedUnits = {}

			-- 5.1) . PRIORIDADE (slots 1→6)
			for i = 6, 1, -1 do
				if waveValue >= waveThreshold[i] then
					local slot = slotsFolder:FindFirstChild("Slot" .. i)
					local name = slot and slot.Value or ""
					if
						name ~= ""
						and (towerCounts[name] or 0) < placeMax[i]
						and cash
						and cash.Value >= (costs[i] or 0)
					then
						if maxPlacement[name] then
							if towerCounts[name] >= maxPlacement[name] then
								continue
							end
						end
						table.insert(equippedUnits, { UnitName = name, Slot = i })
						break
					end
				end
			end

			-- 5.2) . FALLBACK: todos os slots
			if #equippedUnits == 0 then
				for i = 1, 6 do
					if waveValue >= waveThreshold[i] then
						local slot = slotsFolder:FindFirstChild("Slot" .. i)
						local name = slot and slot.Value or ""
						if
							name ~= ""
							and (towerCounts[name] or 0) < placeMax[i]
							and cash
							and cash.Value >= (costs[i] or 0)
						then
							if maxPlacement[name] then
								if towerCounts[name] >= maxPlacement[name] then
									continue
								end
							end
							table.insert(equippedUnits, { UnitName = name, Slot = i })
						end
					end
				end
			end

			-- 6) Dispara PlaceTower para cada unidade selecionada
			if #equippedUnits > 0 then
				table.sort(equippedUnits, function(a, b)
					return isFarmUnit(a.UnitName) and not isFarmUnit(b.UnitName)
				end)

				local radius = (groundPercent / 100) * 13
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
	getgenv().isPlacingUnits = false
end

function autoAbilitySkills()
	local ElapsedTime = game:GetService("ReplicatedStorage"):WaitForChild("ElapsedTime")
	local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave")
	local mainUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainUI")
	local TowerInfos = require(game:GetService("ReplicatedStorage").Modules.TowerInfo)

	while task.wait(3) do
		local Towers = {}
		for _, v in pairs(workspace.Towers:GetChildren()) do
			local name = v:GetAttribute("UnitName") or v.Name
			if not Towers[name] then
				Towers[name] = {}
			end
			table.insert(Towers[name], v)
		end
		for _ = 1, 4 do
			while not (MacLib and MacLib.Options) do
				task.wait(0.1)
			end
			local Unit = MacLib.Options[("autoAbilityDropdown%s"):format(_)].Value
			local UseSkill1InWave = MacLib.Options[("skill1WaveSlider%s"):format(_)].Value
			local OnlyuseSkill1inboss = MacLib.Options[("onlyUseSkill1InBossToggle%s"):format(_)].State
			local OnlyuseSkill1inWave = MacLib.Options[("onlyUseSkill1InWaveToggle%s"):format(_)].State

			if (not Unit or Unit == "None") or not Towers[Unit] then
				continue
			end

			if OnlyuseSkill1inWave == false then
				continue
			end
			if OnlyuseSkill1inWave and not (tonumber(waveValue.Value) >= tonumber(UseSkill1InWave)) then
				continue
			end

			if OnlyuseSkill1inboss and not mainUI.BarHolder:FindFirstChild("Boss") then
				continue
			end

			for __, ohInstance1 in Towers[Unit] do
				if not ohInstance1:FindFirstChild("Upgrade") then
					continue
				end
				local Info = TowerInfos[ohInstance1.Name][ohInstance1.Upgrade.Value]
				local Abilitys = Info and (Info.Ability or Info.Abilities) or nil
				if not Abilitys then
					continue
				end
				for i = 1, (#Abilitys == 0 and 1 or #Abilitys) do
					local Ability = Abilitys[i] or Abilitys
					local IsCdGlobal = Ability.IsCdGlobal
					local AbilityName = Ability.Name

					local Cooldowns = Scoped:ReplicaState("AbilityCooldowns")._EXTREMELY_DANGEROUS_usedAsValue
					local Cooldown = IsCdGlobal and Cooldowns.Global[AbilityName]
						or (Cooldowns.Towers[ohInstance1.Name] and Cooldowns.Towers[ohInstance1.Name][AbilityName])
					if Cooldown then
						local RemainingTime = math.max(0, Cooldown.EndTime - ElapsedTime.Value)
						if RemainingTime > 0 then
							continue
						end
					end
					pcall(function()
						game:GetService("ReplicatedStorage").Remotes.Ability:InvokeServer(ohInstance1, i)
					end)
				end
			end
		end
	end
end
task.spawn(autoAbilitySkills)

function autoUniversalSkillFunction()
	while getgenv().autoUniversalSkillEnabled == true do
		local mainUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainUI")

		if mainUI then
			local bossHealth = mainUI.BarHolder:FindFirstChild("Boss")
			local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value
			local selectedWave = MacLib.Options.selectedWaveXToUseSKill.Value
			local remoteHandler = game:GetService("Players").LocalPlayer.PlayerScripts.Visuals
				:FindFirstChild("RemoteHandler")
			local towersFolder = workspace:WaitForChild("Towers")

			if getgenv().onlyUseSkillsInBossEnabled and bossHealth then
				for i, v in pairs(workspace.Towers:GetChildren()) do
					local ohInstance1 = v
					for fafa = 1, 4 do
						game:GetService("ReplicatedStorage").Remotes.Ability:InvokeServer(ohInstance1, fafa)
					end
				end
			elseif tonumber(waveValue) == tonumber(selectedWave) then
				for i, v in pairs(workspace.Towers:GetChildren()) do
					local ohInstance1 = v
					local skills =
						game:GetService("ReplicatedStorage"):FindFirstChild("UnitVFX"):FindFirstChild("Abilities")
					for allSkills, skill in pairs(skills:GetChildren()) do
						game:GetService("ReplicatedStorage").Remotes.Ability:InvokeServer(ohInstance1, allSkills)
						wait(0.1)
					end
				end
			end
		end
		task.wait(10)
	end
end

function autoRengokuModeFunction()
	while getgenv().autoRengokuModeEnabled == true do
		task.wait(0.5)
		local map = workspace:FindFirstChild("Map")
		if map then
			local RengokuInMap = workspace:FindFirstChild("Towers"):FindFirstChild("RengokuDemon")
			local remoteRengoku = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")
			if RengokuInMap and remoteRengoku and RengokuInMap.Upgrade.Value >= 10 then
				local ohInstance1 = workspace.Towers.RengokuDemon
				local ohNumber2 = 1
				remoteRengoku:InvokeServer(ohInstance1, ohNumber2)
				task.wait(1)
				break
			end
		end
	end
	task.wait()
end

function autoArthurModeFunction()
	while getgenv().autoArthurModeEnabled == true do
		task.wait(0.5)
		local map = workspace:FindFirstChild("Map")
		if map then
			local ArthurInMap = workspace:FindFirstChild("Towers"):FindFirstChild("ArthurStarRing")
			local remoteArthur = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")
			if ArthurInMap and remoteArthur and ArthurInMap.Upgrade.Value >= 12 then
				local ohInstance1 = workspace.Towers.ArthurStarRing
				local ohNumber2 = 1
				remoteArthur:InvokeServer(ohInstance1, ohNumber2)
				task.wait(1)
				break
			end
		end
	end
	task.wait()
end

function autoNinelModeFunction()
	while getgenv().autoNinelModeEnabled == true do
		task.wait(0.5)
		local map = workspace:FindFirstChild("Map")
		if map then
			local NinelInMap = workspace:FindFirstChild("Towers"):FindFirstChild("NoelEvoEZA")
			local remoteNinel = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")
			if NinelInMap and remoteNinel and NinelInMap.Upgrade.Value >= 11 then
				local ohInstance1 = workspace.Towers.NoelEvoEZA
				local ohNumber2 = 2
				remoteNinel:InvokeServer(ohInstance1, ohNumber2)
				task.wait(1)
				break
			end
		end
	end
	task.wait()
end

function autoCanrodCopyFunction()
	while getgenv().autoCanrodCopyEnabled == true do
		task.wait(0.5)
		local map = workspace:FindFirstChild("Map")
		if map then
			local CanrodInMap = workspace:FindFirstChild("Towers"):FindFirstChild("CanrodEvo")
			local remoteCanrod = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")
			local canrodSlots = game:GetService("ReplicatedStorage").Remotes
				:FindFirstChild("AbilityRemotes")
				:FindFirstChild("SelectHotbarSlot")

			if CanrodInMap and remoteCanrod and CanrodInMap.Upgrade.Value >= 4 and canrodSlots then
				local ohInstance1 = workspace.Towers.CanrodEvo
				local ohNumber2 = 2

				remoteCanrod:InvokeServer(ohInstance1, ohNumber2)
				task.wait(3)
				local ohNumber1 = tostring(selectedSlotToCopyValue)
				canrodSlots:FireServer(ohNumber1)

				task.wait(1)
				break
			end
		end
	end
	task.wait()
end

function autoKurumiSkillFunction()
	task.wait(2)
	while getgenv().autoKurumiSkillEnabled == true do
		local map = workspace:FindFirstChild("Map")

		if map then
			local KurumiInMap = workspace:FindFirstChild("Towers"):FindFirstChild("KurumiEvo")
			local remoteKurumi =
				game:GetService("ReplicatedStorage").Remotes:FindFirstChild("AbilityRemotes"):FindFirstChild("Zaphkol")
			local remoteAbility = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")

			if KurumiInMap and remoteKurumi and remoteAbility and KurumiInMap.Upgrade.Value >= 8 then
				local ohInstance1 = workspace.Towers.KurumiEvo
				local ohNumber2 = 1

				remoteAbility:InvokeServer(ohInstance1, ohNumber2)
				task.wait(3)
				local ohString1 = tostring(selectedKurumiSkillType)

				remoteKurumi:FireServer(ohString1)
				break
			end
		end
		task.wait(1)
	end
end

function autoGarouSkillFunction()
	task.wait(2)
	while getgenv().autoGarouSkillEnabled == true do
		local map = workspace:FindFirstChild("Map")

		if map then
			local GarouInMap = workspace:FindFirstChild("Towers"):FindFirstChild("CosmicGarou")
			local remoteGarou = game:GetService("ReplicatedStorage").Remotes
				:FindFirstChild("AbilityRemotes")
				:FindFirstChild("Mode Swap")
			local remoteAbility = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")

			if GarouInMap and remoteGarou and remoteAbility and GarouInMap.Upgrade.Value >= 2 then
				local ohInstance1 = workspace.Towers.CosmicGarou
				local ohNumber2 = 1

				remoteAbility:InvokeServer(ohInstance1, ohNumber2)
				task.wait(3)
				local ohString1 = tostring(selectedGarouSkillType)

				remoteGarou:FireServer(ohString1)
				break
			end
		end
		task.wait(1)
	end
end

function autoShirouSkillFunction()
	task.wait(2)
	while getgenv().autoShirouEnabled == true do
		local map = workspace:FindFirstChild("Map")

		if map then
			local ShirouInMap = workspace:FindFirstChild("Towers"):FindFirstChild("ShirouEvo")
			local remoteShirou =
				game:GetService("ReplicatedStorage").Remotes:FindFirstChild("AbilityRemotes"):FindFirstChild("Tracing")
			local remoteAbility = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")

			if ShirouInMap and remoteShirou and remoteAbility and ShirouInMap.Upgrade.Value >= 11 then
				local ohInstance1 = workspace.Towers.ShirouEvo
				local ohNumber2 = 1

				remoteAbility:InvokeServer(ohInstance1, ohNumber2)
				task.wait(3)
				local ohString1 = tostring(selectedShirouSkillType)

				remoteShirou:FireServer(ohString1)
				break
			end
		end
		task.wait(1)
	end
end

function autoGilgameshSkillFunction()
	task.wait(2)
	while getgenv().autoGilgameshSkillEnabled == true do
		local map = workspace:FindFirstChild("Map")

		if map then
			local GilgameshInMap = workspace:FindFirstChild("Towers"):FindFirstChild("GilgameshEvoEZA")
			local remoteGilgamesh = game:GetService("ReplicatedStorage").Remotes
				:FindFirstChild("AbilityRemotes")
				:FindFirstChild("Sacred Treasures")
			local remoteAbility = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")

			if GilgameshInMap and remoteGilgamesh and remoteAbility and GilgameshInMap.Upgrade.Value >= 10 then
				local ohInstance1 = workspace.Towers.GilgameshEvoEZA
				local ohNumber2 = 1

				remoteAbility:InvokeServer(ohInstance1, ohNumber2)
				task.wait(3)
				local ohString1 = tostring(selectedGilgameshSkill)

				remoteGilgamesh:FireServer(ohString1)
				break
			end
		end
		task.wait(1)
	end
end

function autoCanrodSkillFunction()
	task.wait(2)
	while getgenv().autoCanrodSkillEnabled == true do
		local map = workspace:FindFirstChild("Map")

		if map then
			local CanrodInMap = workspace:FindFirstChild("Towers"):FindFirstChild("CanrodEvo")
			local remoteCanrod = game:GetService("ReplicatedStorage").Remotes
				:FindFirstChild("AbilityRemotes")
				:FindFirstChild("ElementalMastery")
			local remoteAbility = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")

			if CanrodInMap and remoteCanrod and remoteAbility and CanrodInMap.Upgrade.Value >= 1 then
				local ohInstance1 = workspace.Towers.CanrodEvo
				local ohNumber2 = 1

				remoteAbility:InvokeServer(ohInstance1, ohNumber2)
				task.wait(3)
				local ohString1 = tostring(selectedCanrodSkillType)

				remoteCanrod:FireServer(ohString1)
				break
			end
		end
		task.wait(1)
	end
end

function autoIdolFunction()
	while getgenv().autoIdolEnabled == true do
		task.wait(0.5)
		local map = workspace:FindFirstChild("Map")
		if map then
			local IdolInMap = workspace:FindFirstChild("Towers"):FindFirstChild("AiHoshinoEvo")
			local remoteIdol = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")
			if IdolInMap and remoteIdol and IdolInMap.Upgrade.Value == 6 then
				local ohInstance1 = workspace.Towers.AiHoshinoEvo
				local ohNumber2 = "Concert"
				remoteIdol:InvokeServer(ohInstance1, ohNumber2)
				task.wait(10)
			end
		end
	end

	task.wait()
end

function autoGojoTSFunction()
	while getgenv().autoGojoTSEnabled == true do
		task.wait(0.5)
		local map = workspace:FindFirstChild("Map")
		if map then
			local GojoInMap = workspace:FindFirstChild("Towers"):FindFirstChild("GojoEvo2EZA")
			local remoteGojo = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")
			if GojoInMap and remoteGojo then
				local ohInstance1 = workspace.Towers.GojoEvo2EZA
				local ohNumber2 = "Unlimited Void"
				remoteGojo:InvokeServer(ohInstance1, ohNumber2)
				task.wait(10)
			end
		end
	end
	task.wait()
end
function autoPucciResetFunction()
	while getgenv().autoPucciResetEnabled == true do
		task.wait(0.5)
		local map = workspace:FindFirstChild("Map")
		local selectedWave = MacLib.Options.ResetPucciInWaveToggle.Value
		local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value

		if map and tonumber(waveValue) == tonumber(selectedWave) then
			local PucciInMap = workspace:FindFirstChild("Towers"):FindFirstChild("Pucci Made In Heaven")
			local remotePucci = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Ability")
			if PucciInMap and remotePucci and PucciInMap.Upgrade.Value >= 10 then
				local ohInstance1 = workspace.Towers["Pucci Made In Heave"]
				local ohNumber2 = "Reset The Universe"
				remotePucci:InvokeServer(ohInstance1, ohNumber2)
				task.wait(1)
				break
			end
		end
	end
	task.wait()
end

function autoRestartAfterXMatchFunction()
	task.wait(2)
	while getgenv().autoRestartAfterXMatchEnabled == true do
		repeat
			task.wait()
		until game:IsLoaded() and game:GetService("Players").LocalPlayer

		local SCRIPT_ENABLED = true
		local MATCH_LIMIT = MacLib.Options.selectedMatchXToRestartSlider.Value
		local MATCH_DELAY = 7

		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local RestartMatch = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("RestartMatch")

		local matchCounter = 0
		local matchEnded = false
		local player = game.Players.LocalPlayer

		local finishPart = nil
		repeat
			finishPart = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Finish")
			if not finishPart then
				task.wait(1)
			end
		until finishPart

		local BaseHumanoid = nil
		repeat
			BaseHumanoid = finishPart:FindFirstChild("Humanoid")
			if not BaseHumanoid then
				task.wait(1)
			end
		until BaseHumanoid

		function onHealthChanged()
			if BaseHumanoid.Health <= 0 and not matchEnded then
				matchEnded = true
				matchCounter = matchCounter + 1

				if matchCounter == MATCH_LIMIT then
					task.wait(MATCH_DELAY)

					if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Finish") then
						RestartMatch:FireServer()
					else
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
function autoLeaveAfterXMatchesFunction()
	while getgenv().autoLeaveAfterXMatches == true do
		repeat
			task.wait()
		until game:IsLoaded() and game:GetService("Players").LocalPlayer

		local SCRIPT_ENABLED = true
		local MATCH_LIMIT = MacLib.Options.selectedMatchxToLeaveSlider.Value
		local MATCH_DELAY = 7

		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local TeleportBack = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("TeleportBack")

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
						TeleportBack:FireServer()
					end

					SCRIPT_ENABLED = false
				end
			elseif BaseHumanoid.Health > 0 then
				matchEnded = false
			end
		end

		BaseHumanoid.HealthChanged:Connect(onHealthChanged)

		onHealthChanged()
		task.wait(1)
	end
end

function autoLeaveInstaFunction()
	while getgenv().autoLeaveInstaEnabled == true do
		local mainUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local selectedWave = MacLib.Options.OnlyLeaveinWave.Value
			local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value

			OnlyLeaveinWave = MacLib.Options.OnlyLeaveinWave.Value

			if OnlyLeaveinWave and tonumber(waveValue) == tonumber(selectedWave) then
				task.wait(1)
				game:GetService("ReplicatedStorage").Remotes.TeleportBack:FireServer()
				break
			end
		end
		task.wait()
	end
end

function autoRestartFunction()
	while getgenv().autoRestartEnabled == true do
		local mainUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local selectedWave = MacLib.Options.RestartinWave.Value
			local waveValue = game:GetService("ReplicatedStorage"):WaitForChild("Wave").Value

			selectedWaveXToRestart = MacLib.Options.RestartinWave.Value

			if selectedWaveXToRestart and tonumber(waveValue) == tonumber(selectedWave) then
				restartMatch = true
				task.wait(1)
				game:GetService("ReplicatedStorage").Remotes.RestartMatch:FireServer()
				break
			end
		end
		task.wait(1)
	end
end

function autoCannonFunction()
	while getgenv().autoCannonEnabled == true do
		local mapa = workspace:FindFirstChild("Map")
		if mapa then
			local canhoes = workspace.Map.Map:WaitForChild("Cannons")

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
							task.wait(1)
						end
					end
				end
			end
		end
		task.wait(1)
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
							task.wait(1)
							local buttonConfirm =
								game:GetService("Players").LocalPlayer.PlayerGui.Prompt.TextButton.Frame
									:GetChildren()[5].TextButton
							firebutton(buttonConfirm, "VirtualInputManager")
						end
					end
				end
			end
		end
		task.wait(1)
	end
end

function autoGrailRushCardFunction()
	while getgenv().autoGrailRushCardEnabled == true do
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
							if cardPriorities3[cardName] and cardPriorities3[cardName] > highestPriorityValue then
								highestPriorityValue = cardPriorities3[cardName]
								highestPriorityCard = cardName
							end
						end

						if highestPriorityCard then
							local cardPosition = cardPositions[highestPriorityCard]
							local selectedButtonGrailRushCard = cardButtons[highestPriorityCard]

							firebutton(selectedButtonGrailRushCard, "VirtualInputManager")
							task.wait(1)
							local buttonConfirm =
								game:GetService("Players").LocalPlayer.PlayerGui.Prompt.TextButton.Frame
									:GetChildren()[5].TextButton
							firebutton(buttonConfirm, "VirtualInputManager")
						end
					end
				end
			end
		end
		task.wait(1)
	end
end

function autoJoinChallengeFunction()
	while getgenv().autoJoinChallengeEnabled == true do
		task.wait(getgenv().selectedDelay)
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
				local challengeCFrame = GetCFrame(challenge)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(challengeCFrame)
				task.wait(1)
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
		task.wait()
	end
end

function autoJoinStoryFunction()
	while getgenv().autoJoinStoryEnabled == true do
		task.wait(getgenv().selectedDelay)
		local story = workspace:FindFirstChild("TeleporterFolder") and workspace.TeleporterFolder.Story.Teleporter.Door
		if story then
			local doorCFrame = GetCFrame(story)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
			task.wait(1)
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
			task.wait(1)
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
		task.wait()
	end
end

function autoJoinShinjukuBreachFunction()
	task.wait(getgenv().selectedDelay)
    task.wait(1)
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local lobbyFolder = workspace:WaitForChild("Lobby", 1)
	local enterBreach = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Breach"):WaitForChild("Enter")

	if not lobbyFolder then
		return
	end

	local breachesFolder = lobbyFolder:WaitForChild("Breaches", 1)
	if not breachesFolder then
		return
	end

	while true do
		local lp = Players.LocalPlayer
		local char = lp.Character or lp.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")

		if hrp then
			for _, breachPart in ipairs(breachesFolder:GetChildren()) do
				if breachPart:IsA("BasePart") and #breachPart:GetChildren() > 0 then
					local c = breachPart.Color
					if
						math.abs(c.R - 1) < 0.01
						and math.abs(c.G - 0.235294) < 0.01
						and math.abs(c.B - 0.133333) < 0.01
					then
						task.wait(1)
						enterBreach:FireServer(breachPart)
						hrp.CFrame = breachPart.CFrame + Vector3.new(0, 5, 0)
						task.wait(0.5)
						break
					end
				end
				task.wait(0.1)
			end
		end
	end
    task.wait(5)
end

function autoJoinSharkmanBreachFunction()
	task.wait(getgenv().selectedDelay)
	task.wait(1)
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local lobbyFolder = workspace:WaitForChild("Lobby", 1)
	local enterBreach = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Breach"):WaitForChild("Enter")

	if not lobbyFolder then
		return
	end

	local breachesFolder = lobbyFolder:WaitForChild("Breaches", 1)
	if not breachesFolder then
		return
	end

	while true do
		local lp = Players.LocalPlayer
		local char = lp.Character or lp.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")

		if hrp then
			for _, breachPart in ipairs(breachesFolder:GetChildren()) do
				if breachPart:IsA("BasePart") and #breachPart:GetChildren() > 0 then
					local c = breachPart.Color
					if
						math.abs(c.R - 0.639216) < 0.01
						and math.abs(c.G - 0.635294) < 0.01
						and math.abs(c.B - 0.647059) < 0.01
					then
						task.wait(1)
						enterBreach:FireServer(breachPart)
						hrp.CFrame = breachPart.CFrame + Vector3.new(0, 5, 0)
						task.wait(0.5)
						break
					end
				end
				task.wait(0.1)
			end
		end
	end
	task.wait(5)
end

function autoJoinBreachesFunction()
	task.wait(getgenv().selectedDelay)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local enterBreach = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Breach"):WaitForChild("Enter")
	local enterBattle = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Easter2025"):WaitForChild("EnterBattle")
	local lobbyFolder = workspace:WaitForChild("Lobby", 60)
	local breachesFolder = lobbyFolder:WaitForChild("Breaches", 60)
	while true do
		local enteredAny = false
		local lp = game:GetService("Players").LocalPlayer
		local char = lp.Character or lp.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		if char then
			if hrp then
				for _, breachPart in ipairs(breachesFolder:GetChildren()) do
					if breachPart:IsA("BasePart") and #breachPart:GetChildren() > 0 then
						enterBreach:FireServer(breachPart)
						hrp.CFrame = breachPart.CFrame + Vector3.new(0, 5, 0)
						task.wait(7)
						enteredAny = true
						break
					end
					if not enteredAny then
						task.wait(5)
						enterBattle:FireServer()
					end
				end
				task.wait(5)
			end
		end
	end
end

function autoCollectEggsFunction()
	task.wait(2)
	local Map = workspace:WaitForChild("Map", 30)
	local lp = game:GetService("Players").LocalPlayer
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	if not Map then
		return
	end
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
		task.wait(getgenv().selectedDelay)
		local raidFolder = workspace:FindFirstChild("TeleporterFolder")
		if raidFolder and raidFolder:FindFirstChild("Raids") then
			local door = raidFolder.Raids.Teleporter:FindFirstChild("Door")
			if door then
				local doorCFrame = GetCFrame(door)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
				task.wait(1)
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
				task.wait(1)
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
		task.wait(1)
	end
end

function fireCastleRequests(room) end

function teleportToNPC(npcName)
	local npc = workspace.Lobby.Npcs:FindFirstChild(npcName)
	if npc then
		local teleportCFrame = GetCFrame(npc)
		if teleportCFrame then
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
			task.wait(1)
		end
	end
end

function joinInfCastleFunction()
	while getgenv().joinInfCastleEnabled == true do
		task.wait(getgenv().selectedDelay)
		teleportToNPC("Asta")

		if selectedRoomInfCastle then
			task.wait(1)
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
		task.wait(1)
	end
end

function autoPortalFunction()
	while getgenv().autoPortalEnabled == true do
		local playerData = game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("GetPlayerData")
			:InvokeServer(game.Players.LocalPlayer)

		local portalsList = {}
		for portalID, portalEntry in pairs(playerData.PortalData) do
			if portalEntry and type(portalEntry) == "table" then
				table.insert(portalsList, portalEntry)
			end
		end

		table.sort(portalsList, function(a, b)
			local aTier = a.PortalData and a.PortalData.Tier or 0
			local bTier = b.PortalData and b.PortalData.Tier or 0
			return aTier > bTier
		end)

		for _, portalEntry in ipairs(portalsList) do
			local portalName = portalEntry.PortalName or "N/A"
			local portalId = portalEntry.PortalID
			local portalData = portalEntry.PortalData or {}
			local challenges = portalData.Challenges or "None"
			local portalTierFormatted = portalData.Tier and ("Tier " .. tostring(portalData.Tier)) or "N/A"

			local mapMatch = selectedPortalMap == "None" or selectedPortalMap == portalName

			local tierMatch = false
			if not selectedPortalTier or #selectedPortalTier == 0 then
				tierMatch = true
			else
				for _, selectedTier in ipairs(selectedPortalTier) do
					if tostring(selectedTier) == portalTierFormatted then
						tierMatch = true
						break
					end
				end
			end

			local modifierMatch = false
			if selectedPortalModifier and #selectedPortalModifier > 0 then
				for _, SelectModifier in ipairs(selectedPortalModifier) do
					if tostring(SelectModifier) == tostring(challenges) then
						modifierMatch = true
						break
					end
				end
			else
				modifierMatch = true
			end

			if mapMatch and tierMatch and modifierMatch then
				local map = workspace:FindFirstChild("Map")

				if not map then
					local args = {
						[1] = tostring(portalId),
					}

					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("Portals")
						:WaitForChild("Activate")
						:InvokeServer(unpack(args))
					task.wait(1)

					local PortalUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("PortalUI")
					if PortalUI then
						task.wait(getgenv().selectedDelay)
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
		task.wait(1)
	end
end

function autoNextPortalFunction()
	while getgenv().autoNextPortalEnabled == true do
		local playerData = game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("GetPlayerData")
			:InvokeServer(game.Players.LocalPlayer)

		local portalList = {}
		for portalID, portalEntry in pairs(playerData.PortalData) do
			if portalEntry and type(portalEntry) == "table" then
				table.insert(portalList, portalEntry)
			end
		end

		table.sort(portalList, function(a, b)
			local tierA = (a.PortalData and a.PortalData.Tier) or 0
			local tierB = (b.PortalData and b.PortalData.Tier) or 0
			return tierA > tierB
		end)

		for _, portalEntry in ipairs(portalList) do
			local portalName = portalEntry.PortalName or "N/A"
			local portalId = portalEntry.PortalID
			local portalData = portalEntry.PortalData or {}
			local challenges = portalData.Challenges or "None"
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

			local modifierMatch = false
			if selectedPortalModifier and #selectedPortalModifier > 0 then
				for _, SelectModifier in ipairs(selectedPortalModifier) do
					if tostring(SelectModifier) == tostring(challenges) then
						modifierMatch = true
					end
				end
			end

			if mapMatch and tierMatch and modifierMatch then
				local player = game.Players.LocalPlayer
				local uiEndGame = player:WaitForChild("PlayerGui"):WaitForChild("EndGameUI")
				if uiEndGame and uiEndGame.Enabled == true then
					task.wait(8)
					local args = { tostring(portalId) }
					game:GetService("ReplicatedStorage")
						:WaitForChild("Remotes")
						:WaitForChild("Portals")
						:WaitForChild("Activate")
						:InvokeServer(unpack(args))
				end
			end
		end
		task.wait(1)
	end
end

local success, erro = pcall(function()
	local portalSelection = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("PortalSelection")
	task.wait()
	if portalSelection then
		portalSelection.OnClientEvent:Connect(function(tb)
			task.wait(3)
			while getgenv().autoGetRewardPortalEnabled == true do
				for i, v in pairs(tb) do
					local button = nil
					local Position = i
					local PortalData = v.PortalData
					local PortalName = v.PortalName

					local prompt = safeWaitForChild(playerGui, "Prompt", 0.5)
					if not prompt then
						print("Break Prompt")
						break
					end
					for challenge, portal in pairs(selectedPortalModifier) do
						if PortalData.Challenges == portal then
							print(portal, PortalData.Challenges, Position)
							local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt")
							local button2 = prompt.TextButton:FindFirstChild("TextButton")
							if button2 then
								firebutton(button2, "getconnections")
							end
							local textButton = safeWaitForChild(prompt, "TextButton", 0.5)
							if not textButton then
								print("Break 1")
								break
							end
							local frame = safeWaitForChild(textButton, "Frame", 0.5)
							if not frame then
								print("Break 2")
								break
							end
							local children = frame:GetChildren()

							if Position == 1 then
								local frameChild = children[4]
								local button1 = frameChild and safeWaitForChild(frameChild, "TextButton", 0.5)

								local button2 = children[5] and safeWaitForChild(children[5], "TextButton", 0.5)

								if button1 and button2 then
									firebutton(button1, "VirtualInputManager")
									task.wait(1)
									firebutton(button2, "VirtualInputManager")
									print("Break Pos 1")
									break
								end
							elseif Position == 2 then
								local subChildren = children[4] and children[4]:GetChildren()
								local button1 = subChildren
									and subChildren[2]
									and safeWaitForChild(subChildren[2], "TextButton", 0.5)
								local button2 = children[5] and safeWaitForChild(children[5], "TextButton", 0.5)

								if button1 and button2 then
									firebutton(button1, "VirtualInputManager")
									task.wait(1)
									firebutton(button2, "VirtualInputManager")
									print("Break Pos 2")
									break
								end
							else
								local subChildren = children[4] and children[4]:GetChildren()
								local button1 = subChildren
									and subChildren[3]
									and safeWaitForChild(subChildren[3], "TextButton", 0.5)
								local button2 = children[5] and safeWaitForChild(children[5], "TextButton", 0.5)

								if button1 and button2 then
									firebutton(button1, "VirtualInputManager")
									task.wait(1)
									firebutton(button2, "VirtualInputManager")
									print("Break Pos 3")
									break
								end
							end
						end
					end
				end
				task.wait(1)
			end
		end)
	end
end)
if not success then
end

function autoBossRushFunction()
	task.wait(getgenv().selectedDelay)
	while getgenv().autoBossRushEnabled == true do
		local remote = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Snej")
		if remote then
			remote.StartBossRush:FireServer(selectedBossRush)
		end
		task.wait(1)
	end
end

function autoElementalCavernFunction()
	while getgenv().autoElementalCavernEnabled == true do
		task.wait(getgenv().selectedDelay)
		local raidFolder = workspace:FindFirstChild("TeleporterFolder")
		if raidFolder and raidFolder:FindFirstChild("ElementalCaverns") then
			local door = raidFolder.ElementalCaverns.Teleporter:FindFirstChild("Door")
			if door then
				local doorCFrame = GetCFrame(door)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
				task.wait(1)
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
				task.wait(1)
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
		task.wait(1)
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
	local retorno =
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerData"):InvokeServer(player)
	while getgenv().autoJoinExtremeBoostEnabled == true do
		task.wait(getgenv().selectedDelay)
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
	task.wait(getgenv().selectedDelay)
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
		task.wait(2)
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
		task.wait(1)
		deselectAllDebuffs(dungeonEntry)
		task.wait(1)
		selectDebuffs(dungeonEntry, selectedDungeonDebuff)
		task.wait(1)
		local btnConfirm = dungeonEntry.Frame.Frame.Frame:GetChildren()[6].TextButton
		firebutton(btnConfirm, "VirtualInputManager")
		task.wait(1)
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
	local canTeleport = true
	while getgenv().autoSurvivalEnabled do
		task.wait(getgenv().selectedDelay)
		local teleFolder = workspace:FindFirstChild("TeleporterFolder")
		local door = teleFolder
			and teleFolder.Survival
			and teleFolder.Survival.Teleporter
			and teleFolder.Survival.Teleporter.Door
		if door and canTeleport then
			local doorCFrame = GetCFrame(door)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
		end
		task.wait(2)
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
						task.wait(1)
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
	while getgenv().autoJoinLegendEnabled == true do
		task.wait(getgenv().selectedDelay)
		local door = workspace:FindFirstChild("TeleporterFolder") and workspace.TeleporterFolder.Story.Teleporter.Door
		local doorCFrame = GetCFrame(door)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(doorCFrame)
		task.wait(1)
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
		task.wait(1)
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
		task.wait()
	end
end

function autoTraitFunction()
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local retornoRemote = Remotes:WaitForChild("GetPlayerData")
	local QuirksRoll = Remotes:WaitForChild("Quirks"):WaitForChild("Roll")
	local selectedPassiveSet = {}
	local Player = game:GetService("Players").LocalPlayer

	if typeof(selectedPassive) == "table" then
		for _, passive in ipairs(selectedPassive) do
			selectedPassiveSet[passive] = true
		end
	end

	while getgenv().autoTraitEnabled == true do
		local Select = Player.PlayerGui.QuirksUI.BG.Content.Selection.Select
		local personagemName = Select:GetAttribute("Unit")
		local quirk = Select:GetAttribute("Quirk")
		local unitID = Select:GetAttribute("UnitID")
		local quirkName = quirk or "None"
		if selectedPassiveSet[quirkName] then
			Window:Notify({
				Title = "Passive Roll",
				Description = "You got one of the selected Passives: " .. quirkName,
				Lifetime = 3,
			})
			webhookTraitRerollFunction(quirkName, tostring(personagemName))
			return
		else
			if quirkName == nil or quirkName == "None" then
				QuirksRoll:InvokeServer(unitID)
			else
				QuirksRoll:InvokeServer(unitID, quirkName)
			end
		end
		task.spawn(webhookTraitRerollFunction, quirkName, tostring(personagemName))
		-- while quirk == Select:GetAttribute("Quirk") and unitID == Select:GetAttribute("UnitID") do
		-- 	task.wait()
		-- end
		task.wait(0.3)
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
		task.wait(1)
	end
end

function autoGetBattlepassFunction()
	while getgenv().autoGetBattlepassEnabled == true do
		task.wait(1)
		local args = {
			[1] = "All",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("ClaimBattlePass")
			:FireServer(unpack(args))
		task.wait(1)
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
				old = hookfunction(v, function(...)
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

function collectRemoteInfoFunction(remoteName, args, moneyOveride)
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
		remoteData.money = moneyOveride or (money and money.Value) or 0
		if moneyOveride then
			remoteData.fr = true
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

function getUnitRemoteFunction(remoteName, args, money)
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
		collectRemoteInfoFunction(action, args, money)
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

function updateStepStatus(actualAction, lastAction)
	if isPlaying then
		StepStatusLabel:UpdateName(string.format("Step: %s/%s", actualAction, lastAction))
	else
		StepStatusLabel:UpdateName("Step: Not playing")
	end
end

function updateActionStatus(actualAction, unitAction)
	formattedAction = "Action: " .. actualAction .. " " .. unitAction
	if isPlaying then
		ActionStatusLabel:UpdateName(string.format("%s", formattedAction))
	else
		ActionStatusLabel:UpdateName("Not playing")
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

local MacroLogs = {}
local PositionsCache = {}
local function addLog(step, name, value)
	if not MacroLogs[tonumber(step)] then
		MacroLogs[tonumber(step)] = {}
	end
	MacroLogs[tonumber(step)][name] = value
	writefile("LogMacro.json", game:GetService("HttpService"):JSONEncode(MacroLogs))
end
function playMacro(macroName)
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local bottomGui = playerGui:WaitForChild("Bottom")
	local frame = bottomGui:WaitForChild("Frame")
	local TowerInfos = require(game:GetService("ReplicatedStorage").Modules.TowerInfo)
	local playerCash = player:WaitForChild("Cash")
	local towers = workspace:FindFirstChild("Towers")
	if not macrosFolder then
		return
	end

	while not startFrameFind() do
		task.wait(1)
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

	repeat
		task.wait()
	until game:GetService("ReplicatedStorage").GameStarted.Value == true

	isPlaying = true
	updateRecordingStatus()

	local startTime = tick()
	local moneyCheckTimeout = 10
	local moneyCheckInterval = 0.1
	selectedDelayMacro = MacLib.Options.selectedDelayMacroSlider.Value
	local delayMacro = selectedDelayMacro

	task.wait(1)

	for i = 1, #macroData.steps do
		local step = macroData.steps[i]
		if not isPlaying then
			addLog(step.index, "status", "Stopped beucase isPlaying is false")
			addLog(step.index, "Failed", true)
			break
		end

		if not step.action then
			addLog(step.index, "status", "Invalid Action (Dont have a action)")
			addLog(step.index, "Failed", true)
			break
		end

		addLog(step.index, "action", step.action)
		addLog(step.index, "arguments", step.arguments)
		addLog(step.index, "index", step.index)
		addLog(step.index, "money", step.money)
		addLog(step.index, "time", step.time)
		addLog(step.index, "fr", step.fr)

		updateStepStatus(tostring(step.index), macroData.currentStepIndex)
		updateActionStatus(tostring(step.action), tostring(step.arguments[1]))

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
			if not sastify then
				addLog(step.index, "status", "Timeout")
				addLog(step.index, "Failed", true)
				break
			end
		end

		local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
		if not remotes then
			addLog(step.index, "status", "Remotes not found")
			addLog(step.index, "Failed", true)
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

			local zX, zY, zZ = math.floor(cf1.X), math.floor(cf1.Y), math.floor(cf1.Z)
			local zX2, zY2, zZ2 = math.floor(cf2.X), math.floor(cf2.Y), math.floor(cf2.Z)

			return (cX == cX2 and cY == cY2 and cZ == cZ2)
				or (zX == zX2 and zY == zY2 and zZ == zZ2)
				or (zX == cX2 and zY == cY2 and zZ == cZ2)
				or (cX == zX2 and cY == zY2 and cZ == zZ2)
		end

		function findUnit()
			local t = function()
				if PositionsCache[step.arguments[2]] then
					return PositionsCache[step.arguments[2]]
				end
				local path = workspace.Towers
				for _, tower in ipairs(path:GetChildren()) do
					if not tower:IsA("Model") then
						continue
					end
					local PlacePos = tower:GetAttribute("PlacePosition")
					local OriginalPos = tower:GetAttribute("OriginalCFrame")

					if tostring(step.arguments[2]) == "nil" then
						if (PlacePos or OriginalPos) == nil and tower.Name == step.arguments[1] then
							return tower
						else
							continue
						end
					end

					if
						tostring(OriginalPos) == tostring(step.arguments[2])
						or tostring(PlacePos) == tostring(step.arguments[2])
						or checkCframe(OriginalPos, step.arguments[2])
					then
						PositionsCache[step.arguments[2]] = tower
						return tower
					end
				end
			end
			local tower
			while not tower do
				tower = t()
				if not tower then
					task.wait(0.5)
				end
			end
			return tower
		end

		local function fireIn(remote, ...)
			local stop = false

			if remote.Name == "Upgrade" then
				local Tower = select(1, ...)
				if not Tower.Parent then
					addLog(step.index, "status", "Tower not found (Parent is nil)")
					addLog(step.index, "Failed", true)
					return false
				end

				local upgradeValue = Tower:FindFirstChild("Upgrade")
				if upgradeValue then
					local Upgraded = false
					upgradeValue:GetPropertyChangedSignal("Value"):Once(function()
						addLog(
							step.index,
							"Info",
							"Detected upgrade to level "
								.. upgradeValue.Value
								.. " | Before -> "
								.. upgradeValue.Value - 1
						)
						Upgraded = true
					end)
					local c = 0
					while not remote:InvokeServer(...) or not Upgraded or not isPlaying do
						c = c + 1
						addLog(step.index, "Attempt to " .. remote.Name, c)
						task.wait(1)
					end
				end
			else
				local c = 0
				while not remote:InvokeServer(...) or not isPlaying do
					c = c + 1
					addLog(step.index, "Attempt to " .. remote.Name, c)
					task.wait(1)
				end
			end

			if not isPlaying then
				addLog(step.index, "status", "Stopped beucase isPlaying is false")
				addLog(step.index, "Failed", true)
				stop = true
			end

			return not stop
		end

		if step.action == "PlaceTower" then
			local remote = remotes:FindFirstChild("PlaceTower")
			if not remote then
				addLog(step.index, "status", "Remote not found")
				addLog(step.index, "Failed", true)
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
					addLog(step.index, "status", "Invalid CFrame")
					addLog(step.index, "Failed", true)
					break
				end
			elseif type(positionData) == "table" then
				cframe = CFrame.new(unpack(positionData))
			else
				addLog(step.index, "status", "Invalid Position Data")
				addLog(step.index, "Failed", true)
				break
			end

			if towerName and cframe then
				while
					not select(
						2,
						pcall(function()
							remote:FireServer(towerName, cframe)
							task.wait(1)
							for _, t in ipairs(towers:GetChildren()) do
								local baseName = t:GetAttribute("UnitName") or t.Name
								if
									baseName == towerName
									and t:FindFirstChild("Owner")
									and tostring(t.Owner.Value) == player.Name
								then
									return true
								end
							end
							return false
						end)
					) == true
				do
					task.wait(1)
				end

				task.wait(math.max(1 - delayMacro, 0))
				addLog(step.index, "status", "Tower Placed")
			else
				addLog(step.index, "status", "Invalid Tower Name or CFrame")
				addLog(step.index, "Failed", true)
			end
		elseif step.action == "Upgrade" then
			local remote = remotes:FindFirstChild("Upgrade")
			local tower = findUnit()
			if remote and tower then
				local upgradeValue = tower:FindFirstChild("Upgrade")
				if upgradeValue then
					local Info = TowerInfos[tower.Name]
					if Info then
						-- if not Info[upgradeValue.Value + 1] then
						-- 	addLog(step.index, "status", "No upgrade available for this unit")
						-- 	addLog(step.index, "Failed", true)
						-- 	continue
						-- end
						-- if not (playerCash.Value >= Info[upgradeValue.Value + 1].Cost) then
						-- 	print("Voce nao tem dinheiro suficiente para fazer o upgrade")
						-- 	continue
						-- end
					end
				end

				local t = fireIn(remote, tower)
				if not t then
					addLog(step.index, "status", "Failed to upgrade tower (10 Seconds timeout)")
					addLog(step.index, "Failed", true)
					continue
				end
				addLog(step.index, "status", "Tower Upgraded")
			elseif not tower then
				addLog(step.index, "status", "Tower not found")
				addLog(step.index, "Failed", true)
			elseif not remote then
				addLog(step.index, "status", "Remote not found")
				addLog(step.index, "Failed", true)
			end
		elseif step.action == "Sell" then
			local remote = remotes:FindFirstChild("Sell")
			local tower = findUnit()
			if remote and tower then
				local t = fireIn(remote, tower)
				if not t then
					addLog(step.index, "status", "Failed to sell tower")
					addLog(step.index, "Failed", true)
					continue
				end
				addLog(step.index, "status", "Tower Sold")
			elseif not tower then
				addLog(step.index, "status", "Tower not found")
				addLog(step.index, "Failed", true)
			elseif not remote then
				addLog(step.index, "status", "Remote not found")
				addLog(step.index, "Failed", true)
			end
		elseif step.action == "Ability" then
			local remote = remotes:FindFirstChild("Ability")
			local tower = findUnit()
			if remote and tower then
				local t = fireIn(remote, tower, step.arguments[3])
				if not t then
					addLog(step.index, "status", "Failed to use ability")
					addLog(step.index, "Failed", true)
					continue
				end
				addLog(step.index, "status", "Ability Used")
			elseif not tower then
				addLog(step.index, "status", "Tower not found")
				addLog(step.index, "Failed", true)
			elseif not remote then
				addLog(step.index, "status", "Remote not found")
				addLog(step.index, "Failed", true)
			end
		else
			addLog(step.index, "status", "Unknown Action")
			addLog(step.index, "Failed", true)
		end

		task.wait(delayMacro)
	end

	isPlaying = false
	updateRecordingStatus()
end

local StatsCal = require(game.ReplicatedStorage.Modules.StatCalculator)
local TowerInfos = require(game:GetService("ReplicatedStorage").Modules.TowerInfo)

local cache = {}
local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	local args = { ... }
	local remoteName = self.Name

	if isRecording and not checkcaller() then
		if method == "FireServer" and remoteName == "PlaceTower" and self.Parent == game.ReplicatedStorage.Remotes then
			local InfoTower = TowerInfos[args[1]]
			local InfoCost = InfoTower and InfoTower[0] and InfoTower[0].Cost

			local processedArgs = {
				tostring(args[1]),
				tostring(args[2]),
			}
			task.spawn(function()
				getUnitRemoteFunction("PlaceTower", processedArgs, InfoCost)
			end)
		elseif method == "InvokeServer" and self.Parent == game.ReplicatedStorage.Remotes then
			if remoteName == "Sell" or remoteName == "ChangeTargeting" or remoteName == "Ability" then
				local results = { originalNamecall(self, ...) }
				if results[1] ~= true then
					return unpack(results)
				end
				task.spawn(function()
					getUnitRemoteFunction(remoteName, {
						tostring(args[1]),
						tostring(args[1]:GetAttribute("PlacePosition") or args[1]:GetAttribute("OriginalCFrame")),
						args[2],
					})
				end)
			elseif remoteName == "Upgrade" then
				task.spawn(function()
					local upgradeValue = args[1]:WaitForChild("Upgrade")
					if cache[upgradeValue] then
						return
					end
					cache[upgradeValue] = true
					local con
					con = upgradeValue:GetPropertyChangedSignal("Value"):Connect(function()
						if not isRecording then
							con:Disconnect()
							cache[upgradeValue] = nil
							return
						end

						local Info = StatsCal.Game_Calculate(args[1])
						local InfoTower = TowerInfos[args[1].Name]
						local InfoUpgrade = InfoTower[upgradeValue.Value]
						local InfoCost = InfoUpgrade
							and InfoUpgrade.Cost
							and (tonumber(InfoUpgrade.Cost) * Info.TotalCost)

						getUnitRemoteFunction(remoteName, {
							tostring(args[1]),
							tostring(args[1]:GetAttribute("PlacePosition") or args[1]:GetAttribute("OriginalCFrame")),
							args[2],
						}, InfoCost)
					end)
					print(con, "added")
				end)
			end
		end
	end

	return originalNamecall(self, ...)
end)

task.spawn(function()
	local player = game:GetService("Players").LocalPlayer
	local GameEnded = game:GetService("ReplicatedStorage"):WaitForChild("GameEnded")
	GameEnded:GetPropertyChangedSignal("Value"):Connect(function()
		if not GameEnded.Value then
			return
		end
		task.spawn(webhookFunction)
		while GameEnded.Value do
			task.wait(1)
		end
		task.wait(5)
		table.clear(PositionsCache)
		if PlayMacro:GetState() == true then
			if isPlaying then
				isPlaying = false
			end
			task.defer(playMacro, selectedMacro)
		end
		if not getgenv().isPlacingUnits and placeUnitsToggle:GetState() == true then
			task.spawn(placeUnitsFunction)
		end
		if getgenv().autoKurumiSkillEnabled == true then
			task.spawn(autoKurumiSkillFunction)
		end
		if getgenv().autoGarouSkillEnabled == true then
			task.spawn(autoGarouSkillFunction)
		end
		if getgenv().autoShirouEnabled == true then
			task.spawn(autoShirouSkillFunction)
		end
		if getgenv().autoGilgameshSkillEnabled == true then
			task.spawn(autoGilgameshSkillFunction)
		end
		if getgenv().autoCanrodSkillEnabled == true then
			task.spawn(autoCanrodSkillFunction)
		end
		if getgenv().autoCanrodCopyEnabled == true then
			task.spawn(autoCanrodCopyFunction)
		end
		if getgenv().autoRengokuModeEnabled == true then
			task.spawn(autoRengokuModeFunction)
		end
		if getgenv().autoArthurModeEnabled == true then
			task.spawn(autoArthurModeFunction)
		end
		if getgenv().autoNinelModeEnabled == true then
			task.spawn(autoNinelModeFunction)
		end
		if getgenv().autoPucciResetEnabled == true then
			task.spawn(autoPucciResetFunction)
		end
	end)
end)

-- task.spawn(function()
-- 	local playerCash = player:FindFirstChild("Cash")
-- 	if playerCash then
-- 		local old = playerCash.Value
-- 		local oldIndex = -1
-- 		playerCash:GetPropertyChangedSignal("Value"):Connect(function()
-- 			local new = playerCash.Value
-- 			if new == 600 then
-- 				old = new
-- 				return
-- 			end
-- 			if new < old then
-- 				local index = recordingData and recordingData.currentStepIndex
-- 				if isRecording and index then
-- 					if oldIndex == index then
-- 						index = index + 1
-- 					end
-- 					local step = recordingData.steps[index]
-- 					while not step do
-- 						step = recordingData.steps[index]
-- 						task.wait()
-- 					end
-- 					if step and (selectedTypeOfRecord == "Hybrid" or selectedTypeOfRecord == "Money") then
-- 						warn("Gastou Money: " .. tostring(old - new))
-- 						recordingData.steps[index].money = (old - new)
-- 						recordingData.steps[index].fr = true
-- 					end
-- 				end
-- 			end
-- 			old = new
-- 		end)
-- 	end
-- end)

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
	table.insert(ValuesPortalTier, "Tier 7")
	table.insert(ValuesPortalMap, "Ashen Ruins")
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
					if name and name:match("Portal") then
						table.insert(types, "Portal")
						continue
					end
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

-- UI Tabs
local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://10723407389" }),
	Event = tabGroups.TabGroup1:Tab({ Name = "Event", Image = "rbxassetid://10723345518" }),
	AutoJoin = tabGroups.TabGroup1:Tab({ Name = "Auto Join", Image = "rbxassetid://10734923549" }),
	AutoPlay = tabGroups.TabGroup1:Tab({ Name = "Auto Play", Image = "rbxassetid://10734923549" }),
	AutoAbility = tabGroups.TabGroup1:Tab({ Name = "Auto Ability", Image = "rbxassetid://10734930466" }),
	AutoCard = tabGroups.TabGroup1:Tab({ Name = "Auto Card", Image = "rbxassetid://10734907168" }),
	Team = tabGroups.TabGroup1:Tab({ Name = "Team", Image = "rbxassetid://10734920149" }),
	Macro = tabGroups.TabGroup1:Tab({ Name = "Macro", Image = "rbxassetid://10735024209" }),
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
	MainSection18 = tabs.AutoPlay:Section({ Side = "Right" }),
	MainSection19 = tabs.AutoPlay:Section({ Side = "Left" }),
	MainSection34 = tabs.AutoPlay:Section({ Side = "Right" }),
	MainSection23 = tabs.AutoAbility:Section({ Side = "Left" }),
	MainSection27 = tabs.AutoAbility:Section({ Side = "Right" }),
	MainSection29 = tabs.AutoAbility:Section({ Side = "Right" }),
	MainSection35 = tabs.AutoAbility:Section({ Side = "Right" }),
	MainSection20 = tabs.AutoCard:Section({ Side = "Left" }),
	MainSection21 = tabs.AutoCard:Section({ Side = "Right" }),
	MainSection24 = tabs.AutoCard:Section({ Side = "Right" }),
	MainSection36 = tabs.Team:Section({ Side = "Left" }),
	MainSection37 = tabs.Team:Section({ Side = "Left" }),
	MainSection38 = tabs.Team:Section({ Side = "Left" }),
	MainSection39 = tabs.Team:Section({ Side = "Left" }),
	MainSection40 = tabs.Team:Section({ Side = "Left" }),
	MainSection45 = tabs.Team:Section({ Side = "Left" }),
	MainSection41 = tabs.Team:Section({ Side = "Right" }),
	MainSection42 = tabs.Team:Section({ Side = "Right" }),
	MainSection43 = tabs.Team:Section({ Side = "Right" }),
	MainSection44 = tabs.Team:Section({ Side = "Right" }),
	MainSection46 = tabs.Team:Section({ Side = "Right" }),
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
		MacLib:HidePlayer(value)
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
	Name = "Send when finish game",
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
	Name = "Ping User If Get Unit Or Item",
	Default = false,
	Callback = function(value)
		getgenv().pingUserifGetUnitEnabled = value
	end,
}, "pingUserifGetUnitToggle")

sections.MainSection2:Toggle({
	Name = "Send when Get Trait",
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
	Name = "Breach Event",
})

sections.MainSection26:Toggle({
	Name = "Auto Join Shinjuku Breach",
	Default = false,
	Callback = function(value)
		if value then
			autoJoinShinjukuBreachFunction()
		end
	end,
}, "AutoJoinShinjukuBreach")

sections.MainSection26:Toggle({
	Name = "Auto Join Sharkman Breach",
	Default = false,
	Callback = function(value)
		if value then
			autoJoinSharkmanBreachFunction()
		end
	end,
}, "AutoJoinSharkmanBreach")

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
		getgenv().selectedDelay = Value
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
			task.wait(1)
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
			task.wait(1)
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
			task.wait(1)
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

sections.MainSection15:Toggle({
	Name = "Only Upgrade in Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlyupgradeinwaveXEnabled = value
	end,
}, "onlyUpgradeInWaveXToggle")

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

sections.MainSection16:Toggle({
	Name = "Anti Magic Zone",
	Default = false,
	Callback = function(value)
		getgenv().autoAntiZoneEnabled = value
		if value then
			autoAntiZoneFunction()
		end
	end,
}, "autoAntiZoneToggle")

sections.MainSection16:Toggle({
	Name = "Anti Magic Orb",
	Default = false,
	Callback = function(value)
		autoAntiOrbFunction()
	end,
}, "autoAntiOrbToggle")

sections.MainSection4:Divider()

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
	Default = 4,
	Minimum = 1,
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
	Default = 4,
	Minimum = 1,
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
	Name = "Auto Restart Match",
	Default = false,
	Callback = function(value)
		getgenv().autoRestartAfterXMatchEnabled = value
		if value then
			autoRestartAfterXMatchFunction()
		end
	end,
}, "autoRestartafterxMatches")

sections.MainSection19:Slider({
	Name = "Leave After Match",
	Default = 1,
	Minimum = 1,
	Maximum = 20,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		MacLib.Options.selectedMatchxToLeaveSlider.Value = Value
	end,
}, "selectedMatchxToLeaveSlider")

sections.MainSection19:Toggle({
	Name = "Auto Leave Match",
	Default = false,
	Callback = function(value)
		getgenv().autoLeaveAfterXMatches = value
		if value then
			autoLeaveAfterXMatchesFunction()
		end
	end,
}, "autoLeaveafterxMatches")

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

sections.MainSection24:Header({
	Name = "Auto Grail Rush",
})

sections.MainSection24:Slider({
	Name = "Enraged I",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Enraged I"] = Value
	end,
}, "Enraged I")

sections.MainSection24:Slider({
	Name = "Enraged II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Enraged II"] = Value
	end,
}, "Enraged II")

sections.MainSection24:Slider({
	Name = "Sluggish I",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Sluggish I"] = Value
	end,
}, "Sluggish I")

sections.MainSection24:Slider({
	Name = "Sluggish II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Sluggish II"] = Value
	end,
}, "Sluggish II")

sections.MainSection24:Slider({
	Name = "Avarice I",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Avarice I"] = Value
	end,
}, "Avarice I")

sections.MainSection24:Slider({
	Name = "Avarice II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Avarice II"] = Value
	end,
}, "Avarice II")

sections.MainSection24:Slider({
	Name = "Weak Point II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Weak Point I"] = Value
	end,
}, "Weak Point I")

sections.MainSection24:Slider({
	Name = "Weak Point II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Weak Point II"] = Value
	end,
}, "Weak Point II")

sections.MainSection24:Slider({
	Name = "God Speed I",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["God Speed I"] = Value
	end,
}, "God Speed I")

sections.MainSection24:Slider({
	Name = "God Speed II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["God Speed II"] = Value
	end,
}, "God Speed II")

sections.MainSection24:Slider({
	Name = "Loyalty I",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Loyalty I"] = Value
	end,
}, "Loyalty I")

sections.MainSection24:Slider({
	Name = "Loyalty II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Loyalty II"] = Value
	end,
}, "Loyalty II")

sections.MainSection24:Slider({
	Name = "Reconnaissance I",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Reconnaissance I"] = Value
	end,
}, "Reconnaissance I")

sections.MainSection24:Slider({
	Name = "Reconnaissance II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Reconnaissance II"] = Value
	end,
}, "Reconnaissance II")

sections.MainSection24:Slider({
	Name = "Initiative I",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Initiative I"] = Value
	end,
}, "Initiative I")

sections.MainSection24:Slider({
	Name = "Initiative II",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Initiative II"] = Value
	end,
}, "Initiative II")

sections.MainSection24:Slider({
	Name = "Opulence",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Opulence"] = Value
	end,
}, "Opulence")

sections.MainSection24:Slider({
	Name = "Metal Skin",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Metal Skin"] = Value
	end,
}, "Metal Skin")

sections.MainSection24:Slider({
	Name = "Insanity",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Insanity"] = Value
	end,
}, "Insanity")

sections.MainSection24:Slider({
	Name = "Lethargy",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Lethargy"] = Value
	end,
}, "Lethargy")

sections.MainSection24:Slider({
	Name = "Ambush",
	Default = 0,
	Minimum = 0,
	Maximum = 21,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		cardPriorities3["Ambush"] = Value
	end,
}, "Ambush")

sections.MainSection24:Toggle({
	Name = "Auto Grail Rush Card",
	Default = false,
	Callback = function(value)
		getgenv().autoGrailRushCardEnabled = value
		if value then
			cardPriorities3["Enraged I"] = MacLib.Options["Enraged I"].Value
			cardPriorities3["Enraged II"] = MacLib.Options["Enraged II"].Value
			cardPriorities3["Sluggish I"] = MacLib.Options["Sluggish I"].Value
			cardPriorities3["Sluggish II"] = MacLib.Options["Sluggish II"].Value
			cardPriorities3["Avarice I"] = MacLib.Options["Avarice I"].Value
			cardPriorities3["Avarice II"] = MacLib.Options["Avarice II"].Value
			cardPriorities3["Weak Point I"] = MacLib.Options["Weak Point I"].Value
			cardPriorities3["Weak Point II"] = MacLib.Options["Weak Point II"].Value
			cardPriorities3["God Speed I"] = MacLib.Options["God Speed I"].Value
			cardPriorities3["God Speed II"] = MacLib.Options["God Speed II"].Value
			cardPriorities3["Loyalty I"] = MacLib.Options["Loyalty I"].Value
			cardPriorities3["Loyalty II"] = MacLib.Options["Loyalty II"].Value
			cardPriorities3["Reconnaissance I"] = MacLib.Options["Reconnaissance I"].Value
			cardPriorities3["Reconnaissance II"] = MacLib.Options["Reconnaissance II"].Value
			cardPriorities3["Initiative I"] = MacLib.Options["Initiative I"].Value
			cardPriorities3["Initiative II"] = MacLib.Options["Initiative II"].Value
			cardPriorities3["Opulence"] = MacLib.Options["Opulence"].Value
			cardPriorities3["Metal Skin"] = MacLib.Options["Metal Skin"].Value
			cardPriorities3["Insanity"] = MacLib.Options["Insanity"].Value
			cardPriorities3["Lethargy"] = MacLib.Options["Lethargy"].Value
			cardPriorities3["Ambush"] = MacLib.Options["Ambush"].Value
			autoGrailRushCardFunction()
		end
	end,
}, "autoGrailRushCardToggle")

sections.MainSection23:Header({
	Name = "Auto Abilities",
})

for _ = 1, 4 do
	sections.MainSection23:Dropdown({
		Name = ("Auto Ability %s"):format(_),
		Search = true,
		Multi = false,
		Required = true,
		Options = EquippedUnitsInSlot,
		Default = "None",
	}, ("autoAbilityDropdown%s"):format(_))

	sections.MainSection23:Slider({
		Name = ("Use Skill %s In Wave"):format(_),
		Default = 1,
		Minimum = 1,
		Maximum = 500,
		DisplayMethod = "Number",
		Precision = 0,
	}, ("skill1WaveSlider%s"):format(_))

	sections.MainSection23:Toggle({
		Name = ("Only use Skill %s in boss"):format(_),
		Default = false,
	}, ("onlyUseSkill1InBossToggle%s"):format(_))

	sections.MainSection23:Toggle({
		Name = ("Only use Skill %s in Wave"):format(_),
		Default = false,
	}, ("onlyUseSkill1InWaveToggle%s"):format(_))
end

sections.MainSection23:Divider()

sections.MainSection23:Slider({
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

sections.MainSection23:Toggle({
	Name = "Auto Universal Skill",
	Default = false,
	Callback = function(value)
		getgenv().autoUniversalSkillEnabled = value
		autoUniversalSkillFunction()
	end,
}, "autoUniversalSkillToggle")

sections.MainSection23:Toggle({
	Name = "Only use skills in boss",
	Default = false,
	Callback = function(value)
		getgenv().onlyUseSkillsInBossEnabled = value
	end,
}, "onlyUseSkillsInBossToggle")

sections.MainSection23:Toggle({
	Name = "Only use skills in Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlyUseSkillsInWaveXEnabled = value
	end,
}, "onlyUseSkillsInWaveXToggle")

sections.MainSection27:Header({
	Name = "Auto Infinite Buff",
})
sections.MainSection27:Toggle({
	Name = "Auto Idol",
	Default = false,
	Callback = function(value)
		getgenv().autoIdolEnabled = value
		autoIdolFunction()
	end,
}, "AutoIdolToggle")
sections.MainSection27:Toggle({
	Name = "Auto Gojo TS",
	Default = false,
	Callback = function(value)
		getgenv().autoGojoTSEnabled = value
		autoGojoTSFunction()
	end,
}, "AutoGojoToggle")

sections.MainSection27:Divider()

sections.MainSection27:Toggle({
	Name = "Auto Pucci Reset",
	Default = false,
	Callback = function(value)
		getgenv().autoPucciResetEnabled = value
		autoPucciResetFunction()
	end,
}, "AutoPucciResetToggle")

sections.MainSection27:Slider({
	Name = "Reset In Wave",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Percentage",
	Precision = 0,
	Callback = function(Value)
		MacLib.Options.ResetPucciInWaveToggle.Value = Value
	end,
}, "ResetPucciInWaveToggle")

sections.MainSection29:Header({
	Name = "Auto Trasform",
})

sections.MainSection29:Toggle({
	Name = "Auto Kurumi Transformation",
	Default = false,
	Callback = function(value)
		getgenv().autoKurumiSkillEnabled = value
		autoKurumiSkillFunction()
	end,
}, "autoKurumiSkillToggle")

sections.MainSection29:Dropdown({
	Name = "Select Form Kurumi ",
	Multi = false,
	Required = true,
	Options = { "Buff", "DPS", "Support" },
	Default = "None",
	Callback = function(Value)
		selectedKurumiSkillType = Value
	end,
}, "selectedKurumiSkill")

sections.MainSection29:Toggle({
	Name = "Auto Garou Transformation",
	Default = false,
	Callback = function(value)
		getgenv().autoGarouSkillEnabled = value
		autoGarouSkillFunction()
	end,
}, "autoGarouSkillToggle")

sections.MainSection29:Dropdown({
	Name = "Select Form Garou ",
	Multi = false,
	Required = true,
	Options = { "Cosmic", "Baldy" },
	Default = "None",
	Callback = function(Value)
		selectedGarouSkillType = Value
	end,
}, "selectedGarouSkill")

sections.MainSection29:Toggle({
	Name = "Auto Shirou Transformation",
	Default = false,
	Callback = function(value)
		getgenv().autoShirouEnabled = value
		autoShirouSkillFunction()
	end,
}, "autoShirouSkillToggle")

sections.MainSection29:Dropdown({
	Name = "Select Form Shirou ",
	Multi = false,
	Required = true,
	Options = { "Sword", "Knife", "Berserk" },
	Default = "None",
	Callback = function(Value)
		selectedShirouSkillType = Value
	end,
}, "selectedShirouSkill")

sections.MainSection29:Toggle({
	Name = "Auto Gilgamesh Transformation",
	Default = false,
	Callback = function(value)
		getgenv().autoGilgameshSkillEnabled = value
		autoGilgameshSkillFunction()
	end,
}, "autoGilgameshSkillToggle")

sections.MainSection29:Dropdown({
	Name = "Select Form Gilgamesh",
	Multi = false,
	Required = true,
	Options = { "Heavenly Chains", "Rupture", "Heavenly Gates" },
	Default = "None",
	Callback = function(Value)
		selectedGilgameshSkill = Value
	end,
}, "selectedGilgameshSkill")

sections.MainSection29:Toggle({
	Name = "Auto Canrod Transformation",
	Default = false,
	Callback = function(value)
		getgenv().autoCanrodSkillEnabled = value
		autoCanrodSkillFunction()
	end,
}, "autoCanrodSkillToggle")

sections.MainSection29:Dropdown({
	Name = "Select Form Canrod ",
	Multi = false,
	Required = true,
	Options = { "Water", "Dark", "Fire", "Light", "Nature" },
	Default = "None",
	Callback = function(Value)
		selectedCanrodSkillType = Value
	end,
}, "selectedCanrodSkill")

sections.MainSection29:Toggle({
	Name = "Auto Canrod Copy",
	Default = false,
	Callback = function(value)
		getgenv().autoCanrodCopyEnabled = value
		autoCanrodCopyFunction()
	end,
}, "AutoCanrodCopy")

sections.MainSection29:Dropdown({
	Name = "Select Slot Canrod",
	Multi = false,
	Required = true,
	Options = { "1", "2", "3", "4", "5", "6" },
	Default = "None",
	Callback = function(Value)
		selectedSlotToCopyValue = Value
	end,
}, "selectedSlotToCopy")

sections.MainSection35:Header({
	Name = "Auto Modes",
})

sections.MainSection35:Toggle({
	Name = "Auto Rengoku Mode",
	Default = false,
	Callback = function(value)
		getgenv().autoRengokuModeEnabled = value
		autoRengokuModeFunction()
	end,
}, "AutoRengokuMode")

sections.MainSection35:Toggle({
	Name = "Auto Arthur Mode",
	Default = false,
	Callback = function(value)
		getgenv().autoArthurModeEnabled = value
		autoArthurModeFunction()
	end,
}, "AutoArthurMode")

sections.MainSection35:Toggle({
	Name = "Auto Ninel Mode",
	Default = false,
	Callback = function(value)
		getgenv().autoNinelModeEnabled = value
		autoNinelModeFunction()
	end,
}, "AutoNinelMode")

sections.MainSection36:Header({
	Name = "Story and Infinite",
})

sections.MainSection36:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToStory = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToStoryDropdown")

sections.MainSection37:Header({
	Name = "Legend Stage",
})

sections.MainSection37:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToLegendStage = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToLegendStageDropdown")

sections.MainSection38:Header({
	Name = "Raid",
})

sections.MainSection38:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToRaid = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToRaidDropdown")

sections.MainSection39:Header({
	Name = "Challenge",
})

sections.MainSection39:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToChallenge = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToChallengeDropdown")

sections.MainSection40:Header({
	Name = "Elemental Cavern",
})

sections.MainSection40:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToElementalCavern = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToElementalCavernDropdown")

sections.MainSection41:Header({
	Name = "Boss Rush",
})

sections.MainSection41:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToBossRush = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToBossRushDropdown")

sections.MainSection42:Header({
	Name = "Extreme Boost",
})

sections.MainSection42:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToExtremeBoost = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToExtremeBoostDropdown")

sections.MainSection43:Header({
	Name = "Dungeon",
})

sections.MainSection43:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToDungeon = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToDungeonDropdown")

sections.MainSection44:Header({
	Name = "Survival",
})

sections.MainSection44:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToSurvival = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToSurvivalDropdown")

sections.MainSection45:Header({
	Name = "Portal",
})

sections.MainSection45:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToPortal = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToPortalDropdown")

sections.MainSection46:Header({
	Name = "Infinite Castle",
})

sections.MainSection46:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = { 1, 2, 3, 4 },
	Default = "None",
	Callback = function(Value)
		selectedTeamToInfiniteCastle = Value
		EquipTeamByMode()
	end,
}, "selectedTeamToInfiniteCastleDropdown")

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

StepStatusLabel = sections.MainSection22:Label({
	Text = "Step: None",
})

ActionStatusLabel = sections.MainSection22:Label({
	Text = "Action: None",
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
			updateStepStatus(0, 0)
			updateActionStatus(0, 0)
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
		MacLib:lowCpuUsage(value)
	end,
}, "LowCpuUsage")

sections.MainSection25:Toggle({
	Name = "FPS Boost",
	Default = false,
	Callback = function(value)
		MacLib:FPSBoost(value)
	end,
}, "FPSBoostToggle")

sections.MainSection25:Slider({
	Name = "Change UI Size",
	Default = 0.8,
	Minimum = 0.5,
	Maximum = 1.5,
	Increment = 0.05,
	DisplayMethod = "Round",
	Precision = 1,
	Callback = function(scale)
		resizeFrames(scale)
	end,
}, "changeUISize")

Window.onUnloaded(function() end)
tabs.Main:Select()

local GameConfigName = "_ALS_"
local player = game.Players.LocalPlayer
local GuiService = game:GetService("GuiService")
MacLib:SetFolder("Tempest Hub")
MacLib:SetFolder("Tempest Hub/_ALS_")
MacLib:LoadConfig(player.Name .. GameConfigName)

local function saveConfigBeforeGameLeave()
	MacLib:SaveConfig(player.Name .. GameConfigName)
end
GuiService.NativeClose:Connect(saveConfigBeforeGameLeave)
GuiService.MenuOpened:Connect(saveConfigBeforeGameLeave)
player.OnTeleport:Connect(function()
	saveConfigBeforeGameLeave()
end)
task.spawn(function()
	while true do
		saveConfigBeforeGameLeave()
		task.wait(60)
	end
end)

local LocalPlayer = game:GetService("Players").LocalPlayer
for _, v in pairs(getconnections(LocalPlayer.Idled)) do
	v:Disable()
end
