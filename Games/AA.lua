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
	Title = "Tempest Hub | Anime Adventures",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

Library:Notify("Loading Anime Adventures Script", 5)
warn("[TEMPEST HUB] Loading Function")
wait()
warn("[TEMPEST HUB] Loading Toggles")
wait()
warn("[TEMPEST HUB] Last Checking")
wait()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local speed = 1000

--START OF FUNCTIONS
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
			if
				(State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress) and not teleportQueued
			then
				teleportQueued = true

				queue_on_teleport([[         
                    repeat task.wait() until game:IsLoaded()
                    wait(3)
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

function autostart()
	while getgenv().autostart == true do
		game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
	end
end

function autoskipwave()
	while getgenv().autoskipwave == true do
		game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_wave_skip:InvokeServer()
	end
end

function autoreplay()
	while getgenv().autoreplay == true do
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
	while getgenv().autoleave == true do
		local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI
		if resultUI and resultUI.Enabled == true then
			wait(3)
			game:GetService("ReplicatedStorage").endpoints.client_to_server.teleport_back_to_lobby:InvokeServer("leave")
		end
		wait()
	end
end

function autonext()
	while getgenv().autonext == true do
		local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI
		if resultUI and resultUI.Enabled == true then
			wait(3)
			local args = {
				[1] = "next_story",
			}

			game:GetService("ReplicatedStorage").endpoints.client_to_server.set_game_finished_vote
				:InvokeServer(unpack(args))
		end
		wait()
	end
end

function autoEnter()
	while getgenv().autoEnter == true do
		local args = {
			[1] = "_lobbytemplategreen1",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_join_lobby")
			:InvokeServer(unpack(args))
		wait(1)
		if selectedAct ~= "Infinite" then
			local args = {
				[1] = "_lobbytemplategreen1",
				[2] = selectedMap .. "_level_" .. selectedAct,
				[3] = false,
				[4] = selectedDifficulty,
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("endpoints")
				:WaitForChild("client_to_server")
				:WaitForChild("request_lock_level")
				:InvokeServer(unpack(args))
		else
			local args = {
				[1] = "_lobbytemplategreen1",
				[2] = selectedMap .. "_infinite",
				[3] = selectedFriendsOnly,
				[4] = selectedDifficulty,
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("endpoints")
				:WaitForChild("client_to_server")
				:WaitForChild("request_lock_level")
				:InvokeServer(unpack(args))
		end
		wait(1)
		local args = {
			[1] = "_lobbytemplategreen1",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_start_game")
			:InvokeServer(unpack(args))
		break
	end
end

function autoEnterRaid()
	while getgenv().autoEnterRaid == true do
		local args = {
			[1] = "_lobbytemplate214",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_join_lobby")
			:InvokeServer(unpack(args))
		wait(1)
		local args = {
			[1] = "_lobbytemplate214",
			[2] = selectedMapRaid,
			[3] = selectedFriendsOnly,
			[4] = "Hard",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_lock_level")
			:InvokeServer(unpack(args))
		wait(1)
		local args = {
			[1] = "_lobbytemplate214",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_start_game")
			:InvokeServer(unpack(args))
		break
	end
end

function autoEnterChallenge()
	while getgenv().autoEnterChallenge == true do
		wait()
	end
end

function CheckErwinCount(erwin1)
	return #erwin1 == 4
end

function UseActiveAttackE()
	local goat = game.Players.LocalPlayer
	local erwin1 = {}

	while toggle do
		erwin1 = {}

		print("Buscando unidades 'erwin'...")

		for _, v in pairs(game:GetService("Workspace")._UNITS:GetChildren()) do
			if v.Name == "erwin" and v._stats.player.Value == goat then
				table.insert(erwin1, v)
			end
		end

		print("Erwins encontrados: ", #erwin1)

		if CheckErwinCount(erwin1) then
			print("Verificando se os 'erwins' são válidos...")

			for i, erwin in ipairs(erwin1) do
				if not toggle then
					break
				end

				local endpoints = game:GetService("ReplicatedStorage"):WaitForChild("endpoints")
				local client_to_server = endpoints:WaitForChild("client_to_server")
				local use_active_attack = client_to_server:WaitForChild("use_active_attack")

				print("Ativando ataque para Erwin: ", erwin)

				use_active_attack:InvokeServer(erwin)
				wait(15.7)
			end
		else
			print("Número insuficiente de 'Erwins' para ativar o ataque.")
		end
		wait(2)
	end
end

function CheckWendyCount(wendyTable)
	return #wendyTable == 4
end

function UseActiveAttackW()
	local player = game.Players.LocalPlayer
	print("Iniciando a função UseActiveAttackW para", player.Name)

	while toggle2 do
		print("Verificando a presença do jogador e seu personagem...")
		repeat
			wait(1)
		until player and player.Character
		print("Jogador e personagem encontrados:", player.Name)

		local wendy1 = {}
		print("Filtrando unidades Wendy...")

		for _, unit in pairs(game:GetService("Workspace")._UNITS:GetChildren()) do
			if (unit.Name == "wendy" or unit.Name == "wendy_halloween") and unit._stats.player.Value == player then
				table.insert(wendy1, unit)
				print("Unidade Wendy ou Wendy Halloween encontrada:", unit.Name)
			end
		end

		print("Número de unidades Wendy ou Wendy Halloween controladas pelo jogador:", #wendy1)

		if CheckWendyCount(wendy1) then
			print("Número correto de unidades Wendy (4) encontrado, iniciando ataque ativo...")

			if not toggle2 then
				print("A execução do buff foi interrompida, toggle desativado.")
				break
			end
			for _, wendyUnit in ipairs(wendy1) do
				print("Ativando o ataque para a Wendy:", wendyUnit.Name)
				game:GetService("ReplicatedStorage")
					:WaitForChild("endpoints")
					:WaitForChild("client_to_server")
					:WaitForChild("use_active_attack")
					:InvokeServer(wendyUnit)
				print("Ataque ativo invocado para a Wendy:", wendyUnit.Name)
				wait(15.8)
			end
		else
			print("Número incorreto de unidades Wendy, não aplicando buff.")
		end
		wait(1)
	end

	print("Função UseActiveAttackW finalizada.")
end

function CheckLeafyCount(leafy1)
	return #leafy1 == 4
end

function UseActiveAttackL()
	local goat = game.Players.LocalPlayer
	local leafy1 = {}

	while toggle3 do
		leafy1 = {}

		print("Buscando unidades 'leafy'...")

		for _, v in pairs(game:GetService("Workspace")._UNITS:GetChildren()) do
			if v.Name == "leafy" and v._stats.player.Value == goat then
				table.insert(leafy1, v)
			end
		end

		print("leafy encontrados: ", #leafy1)

		if CheckLeafyCount(leafy1) then
			print("Verificando se os 'leafy' são válidos...")

			for i, leafy in ipairs(leafy1) do
				if not toggle3 then
					break
				end

				local endpoints = game:GetService("ReplicatedStorage"):WaitForChild("endpoints")
				local client_to_server = endpoints:WaitForChild("client_to_server")
				local use_active_attack = client_to_server:WaitForChild("use_active_attack")

				print("Ativando ataque para leafy: ", leafy)

				use_active_attack:InvokeServer(leafy)
				wait(15.7)
			end
		else
			print("Número insuficiente de 'leafy' para ativar o ataque.")
		end
		wait(1)
	end
end

function autoGetBattlepass()
	while getgenv().autoGetBattlepass == true do
		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("claim_battlepass_rewards")
			:InvokeServer()
		wait(10)
	end
end

function autoGivePresents()
	while getgenv().autoGivePresents == true do
		game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("feed_easter_meter"):InvokeServer()
		wait()
	end
end

function autoJoinHolidayEvent()
	if getgenv().autoJoinHolidayEvent == true then
		local args = {
			[1] = "_lobbytemplate_event3",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_join_lobby")
			:InvokeServer(unpack(args))
		wait()
	end
end

function autoJoinHalloweenEvent()
	if getgenv().autoJoinHalloweenEvent == true then
		local args = {
			[1] = "_lobbytemplate_event4",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_join_lobby")
			:InvokeServer(unpack(args))
		wait()
	end
end

function autoJoinCursedWomb()
	if getgenv().autoJoinCursedWomb == true then
		local args = {
			[1] = "Items",
			[2] = 0,
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("save_notifications_state")
			:InvokeServer(unpack(args))
		wait(1)
		local args = {
			[1] = "_lobbytemplate_event222",
			[2] = {
				["selected_key"] = "key_jjk_finger",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_join_lobby")
			:InvokeServer(unpack(args))
		wait()
	end
end

function autoMatchmakingHalloweenEvent()
    while getgenv().matchmakingHalloween == true do
		game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer("halloween2_event")
        wait()
    end
end

function autoMatchmakingHolidayEvent()
    while getgenv().matchmakingHoliday == true do
        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer("christmas_event")
        wait()
    end
end

function autoBuy()
	while getgenv().autoBuy == true do
		local args = {
			[1] = selectedItemToBuy,
			[2] = "1",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("buy_travelling_merchant_item")
			:InvokeServer(unpack(args))
		local args = {
			[1] = "Items",
			[2] = 1,
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("save_notifications_state")
			:InvokeServer(unpack(args))
		wait()
	end
end

function autoOpenCapsule()
	while getgenv().autoOpenCapsule == true do
		local args = {
			[1] = selectedCapsule,
			[2] = {
				["use10"] = false,
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("use_item")
			:InvokeServer(unpack(args))
		wait()
	end
end

function autoFeed()
	while getgenv().autoFeed == true do
		local args = {
			[1] = selectedUnitToFeed,
			[2] = {
				[selectedFeed] = 1,
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("level_up_feed")
			:InvokeServer(unpack(args))
		local args = {
			[1] = "Inventory",
			[2] = 0,
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("save_notifications_state")
			:InvokeServer(unpack(args))
		wait()
	end
end

function disableNotifications()
	local notifications = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("NotificationWindows")
	if notifications then
		notifications.Enabled = false
	end
end

function autoPlace()
	while getgenv().autoPlace == true do
		local wave = workspace:FindFirstChild("_wave_num")
		if getgenv().onlyupgradeinXwave == true then
			if selectedWaveToUpgrade == wave then
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
		
				local ValuesIDUnits = {}
				local StatsServiceClient = Modules["CLIENT_SERVICE"] and Modules["CLIENT_SERVICE"]["StatsServiceClient"]
		
				local function getRandomWaypoint(existingPositions)
					local lane = nil
					while not lane do
						lane = workspace._BASES.player.LANES:FindFirstChild("1")
						wait(1)
					end
		
					local waypoints = {}
					
					for _, child in pairs(lane:GetChildren()) do
						if child.Name ~= "_formation" and child:IsA("BasePart") then
							table.insert(waypoints, child.CFrame)
						end
					end
					
					if #waypoints == 0 then
						if #existingPositions > 0 then
							local position = existingPositions[math.random(1, #existingPositions)]
							local offset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
							return CFrame.new(position + offset)
						else
							warn("No valid waypoints or existing positions found.")
							return nil
						end
					else
						return waypoints[math.random(1, #waypoints)]
					end
				end
		
				if StatsServiceClient and StatsServiceClient.module and StatsServiceClient.module.session 
				and StatsServiceClient.module.session.collection 
				and StatsServiceClient.module.session.collection.collection_profile_data 
				and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units then
		
					local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
					local existingPositions = {}
		
					for _, unit in pairs(equippedUnits) do
						if type(unit) == "table" then
							for _, unitID in pairs(unit) do
								local waypointCFrame = getRandomWaypoint(existingPositions)
								if waypointCFrame then
									local spawnCFrame = GetCFrame(waypointCFrame.Position, 0, 0)
									local args = {
										[1] = unitID,
										[2] = spawnCFrame
									}
		
									table.insert(existingPositions, spawnCFrame.Position)
		
									game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unpack(args))
								end
							end
						else
							local waypointCFrame = getRandomWaypoint(existingPositions)
							if waypointCFrame then
								local spawnCFrame = GetCFrame(waypointCFrame.Position, 0, 0)
								local args = {
									[1] = unit,
									[2] = spawnCFrame
								}
		
								table.insert(existingPositions, spawnCFrame.Position)
		
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unpack(args))
							end
						end
					end
				else
					warn("Invalid path to StatsServiceClient or equipped_units")
					return
				end
			end
		else
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

			local ValuesIDUnits = {}
			local StatsServiceClient = Modules["CLIENT_SERVICE"] and Modules["CLIENT_SERVICE"]["StatsServiceClient"]

			local function getRandomWaypoint(existingPositions)
				local lane = nil
				while not lane do
					lane = workspace._BASES.player.LANES["1"]
					wait(1)
				end

				local waypoints = {}
				
				for _, child in pairs(lane:GetChildren()) do
					if child.Name ~= "_formation" and child:IsA("BasePart") then
						table.insert(waypoints, child.CFrame)
					end
				end
				
				if #waypoints == 0 then
					if #existingPositions > 0 then
						local position = existingPositions[math.random(1, #existingPositions)]
						local offset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
						return CFrame.new(position + offset)
					else
						warn("No valid waypoints or existing positions found.")
						return nil
					end
				else
					return waypoints[math.random(1, #waypoints)]
				end
			end

			if StatsServiceClient and StatsServiceClient.module and StatsServiceClient.module.session 
			and StatsServiceClient.module.session.collection 
			and StatsServiceClient.module.session.collection.collection_profile_data 
			and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units then

				local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
				local existingPositions = {}

				for _, unit in pairs(equippedUnits) do
					if type(unit) == "table" then
						for _, unitID in pairs(unit) do
							local waypointCFrame = getRandomWaypoint(existingPositions)
							if waypointCFrame then
								local spawnCFrame = GetCFrame(waypointCFrame.Position, 0, 0)
								local args = {
									[1] = unitID,
									[2] = spawnCFrame
								}

								table.insert(existingPositions, spawnCFrame.Position)

								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unpack(args))
							end
						end
					else
						local waypointCFrame = getRandomWaypoint(existingPositions)
						if waypointCFrame then
							local spawnCFrame = GetCFrame(waypointCFrame.Position, 0, 0)
							local args = {
								[1] = unit,
								[2] = spawnCFrame
							}

							table.insert(existingPositions, spawnCFrame.Position)

							game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unpack(args))
						end
					end
				end
			else
				warn("Invalid path to StatsServiceClient or equipped_units")
				return
			end
		end
		wait()
	end
end

function autoUpgrade()
	while getgenv().autoUpgrade == true do
		local wave = workspace:FindFirstChild("_wave_num")
		if getgenv().onlyupgradeinXwave == true then
			if selectedWaveToUpgrade == wave then
				local units = workspace:FindFirstChild("_UNITS")

				if units then
					for k, l in pairs(units:GetChildren()) do
						local unitAssets = game:GetService("ReplicatedStorage").packages.assets.units
						for i, v in pairs(unitAssets:GetChildren()) do
							for _, j in pairs(v:GetChildren()) do
								if string.lower(j.Name) == string.lower(l.Name) and j ~= pve then
									local args = {
										[1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(j))
									}

									game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("upgrade_unit_ingame"):InvokeServer(unpack(args))    
								end
							end
						end
					end
				else
					print("_UNITS não encontrado no workspace.")
				end
			end
		else
			local units = workspace:FindFirstChild("_UNITS")

			if units then
				for i,v in pairs(units:GetChildren())do
					local args = {
						[1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(v))
					}

					game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("upgrade_unit_ingame"):InvokeServer(unpack(args))    
				end
			end
		end
		wait()
	end
end

function autoSell()
	while getgenv().autoSell == true do
		if getgenv().onlysellinXwave == true then
			local wave = workspace:FindFirstChild("_wave_num")
			if selectedWaveToSell == wave then
				local units = workspace:FindFirstChild("_UNITS")

				if units then
					for i,v in pairs(units:GetChildren())do
						local args = {
							[1] = game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"):WaitForChild("vanilla_ice")
						}
						
						game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("sell_unit_ingame"):InvokeServer(unpack(args))
					end
				end
			end
		else
			local units = workspace:FindFirstChild("_UNITS")

			if units then
				for i,v in pairs(units:GetChildren())do
					local args = {
						[1] = game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"):WaitForChild("vanilla_ice")
					}
					
					game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("sell_unit_ingame"):InvokeServer(unpack(args))
				end
			end
		end
		wait()
	end
end		

function universalSkill()
    while getgenv().universalSkill == true do
        if getgenv().universalSkillinXWave == true then
            local wave = workspace:FindFirstChild("_wave_num")
            if selectedWaveToUniversalSkill == wave then
                local units = workspace:WaitForChild("_UNITS")

                if units then
                    for i, v in pairs(units:GetChildren()) do
                        local args = {
                            [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(v))
                        }

                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
                        end)
                        
                        if not success then
                            warn("Error occurred: " .. err)
                        end
                    end
                end
            end
        else
            local units = workspace:WaitForChild("_UNITS")

            if units then
                for i, v in pairs(units:GetChildren()) do
                    local args = {
                        [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(v))
                    }

                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
                    end)
                    
                    if not success then
                        warn("Error occurred: " .. err)
                    end
                end
            end
        end
        wait()
    end
end

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = "https://discord.com/api/webhooks/1303406324452687935/ou5GoCcOkvH-iRy9hhPoGJnJBs1B8edcin3QNq6UcU--wIhyDltFGmt7j7g-wg9wfE0E"
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

-- Get Informations for Dropdown or other things

function printChallenges(module)
	local challengesKeys = {}
	if module.challenges then
		for key, value in pairs(module.challenges) do
			table.insert(challengesKeys, key)
		end
		return challengesKeys
	else
		print("O módulo não contém 'challenges'.")
	end
end

local module = require(game:GetService("ReplicatedStorage").src.Data.ChallengeAndRewards)
local challengeValues = printChallenges(module)

local Module2 = require(game:GetService("ReplicatedStorage").src.Data.Maps)
function getStoryMapValues(module)
	local seen = {}
	local values = {}

	for key, value in pairs(module) do
		local firstPart = key:match("([^_]+)")

		if not seen[firstPart] then
			seen[firstPart] = true
			table.insert(values, firstPart)
		end
	end

	return values
end

local storyMapValues = getStoryMapValues(Module2)

local portals = game:GetService("ReplicatedStorage").LOBBY_ASSETS:FindFirstChild("_portal_templates")
local ValuesPortalsMaps = {}
if portals then
	for i, v in pairs(portals:GetChildren()) do
		local nameWithoutUnderscore = string.sub(v.Name, 2)
		table.insert(ValuesPortalsMaps, nameWithoutUnderscore)
	end
end

local capsules = game:GetService("ReplicatedStorage").packages.assets:FindFirstChild("ItemModels")
local ValuesCapsules = {}
if capsules then
	for i, v in pairs(capsules:GetChildren()) do
		if string.find(v.Name:lower(), "capsule") then
			table.insert(ValuesCapsules, v.Name)
		end
	end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopItemsModule = ReplicatedStorage.src.Data:FindFirstChild("ShopItems")
local ValuesItemShop = {}
if ShopItemsModule then
	local ShopItems = require(ShopItemsModule)

	for key, value in pairs(ShopItems) do
		if
			not string.find(key, "bundle")
			and not string.find(key, "gift")
			and not string.find(tostring(value), "bundle")
			and not string.find(tostring(value), "gift")
		then
			table.insert(ValuesItemShop, key.Name)
		end
	end
else
	warn("Módulo ShopItems não encontrado.")
end

local itemModels = game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("assets"):FindFirstChild("ItemModels")
local ValuesItemsToFeed = {}
if itemModels then
    for i, v in pairs(itemModels:GetChildren()) do
        table.insert(ValuesItemsToFeed, v.Name)
    end
else
    warn("ItemModels not found!")
end

local fxCache = game:GetService("ReplicatedStorage"):FindFirstChild("_FX_CACHE")
local ValuesUnitId = {}
if fxCache then
    for _, v in pairs(fxCache:GetChildren()) do
        if v.Name == "CollectionUnitFrame" then
            local collectionUnitFrame = v
            table.insert(ValuesUnitId,collectionUnitFrame.name.Text .. " | Level: " .. collectionUnitFrame.Main.Level.Text .. " | " .. collectionUnitFrame._uuid.Value)
        end
    end
end

--Start of UI

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

LeftGroupBox:AddToggle("AL", {
	Text = "Auto Leave",
	Default = false,
	Callback = function(Value)
		getgenv().autoleave = Value
		autoleave()
	end,
})

LeftGroupBox:AddToggle("AR", {
	Text = "Auto Replay",
	Default = false,
	Callback = function(Value)
		getgenv().autoreplay = Value
		autoreplay()
	end,
})

LeftGroupBox:AddToggle("AN", {
	Text = "Auto Next",
	Default = false,
	Callback = function(Value)
		getgenv().autonext = Value
		autonext()
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
		getgenv().autoskipwave = Value
		autoskipwave()
	end,
})

local TabBox2 = Tabs.Main:AddRightTabbox()

local Tab1 = TabBox2:AddTab("Extra")

Tab1:AddToggle("AGB", {
	Text = "Auto Get Battlepass",
	Default = false,
	Callback = function(Value)
		getgenv().autoGetBattlepass = Value
		autoGetBattlepass()
	end,
})

Tab1:AddToggle("DN", {
	Text = "Disable Notifications",
	Default = false,
	Callback = function(Value)
		getgenv().disableNotifications = Value
		disableNotifications()
	end,
})

Tab1:AddToggle("FO", {
	Text = "Friends Only",
	Default = false,
	Callback = function(Value)
		selectedFriendsOnly = Value
	end,
})

Tab1:AddDropdown("dropdownSelectCapsule", {
	Values = ValuesCapsules,
	Default = "None",
	Multi = false,
	Text = "Select Unit to Feed",
	Callback = function(Value)
		selectedCapsule = Value
	end,
})

Tab1:AddToggle("AOC", {
	Text = "Auto Open Capsule",
	Default = false,
	Callback = function(Value)
		getgenv().autoOpenCapsule = Value
		autoOpenCapsule()
	end,
})

local Tab2 = TabBox2:AddTab("Event")

Tab2:AddToggle("AJCW", {
	Text = "Auto Join Cursed Womb",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinCursedWomb = Value
		autoJoinCursedWomb()
	end,
})

Tab2:AddToggle("AJHE", {
	Text = "Auto Join Halloween Event",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinHalloweenEvent = Value
		autoJoinHalloweenEvent()
	end,
})

Tab2:AddToggle("AJHOE", {
	Text = "Auto Join Holiday Event",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinHolidayEvent = Value
		autoJoinHolidayEvent()
	end,
})


Tab2:AddToggle("AMHE", {
	Text = "Auto Matchmaking Halloween Event",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinHalloweenEvent = Value
		autoJoinHalloweenEvent()
	end,
})

Tab2:AddToggle("AMHOE", {
	Text = "Auto Matchmaking Holiday Event",
	Default = false,
	Callback = function(Value)
		getgenv().matchmakingHoliday = Value
		autoMatchmakingHolidayEvent()
	end,
})

Tab2:AddToggle("AGP", {
	Text = "Auto Give Presents",
	Default = false,
	Callback = function(Value)
		getgenv().autoGivePresents = Value
		autoGivePresents()
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

local TabBox = Tabs.Main:AddRightTabbox()

local Tab1 = TabBox:AddTab("Passive")

Tab1:AddLabel("W.I.P")

local Tab2 = TabBox:AddTab("Feed")

Tab2:AddDropdown("FeedUnit", {
	Values = ValuesUnitId,
	Default = "None",
	Multi = false,
	Text = "Select Unit",

	Callback = function(value)
		selectedUnitToFeed = value:match(".* | .* | (.+)")
	end,
})

Tab2:AddDropdown("dropdownSelectItemsToFeed", {
	Values = ValuesItemsToFeed,
	Default = "None",
	Multi = false,
	Text = "Select Unit to Feed",
	Callback = function(Value)
		selectedFeed = Value
	end,
})

Tab2:AddToggle("AFEED", {
	Text = "Auto Feed",
	Default = false,
	Callback = function(Value)
		getgenv().autoFeed = Value
		autoFeed()
	end,
})

local Tabs = {
	Farm = Window:AddTab("Farm"),
}

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Story")

LeftGroupBox:AddDropdown("dropdownStoryMap", {
	Values = storyMapValues,
	Default = "None",
	Multi = false,

	Text = "Select Story Map",

	Callback = function(Value)
		selectedMap = Value
	end,
})

LeftGroupBox:AddDropdown("dropdownSelectDifficultyStory", {
	Values = { "Normal", "Hard" },
	Default = "None",
	Multi = false,

	Text = "Select Difficulty",

	Callback = function(Values)
		selectedDifficulty = Values
	end,
})

LeftGroupBox:AddDropdown("dropdownSelectActStory", {
	Values = { "1", "2", "3", "4", "5", "6", "Infinite" },
	Default = "None",
	Multi = false,

	Text = "Select Act",

	Callback = function(Value)
		selectedAct = Value
	end,
})

LeftGroupBox:AddToggle("AES", {
	Text = "Auto Enter",
	Default = false,
	Callback = function(Value)
		getgenv().autoEnter = Value
		autoEnter()
	end,
})

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Challenge")

RightGroupbox:AddDropdown("dropdownChallengeMap", {
	Values = storyMapValues,
	Default = "None",
	Multi = false,

	Text = "Select Map",

	Callback = function(Values)
		selectedDifficulty = Values
	end,
})

RightGroupbox:AddDropdown("dropdownSelectChallenge", {
	Values = challengeValues,
	Default = "None",
	Multi = false,

	Text = "Select Difficulty",

	Callback = function(Value)
		selectedChallenge = Value
	end,
})

RightGroupbox:AddToggle("AENTER", {
	Text = "Auto Enter",
	Default = false,
	Callback = function(Value)
		getgenv().autoEnterChallenge = Value
		autoEnterChallenge()
	end,
})

local Tabs = {
	Others = Window:AddTab("Others"),
}

local LeftGroupBox = Tabs.Others:AddLeftGroupbox("Unit")

LeftGroupBox:AddInput('inputAutoPlaceWaveX', {
    Default = '',
    Text = "Start Place at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveToPlace = Value
    end
})

LeftGroupBox:AddToggle("Auto Place", {
	Text = "Auto Place",
	Default = false,

	Callback = function(Value)
		getgenv().autoPlace = Value
		autoPlace()
	end,
})

LeftGroupBox:AddToggle("Auto Place", {
	Text = "Only Start Place in X Wave",
	Default = false,

	Callback = function(Value)
		getgenv().autoPlace = Value
		autoPlace()
	end,
})

LeftGroupBox:AddInput('inputAutoPlaceWaveX', {
    Default = '',
    Text = "Start Place at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveToUpgrade = Value
    end
})

LeftGroupBox:AddToggle("Auto Upgrade", {
	Text = "Auto Upgrade",
	Default = false,

	Callback = function(Value)
		getgenv().autoUpgrade = Value
		autoUpgrade()
	end,
})

LeftGroupBox:AddToggle("Auto Upgrade", {
	Text = "Only Upgrade in X Wave",
	Default = false,

	Callback = function(Value)
		getgenv().onlyupgradeinXwave = Value
	end,
})

LeftGroupBox:AddInput('inputAutoPlaceWaveX', {
    Default = '',
    Text = "Start Place at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveToSell = Value
    end
})

LeftGroupBox:AddToggle("Auto Sell", {
	Text = "Auto Sell",
	Default = false,

	Callback = function(Value)
		getgenv().autoSell = Value
		autoSell()
	end,
})

LeftGroupBox:AddToggle("Auto Upgrade", {
	Text = "Only Upgrade in X Wave",
	Default = false,

	Callback = function(Value)
		getgenv().onlysellinXwave = Value
	end,
})

local RightGroupbox = Tabs.Others:AddRightGroupbox("Skill")

RightGroupbox:AddInput('inputAutoPlaceWaveX', {
    Default = '',
    Text = "Start Skill at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveToUniversalSkill = Value
    end
})

RightGroupbox:AddToggle("Auto Buff Erwin", {
	Text = "Auto Universal Skill",
	Default = false,

	Callback = function(Value)
		getgenv().universalSkill = Value
		universalSkill()
	end,
})

RightGroupbox:AddToggle("Auto Upgrade", {
	Text = "Only Universal Skill in X Wave",
	Default = false,

	Callback = function(Value)
		getgenv().universalSkillinXWave = Value
	end,
})

RightGroupbox:AddToggle("Auto Buff Erwin", {
	Text = "Auto Buff Erwin",
	Default = false,

	Callback = function(Value)
		toggle = Value
		if toggle then
			UseActiveAttackE()
		end
	end,
})

RightGroupbox:AddToggle("Auto Buff Wenda", {
	Text = "Auto Buff Wenda",
	Default = false,
	Tooltip = "Auto Buff Wenda",

	Callback = function(Value)
		toggle2 = Value
		if toggle2 then
			UseActiveAttackW()
		end
	end,
})

RightGroupbox:AddToggle("Auto Buff Leafy", {
	Text = "Auto Buff Leafy",
	Default = false,

	Callback = function(Value)
		toggle3 = Value
		if toggle3 then
			UseActiveAttackL()
		end
	end,
})

local Tabs = {
	Shop = Window:AddTab("Shop"),
}

local LeftGroupBox = Tabs.Shop:AddLeftGroupbox("Shop")

LeftGroupBox:AddDropdown("dropdownSelectItemToBuy", {
	Values = ValuesItemsToFeed,
	Default = "None",
	Multi = false,

	Text = "Select Item",

	Callback = function(Value)
		selectedItemToBuy = Value
	end,
})

LeftGroupBox:AddToggle("ABS", {
	Text = "Auto Buy",
	Default = false,

	Callback = function(Value)
		getgenv().autoBuy = Value
		autoBuy()
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

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "End", NoUI = true, Text = "Menu keybind" })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

--Save Settings
ThemeManager:SetFolder("Tempest Hub")
SaveManager:SetFolder("Tempest Hub/_AA_")

SaveManager:BuildConfigSection(TabsUI["UI Settings"])

ThemeManager:ApplyToTab(TabsUI["UI Settings"])

SaveManager:LoadAutoloadConfig()

local GameConfigName = "_AA_"
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