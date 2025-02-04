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
local selectedMapChallenges = {}
local selectedChallengesDiff = {}
local selectedTierContract = {}
local selectedIgnoreContractChallenge = {}
local selectedIgnoreDmgBonus = {}
local selectedTierPortal = {}
local selectedPortalDiff = {}
local selectedPassiveToRoll = {}
local dmgBonus = {"None", "air", "physical", "light", "fire", "storm", "dark", "magic", "aqua"}
local passivesValues = {"superior 1", "range 1", "nimble 1", "superior 2", "range 2", "nimble 2", "superior 3", "range 3", "nimble 3", "adept 1", "culling 1", "sniper 1", "godspeed 1", "reaper 1", "celestial 1", "divine 1", "golden 1", "unique 1"}
local shardsValues = {"nagumo_shard", "madoka_portal_shard", "dazai_shard", "relic_shard"}
local chosenCard = nil
local selectedPriorities = {
    Buff = {},
    Debuff = {}
}
local Cards = {
    Buff = {
        "+ Attack I", "+ Attack II", "+ Attack III",
        "+ Boss Damage I", "+ Boss Damage II", "+ Boss Damage III",
        "+ Gain 2 Random Effects Tier 1", "+ Gain 2 Random Effects Tier 2", "+ Gain 2 Random Effects Tier 3",
        "+ Range I", "+ Range II", "+ Range III",
        "+ Random Blessings I", "+ Random Blessings II", "+ Random Blessings III",
        "+ Yen I", "+ Yen II", "+ Yen III",
        "- Cooldown I", "- Cooldown II", "- Cooldown III",
        "- Active Cooldown I", "- Active Cooldown II", "- Active Cooldown III",
        "+ Double Attack, Half Range", "+ Double Attack, Double Cooldown",
        "+ Double Attack", "+ Double Range"
    },
    Debuff = {
        "+ Enemy Health I", "+ Enemy Health II", "+ Enemy Health III",
        "+ Enemy Shield I", "+ Enemy Shield II", "+ Enemy Shield III",
        "+ Enemy Speed I", "+ Enemy Speed II", "+ Enemy Speed III",
        "+ Enemy Regen I", "+ Enemy Regen II", "+ Enemy Regen III",
        "+ Explosive Deaths I", "+ Explosive Deaths II", "+ Explosive Deaths III",
        "+ New Path",
        "+ Random Curses I", "+ Random Curses II", "+ Random Curses III"
    }
}

--START OF FUNCTIONS

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

function showInfoUnits()
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
				local unitInMap = false
				for _, unit in pairs(unitsFolder:GetChildren()) do
					if getBaseName(ownedUnit.unit_id) == getBaseName(unit.Name) then
						unitInMap = true
						local billboardGui = unit:FindFirstChild("BillboardGui")
						if billboardGui then
                            billboardGui.Enabled = not billboardGui.Enabled
                        end
					end
				end
				
				if not unitInMap then
					print("Unit", ownedUnit.unit_id, "not found in the map.")
				end
			end
		end
	end

	local matchingUUIDs = checkEquippedAgainstOwned()
	if #matchingUUIDs > 0 then
		printUnitNames(matchingUUIDs)
	end
end

function createBC()
    local existingScreenGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("BlackScreenTempestHub")
    if existingScreenGui then
        return
    end
    
    local player = game:GetService("Players").LocalPlayer
    local screengui = Instance.new("ScreenGui")
    local BackgroundFrame = Instance.new("Frame")
    local statFrame = Instance.new("Frame")
    local border = Instance.new("UICorner")
    
    local levelLabel = Instance.new("TextLabel")
    local gemsLabel = Instance.new("TextLabel")
    local goldLabel = Instance.new("TextLabel")
    local holidayLabel = Instance.new("TextLabel")
    local assassinLabel = Instance.new("TextLabel")
    
    screengui.Name = "BlackScreenTempestHub"
    screengui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
    screengui.Enabled = false
    
    BackgroundFrame.Name = "BackgroundFrame"
    BackgroundFrame.Parent = screengui
    BackgroundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    BackgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    BackgroundFrame.BorderSizePixel = 0
    BackgroundFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    BackgroundFrame.Size = UDim2.new(1, 0, 2, 0)
    
    statFrame.Name = "statFrame"
    statFrame.Parent = BackgroundFrame
    statFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    statFrame.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
    statFrame.BorderSizePixel = 0
    statFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    statFrame.Size = UDim2.new(0, 850, 0, 550)
    
    border.Parent = statFrame
    
    function createLabel(name, positionY)
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
    
    nameLabel = createLabel("nameLabel", 0.1)
    nameLabel.Text = "Tempest Hub"
    
    levelLabel = createLabel("levelLabel", 0.25)
    gemsLabel = createLabel("gemsLabel", 0.4)
    goldLabel = createLabel("goldLabel", 0.55)
    holidayLabel = createLabel("holidayLabel", 0.7)
    assassinLabel = createLabel("assassinLabel", 0.85)

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

    local sakamotoCoin = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.inventory.inventory_profile_data.normal_items.sakamoto_coin
    
    function updateStats()
        local levelText = player.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text
        local levelValue = levelText:sub(7)
        levelLabel.Text = "Level: " .. levelValue
    
        local gemsAmount = player._stats:FindFirstChild("gem_amount")
        gemsLabel.Text = "Gems: " .. (gemsAmount and gemsAmount.Value or "0")
    
        local goldAmount = player._stats:FindFirstChild("gold_amount")
        goldLabel.Text = "Gold: " .. (goldAmount and goldAmount.Value or "0")
    
        local holidayAmount = player._stats:FindFirstChild("_resourceHolidayStars")
        holidayLabel.Text = "Holiday Stars: " .. (holidayAmount and holidayAmount.Value or "0")
    
        local assassinAmount = player._stats:FindFirstChild("assassin_token")
        assassinLabel.Text = "Assassin Token: " .. (sakamotoCoin or "0")
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        updateStats()
    end)
end

function createInfoUnit()
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
				local unitInMap = false
				for _, unit in pairs(unitsFolder:GetChildren()) do
					if getBaseName(ownedUnit.unit_id) == getBaseName(unit.Name) then
						unitInMap = true
						local totalKills = ownedUnit.total_kills or 0
						local worthness = ownedUnit.stat_luck or 0
						local billboardGui = Instance.new("BillboardGui")
						billboardGui.Adornee = unit
						billboardGui.Size = UDim2.new(0, 250, 0, 75)
						billboardGui.StudsOffset = Vector3.new(0, 2, 0)

						local textLabel = Instance.new("TextLabel")
						textLabel.Parent = billboardGui
						textLabel.Size = UDim2.new(1, 0, 1, 0)
						textLabel.BackgroundTransparency = 1
						textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						textLabel.TextStrokeTransparency = 0.6
						textLabel.TextSize = 18 
						textLabel.Text = "Total Kills: " .. (totalKills or 0) .. "\nWorthness: " .. (worthness or 0) .. "%"
						billboardGui.Parent = unit
						billboardGui.Enabled = false
					end
				end
				
				if not unitInMap then
					print("Unit", ownedUnit.unit_id, "not found in the map.")
				end
			end
		end
	end

	local matchingUUIDs = checkEquippedAgainstOwned()
	if #matchingUUIDs > 0 then
		printUnitNames(matchingUUIDs)
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
	while getgenv().fpsBoost == true do
		removeTexturesAndHeavyObjects(workspace)
		wait()
	end
end

function betterFpsBoost()
	while getgenv().betterFpsBoost == true do
		removeTexturesAndHeavyObjects(workspace)
		local enemiesAndUnits = workspace:FindFirstChild("_UNITS")

		if enemiesAndUnits then
			for i,v in pairs(enemiesAndUnits:GetChildren())do
				v:Destroy()
			end
		end
		wait()
	end
end

function extremeFpsBoost()
    while getgenv().extremeFpsBoost == true do
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
		wait()
    end
end

function autoWalk()
	while getgenv().autoWalk == true do
		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
		wait(1)
		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.S, false, game)
		wait(1)
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
		if #players:GetPlayers() >= selecteQuantityPlayer then
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
		wait(1)
		local map = workspace:FindFirstChild("_map")

		if map then
			for i,v in pairs(map:GetChildren())do
				if v.Name ~= "bottom" then
					v:Destroy()
				end
			end
		end
	end
end

function hideInfoPlayer()
	if getgenv().hideInfoPlayer == true then
		local players = game.Players
		local player = players.LocalPlayer
		local character = player.Character
		local gui = player.PlayerGui
		
		if player and character then
			local overhead = character.Head:FindFirstChild("_overhead")
			local unitsGui = gui.spawn_units.Lives.Frame:FindFirstChild("Units")
			local resources = gui.spawn_units.Lives.Frame:FindFirstChild("Resource")
			local limitBreak = gui.spawn_units.Lives.Frame:FindFirstChild("LimitBreaks")
			local levelGui = gui.spawn_units.Lives:FindFirstChild("Main")
			local petInGame = workspace.TRILHA_444:FindFirstChild("_pets_folder")
		
			if overhead then
				overhead.Frame.Visible = false
			end
			for _, obj in ipairs(character:GetChildren()) do
				if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") then
					obj:Destroy()
				end
			end
			if unitsGui and levelGui and resources and limitBreak then
				local desc = levelGui:FindFirstChild("Desc")
				local health = levelGui:FindFirstChild("Health")
				local gem = resources:FindFirstChild("Gem")
				local gold = resources:FindFirstChild("Gold")
				local holidayStars = resources:FindFirstChild("HolidayStars")
				for i, v in pairs(unitsGui:GetChildren()) do
					if v.Name ~= "UIListLayout" then
						local main = v:FindFirstChild("Main")
						local cost = v:FindFirstChild("Cost")
						local evolvedGlow = v:FindFirstChild("EvolvedGlow")
						local border = v:FindFirstChild("Border")
		
						if main then
							local view = main:FindFirstChild("View")
							local level = main:FindFirstChild("Level")
							local evolvedShine = main:FindFirstChild("EvolvedShine")
							local traitIcons = main:FindFirstChild("TraitIcons")
		
							if view then view.Visible = false end
							if level then level.Visible = false end
							if evolvedShine then evolvedShine.Visible = false end
							if traitIcons then traitIcons.Visible = false end
						end
						if cost then
							local text = cost:FindFirstChild("text")
							if text then text.Text = "99999" end
						end
						if evolvedGlow then
							evolvedGlow.Visible = false
						end
						if border then
							border.Enabled = false
						end
					end
				end
				limitBreak.Boost.Text = "99999"
				if gem and gold and holidayStars then
					gem.Level.Text = "99999"
					gold.Level.Text = "99999"
					holidayStars.Level.Text = "99999"
				end
				if desc and health then
					desc.Visible = false
					health.Visible = false
				end
			end
			if petInGame then
				for _, obj in ipairs(petInGame:GetDescendants()) do
					obj.HumanoidRootPart._overhead.OverFrame.Visible = false
					local model = obj:FindFirstChild("Model")
					local fakeHead = obj.fakehead:FindFirstChild("Decal")
					if model then
						model:Destroy()
					end
					if fakeHead then
						fakeHead:Destroy()
					end
				end
			end
		end
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
					for _, unit in pairs(unitsFolder:GetChildren()) do
						if getBaseName(ownedUnit.unit_id) == getBaseName(unit.Name) then
							local hitbox = unit:FindFirstChild("_hitbox")
							if hitbox then
								hitbox.Size = Vector3.new(0, 0, 0)
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

function UpdatePriorityList(category, selectedList)
    selectedPriorities[category] = selectedList
end

function autoChooseCard()
    while getgenv().autoChooseCard == true do
        local player = game:GetService("Players").LocalPlayer
        local itemsFrame = player.PlayerGui.RoguelikeSelect.Main.Main.Items
        local foundCards = {}
        local cardPositions = {}
        local index = 1
        for _, frame in ipairs(itemsFrame:GetChildren()) do
            if frame:IsA("Frame") and frame:FindFirstChild("bg") and frame.bg:FindFirstChild("Main") and frame.bg.Main:FindFirstChild("Title") and frame.bg.Main.Title:FindFirstChild("TextLabel") then
                local cardName = frame.bg.Main.Title.TextLabel.Text
                foundCards[index] = cardName
                cardPositions[cardName] = index
                index = index + 1
            end
        end

        local chosenCard = nil
        local chosenCardPosition = nil

        if getgenv().focusBuff then
            for pos, availableCard in pairs(foundCards) do
                for _, priorityBuff in ipairs(selectedPriorities.Buff) do
                    if availableCard == priorityBuff then
                        chosenCard = availableCard
                        chosenCardPosition = pos
                        break
                    end
                end
                if chosenCard then break end
            end
        end

        if not chosenCard and getgenv().focusDebuff then
            for pos, availableCard in pairs(foundCards) do
                for _, priorityDebuff in ipairs(selectedPriorities.Debuff) do
                    if availableCard == priorityDebuff then
                        chosenCard = availableCard
                        chosenCardPosition = pos
                        break
                    end
                end
                if chosenCard then break end
            end
        end

        if not chosenCard then
            for pos, availableCard in pairs(foundCards) do
                for _, priorityBuff in ipairs(selectedPriorities.Buff) do
                    if availableCard == priorityBuff then
                        chosenCard = availableCard
                        chosenCardPosition = pos
                        break
                    end
                end
                if chosenCard then break end
            end
        end

        if not chosenCard then
            for pos, availableCard in pairs(foundCards) do
                for _, priorityDebuff in ipairs(selectedPriorities.Debuff) do
                    if availableCard == priorityDebuff then
                        chosenCard = availableCard
                        chosenCardPosition = pos
                        break
                    end
                end
                if chosenCard then break end
            end
        end

        if chosenCard then
            local args = {
                [1] = tostring(chosenCardPosition)
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("select_roguelike_option"):InvokeServer(unpack(args))            
        end
        wait()
    end
end

function autoGetQuest()
	while getgenv().autoGetQuest == true do
		local quests = {
			game:GetService("Players").LocalPlayer.PlayerGui.QuestsUI.Main.Main.Main.Content.daily:FindFirstChild("Scroll"),
			game:GetService("Players").LocalPlayer.PlayerGui.QuestsUI.Main.Main.Main.Content.event:FindFirstChild("Scroll"),
			game:GetService("Players").LocalPlayer.PlayerGui.QuestsUI.Main.Main.Main.Content.infinite:FindFirstChild("Scroll"),
			game:GetService("Players").LocalPlayer.PlayerGui.QuestsUI.Main.Main.Main.Content.story:FindFirstChild("Scroll")
		}
		
		for _, quest in pairs(quests) do
			if quest then
				for _, child in pairs(quest:GetChildren()) do
					if child.Name ~= "UIListLayout" and child.Name ~= "RefreshFrame" and child.Name ~= "Empty" then
						local args = {
							[1] = child
						}
						
						game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("redeem_quest"):InvokeServer(unpack(args))						
					end
				end
			end
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

function autoEnterChallenge()
    while getgenv().autoEnterChallenge == true do
        local level = workspace._CHALLENGES.Challenges._lobbytemplate315:FindFirstChild("Level")
        local challenge = workspace._CHALLENGES.Challenges._lobbytemplate315:FindFirstChild("Challenge")
        if level and challenge then
            for _, map in pairs(selectedMapChallenges) do
                for _, diff in pairs(selectedChallengesDiff) do
                    if level.Value == map and challenge.Value == diff then
						local args = {
							[1] = "_lobbytemplate315"
						}
						
						game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_join_lobby"):InvokeServer(unpack(args))						
                    end
                end
            end
        end
        wait()
    end
end

function autoEnterDailyChallenge()
	while getgenv().autoEnterDailyChallenge == true do
		local args = {
			[1] = "_lobbytemplate320"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_join_lobby"):InvokeServer(unpack(args))		
		wait()
	end
end

function autoMatchmakingDailyChallenge()
	while getgenv().autoMatchmakingDailyChallenge == true do
		game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer("__DAILY_CHALLENGE")
		wait()
	end
end

function autoEnterInfiniteCastle()
	while getgenv().autoEnterInfiniteCastle == true do
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
		local lastInfcastle = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data.level_data.infinite_tower.floor_reached
		if selectedHardInfCastle == true then
			local args = {
				[1] = lastInfcastle,
				[2] = "Hard"
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_start_infinite_tower"):InvokeServer(unpack(args))
		else
			local args = {
				[1] = lastInfcastle,
				[2] = "Normal"
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_start_infinite_tower"):InvokeServer(unpack(args))
		end
		wait()
	end
end

function autoEnterRaid()
	while getgenv().autoEnterRaid == true do
		if selectedFriendsOnly == true then
			local args = {
				[1] = "_lobbytemplate210"
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_join_lobby"):InvokeServer(unpack(args))
			wait(1)
			local args = {
				[1] = "_lobbytemplate210",
				[2] = selectedRaidMap,
				[3] = true,
				[4] = "Hard"
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_lock_level"):InvokeServer(unpack(args))
			local args = {
				[1] = "_lobbytemplate210",
			}
	
			game:GetService("ReplicatedStorage")
				:WaitForChild("endpoints")
				:WaitForChild("client_to_server")
				:WaitForChild("request_start_game")
				:InvokeServer(unpack(args))
		else
			local args = {
				[1] = "_lobbytemplate210"
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_join_lobby"):InvokeServer(unpack(args))
			wait(1)
			local args = {
				[1] = "_lobbytemplate210",
				[2] = selectedRaidMap,
				[3] = false,
				[4] = "Hard"
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_lock_level"):InvokeServer(unpack(args))
			wait(1)
			local args = {
				[1] = "_lobbytemplate210",
			}
	
			game:GetService("ReplicatedStorage")
				:WaitForChild("endpoints")
				:WaitForChild("client_to_server")
				:WaitForChild("request_start_game")
				:InvokeServer(unpack(args))
		end
		wait()
	end
end

function autoEnterLegendStage()
	while getgenv().autoEnterLegendStage == true do
		local args = {
			[1] = "_lobbytemplategreen1",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("request_join_lobby")
			:InvokeServer(unpack(args))
		wait(1)
		if selectedFriendsOnly == true then
			local args = {
				[1] = "_lobbytemplategreen1",
				[2] = selectedLegendStageMap,
				[3] = true,
				[4] = "Hard",
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("endpoints")
				:WaitForChild("client_to_server")
				:WaitForChild("request_lock_level")
				:InvokeServer(unpack(args))
		else
			local args = {
				[1] = "_lobbytemplategreen1",
				[2] = selectedLegendStageMap,
				[3] = false,
				[4] = "Hard",
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
		wait()
	end
end

function autoEnterPortal()
    while getgenv().autoEnterPortal == true do
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local endpoints = ReplicatedStorage:WaitForChild("endpoints")
        local client_to_server = endpoints:WaitForChild("client_to_server")
        local save_notifications_state = client_to_server:WaitForChild("save_notifications_state")

        local args = { [1] = "Items", [2] = 0 }
        save_notifications_state:InvokeServer(unpack(args))

        wait(1)

        local Loader = require(ReplicatedStorage.src.Loader)
        local upvalues = debug.getupvalues(Loader.init)

        local Modules = {
            ["CORE_CLASS"] = upvalues[6],
            ["CORE_SERVICE"] = upvalues[7],
            ["SERVER_CLASS"] = upvalues[8],
            ["SERVER_SERVICE"] = upvalues[9],
            ["CLIENT_CLASS"] = upvalues[10],
            ["CLIENT_SERVICE"] = upvalues[11],
        }

        local uniqueItems = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.inventory.inventory_profile_data.unique_items

        if type(uniqueItems) == "table" then
            for _, item in pairs(uniqueItems) do
                if item.uuid then
                    local uniqueItemData = item._unique_item_data
                    if uniqueItemData and uniqueItemData._unique_portal_data then
                        local portalData = uniqueItemData._unique_portal_data
                        
                        if portalData.level_id and portalData.portal_depth and portalData._weak_against and portalData._weak_against[1] and portalData._weak_against[1].damage_type then
                            for _, tier in pairs(selectedTierPortal) do
                                tier = tostring(tier)
                                for _, IgnoreDmgBonus in pairs(selectedIgnoreDmgBonus) do
                                    IgnoreDmgBonus = tostring(IgnoreDmgBonus)
										for _, IgnoreChallenge in pairs(selectedPortalDiff) do
										IgnoreChallenge = tostring(IgnoreChallenge)
                                        
										if IgnoreChallenge == "" or IgnoreChallenge == nil or IgnoreChallenge == "None" then
											if IgnoreDmgBonus == "" or IgnoreDmgBonus == nil or IgnoreDmgBonus == "None" then
												if tostring(portalData.level_id) == tostring(selectedPortalMap) and tostring(portalData.portal_depth) == tier then
													local args = {
														[1] = tostring(item.uuid),
														[2] = (getgenv().FriendsOnly and {["friends_only"] = true}) or nil
													}
													client_to_server:WaitForChild("use_portal"):InvokeServer(unpack(args))
												end
											else
												if tostring(portalData.level_id) == tostring(selectedPortalMap) and tostring(portalData.portal_depth) == tier and tostring(portalData._weak_against[1].damage_type) ~= IgnoreDmgBonus then
													local args = {
														[1] = tostring(item.uuid),
														[2] = (getgenv().FriendsOnly and {["friends_only"] = true}) or nil
													}
													client_to_server:WaitForChild("use_portal"):InvokeServer(unpack(args))
												end
											end
										else
											if IgnoreDmgBonus == "" or IgnoreDmgBonus == nil or IgnoreDmgBonus == "None" then
												if tostring(portalData.level_id) == tostring(selectedPortalMap) and tostring(portalData.portal_depth) == tier then
													local args = {
														[1] = tostring(item.uuid),
														[2] = (getgenv().FriendsOnly and {["friends_only"] = true}) or nil
													}
													client_to_server:WaitForChild("use_portal"):InvokeServer(unpack(args))
												end
											else
												if tostring(portalData.level_id) == tostring(selectedPortalMap) and tostring(portalData.portal_depth) == tier and tostring(portalData._weak_against[1].damage_type) ~= IgnoreDmgBonus then
													local args = {
														[1] = tostring(item.uuid),
														[2] = (getgenv().FriendsOnly and {["friends_only"] = true}) or nil
													}
													client_to_server:WaitForChild("use_portal"):InvokeServer(unpack(args))
												end
											end
										end										
									end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait()
    end
end

function autoNextContrato()
	while getgenv().autoNextContrato == true do
		local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI
		if resultUI and resultUI.Enabled == true then
			local scroll = game:GetService("Players").LocalPlayer.PlayerGui.ContractsUI.Main.Main.Frame.Outer.main.Scroll
			local remoteSent = false

			for _, v in pairs(scroll:GetChildren()) do
				if v.Name == "MissionFrame" then

					if v.Main.Cleared.Visible ~= true then
						local player = game:GetService("Players").LocalPlayer
						local missionContainer = player.PlayerGui.ContractsUI.Main.Main.Frame.Outer.main.Scroll

						function findTextLabelByName(frame, name)
							for _, child in ipairs(frame:GetChildren()) do
								if child:IsA("TextLabel") and child.Name == name then
									return child
								end
								local result = findTextLabelByName(child, name)
								if result then
									return result
								end
							end
							return nil
						end

						local missionFrames = {}
						for _, frame in ipairs(missionContainer:GetChildren()) do
							if frame:IsA("Frame") then
								table.insert(missionFrames, frame)
							end
						end

						table.sort(missionFrames, function(a, b)
							return a.AbsolutePosition.X < b.AbsolutePosition.X
						end)

						for i, frame in ipairs(missionFrames) do

							local challenge = findTextLabelByName(frame, "Challenge")
							local difficulty = findTextLabelByName(frame, "Difficulty")

							if challenge and difficulty then

								local difficultyText = difficulty.Text:match("%d+")
								local challengeText = challenge.Text:lower():gsub(" ", "_")

									for _, map in pairs(selectedTierContract) do
										for _, diff in pairs(selectedIgnoreContractChallenge) do
											if difficultyText == tostring(map) and challengeText ~= tostring(diff) and not remoteSent then
												local args = {
													[1] = "eventcontract",
													[2] = {
														["_eventcontractslot"] = tostring(i)
													}
												}
												
												game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("set_game_finished_vote"):InvokeServer(unpack(args))
											remoteSent = true
										end
									end
								end
							end
						end
					end
				end
			end
		end
		wait()
	end
end

function autoNextPortal()
	while getgenv().autoNextPortal == true do
		local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI
		if resultUI and resultUI.Enabled == true then
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local endpoints = ReplicatedStorage:WaitForChild("endpoints")
			local client_to_server = endpoints:WaitForChild("client_to_server")
			local save_notifications_state = client_to_server:WaitForChild("save_notifications_state")
	
			local args = { [1] = "Items", [2] = 0 }
			save_notifications_state:InvokeServer(unpack(args))
	
			wait(1)
	
			local Loader = require(ReplicatedStorage.src.Loader)
			local upvalues = debug.getupvalues(Loader.init)
	
			local Modules = {
				["CORE_CLASS"] = upvalues[6],
				["CORE_SERVICE"] = upvalues[7],
				["SERVER_CLASS"] = upvalues[8],
				["SERVER_SERVICE"] = upvalues[9],
				["CLIENT_CLASS"] = upvalues[10],
				["CLIENT_SERVICE"] = upvalues[11],
			}
	
			local uniqueItems = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.inventory.inventory_profile_data.unique_items
	
			if type(uniqueItems) == "table" then
				for _, item in pairs(uniqueItems) do
					if item.uuid then
						local uniqueItemData = item._unique_item_data
						if uniqueItemData and uniqueItemData._unique_portal_data then
							local portalData = uniqueItemData._unique_portal_data
							
							if portalData.level_id and portalData.portal_depth and portalData._weak_against and portalData._weak_against[1] and portalData._weak_against[1].damage_type then
								for _, tier in pairs(selectedTierPortal) do
									tier = tostring(tier)
									for _, IgnoreDmgBonus in pairs(selectedIgnoreDmgBonus) do
										IgnoreDmgBonus = tostring(IgnoreDmgBonus)
											for _, IgnoreChallenge in pairs(selectedPortalDiff) do
											IgnoreChallenge = tostring(IgnoreChallenge)
											
											if IgnoreChallenge == "" or IgnoreChallenge == nil or IgnoreChallenge == "None" then
												if IgnoreDmgBonus == "" or IgnoreDmgBonus == nil or IgnoreDmgBonus == "None" then
													if tostring(portalData.level_id) == tostring(selectedPortalMap) and tostring(portalData.portal_depth) == tier then
														local args = {
															[1] = "replay",
															[2] = {
																["item_uuid"] = tostring(item.uuid)
															}
														}
														game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("set_game_finished_vote"):InvokeServer(unpack(args))
													end
												else
													if tostring(portalData.level_id) == tostring(selectedPortalMap) and tostring(portalData.portal_depth) == tier and tostring(portalData._weak_against[1].damage_type) ~= IgnoreDmgBonus then
														local args = {
															[1] = "replay",
															[2] = {
																["item_uuid"] = tostring(item.uuid)
															}
														}
														game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("set_game_finished_vote"):InvokeServer(unpack(args))
													end
												end
											else
												if IgnoreDmgBonus == "" or IgnoreDmgBonus == nil or IgnoreDmgBonus == "None" then
													if tostring(portalData.level_id) == tostring(selectedPortalMap) and tostring(portalData.portal_depth) == tier then
														local args = {
															[1] = "replay",
															[2] = {
																["item_uuid"] = tostring(item.uuid)
															}
														}
														game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("set_game_finished_vote"):InvokeServer(unpack(args))
													end
												else
													if tostring(portalData.level_id) == tostring(selectedPortalMap) and tostring(portalData.portal_depth) == tier and tostring(portalData._weak_against[1].damage_type) ~= IgnoreDmgBonus and tostring(portalData.challenge) ~= IgnoreChallenge then
														local args = {
															[1] = "replay",
															[2] = {
																["item_uuid"] = tostring(item.uuid)
															}
														}
														game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("set_game_finished_vote"):InvokeServer(unpack(args))
													end
												end
											end										
										end
									end
								end
							end
						end
					end
				end
			end
		end
		wait()
	end
end

function autoCraftShard()
	while getgenv().autoCraftShard == true do
		local args = {
			[1] = selectedShardtoCraft,
			[2] = {
				["use10"] = false
			}
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_item"):InvokeServer(unpack(args))		
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

function AutoMatchmaking()
    while getgenv().AutoMatchmaking == true do
		game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer(selectedMatchmakingMap)
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
		if getgenv().OnlyautoPlace == true then
			local wave = workspace:FindFirstChild("_wave_num")
			if selectedWaveToPlace == wave then
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
				local restrictedUnits = {"erwin", "wendy", "Leafy"}
				
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
				
				function checkEquippedAgainstOwnedAutoPlace()
					local ownedUnits = StatsServiceClient.module.session.collection.collection_profile_data.owned_units
					local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
					local matchedUUIDs = {}
					local unitNames = {}
				
					for _, equippedUUID in pairs(equippedUnits) do
						for key, unitData in pairs(ownedUnits) do
							if tostring(equippedUUID) == tostring(key) then
								table.insert(matchedUUIDs, key)
								unitNames[key] = unitData.unit_id
							end
						end
					end
				
					return matchedUUIDs, unitNames
				end
				
				function isFemtoInMapAutoPlace()
					for _, unit in pairs(workspace:GetChildren()) do
						if unit:IsA("Model") and (unit.Name == "griffith_reincarnation" or unit.Name == "femto_egg") then
							return true
						end
					end
					return false
				end
				
				function placeUnit(unitID, waypoint, radius)
					alternarUnidadeTipo(unitID)
					local isAerial = unitTypes[unitID] == "aerea"
				
					local spawnPosition = getRandomPositionAroundWaypoint(waypoint.Position, radius)
					local spawnCFrame = GetCFrame(spawnPosition, 0, 0, isAerial)
				
					local matchedUnits, unitNames = checkEquippedAgainstOwnedAutoPlace()
				
					for _, matchedID in pairs(matchedUnits) do
						if matchedID == unitID then
							local unitName = unitNames[unitID] or "Unknown"
							
							if getgenv().autoSacrificeGriffith == true and workspace._UNITS:FindFirstChild("femto_egg") then
								if table.find(restrictedUnits, unitName) and not isFemtoInMapAutoPlace() then
									print("Skipping unit:", unitName, "until a Femto is in the map.")
									return
								end
							end
				
							if unitName == "femto_egg" and not isFemtoInMapAutoPlace() then
								local oppositePosition = waypoint.Position + Vector3.new(25, 0, 25)
								local oppositeCFrame = GetCFrame(oppositePosition, 0, 0, false)
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unitID, oppositeCFrame)
							else
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unitID, spawnCFrame)
							end
						end
					end
				end
				
				function placeUnitsWithFemtoPriority(equippedUnits, waypoints, radiusMax)
					local femtoEggInTeam = false
					local femtoEggID = nil
				
					for _, unitID in pairs(equippedUnits) do
						local matchedUnits, unitNames = checkEquippedAgainstOwnedAutoPlace()
						for _, matchedID in pairs(matchedUnits) do
							local unitName = unitNames[matchedID]
							if unitName == "femto_egg" then
								femtoEggInTeam = true
								femtoEggID = unitID
								break
							end
						end
						if femtoEggInTeam then break end
					end
				
					local unitQueue = {}
				
					if femtoEggInTeam then
						table.insert(unitQueue, femtoEggID)
					end
				
					for _, unitID in pairs(equippedUnits) do
						if unitID ~= femtoEggID then
							table.insert(unitQueue, unitID)
						end
					end
				
					local totalWaypoints = #waypoints
					local waypointStep = totalWaypoints / 100
					local radiusStep = radiusMax / 100
				
					for _, unitID in pairs(unitQueue) do
						local selectedWaypointIndex = math.clamp(math.floor(selectedDistance * waypointStep), 1, totalWaypoints)
						local selectedRadius = math.clamp(selectedGroundDistance * radiusStep, 1, radiusMax)
						local waypoint = waypoints[selectedWaypointIndex]
						placeUnit(unitID, waypoint, selectedRadius)
					end
				end
				
				if StatsServiceClient and StatsServiceClient.module and StatsServiceClient.module.session and StatsServiceClient.module.session.collection and StatsServiceClient.module.session.collection.collection_profile_data and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units then
					local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
					local waypoints = workspace._BASES.pve.LANES["1"]:GetChildren()
					local radiusMax = 15
				
					placeUnitsWithFemtoPriority(equippedUnits, waypoints, radiusMax)
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
			
			local StatsServiceClient = Modules["CLIENT_SERVICE"] and Modules["CLIENT_SERVICE"]["StatsServiceClient"]
			
			local unitTypes = {}
			local restrictedUnits = {"erwin", "wendy", "Leafy"}
			
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
			
			function checkEquippedAgainstOwnedAutoPlace()
				local ownedUnits = StatsServiceClient.module.session.collection.collection_profile_data.owned_units
				local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
				local matchedUUIDs = {}
				local unitNames = {}
			
				for _, equippedUUID in pairs(equippedUnits) do
					for key, unitData in pairs(ownedUnits) do
						if tostring(equippedUUID) == tostring(key) then
							table.insert(matchedUUIDs, key)
							unitNames[key] = unitData.unit_id
						end
					end
				end
			
				return matchedUUIDs, unitNames
			end
			
			function isFemtoInMapAutoPlace()
				for _, unit in pairs(workspace:GetChildren()) do
					if unit:IsA("Model") and (unit.Name == "griffith_reincarnation" or unit.Name == "femto_egg") then
						return true
					end
				end
				return false
			end
			
			function placeUnit(unitID, waypoint, radius)
				alternarUnidadeTipo(unitID)
				local isAerial = unitTypes[unitID] == "aerea"
			
				local spawnPosition = getRandomPositionAroundWaypoint(waypoint.Position, radius)
				local spawnCFrame = GetCFrame(spawnPosition, 0, 0, isAerial)
			
				local matchedUnits, unitNames = checkEquippedAgainstOwnedAutoPlace()
			
				for _, matchedID in pairs(matchedUnits) do
					if matchedID == unitID then
						local unitName = unitNames[unitID] or "Unknown"
						
						if getgenv().autoSacrificeGriffith == true and workspace._UNITS:FindFirstChild("femto_egg") then
							if table.find(restrictedUnits, unitName) and not isFemtoInMapAutoPlace() then
								print("Skipping unit:", unitName, "until a Femto is in the map.")
								return
							end
						end
			
						if unitName == "femto_egg" and not isFemtoInMapAutoPlace() then
							local oppositePosition = waypoint.Position + Vector3.new(25, 0, 25)
							local oppositeCFrame = GetCFrame(oppositePosition, 0, 0, false)
							game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unitID, oppositeCFrame)
						else
							game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unitID, spawnCFrame)
						end
					end
				end
			end
			
			function placeUnitsWithFemtoPriority(equippedUnits, waypoints, radiusMax)
				local femtoEggInTeam = false
				local femtoEggID = nil
			
				for _, unitID in pairs(equippedUnits) do
					local matchedUnits, unitNames = checkEquippedAgainstOwnedAutoPlace()
					for _, matchedID in pairs(matchedUnits) do
						local unitName = unitNames[matchedID]
						if unitName == "femto_egg" then
							femtoEggInTeam = true
							femtoEggID = unitID
							break
						end
					end
					if femtoEggInTeam then break end
				end
			
				local unitQueue = {}
			
				if femtoEggInTeam then
					table.insert(unitQueue, femtoEggID)
				end
			
				for _, unitID in pairs(equippedUnits) do
					if unitID ~= femtoEggID then
						table.insert(unitQueue, unitID)
					end
				end
			
				local totalWaypoints = #waypoints
				local waypointStep = totalWaypoints / 100
				local radiusStep = radiusMax / 100
			
                for _, unitID in pairs(unitQueue) do
                    local selectedWaypointIndex = math.clamp(math.floor(selectedDistance * waypointStep), 1, totalWaypoints)
                    local selectedRadius = math.clamp(selectedGroundDistance * radiusStep, 1, radiusMax)
                    local waypoint = waypoints[selectedWaypointIndex]
                    placeUnit(unitID, waypoint, selectedRadius)
                end
			end
			
			if StatsServiceClient and StatsServiceClient.module and StatsServiceClient.module.session and StatsServiceClient.module.session.collection and StatsServiceClient.module.session.collection.collection_profile_data and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units then
				local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
				local waypoints = workspace._BASES.pve.LANES["1"]:GetChildren()
				local radiusMax = 15
			
				placeUnitsWithFemtoPriority(equippedUnits, waypoints, radiusMax)
			end
		end
		wait()
	end
end

function autoUpgrade()
    while getgenv().autoUpgrade == true do
        if getgenv().onlyupgradeinwaveX == true then
            local wave = workspace:FindFirstChild("_wave_num")
            if getgenv().selectedWaveToUpgrade == wave then
                local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
                local upvalues = debug.getupvalues(Loader.init)
                
                local Modules_Upgrade = {
                    ["CORE_CLASS"] = upvalues[6],
                    ["CORE_SERVICE"] = upvalues[7],
                    ["SERVER_CLASS"] = upvalues[8],
                    ["SERVER_SERVICE"] = upvalues[9],
                    ["CLIENT_CLASS"] = upvalues[10],
                    ["CLIENT_SERVICE"] = upvalues[11],
                }
                
                local ownedUnits_Upgrade = Modules_Upgrade["CLIENT_SERVICE"]["StatsServiceClient"].module.session.collection.collection_profile_data.owned_units
                local equippedUnits_Upgrade = Modules_Upgrade["CLIENT_SERVICE"]["StatsServiceClient"].module.session.collection.collection_profile_data.equipped_units
                
                function checkEquippedAgainstOwned_Upgrade()
                    local matchedUUIDs = {}
                    
                    for _, equippedUUID in pairs(equippedUnits_Upgrade) do
                        for key, _ in pairs(ownedUnits_Upgrade) do
                            if tostring(equippedUUID) == tostring(key) then
                                table.insert(matchedUUIDs, key)
                            end
                        end
                    end
                    
                    return matchedUUIDs
                end
                
                function getBaseName_Upgrade(unitName)
                    return string.match(unitName, "^(.-)_evolved$")
                        or string.match(unitName, "^(.-)_christmas$")
                        or string.match(unitName, "^(.-)_halloween$")
                        or unitName
                end
                
                function upgradeUnits(matchedUUIDs)
                    local unitsFolder = workspace:FindFirstChild("_UNITS")
                    if not unitsFolder then
                        warn("Pasta '_UNITS' não encontrada no workspace!")
                        return
                    end
                    
                    local unitsToUpgrade = {}
                    
                    for _, matchedUUID in pairs(matchedUUIDs) do
                        local ownedUnit = ownedUnits_Upgrade[matchedUUID]
                        if ownedUnit and ownedUnit.unit_id then
                            for _, unit in pairs(unitsFolder:GetChildren()) do
                                if getBaseName_Upgrade(ownedUnit.unit_id) == getBaseName_Upgrade(unit.Name) then
                                    table.insert(unitsToUpgrade, unit)
                                end
                            end
                        end
                    end
                    
                    for _, unitInstance in pairs(unitsToUpgrade) do
                        local args = { [1] = unitInstance }
                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("upgrade_unit_ingame"):InvokeServer(unpack(args))
                        end)
                        
                        if not success then
                            warn("Erro ao realizar upgrade da unidade:", err)
                        end
                    end
                end
                
                local matchingUUIDs = checkEquippedAgainstOwned_Upgrade()
                if #matchingUUIDs > 0 then
                    upgradeUnits(matchingUUIDs)
                end
            end
		else
			local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
                local upvalues = debug.getupvalues(Loader.init)
                
                local Modules_Upgrade = {
                    ["CORE_CLASS"] = upvalues[6],
                    ["CORE_SERVICE"] = upvalues[7],
                    ["SERVER_CLASS"] = upvalues[8],
                    ["SERVER_SERVICE"] = upvalues[9],
                    ["CLIENT_CLASS"] = upvalues[10],
                    ["CLIENT_SERVICE"] = upvalues[11],
                }
                
                local ownedUnits_Upgrade = Modules_Upgrade["CLIENT_SERVICE"]["StatsServiceClient"].module.session.collection.collection_profile_data.owned_units
                local equippedUnits_Upgrade = Modules_Upgrade["CLIENT_SERVICE"]["StatsServiceClient"].module.session.collection.collection_profile_data.equipped_units
                
                function checkEquippedAgainstOwned_Upgrade()
                    local matchedUUIDs = {}
                    
                    for _, equippedUUID in pairs(equippedUnits_Upgrade) do
                        for key, _ in pairs(ownedUnits_Upgrade) do
                            if tostring(equippedUUID) == tostring(key) then
                                table.insert(matchedUUIDs, key)
                            end
                        end
                    end
                    
                    return matchedUUIDs
                end
                
                function getBaseName_Upgrade(unitName)
                    return string.match(unitName, "^(.-)_evolved$")
                        or string.match(unitName, "^(.-)_christmas$")
                        or string.match(unitName, "^(.-)_halloween$")
                        or unitName
                end
                
                function upgradeUnits(matchedUUIDs)
                    local unitsFolder = workspace:FindFirstChild("_UNITS")
                    if not unitsFolder then
                        warn("Pasta '_UNITS' não encontrada no workspace!")
                        return
                    end
                    
                    local unitsToUpgrade = {}
                    
                    for _, matchedUUID in pairs(matchedUUIDs) do
                        local ownedUnit = ownedUnits_Upgrade[matchedUUID]
                        if ownedUnit and ownedUnit.unit_id then
                            for _, unit in pairs(unitsFolder:GetChildren()) do
                                if getBaseName_Upgrade(ownedUnit.unit_id) == getBaseName_Upgrade(unit.Name) then
                                    table.insert(unitsToUpgrade, unit)
                                end
                            end
                        end
                    end
                    
                    for _, unitInstance in pairs(unitsToUpgrade) do
                        local args = { [1] = unitInstance }
                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("upgrade_unit_ingame"):InvokeServer(unpack(args))
                        end)
                        
                        if not success then
                            warn("Erro ao realizar upgrade da unidade:", err)
                        end
                    end
                end
                
            local matchingUUIDs = checkEquippedAgainstOwned_Upgrade()
            if #matchingUUIDs > 0 then
                upgradeUnits(matchingUUIDs)
            end
        end
        wait(1)
    end
end


function autoSell()
    while getgenv().autoSell do
        local units = workspace:FindFirstChild("_UNITS")
        if units then
            local wave = workspace:FindFirstChild("_wave_num")
            if getgenv().onlysellinXwave == true then
                if selectedWaveToSell == wave then
                    for _, v in pairs(units:GetChildren()) do
                        local args = {
                            [1] = game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"):WaitForChild("vanilla_ice")
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("sell_unit_ingame"):InvokeServer(unpack(args))
                    end
                end
            else
                for _, v in pairs(units:GetChildren()) do
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
    while getgenv().universalSkill do
        local units = workspace:WaitForChild("_UNITS")
        local url = "https://raw.githubusercontent.com/buang5516/buanghub/main/AA/UnitsAbility.luau"

        local success, content = pcall(function()
            return game:HttpGet(url, true)
        end)

        if success then
            local successLoad, data = pcall(function()
                return loadstring(content)()
            end)

            if successLoad then
                for _, v in pairs(data) do
                    for _, l in pairs(units:GetChildren()) do
                        if getBaseName(v) == getBaseName(l.Name) then
                            local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(l)) }
                            local success, err = pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
                            end)

                            if not success then
                                warn("Error occurred: " .. err)
                            end
                        end
                    end
                end
            end
        end
        wait()
    end
end

function dupeVegeto()
    while getgenv().dupeVegeto do
        local gokuSSJ3 = safeWaitForChild(workspace:WaitForChild("_UNITS"), "goku_ssj3", 1)
        if gokuSSJ3 then
            local args = { [1] = gokuSSJ3 }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end

        local vegetaMajin = safeWaitForChild(workspace:WaitForChild("_UNITS"), "vegeta_majin", 1)
        if vegetaMajin then
            local args = { [1] = vegetaMajin }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end

        local gokuSSJ3Dead = safeWaitForChild(game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"), "goku_ssj3", 1)
        if gokuSSJ3Dead then
            local args = { [1] = gokuSSJ3Dead }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end

        local vegetaMajinDead = safeWaitForChild(game:GetService("ReplicatedStorage"):FindFirstChild("_DEAD_UNITS"), "vegeta_majin", 1)
        if vegetaMajinDead then
            local args = { [1] = vegetaMajinDead }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end
        wait()
    end
end

function dupeGriffith()
    while getgenv().dupeGriffith do
        local griffithNormal = safeWaitForChild(workspace:WaitForChild("_UNITS"), "femto_egg", 0.5)
        if griffithNormal then
            local args = { [1] = griffithNormal }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end

        local griffithDead = safeWaitForChild(game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"), "femto_egg", 0.5)
        if griffithDead then
            local args = { [1] = griffithDead }
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end
        wait()
    end
end

function autoSacrificeGriffith()
    while getgenv().autoSacrificeGriffith == true do
		local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
		local success, upvalues = pcall(debug.getupvalues, Loader.init)

		if not success then
			warn("Failed to get upvalues from Loader.init")
			return
		end

		local Modules = {
			["CLIENT_SERVICE"] = upvalues[11],
		}

		local StatsServiceClient = Modules["CLIENT_SERVICE"] and Modules["CLIENT_SERVICE"]["StatsServiceClient"]
		local restrictedUnits = {"orwin", "wendy", "elf"}
		local unitTypes = {}

		function getRandomPositionAroundGriffith(position, radius)
			local angle = math.random() * (2 * math.pi)
			local distance = math.random() * radius
			local offset = Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
			local result = position + offset
			return result
		end

		function alternarUnidadeTipo(unitID)
			if not unitTypes[unitID] then
				unitTypes[unitID] = math.random() < 0.5 and "aerea" or "terrestre"
			end
		end

		function checkEquippedAgainstOwnedGriffith()
			local ownedUnits = StatsServiceClient.module.session.collection.collection_profile_data.owned_units
			local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
			local matchedUUIDs = {}
			local unitNames = {}

			if not ownedUnits or not equippedUnits then
				return {}, {}
			end

			for _, equippedUUID in pairs(equippedUnits) do
				for key, unitData in pairs(ownedUnits) do
					if tostring(equippedUUID) == tostring(key) then
						table.insert(matchedUUIDs, key)
						if unitData and unitData.unit_id then
							unitNames[key] = unitData.unit_id
						end
					end
				end
			end

			return matchedUUIDs, unitNames
		end

		function isFemtoInMap()
			for _, unit in pairs(workspace:GetChildren()) do
				if unit:IsA("Model") and unit.Name == "griffith_reincarnation" then
					return true
				end
			end
			return false
		end

		function placeUnitGriffith(unitID, griffithPosition, radius)
			alternarUnidadeTipo(unitID)
			for _, unit in pairs(workspace._UNITS:GetChildren()) do
				if unit:IsA("Model") and unit.Name == "femto_egg" then
					local spawnPosition = getRandomPositionAroundGriffith(griffithPosition, radius)
					spawnPosition = Vector3.new(spawnPosition.X, spawnPosition.Y - 1, spawnPosition.Z + 1)

					local matchedUnits, unitNames = checkEquippedAgainstOwnedGriffith()

					for _, matchedID in pairs(matchedUnits) do
						if matchedID == unitID then
							local unitName = unitNames[unitID]
							getgenv().autoSacrificeGriffith = true
							if getgenv().autoSacrificeGriffith == true and workspace._UNITS:FindFirstChild("femto_egg") then
								if table.find(restrictedUnits, unitName) then
									if not isFemtoInMap() then
										local unit = workspace._UNITS
										if unit then
											local wendyCount = 0
											for i, v in pairs(unit:GetChildren()) do
												if v.Name == "wendy" or v.Name == "wendy_halloween" then
													wendyCount = wendyCount + 1
												end
											end

											if wendyCount == 6 then
												local allWendyUpgraded = true
												for i, v in pairs(unit:GetChildren()) do
													if v.Name == "wendy" or v.Name == "wendy_halloween" then
														local upgrade = nil
														if v:FindFirstChild("_stats") then
															upgrade = v._stats.upgrade.Value
														end

														if upgrade then
															if upgrade < 6 then
																allWendyUpgraded = false
															end
														end
													end
												end

												if allWendyUpgraded then
													local femtoEgg = workspace:WaitForChild("_UNITS"):WaitForChild("femto_egg")
													if femtoEgg and femtoEgg:IsA("Model") and femtoEgg:FindFirstChild("HumanoidRootPart") then
														local args = {
															[1] = femtoEgg
														}
														game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
													end
												end
											else
												game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("spawn_unit"):InvokeServer(unitID, CFrame.new(spawnPosition))
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if StatsServiceClient and StatsServiceClient.module and StatsServiceClient.module.session and StatsServiceClient.module.session.collection and StatsServiceClient.module.session.collection.collection_profile_data and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units then
			local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
			local griffith = workspace._UNITS:FindFirstChild("femto_egg")

			if griffith then
				local griffithPosition = griffith.HumanoidRootPart.Position
				local spawnRadius = 10

				for _, unit in pairs(equippedUnits) do
					placeUnitGriffith(unit, griffithPosition, spawnRadius)
				end
			end
		end
        wait()
    end
end

function autoContractMatchmaking()
    while getgenv().autoContractMatchmaking == true do
		local scroll = game:GetService("Players").LocalPlayer.PlayerGui.ContractsUI.Main.Main.Frame.Outer.main.Scroll
		local remoteSent = false
		
		for _, v in pairs(scroll:GetChildren()) do
			if v.Name == "MissionFrame" then
				if v.Main.Cleared.Visible ~= true then
					local player = game:GetService("Players").LocalPlayer
					local missionContainer = player.PlayerGui.ContractsUI.Main.Main.Frame.Outer.main.Scroll
		
					function findTextLabelByName(frame, name)
						for _, child in ipairs(frame:GetChildren()) do
							if child:IsA("TextLabel") and child.Name == name then
								return child
							end
							local result = findTextLabelByName(child, name)
							if result then
								return result
							end
						end
						return nil
					end
		
					local missionFrames = {}
					for _, frame in ipairs(missionContainer:GetChildren()) do
						if frame:IsA("Frame") then
							table.insert(missionFrames, frame)
						end
					end
		
					table.sort(missionFrames, function(a, b)
						return a.AbsolutePosition.X < b.AbsolutePosition.X
					end)
		
					for i, frame in ipairs(missionFrames) do
						local challenge = findTextLabelByName(frame, "Challenge")
						local difficulty = findTextLabelByName(frame, "Difficulty")
		
						local difficultyText = difficulty.Text:match("%d+")
						local challengeText = challenge.Text:lower():gsub(" ", "_")
		
						for _, map in pairs(selectedTierContract) do
							for _, diff in pairs(selectedIgnoreContractChallenge) do
								if difficultyText == tostring(map) and challengeText ~= tostring(diff) and not remoteSent then
									local args = {
										[1] = "__EVENT_CONTRACT_Sakamoto:" .. tostring(i)
									}
									
									game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_matchmaking"):InvokeServer(unpack(args))									
									remoteSent = true
								end
							end
						end
					end
				end
			end
		end
        wait()
    end
end

function autoContract()
    while getgenv().autoContract == true do
        local scroll = game:GetService("Players").LocalPlayer.PlayerGui.ContractsUI.Main.Main.Frame.Outer.main.Scroll
        local remoteSent = false

        for _, v in pairs(scroll:GetChildren()) do
            if v.Name == "MissionFrame" then

                if v.Main.Cleared.Visible ~= true then
                    local player = game:GetService("Players").LocalPlayer
                    local missionContainer = player.PlayerGui.ContractsUI.Main.Main.Frame.Outer.main.Scroll

                    function findTextLabelByName(frame, name)
                        for _, child in ipairs(frame:GetChildren()) do
                            if child:IsA("TextLabel") and child.Name == name then
                                return child
                            end
                            local result = findTextLabelByName(child, name)
                            if result then
                                return result
                            end
                        end
                        return nil
                    end

                    local missionFrames = {}
                    for _, frame in ipairs(missionContainer:GetChildren()) do
                        if frame:IsA("Frame") then
                            table.insert(missionFrames, frame)
                        end
                    end

                    table.sort(missionFrames, function(a, b)
                        return a.AbsolutePosition.X < b.AbsolutePosition.X
                    end)

                    for i, frame in ipairs(missionFrames) do

                        local challenge = findTextLabelByName(frame, "Challenge")
                        local difficulty = findTextLabelByName(frame, "Difficulty")

                        if challenge and difficulty then

                            local difficultyText = difficulty.Text:match("%d+")
                            local challengeText = challenge.Text:lower():gsub(" ", "_")

								for _, map in pairs(selectedTierContract) do
									for _, diff in pairs(selectedIgnoreContractChallenge) do
										if difficultyText == tostring(map) and challengeText ~= tostring(diff) and not remoteSent then
											if getgenv().FriendsOnly == true then
												local args = {
													[1] = tostring(i),
													[2] = {
														["friends_only"] = true
													}
												}
												
												game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("open_event_contract_portal"):InvokeServer(unpack(args))                                
											else
												local args = {
													[1] = tostring(i)
												}
							
												game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("open_event_contract_portal"):InvokeServer(unpack(args))
											end
										remoteSent = true
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

function autoEquipTeam()
	while getgenv().autoEquipTeam == true do
		local levelDataRemote = workspace._MAP_CONFIG:FindFirstChild("GetLevelData")
		local levelData = levelDataRemote:InvokeServer()
		
		if typeof(levelData) == "table" then
			for k, v in pairs(levelData) do
				if typeof(v) == "string" and string.match(v, "^__EVENT_CONTRACT_Sakamoto:%d$") then
					if type(levelData._daily_challenge_weak_against) == "table" then
						for k, v in pairs(levelData._daily_challenge_weak_against) do
							if v == "physical" then
								local args = {
									[1] = selectedTeamPhysicContract
								}
								
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))
							else
								local args = {
									[1] = selectedTeamMagicContract
								}
								
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))
							end
						end
					end					
				elseif v == "challenge" then
					if type(levelData._daily_challenge_weak_against) == "table" then
						for k, v in pairs(levelData._daily_challenge_weak_against) do
							if v == "physical" then
								local args = {
									[1] = selectedTeamPhysicChallengeDailyChallenge
								}
								
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))
							elseif v == "magic" then
								local args = {
									[1] = selectedTeamMagicChallengeDailyChallenge
								}
								
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))
							else 
								local args = {
									[1] = selectedTeamChallengeDailyChallenge
								}
								
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))
							end
						end
					end							
				elseif v == "raid" then
					local args = {
						[1] = selectedTeamRaid
					}
					
					game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))					
				elseif v == "infinite_tower" then
					local args = {
						[1] = selectedTeamInfTower
					}
					
					game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))					
				elseif v == "infinite" or v == "story" then
					local args = {
						[1] = selectedTeamStoryInf
					}
					
					game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("load_team_loadout"):InvokeServer(unpack(args))					
				end
			end
		end
		wait()
	end
end

function autoRollPassive()
	while getgenv().autoRollPassive == true do
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

		local ownedUnits = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.collection.collection_profile_data.owned_units

		local trait, tier

		for id, unit in pairs(ownedUnits) do
			if type(unit) == "table" then
				if unit.traits and type(unit.traits) == "table" then
					if unit.traits[1] and type(unit.traits[1]) == "table" then
						for subKey, subValue in pairs(unit.traits[1]) do
							if subKey == "trait" then
								trait = subValue
							elseif subKey == "tier" then
								tier = subValue
							end
						end
						if trait and tier then
							local traitCheck = trait .. " " .. tier
							if selectedUnitToRoll == id then
								for _, passive in pairs(selectedPassiveToRoll) do
									if passive == traitCheck then
										print("A unidade pegou a passiva desejada:", traitCheck)
										return
									end
								end
								local args = {
									[1] = tostring(selectedUnitToRoll)
								}
								
								game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_token_trait_reroll"):InvokeServer(unpack(args))								
							end
						end
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
			local sakamotoCoin = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.inventory.inventory_profile_data.normal_items.sakamoto_coin

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
                                value = string.format("<:gemsAA:1322365177320177705> %s\n <:goldAA:1322369598015668315> %s\n<:holidayEventAA:1322369599517491241> %s\n<:sakamotoCoin:1335489173057962075> %s\n", gems, gold, holiday, sakamotoCoin),
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

function testWebhook()
    local discordWebhookUrl = urlwebhook
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
                description = "Test Webhook LMAO\n\n```REWARDS:\n+AIZEN (999)\n```",
                color = 8716543,
                author = {
                    name = "Anime Adventures"
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
        else
            warn("Error sending message to Discord with http_request:", response.StatusCode, response.Body)
        end
    else
        print("Synchronization not supported on this device.")
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

local levelsModule = require(game:GetService("ReplicatedStorage").src.Data.Levels)
local ChallengeMapValues = {}

if type(levelsModule) == "table" then
    for levelName, levelData in pairs(levelsModule) do
        if levelData.id then
            table.insert(ChallengeMapValues, tostring(levelData.id))
        end
    end
end

local levelsModule = require(game:GetService("ReplicatedStorage").src.Data.Levels)
local PortalMapValues = {}

if type(levelsModule) == "table" then
    for levelName, levelData in pairs(levelsModule) do
        if levelData.id and string.find(levelName:lower(), "portal") then
            table.insert(PortalMapValues, tostring(levelData.id))
        end
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

local namePortal = game:GetService("ReplicatedStorage").packages.assets:FindFirstChild("ItemModels")
local ValuesPortalName = {}

if namePortal then
    for i, v in pairs(namePortal:GetChildren()) do
        if string.find(v.Name:lower(), "portal") then
            table.insert(ValuesPortalName,v.Name)
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

LeftGroupBox:AddToggle("AutoWalk", {
	Text = "Auto Walk",
	Default = false,
	Callback = function(Value)
		getgenv().autoWalk = Value
		autoWalk()
	end,
})


LeftGroupBox:AddDropdown("dropdownSelectActStory", {
	Values = {2, 3, 4, 5, 6},
	Default = "None",
	Multi = false,

	Text = "Select Quantity of people",

	Callback = function(Value)
		selecteQuantityPlayer = Value
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

LeftGroupBox:AddToggle("AutoNextPortal", {
	Text = "Auto Next Portal",
	Default = false,
	Callback = function(Value)
		getgenv().autoNextPortal = Value
		autoNextPortal()
	end,
})

LeftGroupBox:AddToggle("AutoNext", {
	Text = "Auto Next Contract",
	Default = false,
	Callback = function(Value)
		getgenv().autoNextContrato = Value
		autoNextContrato()
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

Tab1:AddToggle("autoGetQuest", {
	Text = "Auto Get Quest",
	Default = false,
	Callback = function(Value)
		getgenv().autoGetQuest = Value
		autoGetQuest()
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

Tab1:AddToggle("ShowInfoUnits", {
	Text = "Show Info Units",
	Default = false,
	Callback = function(Value)
		getgenv().showInfoUnits = Value
		showInfoUnits()
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

Tab1:AddDropdown("dropdownSelectCapsule", {
	Values = shardsValues,
	Default = "None",
	Multi = false,
	Text = "Select Shard to Craft",
	Callback = function(Value)
		selectedShardtoCraft = Value
	end,
})

Tab1:AddToggle("autoCraftShards", {
	Text = "Auto Craft Shards",
	Default = false,
	Callback = function(Value)
		getgenv().autoCraftShard = Value
		autoCraftShard()
	end,
})

local MyButton2 = Tab1:AddButton({
    Text = 'Reedem Codes',
    Func = function()
        local codes = {
			"ASSASSIN"
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

local Tab2 = TabBox2:AddTab("Event")

Tab2:AddToggle("AutoJoinCursedWomb", {
	Text = "Auto Join Cursed Womb",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoinCursedWomb = Value
		autoJoinCursedWomb()
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

local MyButton2 = LeftGroupBox:AddButton({
    Text = 'Test Webhook',
    Func = function()
        testWebhook()            
    end,
    DoubleClick = false,
})

local TabBox = Tabs.Main:AddRightTabbox()

local Tab1 = TabBox:AddTab("Passive")

Tab1:AddDropdown("RollUnit", {
	Values = ValuesUnitId,
	Default = "None",
	Multi = false,
	Text = "Select Unit",

	Callback = function(value)
		selectedUnitToRoll = value:match(".* | .* | (.+)")
	end,
})

Tab1:AddDropdown("dropdownSelectPassiveToRoll", {
	Values = passivesValues,
	Default = "None",
	Multi = true,
	Text = "Select Passive",
	Callback = function(Value)
		selectedPassiveToRoll = Value
	end,
})

Tab1:AddToggle("autoRoll", {
	Text = "Auto Roll",
	Default = false,
	Callback = function(Value)
		getgenv().autoRollPassive = Value
		autoRollPassive()
	end,
})

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

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Portal")

LeftGroupBox:AddDropdown("dropdownPortalMap", {
	Values = PortalMapValues,
	Default = "None",
	Multi = false,

	Text = "Select Portal",

	Callback = function(Value)
		selectedPortalMap = Value
	end,
})

LeftGroupBox:AddDropdown("dropdownTierPortal", {
	Values = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"},
	Default = "0",
	Multi = true,

	Text = "Select Tier",

	Callback = function(Values)
		selectedTierPortal = Values
	end,
})

LeftGroupBox:AddDropdown("dropdownSelectChallengePortal", {
    Values = challengeValues,
    Default = "None",
    Multi = true,

    Text = "Select Ignore Difficulty",

    Callback = function(Value)
        selectedPortalDiff = Value
    end,
})

LeftGroupBox:AddDropdown("dropdownIgnoreDmgBonusPortal", {
	Values = dmgBonus,
	Default = "None",
	Multi = true,

	Text = "Select Ignore Dmg bonus",

	Callback = function(Values)
		selectedIgnoreDmgBonus = Values
	end,
})

LeftGroupBox:AddToggle("AutoEnterPortal", {
	Text = "Auto Open Portal",
	Default = false,
	Callback = function(Value)
		getgenv().autoEnterPortal = Value
		autoEnterPortal()
	end,
})

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Matchmaking")

LeftGroupBox:AddDropdown("dropdownMatchmakingMap", {
	Values = ChallengeMapValues,
	Default = "None",
	Multi = false,

	Text = "Select Map",

	Callback = function(Value)
		selectedMatchmakingMap = Value
	end,
})

LeftGroupBox:AddToggle("AutoMatchmaking", {
	Text = "Auto Matchmaking",
	Default = false,
	Callback = function(Value)
		getgenv().AutoMatchmaking = Value
		AutoMatchmaking()
	end,
})

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Contract")

LeftGroupBox:AddDropdown("dropdownSelectActStory", {
    Values = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20" },
    Default = "None",
    Multi = true,
    Text = "Select Tier",
    Callback = function(Value)
        selectedTierContract = Value
    end,
})

LeftGroupBox:AddDropdown("dropdownSelectActStory", {
    Values = challengeValues,
    Default = "None",
    Multi = true,
    Text = "Select Ignore Challenge",
    Callback = function(Value)
        selectedIgnoreContractChallenge = Value
    end,
})

LeftGroupBox:AddToggle("AutoMatchmakingContract", {
    Text = "Auto Matchmaking Contract",
    Default = false,
    Callback = function(Value)
        getgenv().autoContractMatchmaking = Value
        autoContractMatchmaking()
    end,
})

LeftGroupBox:AddToggle("autoContract", {
    Text = "Auto Contract",
    Default = false,
    Callback = function(Value)
        getgenv().autoContract = Value
        autoContract()
    end,
})

local LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Infinite Castle")

LeftGroupBox:AddToggle("HardInfCastle", {
	Text = "Hard Inf Castle",
	Default = false,
	Callback = function(Value)
		getgenv().selectedHardInfCastle = Value
	end,
})

LeftGroupBox:AddToggle("AutoEnterInfCastle", {
	Text = "Auto Enter Inf Caslte",
	Default = false,
	Callback = function(Value)
		getgenv().autoEnterInfiniteCastle = Value
		autoEnterInfiniteCastle()
	end,
})

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Story")

RightGroupbox:AddDropdown("dropdownStoryMap", {
	Values = storyMapValues,
	Default = "None",
	Multi = false,

	Text = "Select Story Map",

	Callback = function(Value)
		selectedMap = Value
	end,
})

RightGroupbox:AddDropdown("dropdownSelectDifficultyStory", {
	Values = { "Normal", "Hard" },
	Default = "None",
	Multi = false,

	Text = "Select Difficulty",

	Callback = function(Values)
		selectedDifficulty = Values
	end,
})

RightGroupbox:AddDropdown("dropdownSelectActStory", {
	Values = { "1", "2", "3", "4", "5", "6", "Infinite" },
	Default = "None",
	Multi = false,

	Text = "Select Act",

	Callback = function(Value)
		selectedAct = Value
	end,
})

RightGroupbox:AddToggle("AutoEnter", {
	Text = "Auto Enter",
	Default = false,
	Callback = function(Value)
		getgenv().autoEnter = Value
		autoEnter()
	end,
})

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Challenge")

RightGroupbox:AddDropdown("dropdownChallengeMap", {
    Values = ChallengeMapValues,
    Default = "None",
    Multi = true,

    Text = "Select Map",

    Callback = function(Values)
        selectedMapChallenges = Values
    end,
})

RightGroupbox:AddDropdown("dropdownSelectChallenge", {
    Values = challengeValues,
    Default = "None",
    Multi = true,

    Text = "Select Difficulty",

    Callback = function(Value)
        selectedChallengesDiff = Value
    end,
})

RightGroupbox:AddToggle("AutoEnterChallenge", {
    Text = "Auto Enter Challenge",
    Default = false,
    Callback = function(Value)
        getgenv().autoEnterChallenge = Value
        autoEnterChallenge()
    end,
})

RightGroupbox:AddToggle("AutoEnterDailyChallenge", {
    Text = "Auto Enter Daily Challenge",
    Default = false,
    Callback = function(Value)
        getgenv().autoEnterDailyChallenge = Value
        autoEnterDailyChallenge()
    end,
})

RightGroupbox:AddToggle("AutoMatchmakingDailyChallenge", {
    Text = "Auto Matchmaking Daily Challenge",
    Default = false,
    Callback = function(Value)
        getgenv().autoMatchmakingDailyChallenge = Value
        autoMatchmakingDailyChallenge()
    end,
})

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Raid")

RightGroupbox:AddDropdown("dropdownSelectRaid", {
    Values = ChallengeMapValues,
    Default = "None",
    Multi = false,

    Text = "Select Map",

    Callback = function(Value)
        selectedRaidMap = Value
    end,
})

RightGroupbox:AddToggle("AutoEnterRaid", {
    Text = "Auto Enter Raid",
    Default = false,
    Callback = function(Value)
        getgenv().autoEnterRaid = Value
        autoEnterRaid()
    end,
})

local RightGroupbox = Tabs.Farm:AddRightGroupbox("Legend Stage")

RightGroupbox:AddDropdown("dropdownSelectLegendStage", {
    Values = ChallengeMapValues,
    Default = "None",
    Multi = false,

    Text = "Select Map",

    Callback = function(Value)
        selectedLegendStageMap = Value
    end,
})

RightGroupbox:AddToggle("AutoEnterLegendStage", {
    Text = "Auto Enter Legend Stage",
    Default = false,
    Callback = function(Value)
        getgenv().autoEnterLegendStage = Value
        autoEnterLegendStage()
    end,
})

local Tabs = {
	Teams = Window:AddTab("Teams"),
}

local LeftGroupBox = Tabs.Teams:AddLeftGroupbox("Story & Infinite")

LeftGroupBox:AddDropdown("dropdownSelectStoryInfiniteMagic", {
	Values = {'1', '2', '3', '4', '5', '6'},
	Default = "None",
	Multi = false,

	Text = "Select Team",

	Callback = function(Value)
		selectedTeamStoryInf = Value
		if selectedTeamStoryInf then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
})

local LeftGroupBox = Tabs.Teams:AddLeftGroupbox("Infinite Tower")

LeftGroupBox:AddDropdown("dropdownSelectInfTowerMagic", {
	Values = {'1', '2', '3', '4', '5', '6'},
	Default = "None",
	Multi = false,

	Text = "Select Team",

	Callback = function(Value)
		selectedTeamInfTower = Value
		if selectedTeamInfTower then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
})

local LeftGroupBox = Tabs.Teams:AddLeftGroupbox("Contract")

LeftGroupBox:AddDropdown("dropdownSelectContractPhysic", {
	Values = {'1', '2', '3', '4', '5', '6'},
	Default = "None",
	Multi = false,

	Text = "Select Physic Team",

	Callback = function(Value)
		selectedTeamPhysicContract = Value
		if selectedTeamPhysicContract then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
})

LeftGroupBox:AddDropdown("dropdownSelectContractMagic", {
	Values = {'1', '2', '3', '4', '5', '6'},
	Default = "None",
	Multi = false,

	Text = "Select Magic Team",

	Callback = function(Value)
		selectedTeamMagicContract = Value
		if selectedTeamMagicContract then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
})

local RightGroupbox = Tabs.Teams:AddRightGroupbox("Challenge & Daily Challenge")

RightGroupbox:AddDropdown("dropdownSelectDailyChallengeChallengePhysic", {
	Values = {'1', '2', '3', '4', '5', '6'},
	Default = "None",
	Multi = false,

	Text = "Select Physic Team",

	Callback = function(Value)
		selectedTeamPhysicChallengeDailyChallenge = Value
		if selectedTeamPhysicChallengeDailyChallenge then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
})

RightGroupbox:AddDropdown("dropdownSelectDailyChallengeChallengeMagic", {
	Values = {'1', '2', '3', '4', '5', '6'},
	Default = "None",
	Multi = false,

	Text = "Select Magic Team",

	Callback = function(Value)
		selectedTeamMagicChallengeDailyChallenge = Value
		if selectedTeamMagicChallengeDailyChallenge then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
})

RightGroupbox:AddDropdown("dropdownSelectDailyChallengeChallenge", {
	Values = {'1', '2', '3', '4', '5', '6'},
	Default = "None",
	Multi = false,

	Text = "Select Team For Normal Challenge",

	Callback = function(Value)
		selectedTeamChallengeDailyChallenge = Value
		if selectedTeamChallengeDailyChallenge then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
})

local RightGroupbox = Tabs.Teams:AddRightGroupbox("Raid")

RightGroupbox:AddDropdown("dropdownSelectRaidMagic", {
	Values = {'1', '2', '3', '4', '5', '6'},
	Default = "None",
	Multi = false,

	Text = "Select Team",

	Callback = function(Value)
		selectedTeamRaid = Value
		if selectedTeamRaid then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
})

local Tabs = {
	Card = Window:AddTab("Card"),
}

local LeftGroupBox = Tabs.Card:AddLeftGroupbox("Card Picker")

LeftGroupBox:AddDropdown("dropdownBuffPriority", {
    Values = Cards.Buff,
    Default = {},
    Multi = true,
    Text = "Select Buff Priority",
    Callback = function(selectedList)
        UpdatePriorityList("Buff", selectedList)
    end,
})

LeftGroupBox:AddDropdown("dropdownDebuffPriority", {
    Values = Cards.Debuff,
    Default = {},
    Multi = true,
    Text = "Select Debuff Priority",
    Callback = function(selectedList)
        UpdatePriorityList("Debuff", selectedList)
    end,
})

LeftGroupBox:AddToggle("AutoCard", {
    Text = "Auto Card",
    Default = false,
    Callback = function(Value)
        getgenv().autoChooseCard = Value
        if Value then
            autoChooseCard()
        end
    end,
})

LeftGroupBox:AddToggle("FocusBuff", {
    Text = "Focus Buff",
    Default = false,
    Callback = function(Value)
        getgenv().focusBuff = Value
    end,
})

LeftGroupBox:AddToggle("FocusDebuff", {
    Text = "Focus Debuff",
    Default = false,
    Callback = function(Value)
        getgenv().focusDebuff = Value
    end,
})

local Tabs = {
	Macro = Window:AddTab("Macro"),
}

local LeftGroupBox = Tabs.Macro:AddLeftGroupbox("Coming Soon")

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

LeftGroupBox:AddSlider('HillPercentage', {
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
		getgenv().OnlyautoPlace = Value
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


LeftGroupBox:AddToggle("FocusInFarm", {
	Text = "Focus Farm",
	Default = false,

	Callback = function(Value)
		getgenv().focusFarm = Value
	end,
})

LeftGroupBox:AddToggle("FocusInGriffith", {
	Text = "Focus Griffith",
	Default = false,

	Callback = function(Value)
		getgenv().focusGriffith = Value
	end,
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

RightGroupbox:AddToggle("AutoSacrificeGriffith", {
	Text = "Auto Sacrifice Griffith",
	Default = false,

	Callback = function(Value)
		getgenv().autoSacrificeGriffith = Value
		autoSacrificeGriffith()
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
        getgenv().fpsBoost = Value
		fpsBoost()
	end,
})

MenuGroup:AddToggle("FPSBoost", {
	Text = "Better FPS Boost",
	Default = false,
	Callback = function(Value)
        getgenv().betterFpsBoost = Value
		betterFpsBoost()
	end,
})

MenuGroup:AddToggle("FPSBoost", {
	Text = "REALLY Better FPS Boost",
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
createInfoUnit()
