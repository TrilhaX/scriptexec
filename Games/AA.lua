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

function placeInRedZones()
	while getgenv().placeInRedZones == true do
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
                            unit._hitbox.Size = Vector3.new(0, 0, 0)
                            found = true
						end
					end
				end
			end
		end
		
		local matchingUUIDs = checkEquippedAgainstOwned()
		if #matchingUUIDs > 0 then
			printUnitNames(matchingUUIDs)
		end	
		wait()
	end
end

function InfRange()
	while getgenv().InfRange == true do
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
					for _, unit in pairs(unitsFolder:GetChildren()) do
						local baseName = getBaseName(ownedUnit.unit_id)
						if baseName:lower() ~= "bulma" and baseName:lower() ~= "speedwagon" then
							if getBaseName(unit.Name) == baseName then
								local humanoidRootPart = unit:WaitForChild("HumanoidRootPart", 5)
								if humanoidRootPart then
									humanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
								end
							end
						end
					end
				end
			end
		end		

		local matchingUUIDs = checkEquippedAgainstOwned()
		if #matchingUUIDs > 0 then
			printUnitNames(matchingUUIDs)
		end
		wait()
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

		for _, v in pairs(game:GetService("Workspace")._UNITS:GetChildren()) do
			if v.Name == "erwin" and v._stats.player.Value == goat then
				table.insert(erwin1, v)
			end
		end


		if CheckErwinCount(erwin1) then

			for i, erwin in ipairs(erwin1) do
				if not toggle then
					break
				end

				local endpoints = game:GetService("ReplicatedStorage"):WaitForChild("endpoints")
				local client_to_server = endpoints:WaitForChild("client_to_server")
				local use_active_attack = client_to_server:WaitForChild("use_active_attack")


				use_active_attack:InvokeServer(erwin)
				wait(15.7)
			end
		end
		wait(2)
	end
end

function CheckWendyCount(wendyTable)
	return #wendyTable == 4
end

function UseActiveAttackW()
	local player = game.Players.LocalPlayer

	while toggle2 do
		repeat
			wait(1)
		until player and player.Character

		local wendy1 = {}

		for _, unit in pairs(game:GetService("Workspace")._UNITS:GetChildren()) do
			if (unit.Name == "wendy" or unit.Name == "wendy_halloween") and unit._stats.player.Value == player then
				table.insert(wendy1, unit)
			end
		end

		if CheckWendyCount(wendy1) then

			if not toggle2 then
				break
			end
			for _, wendyUnit in ipairs(wendy1) do
				game:GetService("ReplicatedStorage")
					:WaitForChild("endpoints")
					:WaitForChild("client_to_server")
					:WaitForChild("use_active_attack")
					:InvokeServer(wendyUnit)
				wait(15.8)
			end
		end
		wait(1)
	end
end

function CheckLeafyCount(leafy1)
	return #leafy1 == 4
end

function UseActiveAttackL()
	local goat = game.Players.LocalPlayer
	local leafy1 = {}

	while toggle3 do
		leafy1 = {}

		for _, v in pairs(game:GetService("Workspace")._UNITS:GetChildren()) do
			if v.Name == "leafy" and v._stats.player.Value == goat then
				table.insert(leafy1, v)
			end
		end


		if CheckLeafyCount(leafy1) then

			for i, leafy in ipairs(leafy1) do
				if not toggle3 then
					break
				end

				local endpoints = game:GetService("ReplicatedStorage"):WaitForChild("endpoints")
				local client_to_server = endpoints:WaitForChild("client_to_server")
				local use_active_attack = client_to_server:WaitForChild("use_active_attack")


				use_active_attack:InvokeServer(leafy)
				wait(15.7)
			end
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
	local notifications2 = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MessageGui")
	if notifications and notifications2 then
		notifications.Enabled = false
		notifications2.Enabled = false
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
		
		local unitTypes = {}
		
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
		
		function GetCFrame(position, rotationX, rotationY, isAerial)
			if isAerial then
				return CFrame.new(position.X, position.Y + 20, position.Z) * CFrame.Angles(math.rad(rotationX), math.rad(rotationY), 0)
			else
				return CFrame.new(position) * CFrame.Angles(math.rad(rotationX), math.rad(rotationY), 0)
			end
		end
		
		function alternarUnidadeTipo(unitID)
			if not unitTypes[unitID] then
				local isAerial = math.random() < 0.5
				unitTypes[unitID] = isAerial and "aerea" or "terrestre"
			end
		end
		
		function placeUnit(unitID, waypoint, radius)
			alternarUnidadeTipo(unitID)
			local isAerial = unitTypes[unitID] == "aerea"
			
			local spawnPosition = getRandomPositionAroundWaypoint(waypoint.Position, radius)
			local spawnCFrame = GetCFrame(spawnPosition, 0, 0, isAerial)

			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unitID, spawnCFrame)
		end
		
		if StatsServiceClient and StatsServiceClient.module and StatsServiceClient.module.session and StatsServiceClient.module.session.collection and StatsServiceClient.module.session.collection.collection_profile_data and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units then
			local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
			local waypoints = workspace._BASES.pve.LANES["1"]:GetChildren()
		
			local totalWaypoints = #waypoints
			local waypointStep = totalWaypoints / 100
			local radiusMax = 15
			local radiusStep = radiusMax / 100
		
			for _, unit in pairs(equippedUnits) do
				if type(unit) == "table" then
					for _, unitID in pairs(unit) do
						local selectedWaypointIndex = math.clamp(math.floor(selectedDistance * waypointStep), 1, totalWaypoints)
						local selectedRadius = math.clamp(selectedGroundDistance * radiusStep, 1, radiusMax)
						local waypoint = waypoints[selectedWaypointIndex]
						placeUnit(unitID, waypoint, selectedRadius)
					end
				else
					local selectedWaypointIndex = math.clamp(math.floor(selectedDistance * waypointStep), 1, totalWaypoints)
					local selectedRadius = math.clamp(selectedGroundDistance * radiusStep, 1, radiusMax)
					local waypoint = waypoints[selectedWaypointIndex]
					placeUnit(unit, waypoint, selectedRadius)
				end
			end
		end			
		wait(1)
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
			return string.match(unitName, "^(.-)_evolved$") 
				or string.match(unitName, "^(.-)_christmas$") 
				or string.match(unitName, "^(.-)_halloween$")
				or unitName
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
					local unitsToUpgrade = {}

					for _, unit in pairs(unitsFolder:GetChildren()) do
						if getBaseName(ownedUnit.unit_id) == getBaseName(unit.Name) then
							table.insert(unitsToUpgrade, unit)
						end
					end
		
					if #unitsToUpgrade > 0 then
						for _, unitInstance in pairs(unitsToUpgrade) do
							local args = {
								[1] = unitInstance
							}
		
							local success, err = pcall(function()
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("upgrade_unit_ingame"):InvokeServer(unpack(args))
							end)
		
							if not success then
								warn("Erro ao realizar upgrade da unidade:", err)
							end
						end
					end
				end
			end
		end
		
		local matchingUUIDs = checkEquippedAgainstOwned()
		if #matchingUUIDs > 0 then
			printUnitNames(matchingUUIDs)
		end		
        wait(1)
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

function dupeVegeto()
    while getgenv().dupeVegeto == true do
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

        local gokuSSJ3 = safeWaitForChild(workspace:WaitForChild("_UNITS"), "goku_ssj3", 5)
        if gokuSSJ3 then
            local args = { [1] = gokuSSJ3 }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end

        local vegetaMajin = safeWaitForChild(workspace:WaitForChild("_UNITS"), "vegeta_majin", 5)
        if vegetaMajin then
            local args = { [1] = vegetaMajin }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end

        local gokuSSJ3Dead = safeWaitForChild(game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"), "goku_ssj3", 5)
        if gokuSSJ3Dead then
            local args = { [1] = gokuSSJ3Dead }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end

        local vegetaMajinDead = safeWaitForChild(game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"), "vegeta_majin", 5)
        if vegetaMajinDead then
            local args = { [1] = vegetaMajinDead }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end
        wait()
    end
end

function dupeGriffith()
	while getgenv().dupeGriffith == true do
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
		
		local griffithNormal = safeWaitForChild(workspace:WaitForChild("_UNITS"), "femto_egg", 5)
        if griffithNormal then
            local args = { [1] = griffithNormal }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end
		local griffithDead = safeWaitForChild(game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"), "femto_egg", 5)
        if griffithDead then
            local args = { [1] = griffithDead }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end
		wait()
	end
end

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local resultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Results")

        local numberAndAfter = {}
        local statsString = {}
        local mapConfigString = {}
        local ValuesRewards = {}
    	local ValuesStatPlayer = {}    
		
		if resultUI and resultUI.Enabled == true then
            local name = game:GetService("Players").LocalPlayer.Name
            local formattedName = "||" .. name .. "||"

            local levelText = game:GetService("Players").LocalPlayer.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text
            local numberAndAfter = levelText:sub(7)

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

            local gems = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data.gem_amount 
            local gold = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data.gold_amount 
            local holiday = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceHolidayStars").Value
            local candie = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceCandies").Value

            local ValuesRewards = {}
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
                            table.insert(ValuesRewards, gainedAmount .. " " ..  frame.Name .. "\n")
                        end
                    end
                end
            end

            local rewardsString = table.concat(ValuesRewards, "\n")

            function formatNumber(num)
                if num >= 1000 then
                    local suffix = "k"
                    local formatted = num / 1000
                    if formatted % 1 == 0 then
                        return formatted .. suffix
                    else
                        return string.format("%.1fk", formatted)
                    end
                else
                    return tostring(num)
                end
            end
            
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
            
            local clientService = Modules["CLIENT_SERVICE"]
            local ValuesUnitInfo = {}
            
            if clientService and clientService["StatsServiceClient"] then
                local statsServiceClient = clientService["StatsServiceClient"].module
                local collectionData = statsServiceClient.session.collection.collection_profile_data
            
                if collectionData and collectionData.owned_units then
                    local ownedUnits = collectionData.owned_units
                    local equippedUnits = collectionData.unit_ingame_levels
                    for _, unit in pairs(ownedUnits) do
                        if type(unit) == "table" then
                            local unitId = unit.unit_id
                            local totalKills = unit.total_kills
                            local worthness = unit.stat_luck
                            if worthness == nil then
                                worthness = 0
                                totalKills = 0
                            end
                            if equippedUnits[unitId] then
                                local formattedUnitInfo = unitId .. " = " .. formatNumber(totalKills) .. ":crossed_swords: [" .. formatNumber(worthness) .. "% W]\n"
                                table.insert(ValuesUnitInfo, formattedUnitInfo)
                            end
                        end
                    end
                else
                    warn("Nenhum dado encontrado em 'owned_units'.")
                end
            else
                warn("CLIENT_SERVICE ou StatsServiceClient não encontrado.")
            end            
            
            local unitInfo = table.concat(ValuesUnitInfo)                   
            
            local ResultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
            local act = ResultUI.Holder.LevelName.Text

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
            
            local levelDataRemote = workspace._MAP_CONFIG:WaitForChild("GetLevelData")
            local levelData = levelDataRemote:InvokeServer()
            
            if type(levelData) == "table" then
                local difficulty = levelData["_difficulty"]
                local locationName = levelData["_location_name"]
                local name = levelData["name"]
            

                if difficulty and name and locationName then
                    local FormattedFinal = formattedTime .. " - " .. result .. "\n" .. locationName .. " - " .. name .. " [" .. difficulty .. "] "
                    table.insert(ValuesMapConfig, FormattedFinal)
                end
            end            

            local mapConfigString = table.concat(ValuesMapConfig, "\n")

            local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("GameLevelInfo")
            local cardsEffect = {}
            
            if gui and gui.Enabled then
                local list = gui:FindFirstChild("List_rg")
                if list and list.Visible then
                    local buffs = list:FindFirstChild("Buffs")
                    if buffs then 
                        for _, v in pairs(buffs:GetChildren()) do
                            if v:IsA("TextLabel") then
                                table.insert(cardsEffect, v.Text)
                            end
                        end
                    end
                end
            end
            
            if #cardsEffect == 0 then
                cardsEffect = {"No card"}
            end
            
            local cards = table.concat(cardsEffect, "\n")
            
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
                content = pingcontent,
                embeds = {
                    {
                        description = "User: " .. formattedName .. "\nLevel: " .. numberAndAfter .. " || [1111/1123] ||",
                        color = color,
                        fields = {
                            {
                                name = "Player Stats",
                                value = string.format("<:gemsAA:1322365177320177705> %s\n <:goldAA:1322369598015668315> %s\n<:holidayEventAA:1322369599517491241> %s\n<:candieAA:1322369601182629929> %s\n", gems, gold, holiday, candie),
                                inline = true
                            },
                            {
                                name = "Rewards",
                                value = string.format("%s",  rewardsString),
                                inline = true
                            },
                            {
                                name = "Units",
                                value = string.format("%s", unitInfo)
                            },
                            {
                                name = "Card Effects",
                                value = string.format("%s", cards)
                            },
                            {
                                name = "Match Result",
                                value = string.format("%s", mapConfigString)
                            }
                        },
                        author = {
                            name = "Anime Adventures"
                        },
                        footer = {
                            text = "https://discord.gg/MfvHUDp5XF - Tempest Hub"
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                        thumbnail = {
                            url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png"
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

LeftGroupBox:AddToggle("HidePlayerInfo", {
	Text = "Hide Player Info",
	Default = false,
	Callback = function(Value)
		getgenv().hideInfoPlayer = Value
		hideInfoPlayer()
	end,
})

LeftGroupBox:AddToggle("SecurityMode", {
	Text = "Security Mode",
	Default = false,
	Callback = function(Value)
		getgenv().securityMode = Value
		securityMode()
	end,
})

LeftGroupBox:AddToggle("DeleteMap", {
	Text = "Delete Map",
	Default = false,
	Callback = function(Value)
		getgenv().deletemap = Value
		deletemap()
	end,
})

LeftGroupBox:AddToggle("AutoLeave", {
	Text = "Auto Leave",
	Default = false,
	Callback = function(Value)
		getgenv().autoleave = Value
		autoleave()
	end,
})

LeftGroupBox:AddToggle("AutoReplay", {
	Text = "Auto Replay",
	Default = false,
	Callback = function(Value)
		getgenv().autoreplay = Value
		autoreplay()
	end,
})

LeftGroupBox:AddToggle("AutoNext", {
	Text = "Auto Next",
	Default = false,
	Callback = function(Value)
		getgenv().autonext = Value
		autonext()
	end,
})

LeftGroupBox:AddToggle("AutoStart", {
	Text = "Auto Start",
	Default = false,
	Callback = function(Value)
		getgenv().autostart = Value
		autostart()
	end,
})

LeftGroupBox:AddToggle("AutoSkipWave", {
	Text = "Auto Skip Wave",
	Default = false,
	Callback = function(Value)
		getgenv().autoskipwave = Value
		autoskipwave()
	end,
})

local TabBox2 = Tabs.Main:AddRightTabbox()

local Tab1 = TabBox2:AddTab("Extra")

Tab1:AddToggle("autoGetBattlepass", {
	Text = "Auto Get Battlepass",
	Default = false,
	Callback = function(Value)
		getgenv().autoGetBattlepass = Value
		autoGetBattlepass()
	end,
})

Tab1:AddToggle("DisableNotifications", {
	Text = "Disable Notifications",
	Default = false,
	Callback = function(Value)
		getgenv().disableNotifications = Value
		disableNotifications()
	end,
})

Tab1:AddToggle("PlaceInRedZones", {
	Text = "Place In Red Zones",
	Default = false,
	Callback = function(Value)
		getgenv().placeInRedZones = Value
		placeInRedZones()
	end,
})

Tab1:AddToggle("DupeVegeto", {
	Text = "Dupe Griffith",
	Default = false,
	Callback = function(Value)
		getgenv().dupeGriffith = Value
		dupeGriffith()
	end,
})

Tab1:AddToggle("DupeVegeto", {
	Text = "Dupe Vegeto",
	Default = false,
	Callback = function(Value)
		getgenv().dupeVegeto = Value
		dupeVegeto()
	end,
})

Tab1:AddToggle("InfRange", {
	Text = "Inf Range",
	Default = false,
	Callback = function(Value)
		getgenv().InfRange = Value
		InfRange()
	end,
})

Tab1:AddToggle("FriendsOnly", {
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
	Text = "Select Capsule to Open",
	Callback = function(Value)
		selectedCapsule = Value
	end,
})

Tab1:AddToggle("AutoOpenCapsule", {
	Text = "Auto Open Capsule",
	Default = false,
	Callback = function(Value)
		getgenv().autoOpenCapsule = Value
		autoOpenCapsule()
	end,
})

local Tab2 = TabBox2:AddTab("Event")

Tab2:AddToggle("AutoJoinCursedWomb", {
	Text = "Auto Join Cursed Womb",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinCursedWomb = Value
		autoJoinCursedWomb()
	end,
})

Tab2:AddToggle("AutoJoinHalloweenEvent", {
	Text = "Auto Join Halloween Event",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinHalloweenEvent = Value
		autoJoinHalloweenEvent()
	end,
})

Tab2:AddToggle("AutoJoinHolidayEvent", {
	Text = "Auto Join Holiday Event",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinHolidayEvent = Value
		autoJoinHolidayEvent()
	end,
})


Tab2:AddToggle("AutoMatchmakingHalloweenEvent", {
	Text = "Auto Matchmaking Halloween Event",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinHalloweenEvent = Value
		autoJoinHalloweenEvent()
	end,
})

Tab2:AddToggle("AutoMatchmakingHolidayEvent", {
	Text = "Auto Matchmaking Holiday Event",
	Default = false,
	Callback = function(Value)
		getgenv().matchmakingHoliday = Value
		autoMatchmakingHolidayEvent()
	end,
})

Tab2:AddToggle("AutoGivePresents", {
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

LeftGroupBox:AddToggle("WebhookFinishGame", {
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

Tab2:AddToggle("AutoFeed", {
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

LeftGroupBox:AddToggle("AutoEnter", {
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

RightGroupbox:AddToggle("AutoEnterChallenge", {
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

LeftGroupBox:AddSlider('distancePercentage', {
	Text = 'Distance Percentage',
	Default = 0,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		selectedDistance = Value
	end
})

LeftGroupBox:AddSlider('GroundPercentage', {
	Text = 'Ground Percentage',
	Default = 0,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		selectedGroundDistance = Value
	end
})

LeftGroupBox:AddSlider('GroundPercentage', {
	Text = 'Hill Percentage',
	Default = 0,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Compact = false,
	Callback = function(Value)
		selectedHillDistance = Value
	end
})

LeftGroupBox:AddToggle("AutoPlace", {
	Text = "Auto Place",
	Default = false,
	Callback = function(Value)
		getgenv().autoPlace = Value
		if Value then
			autoPlace()
		end
	end,
})

LeftGroupBox:AddToggle("OnlyStartPlaceInXWave", {
	Text = "Only Start Place in X Wave",
	Default = false,

	Callback = function(Value)
		getgenv().autoPlace = Value
		autoPlace()
	end,
})

LeftGroupBox:AddInput('inputAutoUpgradeWaveX', {
    Default = '',
    Text = "Start Upgrade at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveToUpgrade = Value
    end
})

LeftGroupBox:AddToggle("AutoUpgrade", {
	Text = "Auto Upgrade",
	Default = false,

	Callback = function(Value)
		getgenv().autoUpgrade = Value
		autoUpgrade()
	end,
})

LeftGroupBox:AddToggle("OnlyUpgradeInXWave", {
	Text = "Only Upgrade in X Wave",
	Default = false,

	Callback = function(Value)
		getgenv().onlyupgradeinXwave = Value
	end,
})

LeftGroupBox:AddInput('inputAutoSellWaveX', {
    Default = '',
    Text = "Start Sell at x Wave",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        selectedWaveToSell = Value
    end
})

LeftGroupBox:AddToggle("AutoSell", {
	Text = "Auto Sell",
	Default = false,

	Callback = function(Value)
		getgenv().autoSell = Value
		autoSell()
	end,
})

LeftGroupBox:AddToggle("OnlySellInXWave", {
	Text = "Only Sell in X Wave",
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

RightGroupbox:AddToggle("AutoBuffErwin", {
	Text = "Auto Universal Skill",
	Default = false,

	Callback = function(Value)
		getgenv().universalSkill = Value
		universalSkill()
	end,
})

RightGroupbox:AddToggle("AutoUpgrade", {
	Text = "Only Universal Skill in X Wave",
	Default = false,

	Callback = function(Value)
		getgenv().universalSkillinXWave = Value
	end,
})

RightGroupbox:AddToggle("AutoBuffErwin", {
	Text = "Auto Buff Erwin",
	Default = false,

	Callback = function(Value)
		toggle = Value
		if toggle then
			UseActiveAttackE()
		end
	end,
})

RightGroupbox:AddToggle("AutoBuffWenda", {
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

RightGroupbox:AddToggle("AutoBuffLeafy", {
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

LeftGroupBox:AddToggle("AutoBuy", {
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

MenuGroup:AddToggle("HideUiWhenExecute", {
	Text = "Hide UI When Execute",
	Default = false,
	Callback = function(Value)
		getgenv().hideUIExec = Value
		hideUIExec()
	end,
})

MenuGroup:AddToggle("AutoExecute", {
	Text = "Auto Execute",
	Default = false,
	Callback = function(Value)
		getgenv().aeuat = Value
		aeuat()
	end,
})

MenuGroup:AddToggle("BlackScreen", {
	Text = "Blackscreen",
	Default = false,
	Callback = function(Value)
		blackScreen()
	end,
})

MenuGroup:AddToggle("FPSBoost", {
	Text = "FPS Boost",
	Default = false,
	Callback = function(Value)
        getgenv().extremeFpsBoost = Value
		extremeFpsBoost()
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
createBC()
