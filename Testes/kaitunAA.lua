repeat task.wait() until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()
local repo = "https://raw.githubusercontent.com/TrilhaX/tempestHubUI/main/"

--Loading UI Library
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
Library:Notify("Welcome to Tempest Hub", 5)

--Configuring UI Library
local Window = Library:CreateWindow({
	Title = "Tempest Hub | Anime Adventures Kaitun",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

Library:Notify("Loading Anime Adventures Kaitun Script", 5)
warn("[TEMPEST HUB] Loading Function")
wait()
warn("[TEMPEST HUB] Loading Toggles")
wait()
warn("[TEMPEST HUB] Last Checking")
wait()

local checkProgressionPlayerEnabled = true
local autoLeaveEnabled = true
local autoreplayEnabled = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local speed = 1000

function hideUIExec()
	if getgenv().hideUIExec then
		local coreGui = game:GetService("CoreGui")
		local windowFrame = nil
		
		if coreGui:FindFirstChild("LinoriaGui") then
			windowFrame = coreGui.LinoriaGui:FindFirstChild("windowFrame")
		elseif coreGui:FindFirstChild("RobloxGui") and coreGui.RobloxGui:FindFirstChild("LinoriaGui") then
			windowFrame = coreGui.RobloxGui.LinoriaGui:FindFirstChild("windowFrame")
		end
		
		if windowFrame then
			windowFrame.Visible = false
		else
			warn("windowFrame não encontrado.")
		end		
	end
end

function aeuat()
	if getgenv().aeuat == true then
		local teleportQueued = false
		game.Players.LocalPlayer.OnTeleport:Connect(function(State)
			if
				(State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress) and not teleportQueued
			then
				teleportQueued = true

				queue_on_teleport([[         
                    repeat task.wait() until game:IsLoaded()
                    if getgenv().executed then return end    
					loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/kaitunAA/main/main.lua"))()
                ]])

				getgenv().executed = true
				wait(10)
				teleportQueued = false
			end
		end)
		wait()
	end
end

function securityMode()
	local players = game:GetService("Players")
	local ignorePlaceIds = { 8304191830 }

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
			local targetPlaceId = 8304191830

			if game.PlaceId ~= targetPlaceId and not isPlaceIdIgnored(game.PlaceId) then
				game:GetService("TeleportService"):Teleport(targetPlaceId, player1)
			end
		end
		wait(1)
	end
end

function deletemap()
	if getgenv().deletemap == true then
		repeat task.wait() until game:IsLoaded()
		wait(5)
		local map = workspace:FindFirstChild("_map")
		local waterBlocks = workspace:FindFirstChild("_water_blocks")

		if map then
			map:Destroy()
		end

		if waterBlocks then
			waterBlocks:Destroy()
		end

		wait(1)
	end
end

function hideInfoPlayer()
	if getgenv().hideInfoPlayer == true then
		local player = game.Players.LocalPlayer
		if not player then
			return
		end

		local head = player.Character and player.Character:FindFirstChild("Head")
		if not head then
			return
		end

		local overhead = head:FindFirstChild("_overhead")
		if not overhead then
			return
		end

		local frame = overhead:FindFirstChild("Frame")
		if not frame then
			return
		end

		frame:Destroy()

		wait(0.1)
	end
end

function autoreplay()
	while autoreplayEnabled == true do
		local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI
		if resultUI and resultUI.Enabled == true then
			wait(3)
			local args = {
				[1] = "replay",
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("endpoints")
				:WaitForChild("client_to_server")
				:WaitForChild("set_game_finished_vote")
				:InvokeServer(unpack(args))
		end
		wait()
	end
end

function autoleave()
	while autoLeaveEnabled == true do
		local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI
		if resultUI and resultUI.Enabled == true then
			wait(3)
			game:GetService("ReplicatedStorage").endpoints.client_to_server.teleport_back_to_lobby:InvokeServer("leave")
		end
		wait()
	end
end

function autostart()
	while getgenv().autostart == true do
		local voteStart = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("VoteStart")
		if voteStart and voteStart.Enabled == true then
			game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
		end
		wait()
	end
end

function disableNotifications()
	local notifications = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("NotificationWindows")
	if notifications then
		notifications.Enabled = false
	end
end

function autoSkipWave()
	while getgenv().autoSkipWave == true do
		local voteSkip = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("VoteSkip")
		if voteSkip and voteSkip.Enabled == true then
			game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_wave_skip:InvokeServer()
		end
		wait()
	end
end

function autoPlace()
	while getgenv().autoPlace == true do
		local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
		local success, upvalues = pcall(debug.getupvalues, Loader.init)

		if not success then
			warn("Failed to get upvalues from Loader.init")
			return
		end

		local Modules = {
			["CORE_CLASS"] = upvalues[6],
			["CORE_SERVICE"] = upvalues[7],
			["SERVER_CLASS"] = upvalues[8],
			["SERVER_SERVICE"] = upvalues[9],
			["CLIENT_CLASS"] = upvalues[10],
			["CLIENT_SERVICE"] = upvalues[11],
		}

		local StatsServiceClient = Modules["CLIENT_SERVICE"] and Modules["CLIENT_SERVICE"]["StatsServiceClient"]

		function createAreaVisualization(center, radius)
			local area = Instance.new("Part")
			area.Name = "UnitSpawnArea"
			area.Size = Vector3.new(radius * 2, 0.1, radius * 2)
			area.Position = center + Vector3.new(0, 0.05, 0)
			area.Anchored = true
			area.CanCollide = false
			area.Transparency = 0.5
			area.Color = Color3.fromRGB(0, 255, 0)
			area.Shape = Enum.PartType.Cylinder
			area.Orientation = Vector3.new(90, 0, 0)
			area.Parent = workspace
			return area
		end

		function getRandomPositionAroundWaypoint(waypointPosition, radius)
			local angle = math.random() * (2 * math.pi)
			local distance = math.random() * radius
			local offset = Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
			return waypointPosition + offset
		end

		function GetCFrame(position, rotationX, rotationY)
			return CFrame.new(position) * CFrame.Angles(math.rad(rotationX), math.rad(rotationY), 0)
		end

		if
			StatsServiceClient
			and StatsServiceClient.module
			and StatsServiceClient.module.session
			and StatsServiceClient.module.session.collection
			and StatsServiceClient.module.session.collection.collection_profile_data
			and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
		then
			local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
			local radius = 5
			local existingPositions = {}

			local lane = workspace._BASES.pve.LANES:FindFirstChild("1")
			local waypoint = lane:FindFirstChild("1")
			if not waypoint then
				warn("Waypoint not found in lane")
				return
			end

			createAreaVisualization(waypoint.Position, radius)

			for _, unit in pairs(equippedUnits) do
				if type(unit) == "table" then
					for _, unitID in pairs(unit) do
						local spawnPosition = getRandomPositionAroundWaypoint(waypoint.Position, radius)
						local spawnCFrame = GetCFrame(spawnPosition, 0, 0)

						local args = {
							[1] = unitID,
							[2] = spawnCFrame,
						}

						table.insert(existingPositions, spawnPosition)
						game:GetService("ReplicatedStorage")
							:WaitForChild("endpoints")
							:WaitForChild("client_to_server")
							:WaitForChild("spawn_unit")
							:InvokeServer(unpack(args))
					end
				else
					local spawnPosition = getRandomPositionAroundWaypoint(waypoint.Position, radius)
					local spawnCFrame = GetCFrame(spawnPosition, 0, 0)

					local args = {
						[1] = unit,
						[2] = spawnCFrame,
					}

					table.insert(existingPositions, spawnPosition)
					game:GetService("ReplicatedStorage")
						:WaitForChild("endpoints")
						:WaitForChild("client_to_server")
						:WaitForChild("spawn_unit")
						:InvokeServer(unpack(args))
				end
			end
		end
		wait()
	end
end

function autoUpgrade()
    while getgenv().autoUpgrade == true do
		local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
		local upvalues = debug.getupvalues(Loader.init)
		
		local Modules = {
			["CORE_CLASS"] = upvalues[6],
			["CORE_SERVICE"] = upvalues[7],
			["SERVER_CLASS"] = upvalues[8],
			["SERVER_SERVICE"] = upvalues[9],
			["CLIENT_CLASS"] = upvalues[10],
			["CLIENT_SERVICE"] = upvalues[11],
		}
		
		local ownedUnits = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.collection.collection_profile_data.owned_units
		local equippedUnits = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.collection.collection_profile_data.equipped_units
		
		function checkEquippedAgainstOwned()
			local matchedUUIDs = {}
		
			for _, equippedUUID in pairs(equippedUnits) do
				for key, _ in pairs(ownedUnits) do
					if tostring(equippedUUID) == tostring(key) then
						table.insert(matchedUUIDs, key)
					end
				end
			end
		
			return matchedUUIDs
		end
		
		function getBaseName(unitName)
			return string.match(unitName, "^(.-)_evolved$") or unitName
		end
		
		function printUnitNames(matchedUUIDs)
			local unitsFolder = workspace:FindFirstChild("_UNITS")
			if not unitsFolder then
				warn("Pasta '_UNITS' não encontrada no workspace!")
				return
			end
		
			for _, matchedUUID in pairs(matchedUUIDs) do
				local ownedUnit = ownedUnits[matchedUUID]
				if ownedUnit and ownedUnit.unit_id then
					local found = false
					for _, unit in pairs(unitsFolder:GetChildren()) do
						if getBaseName(ownedUnit.unit_id) == getBaseName(unit.Name) then
							local args = {
								[1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(ownedUnit.unit_id))
							}

							local success, err = pcall(function()
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("upgrade_unit_ingame"):InvokeServer(unpack(args))
							end)

							if not success then
								warn("Erro ao realizar upgrade da unidade:", err)
							end
							found = true
						end
					end
					if not found then
						print("Unidade possuída não encontrada no mapa:", ownedUnit.unit_id)
					end
				end
			end
		end
		
		local matchingUUIDs = checkEquippedAgainstOwned()
		if #matchingUUIDs > 0 then
			printUnitNames(matchingUUIDs)
		else
			print("Nenhuma unidade equipada corresponde às unidades possuídas.")
		end		
        wait()
    end
end

function autoEquipUnit()
	local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
	upvalues = debug.getupvalues(Loader.init)
	local Modules = {
		["CORE_CLASS"] = upvalues[6],
		["CORE_SERVICE"] = upvalues[7],
		["SERVER_CLASS"] = upvalues[8],
		["SERVER_SERVICE"] = upvalues[9],
		["CLIENT_CLASS"] = upvalues[10],
		["CLIENT_SERVICE"] = upvalues[11],
	}

	local ownedUnits =
		Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.collection.collection_profile_data.owned_units
	local selectedUUIDs = {}
	local count = 0

	function getMaxUnitsByLevel()
		local playerLevel = checkPlayerXp()
		if playerLevel >= 0 and playerLevel <= 14 then
			return 4
		elseif playerLevel >= 15 and playerLevel <= 29 then
			return 5
		else
			return 6
		end
	end

	local maxUnits = getMaxUnitsByLevel()

	if type(ownedUnits) == "table" then
		local uuidList = {}

		for _, unit in pairs(ownedUnits) do
			if unit.uuid then
				table.insert(uuidList, unit.uuid)
			end
		end

		while count < maxUnits and #uuidList > 0 do
			local randomIndex = math.random(1, #uuidList)
			local uuid = uuidList[randomIndex]

			if not selectedUUIDs[uuid] then
				selectedUUIDs[uuid] = true
				count = count + 1
				local args = {
					[1] = tostring(uuid),
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("endpoints")
					:WaitForChild("client_to_server")
					:WaitForChild("equip_unit")
					:InvokeServer(unpack(args))
				wait(1)
			end

			local playerLevel = checkPlayerXp()
			maxUnits = getMaxUnitsByLevel()

			table.remove(uuidList, randomIndex)
		end
	else
		print("A tabela 'owned_units' não é válida ou está vazia.")
	end
end

function checkPlayerXp()
	local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
	local upvalues = debug.getupvalues(Loader.init)
	local Modules = {
		["CORE_CLASS"] = upvalues[6],
		["CORE_SERVICE"] = upvalues[7],
		["SERVER_CLASS"] = upvalues[8],
		["SERVER_SERVICE"] = upvalues[9],
		["CLIENT_CLASS"] = upvalues[10],
		["CLIENT_SERVICE"] = upvalues[11],
	}

	local playerXp = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data.player_xp
	if playerXp == 0 then
		local args = {
			[1] = "EventClover",
			[2] = "gems10",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("buy_from_banner")
			:InvokeServer(unpack(args))
		return 0
	elseif playerXp == 15 or playerXp == 30 then
		print("Have Played")
		return playerXp
	else
		print("Have Played")
		return playerXp or "Unknown XP"
	end
end

function checkProgressionPlayer()
	while checkProgressionPlayerEnabled == true do
		local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
		upvalues = debug.getupvalues(Loader.init)
		local Modules = {
			["CORE_CLASS"] = upvalues[6],
			["CORE_SERVICE"] = upvalues[7],
			["SERVER_CLASS"] = upvalues[8],
			["SERVER_SERVICE"] = upvalues[9],
			["CLIENT_CLASS"] = upvalues[10],
			["CLIENT_SERVICE"] = upvalues[11],
		}
		
		function getKeys(tbl)
			local keys = {}
			for key, _ in pairs(tbl) do
				table.insert(keys, key)
			end
			return keys
		end
		
		local storyFinished = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data.level_data.completed_story_levels
		local storyFinishedToCheck = getKeys(storyFinished)
		
		local hasNamekLevel6 = false
		for _, key in ipairs(storyFinishedToCheck) do
			if key == "namek_level_6" then
				hasNamekLevel6 = true
				break
			end
		end
		
		if hasNamekLevel6 then
			local inLobby = workspace:FindFirstChild("_LOBBY_CONFIG")
			if inLobby then
				local args = {
					[1] = "_lobbytemplategreen1"
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("endpoints")
					:WaitForChild("client_to_server")
					:WaitForChild("request_join_lobby")
					:InvokeServer(unpack(args))

				local args = {
					[1] = "_lobbytemplategreen1",
					[2] = "namek_infinite",
					[3] = true,
					[4] = "Hard",
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("endpoints")
					:WaitForChild("client_to_server")
					:WaitForChild("request_lock_level")
					:InvokeServer(unpack(args))

				wait(1)

				local args = {
					[1] = "_lobbytemplategreen1",
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("endpoints")
					:WaitForChild("client_to_server")
					:WaitForChild("request_start_game")
					:InvokeServer(unpack(args))
			else
				autoreplay()
			end
		else
			local inLobby = workspace:FindFirstChild("_LOBBY_CONFIG")

			if inLobby then
				local args = {
					[1] = "_lobbytemplategreen1"
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("endpoints")
					:WaitForChild("client_to_server")
					:WaitForChild("request_join_lobby")
					:InvokeServer(unpack(args))

				local args = {
					[1] = "namek"
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("endpoints")
					:WaitForChild("client_to_server")
					:WaitForChild("lobby_world_skip")
					:InvokeServer(unpack(args))
			else
				autoleave()
			end
		end

		wait()
	end
end

function blackScreen()
	local screenGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("BlackScreenTempestHub")
	if screenGui then
        screenGui.Enabled = not screenGui.Enabled
    end
end

function createBC()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BlackScreenTempestHub"
	screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	screenGui.Enabled = false
	
	local frame = Instance.new("Frame")
	frame.Name = "BackgroundFrame"
	frame.Size = UDim2.new(1, 0, 2, 0)
	frame.Position = UDim2.new(0, 0, 0, -60)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.Parent = screenGui
	
	local centerFrame = Instance.new("Frame")
	centerFrame.Name = "CenterFrame"
	centerFrame.Size = UDim2.new(0, 300, 0, 300)
	centerFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
	centerFrame.AnchorPoint = Vector2.new(0, 0.7)
	centerFrame.BackgroundTransparency = 1
	centerFrame.Parent = frame
	
	local yOffset = 0
	local player = game.Players.LocalPlayer
	
	local name = player.Name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(0, 200, 0, 50)
	nameLabel.Position = UDim2.new(0.5, -100, 0, yOffset)
	nameLabel.Text = "Name: " .. name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 20
	nameLabel.BackgroundTransparency = 1
	nameLabel.Parent = centerFrame
	yOffset = yOffset + 55
	
	local levelText = player.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text
	local numberAndAfter = levelText:sub(7)
	local levelLabel = Instance.new("TextLabel")
	levelLabel.Name = "LevelLabel"
	levelLabel.Size = UDim2.new(0, 200, 0, 50)
	levelLabel.Position = UDim2.new(0.5, -100, 0, yOffset)
	levelLabel.Text = "Level: " .. numberAndAfter
	levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	levelLabel.TextSize = 20
	levelLabel.BackgroundTransparency = 1
	levelLabel.Parent = centerFrame
	yOffset = yOffset + 55
	
	local gemsAmount = game:GetService("Players").LocalPlayer._stats:FindFirstChild("gem_amount")
	local Gems = Instance.new("TextLabel")
	Gems.Name = "gemsLabel"
	Gems.Size = UDim2.new(0, 200, 0, 50)
	Gems.Position = UDim2.new(0.5, -100, 0, yOffset)
	Gems.Text = "Gems: " .. gemsAmount.Value
	Gems.TextColor3 = Color3.fromRGB(255, 255, 255)
	Gems.TextSize = 20
	Gems.BackgroundTransparency = 1
	Gems.Parent = centerFrame
	yOffset = yOffset + 55
	
	local goldAmount = game:GetService("Players").LocalPlayer._stats:FindFirstChild("gold_amount")
	local Gold = Instance.new("TextLabel")
	Gold.Name = "goldLabel"
	Gold.Size = UDim2.new(0, 200, 0, 50)
	Gold.Position = UDim2.new(0.5, -100, 0, yOffset)
	Gold.Text = "Gold: " .. goldAmount.Value
	Gold.TextColor3 = Color3.fromRGB(255, 255, 255)
	Gold.TextSize = 20
	Gold.BackgroundTransparency = 1
	Gold.Parent = centerFrame
	yOffset = yOffset + 55
	
	local holidayAmount = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceHolidayStars")
	local Holiday = Instance.new("TextLabel")
	Holiday.Name = "holidayLabel"
	Holiday.Size = UDim2.new(0, 200, 0, 50)
	Holiday.Position = UDim2.new(0.5, -100, 0, yOffset)
	Holiday.Text = "Holiday Stars: " .. holidayAmount.Value
	Holiday.TextColor3 = Color3.fromRGB(255, 255, 255)
	Holiday.TextSize = 20
	Holiday.BackgroundTransparency = 1
	Holiday.Parent = centerFrame
	yOffset = yOffset + 55
	
	local candyAmount = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceCandies")
	local candy = Instance.new("TextLabel")
	candy.Name = "candyLabel"
	candy.Size = UDim2.new(0, 200, 0, 50)
	candy.Position = UDim2.new(0.5, -100, 0, yOffset)
	candy.Text = "Candy: " .. candyAmount.Value
	candy.TextColor3 = Color3.fromRGB(255, 255, 255)
	candy.TextSize = 20
	candy.BackgroundTransparency = 1
	candy.Parent = centerFrame
	yOffset = yOffset + 55
end

function kaitun()
	while getgenv().kaitun == true do
		local inLobby = workspace:FindFirstChild("_LOBBY_CONFIG")
		if inLobby then
			task.spawn(function()
				checkPlayerXp()
			end)
			wait(2)
			task.spawn(function()
				autoEquipUnit()
			end)
			wait(1)
			task.spawn(function()
				checkProgressionPlayer()
			end)
		else
			task.spawn(function()
				checkProgressionPlayer()
			end)
        end
		wait()
	end
end

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local resultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")

        if resultUI and resultUI.Enabled == true then
            local ValuesRewards = {}
            local ValuesStatPlayer = {}        
            local name = game:GetService("Players").LocalPlayer.Name
            local formattedName = "||" .. name .. "||"

            local levelText = game:GetService("Players").LocalPlayer.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text
            local numberAndAfter = levelText:sub(7)

            local player = game:GetService("Players").LocalPlayer
            local scrollingFrame = player.PlayerGui.ResultsUI.Holder.LevelRewards.ScrollingFrame

            local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
            local upvalues = debug.getupvalues(Loader.init)
            local Modules = {
                ["CORE_CLASS"] = upvalues[6],
                ["CORE_SERVICE"] = upvalues[7],
                ["SERVER_CLASS"] = upvalues[8],
                ["SERVER_SERVICE"] = upvalues[9],
                ["CLIENT_CLASS"] = upvalues[10],
                ["CLIENT_SERVICE"] = upvalues[11],
            }
            local inventory = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.inventory.inventory_profile_data.normal_items

            for _, frame in pairs(scrollingFrame:GetChildren()) do
                if (frame.Name == "GemReward" or frame.Name == "GoldReward" or frame.Name == "TrophyReward" or frame.Name == "XPReward") and frame.Visible then
                    local amountLabel = frame:FindFirstChild("Main") and frame.Main:FindFirstChild("Amount")
                    if amountLabel then
                        local rewardType = frame.Name:gsub("Reward", "")
                        local gainedAmount = amountLabel.Text
                        local totalAmount = inventory[rewardType:lower()]
            
                        if totalAmount then
                            table.insert(ValuesRewards, gainedAmount .. "[" .. totalAmount .. "]\n")
                        else
                            table.insert(ValuesRewards, gainedAmount .. "\n")
                        end
                    end
                end
            end

            local rewardsString = table.concat(ValuesRewards, "\n")

            local levelDataRemote = workspace._MAP_CONFIG:WaitForChild("GetLevelData")
            local ResultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
            local act = ResultUI.Holder.LevelName.Text
            local levelData = levelDataRemote:InvokeServer()

            local ValuesMapConfig = {}
            
            local result = ResultUI.Holder.Title.Text
            local elapsedTimeText = ResultUI.Holder.Middle.Timer.Text
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
            
            if type(levelData) == "table" then
                if levelData.world and levelData._gamemode and levelData._difficulty then
                    local formattedValue = levelData.world .. " " .. act .." - " .. levelData._gamemode .. " [" .. levelData._difficulty .. "]"
            
                    local FormattedFinal = "\n" .. formattedTime .. " - " .. result .. "\n" .. formattedValue
            
                    table.insert(ValuesMapConfig, FormattedFinal)
                else
                    print("Faltando informações necessárias no levelData.")
                end
            else
                print("O dado recebido não é uma tabela.")
            end      

            local playerData = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data
            local gemsEmoji = "<:gemsAA:1322365177320177705>"
            local goldEmoji = "<:goldAA:1322369598015668315>"
            local traitReroll = "<:traitRerollAA:1322370533106384987>"

            local keysToPrint = {
                ["gem_amount"] = gemsEmoji,
                ["gold_amount"] = goldEmoji,
                ["trait_reroll_tokens"] = traitReroll,
                ["trophies"] = "🏆",
                ["christmas2024_meter_value"] = "🎁"
            }
            
            local battlepassData = playerData.battlepass_data
            local silverChristmasXp = battlepassData.silver_christmas.xp
            
            local ValuesBattlepassXp = {}
            
            local holidayStars = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceHolidayStars")
            local Candies = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceCandies")
            
            if holidayStars and Candies then
                table.insert(ValuesBattlepassXp, holidayStars.Value)
                table.insert(ValuesBattlepassXp, Candies.Value)
            end
            
            table.insert(ValuesBattlepassXp, silverChristmasXp)
            table.insert(ValuesBattlepassXp, battlepassData)
            
            local message = ""
            
            for _, key in ipairs({"gem_amount", "gold_amount", "trait_reroll_tokens", "trophies", "christmas2024_meter_value"}) do
                if playerData[key] then
                    message = message .. keysToPrint[key] .. " " .. playerData[key] .. "\n"
                end
            end
            
            if holidayStars then
                local holidayEmoji = "<:holidayEventAA:1322369599517491241>"
                message = message .. holidayEmoji .. tostring(holidayStars.Value) .. "\n"
            end            
            if Candies then
                local candieEmoji = "<:candieAA:1322369601182629929>"
                message = message .. candieEmoji .. Candies.Value .. "\n"
            end
            
            table.insert(ValuesStatPlayer, message)            
            local statsString = table.concat(ValuesStatPlayer, "\n")
            local mapConfigString = table.concat(ValuesMapConfig, "\n")
            
            local color = 7995647
            if result == "DEFEAT" then
                color = 16711680
            elseif result == "VICTORY" then
                color = 65280
            end

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
                        description = string.format("User: %s\nLevel: %s\n\nPlayer Stats:\n%s\nRewards:\n%s\nMatch Result:%s", formattedName, numberAndAfter, statsString, rewardsString, mapConfigString),
                        color = color,
                        fields = {
                            {
                                name = "Discord",
                                value = "https://discord.gg/ey83AwMvAn"
                            }
                        },
                        author = {
                            name = "Anime Adventures"
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
        wait(1)
    end
end

local Tabs = {
	Main = Window:AddTab("Main"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Player")

LeftGroupBox:AddToggle("HPI", {
	Text = "Hide Player Info",
	Default = false,
	Callback = function(Value)
		getgenv().hideInfoPlayer = Value
		hideInfoPlayer()
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

LeftGroupBox:AddToggle("DM", {
	Text = "Delete Map",
	Default = false,
	Callback = function(Value)
		getgenv().deletemap = Value
		deletemap()
	end,
})

LeftGroupBox:AddToggle("DN", {
	Text = "Disable Notifications",
	Default = false,
	Callback = function(Value)
		getgenv().disableNotifications = Value
		disableNotifications()
	end,
})

LeftGroupBox:AddToggle("AS", {
	Text = "Auto Start",
	Default = false,
	Callback = function(Value)
		getgenv().autostart = Value
		autostart()
	end,
})

LeftGroupBox:AddToggle("ASW", {
	Text = "Auto Skip Wave",
	Default = false,
	Callback = function(Value)
		getgenv().autoSkipWave = Value
		autoSkipWave()
	end,
})

LeftGroupBox:AddToggle("Auto Place", {
	Text = "Auto Place",
	Default = false,

	Callback = function(Value)
		getgenv().autoPlace = Value
		autoPlace()
	end,
})

LeftGroupBox:AddToggle("Auto Upgrade", {
	Text = "Auto Upgrade",
	Default = false,

	Callback = function(Value)
		getgenv().autoUpgrade = Value
		autoUpgrade()
	end,
})

LeftGroupBox:AddToggle("KAITUN", {
	Text = "Kaitun",
	Default = false,
	Callback = function(Value)
		getgenv().kaitun = Value
		kaitun()
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

--UI IMPORTANT THINGS
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

	Library:SetWatermark(
		("Tempest Hub | %s fps | %s ms | %s"):format(
			math.floor(FPS),
			math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()),
			FormatTime(activeTime)
		)
	)
end

WatermarkConnection = game:GetService("RunService").RenderStepped:Connect(UpdateWatermark)

local TabsUI = {
	["UI Settings"] = Window:AddTab("UI Settings"),
}

local function Unload()
	WatermarkConnection:Disconnect()
	print("Unloaded!")
	Library.Unloaded = true
end

local MenuGroup = TabsUI["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("huwe", {
	Text = "Hide UI When Execute",
	Default = false,
	Callback = function(Value)
		getgenv().hideUIExec = Value
		hideUIExec()
	end,
})

MenuGroup:AddToggle("AUTOEXECUTE", {
	Text = "Auto Execute",
	Default = false,
	Callback = function(Value)
		getgenv().aeuat = Value
		aeuat()
	end,
})

MenuGroup:AddToggle("AUTOEXECUTE", {
	Text = "Blackscreen",
	Default = false,
	Callback = function(Value)
		getgenv().blackScreen = Value
		blackScreen()
	end,
})

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "End", NoUI = true, Text = "Menu keybind" })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

--Save Settings
ThemeManager:SetFolder("Tempest Hub")
SaveManager:SetFolder("Tempest Hub/_AA_Kaitun_")

SaveManager:BuildConfigSection(TabsUI["UI Settings"])

ThemeManager:ApplyToTab(TabsUI["UI Settings"])

SaveManager:LoadAutoloadConfig()

local GameConfigName = "_AA_Kaitun_"
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

--Anti AFK
for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end
warn("[TEMPEST HUB] Loaded")
createBC()