repeat task.wait() until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()

local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled

local pcSize = UDim2.fromOffset(868, 650)
local mobileSize = UDim2.fromOffset(700, 550)
local currentSize = isMobile and mobileSize or pcSize

local Window = MacLib:Window({
    Title = "Tempest Hub",
    Subtitle = "Anime Adventures",
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

function hideUI()
	local UICorner1 = Instance.new("UICorner")
	local UICorner2 = Instance.new("UICorner")
	local backgroundFrame = Instance.new("Frame")
	local tempestButton = Instance.new("TextButton")
	local UIPadding = Instance.new("UIPadding")

	backgroundFrame.Name = "backgroundFrame"
	backgroundFrame.Parent = game.CoreGui.RobloxGui.MaclibGui
	backgroundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	backgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	backgroundFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	backgroundFrame.BorderSizePixel = 0
	backgroundFrame.Position = UDim2.new(0.98, 0, 0.5, 0)
	backgroundFrame.Size = UDim2.new(0, 100, 0, 100)

	UICorner1.Parent = backgroundFrame
	UICorner2.Parent = tempestButton

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
		local coreGui = game:GetService("CoreGui")
		local maclib = coreGui.RobloxGui:FindFirstChild("MaclibGui")
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
			Window:SetUserInfoState(bool)
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

function autoRollSakamotoBanner()
	while getgenv().autoRollSakamotoBanner == true do
		local args = {
			[1] = "SakamotoEvent",
			[2] = "gems"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("buy_from_banner"):InvokeServer(unpack(args))		
		wait()
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

local tabGroups = {
	TabGroup1 = Window:TabGroup()
}

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
	Farm = tabGroups.TabGroup1:Tab({ Name = "Farm", Image = "rbxassetid://4391741908" }),
	Freemium = tabGroups.TabGroup1:Tab({ Name = "Freemium", Image = "rbxassetid://11322089619" }),
	Teams = tabGroups.TabGroup1:Tab({ Name = "Teams", Image = "rbxassetid://15443966088" }),
	Cards = tabGroups.TabGroup1:Tab({ Name = "Cards", Image = "rbxassetid://5296816629" }),
	Others = tabGroups.TabGroup1:Tab({ Name = "Others", Image = "rbxassetid://11769203629" }),
	Macro = tabGroups.TabGroup1:Tab({ Name = "Macro", Image = "rbxassetid://5081210075" }),
	Shop = tabGroups.TabGroup1:Tab({ Name = "Shop", Image = "rbxassetid://6908632627" }),
	Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" })
}

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
    MainSection2 = tabs.Main:Section({ Side = "Right" }),
	MainSection3 = tabs.Main:Section({ Side = "Left" }),
	MainSection4 = tabs.Main:Section({ Side = "Right" }),
	MainSection5 = tabs.Main:Section({ Side = "Right" }),
	MainSection6 = tabs.Farm:Section({ Side = "Left" }),
    MainSection7 = tabs.Farm:Section({ Side = "Left" }),
	MainSection8 = tabs.Farm:Section({ Side = "Left" }),
	MainSection9 = tabs.Farm:Section({ Side = "Left" }),
	MainSection10 = tabs.Farm:Section({ Side = "Right" }),
	MainSection11 = tabs.Farm:Section({ Side = "Right" }),
	MainSection12 = tabs.Farm:Section({ Side = "Right" }),
	MainSection13 = tabs.Farm:Section({ Side = "Right" }),
	MainSection14 = tabs.Teams:Section({ Side = "Left" }),
	MainSection15 = tabs.Teams:Section({ Side = "Left" }),
	MainSection16 = tabs.Teams:Section({ Side = "Left" }),
	MainSection17 = tabs.Teams:Section({ Side = "Right" }),
	MainSection18 = tabs.Teams:Section({ Side = "Right" }),
	MainSection19 = tabs.Freemium:Section({ Side = "Left" }),
	MainSection20 = tabs.Cards:Section({ Side = "Left" }),
	MainSection21 = tabs.Others:Section({ Side = "Left" }),
	MainSection22 = tabs.Others:Section({ Side = "Right" }),
	MainSection23 = tabs.Macro:Section({ Side = "Right" }),
	MainSection24 = tabs.Shop:Section({ Side = "Left" }),
	MainSection25 = tabs.Settings:Section({ Side = "Left" }),
}

sections.MainSection1:Header({
	Name = "Player"
})

sections.MainSection1:Toggle({
	Name = "Hide Player Info",
	Default = false,
	Callback = function(value)
		getgenv().hideInfoPlayer = Value
		hideInfoPlayer()
	end,
}, "HidePlayerInfo")

sections.MainSection1:Toggle({
	Name = "Auto Walk",
	Default = false,
	Callback = function(value)
		getgenv().autoWalk = Value
		autoWalk()
	end,
}, "AutoWalk")

local Dropdown = sections.MainSection1:Dropdown({
	Name = "Select Quantity of Player",
	Multi = false,
	Required = true,
	Options = {2, 3, 4, 5, 6},
	Default = None,
	Callback = function(value)
		selecteQuantityPlayer = Value
	end,
}, "dropdownSelectPlayer")

sections.MainSection1:Toggle({
	Name = "Security Mode",
	Default = false,
	Callback = function(value)
		getgenv().securityMode = Value
		securityMode()
	end,
}, "SecurityMode")

sections.MainSection1:Toggle({
	Name = "Delete Map",
	Default = false,
	Callback = function(value)
		getgenv().deletemap = Value
		deletemap()
	end,
}, "DeleteMap")

sections.MainSection1:Toggle({
	Name = "Auto Leave",
	Default = false,
	Callback = function(value)
		getgenv().autoleave = Value
		autoleave()
	end,
}, "AutoLeave")

sections.MainSection1:Toggle({
	Name = "Auto Replay",
	Default = false,
	Callback = function(value)
		getgenv().autoreplay = Value
		autoreplay()
	end,
}, "AutoReplay")

sections.MainSection1:Toggle({
	Name = "Auto Next",
	Default = false,
	Callback = function(value)
		getgenv().autonext = Value
		autonext()
	end,
}, "AutoNext")

sections.MainSection1:Toggle({
	Name = "Auto Next Portal",
	Default = false,
	Callback = function(value)
		getgenv().autoNextPortal = Value
		autoNextPortal()
	end,
}, "AutoNextPortal")

sections.MainSection1:Toggle({
	Name = "Auto Next Contract",
	Default = false,
	Callback = function(value)
		getgenv().autoNextContrato = Value
		autoNextContrato()
	end,
}, "AutoNextContract")

sections.MainSection1:Toggle({
	Name = "Auto Start",
	Default = false,
	Callback = function(value)
		getgenv().autostart = Value
		autostart()
	end,
}, "AutoStart")

sections.MainSection1:Toggle({
	Name = "Auto Skip Wave",
	Default = false,
	Callback = function(value)
		getgenv().autoskipwave = Value
		autoskipwave()
	end,
}, "AutoSkipWave")

sections.MainSection2:Header({
	Name = "Extra"
})

sections.MainSection2:Toggle({
	Name = "Auto Get Battlepass",
	Default = false,
	Callback = function(value)
		getgenv().autoGetBattlepass = Value
		autoGetBattlepass()
	end,
}, "autoGetBattlepass")

sections.MainSection2:Toggle({
	Name = "Auto Get Quest",
	Default = false,
	Callback = function(value)
		getgenv().autoGetQuest = Value
		autoGetQuest()
	end,
}, "autoGetQuest")

sections.MainSection2:Toggle({
	Name = "Disable Notifications",
	Default = false,
	Callback = function(value)
		getgenv().disableNotifications = Value
		disableNotifications()
	end,
}, "DisableNotifications")

sections.MainSection2:Toggle({
	Name = "Place In Red Zones",
	Default = false,
	Callback = function(value)
		getgenv().placeInRedZones = Value
		placeInRedZones()
	end,
}, "PlaceInRedZones")

sections.MainSection2:Toggle({
	Name = "Show Info Units",
	Default = false,
	Callback = function(value)
		getgenv().showInfoUnits = Value
		showInfoUnits()
	end,
}, "ShowInfoUnits")

sections.MainSection2:Toggle({
	Name = "Friends Only",
	Default = false,
	Callback = function(value)
		selectedFriendsOnly = Value
	end,
}, "FriendsOnly")

sections.MainSection2:Toggle({
	Name = "Auto Give Presents",
	Default = false,
	Callback = function(value)
		getgenv().autoGivePresents = Value
		autoGivePresents()
	end,
}, "AutoGivePresents")

sections.MainSection2:Button({
	Name = "Reedem Codes",
	Callback = function()
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
})

sections.MainSection4:Header({
	Name = "Passiva"
})

local Dropdown = sections.MainSection4:Dropdown({
	Name = "Select Unit",
	Multi = false,
	Required = true,
	Options = ValuesUnitId,
	Default = None,
	Callback = function(value)
		selectedUnitToRoll = value:match(".* | .* | (.+)")
	end,
}, "RollUnit")

local Dropdown = sections.MainSection4:Dropdown({
	Name = "Select Passive",
	Multi = true,
	Required = true,
	Options = passivesValues,
	Default = None,
	Callback = function(Value)
		selectedPassiveToRoll = Value
	end,
}, "dropdownSelectPassiveToRoll")

sections.MainSection4:Toggle({
	Name = "Auto Roll",
	Default = false,
	Callback = function(value)
		getgenv().autoRollPassive = Value
		autoRollPassive()
	end,
}, "autoRoll")

sections.MainSection5:Header({
	Name = "Feed"
})

local Dropdown = sections.MainSection5:Dropdown({
	Name = "Select Unit",
	Multi = false,
	Required = true,
	Options = ValuesUnitId,
	Default = None,
	Callback = function(value)
		selectedUnitToRoll = value:match(".* | .* | (.+)")
	end,
}, "FeedUnit")

local Dropdown = sections.MainSection5:Dropdown({
	Name = "Select Unit to Feed",
	Multi = true,
	Required = true,
	Options = ValuesItemsToFeed,
	Default = None,
	Callback = function(Value)
		selectedFeed = Value
	end,
}, "dropdownSelectItemsToFeed")

sections.MainSection5:Toggle({
	Name = "Auto Feed",
	Default = false,
	Callback = function(value)
		getgenv().autoFeed = Value
		autoFeed()
	end,
}, "AutoFeed")

sections.MainSection3:Header({
	Name = "Webhook"
})

sections.MainSection3:Input({
	Name = "Webhook URL",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "All",
	Callback = function(input)
		urlwebhook = Value
	end,
	onChanged = function(input)
        urlwebhook = Value
	end,
}, "WebhookURL")

sections.MainSection3:Input({
	Name = "User ID",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
		urlwebhook = Value
	end,
	onChanged = function(input)
        urlwebhook = Value
	end,
}, "pingUser@")

sections.MainSection3:Toggle({
	Name = "Send Webhook when finish game",
	Default = false,
	Callback = function(value)
        getgenv().webhook = Value
        webhook()
	end,
}, "WebhookFinishGame")

sections.MainSection3:Toggle({
	Name = "Ping user",
	Default = false,
	Callback = function(value)
        getgenv().pingUser = Value
	end,
}, "pingUser")

sections.MainSection3:Button({
	Name = "Test Webhook",
	Callback = function()
        testWebhook()
	end,
})

sections.MainSection6:Header({
	Name = "Portal"
})

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Portal",
	Multi = false,
	Required = true,
	Options = PortalMapValues,
	Default = None,
	Callback = function(value)
		selectedPortalMap = Value
	end,
}, "dropdownPortalMap")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Tier",
	Multi = true,
	Required = true,
	Options = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"},
	Default = None,
	Callback = function(value)
		selectedTierPortal = Values
	end,
}, "dropdownTierPortal")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Ignore Difficulty",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
        selectedPortalDiff = Value
	end,
}, "dropdownSelectChallengePortal")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Ignore Dmg bonus",
	Multi = true,
	Required = true,
	Options = dmgBonus,
	Default = None,
	Callback = function(value)
		selectedIgnoreDmgBonus = Values
	end,
}, "dropdownIgnoreDmgBonusPortal")

sections.MainSection6:Toggle({
	Name = "Auto Open Portal",
	Default = false,
	Callback = function(value)
		getgenv().autoEnterPortal = Value
		autoEnterPortal()
	end,
}, "AutoEnterPortal")

sections.MainSection7:Header({
	Name = "Matchmaking"
})

local Dropdown = sections.MainSection7:Dropdown({
	Name = "Select Map",
	Multi = false,
	Required = true,
	Options = ChallengeMapValues,
	Default = None,
	Callback = function(value)
		selectedMatchmakingMap = Value
	end,
}, "dropdownMatchmakingMap")

sections.MainSection7:Toggle({
	Name = "Auto Matchmaking",
	Default = false,
	Callback = function(value)
		getgenv().AutoMatchmaking = Value
		AutoMatchmaking()
	end,
}, "AutoMatchmaking")

sections.MainSection8:Header({
	Name = "Contract"
})

local Dropdown = sections.MainSection8:Dropdown({
	Name = "Select Tier",
	Multi = true,
	Required = true,
	Options = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20" },
	Default = None,
	Callback = function(value)
        selectedTierContract = Value
	end,
}, "dropdownSelectTierContract")

local Dropdown = sections.MainSection8:Dropdown({
	Name = "Select Ignore Challenge",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
        selectedIgnoreContractChallenge = Value
	end,
}, "dropdownSelectIgnoreChallengeContract")


sections.MainSection8:Toggle({
	Name = "Auto Matchmaking Contract",
	Default = false,
	Callback = function(value)
        getgenv().autoContractMatchmaking = Value
        autoContractMatchmaking()
	end,
}, "AutoMatchmakingContract")

sections.MainSection8:Toggle({
	Name = "Auto Contract",
	Default = false,
	Callback = function(value)
        getgenv().autoContract = Value
        autoContract()
	end,
}, "autoContract")

sections.MainSection9:Header({
	Name = "Others"
})

sections.MainSection9:Toggle({
	Name = "Hard Inf Castle",
	Default = false,
	Callback = function(value)
		getgenv().selectedHardInfCastle = Value
	end,
}, "HardInfCastle")

sections.MainSection9:Toggle({
	Name = "Auto Enter Inf Castle",
	Default = false,
	Callback = function(value)
		getgenv().autoEnterInfiniteCastle = Value
		autoEnterInfiniteCastle()
	end,
}, "AutoEnterInfCastle")


sections.MainSection9:Toggle({
	Name = "Auto Join Cursed Womb",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinCursedWomb = Value
		autoJoinCursedWomb()
	end,
}, "AutoJoinCursedWomb")

sections.MainSection10:Header({
	Name = "Story"
})

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Story Map",
	Multi = false,
	Required = true,
	Options = storyMapValues,
	Default = None,
	Callback = function(value)
		selectedMap = Value
	end,
}, "dropdownStoryMap")

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Difficulty",
	Multi = false,
	Required = true,
	Options = {"Normal", "Hard"},
	Default = None,
	Callback = function(value)
		selectedDifficulty = Values
	end,
}, "dropdownSelectDifficultyStory")

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = {"1", "2", "3", "4", "5", "6", "Infinite"},
	Default = None,
	Callback = function(value)
		selectedAct = Value
	end,
}, "dropdownSelectActStory")

sections.MainSection10:Toggle({
	Name = "Auto Enter",
	Default = false,
	Callback = function(value)
		getgenv().autoEnter = Value
		autoEnter()
	end,
}, "AutoEnter")

sections.MainSection11:Header({
	Name = "Challenge"
})

local Dropdown = sections.MainSection11:Dropdown({
	Name = "Select Map",
	Multi = true,
	Required = true,
	Options = ChallengeMapValues,
	Default = None,
	Callback = function(value)
        selectedMapChallenges = Values
	end,
}, "dropdownChallengeMap")

local Dropdown = sections.MainSection11:Dropdown({
	Name = "Select Difficulty",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
        selectedChallengesDiff = Value
	end,
}, "dropdownSelectChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Enter Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterChallenge = Value
        autoEnterChallenge()
	end,
}, "AutoEnterChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Enter Daily Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterDailyChallenge = Value
        autoEnterDailyChallenge()
	end,
}, "AutoEnterDailyChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Matchmaking Daily Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoMatchmakingDailyChallenge = Value
        autoMatchmakingDailyChallenge()
	end,
}, "AutoMatchmakingDailyChallenge")

sections.MainSection12:Header({
	Name = "Raid"
})

local Dropdown = sections.MainSection12:Dropdown({
	Name = "Select Map",
	Multi = false,
	Required = true,
	Options = ChallengeMapValues,
	Default = None,
	Callback = function(value)
        selectedRaidMap = Value
	end,
}, "dropdownSelectRaid")

sections.MainSection12:Toggle({
	Name = "Auto Enter Raid",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterRaid = Value
        autoEnterRaid()
	end,
}, "AutoEnterRaid")

sections.MainSection13:Header({
	Name = "Legend Stage"
})

local Dropdown = sections.MainSection13:Dropdown({
	Name = "Select Map",
	Multi = false,
	Required = true,
	Options = ChallengeMapValues,
	Default = None,
	Callback = function(value)
        selectedLegendStageMap = Value
	end,
}, "dropdownSelectLegendStage")

sections.MainSection13:Toggle({
	Name = "Auto Enter Legend Stage",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterLegendStage = Value
        autoEnterLegendStage()
	end,
}, "AutoEnterLegendStage")

sections.MainSection14:Header({
	Name = "Story & Infinite"
})

local Dropdown = sections.MainSection14:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
		selectedTeamStoryInf = Value
		if selectedTeamStoryInf then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
}, "dropdownSelectStoryInfiniteMagic")

sections.MainSection15:Header({
	Name = "Infinite Tower"
})

local Dropdown = sections.MainSection15:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
		selectedTeamInfTower = Value
		if selectedTeamInfTower then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
}, "dropdownSelectInfTowerMagic")

sections.MainSection16:Header({
	Name = "Contract"
})

local Dropdown = sections.MainSection16:Dropdown({
	Name = "Select Physic Team",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
		selectedTeamPhysicContract = Value
		if selectedTeamPhysicContract then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
}, "dropdownSelectContractPhysic")

local Dropdown = sections.MainSection16:Dropdown({
	Name = "Select Magic Team",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
		selectedTeamMagicContract = Value
		if selectedTeamMagicContract then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
}, "dropdownSelectContractMagic")

sections.MainSection17:Header({
	Name = "Challenge & Daily Challenge"
})

local Dropdown = sections.MainSection17:Dropdown({
	Name = "Select Physic Team",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
		selectedTeamPhysicChallengeDailyChallenge = Value
		if selectedTeamPhysicChallengeDailyChallenge then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
}, "dropdownSelectDailyChallengeChallengePhysic")

local Dropdown = sections.MainSection17:Dropdown({
	Name = "Select Magic Team",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
		selectedTeamMagicChallengeDailyChallenge = Value
		if selectedTeamMagicChallengeDailyChallenge then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
}, "dropdownSelectDailyChallengeChallengeMagic")

local Dropdown = sections.MainSection17:Dropdown({
	Name = "Select Team For Normal Challenge",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
		selectedTeamChallengeDailyChallenge = Value
		if selectedTeamChallengeDailyChallenge then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
}, "dropdownSelectDailyChallengeChallenge")

sections.MainSection18:Header({
	Name = "Raid"
})

local Dropdown = sections.MainSection18:Dropdown({
	Name = "Select Team",
	Multi = false,
	Required = true,
	Options = {'1', '2', '3', '4', '5', '6'},
	Default = None,
	Callback = function(value)
		selectedTeamRaid = Value
		if selectedTeamRaid then
			getgenv().autoEquipTeam = true
			autoEquipTeam()
		end
	end,
}, "dropdownSelectRaidMagic")

sections.MainSection19:Header({
	Name = "Freemium"
})

sections.MainSection19:Toggle({
	Name = "Dupe Griffith",
	Default = false,
	Callback = function(value)
		getgenv().dupeGriffith = Value
		dupeGriffith()
	end,
}, "DupeGriffith")

sections.MainSection19:Toggle({
	Name = "Dupe Vegeto",
	Default = false,
	Callback = function(value)
		getgenv().dupeVegeto = Value
		dupeVegeto()
	end,
}, "DupeVegeto")

sections.MainSection19:Toggle({
	Name = "Inf Range",
	Default = false,
	Callback = function(value)
		getgenv().InfRange = Value
		InfRange()
	end,
}, "InfRange")

sections.MainSection20:Header({
	Name = "Card Picker"
})

local Dropdown = sections.MainSection20:Dropdown({
	Name = "Select Buff Priority",
	Multi = true,
	Required = true,
	Options = Cards.Buff,
	Default = None,
	Callback = function(value)
        UpdatePriorityList("Buff", selectedList)
	end,
}, "dropdownBuffPriority")

local Dropdown = sections.MainSection20:Dropdown({
	Name = "Select Debuff Priority",
	Multi = true,
	Required = true,
	Options = Cards.Debuff,
	Default = None,
	Callback = function(value)
        UpdatePriorityList("Debuff", selectedList)
	end,
}, "dropdownDebuffPriority")

sections.MainSection20:Toggle({
	Name = "Auto Card",
	Default = false,
	Callback = function(value)
        getgenv().autoChooseCard = Value
        if Value then
            autoChooseCard()
        end
	end,
}, "AutoCard")

sections.MainSection20:Toggle({
	Name = "Focus Buff",
	Default = false,
	Callback = function(value)
        getgenv().focusBuff = Value
	end,
}, "FocusBuff")

sections.MainSection20:Toggle({
	Name = "Focus Debuff",
	Default = false,
	Callback = function(value)
        getgenv().focusDebuff = Value
	end,
}, "FocusDebuff")

sections.MainSection21:Header({
	Name = "Unit"
})

sections.MainSection21:Input({
	Name = "Start Place at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
        selectedWaveToPlace = Value
	end,
	onChanged = function(input)
        selectedWaveToPlace = Value
	end,
}, "inputAutoPlaceWaveX")

sections.MainSection21:Slider({
	Name = "Distance Percentage",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Round",
	Precision = 0,
	Callback = function(value)
		selectedDistance = Value
	end,
}, "distancePercentage")

sections.MainSection21:Slider({
	Name = "Ground Percentage",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Round",
	Precision = 0,
	Callback = function(value)
		selectedGroundDistance = Value
	end,
}, "GroundPercentage")

sections.MainSection21:Slider({
	Name = "Hill Percentage",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Round",
	Precision = 0,
	Callback = function(value)
		selectedHillDistance = Value
	end,
}, "HillPercentage")

sections.MainSection21:Toggle({
	Name = "Auto Place",
	Default = false,
	Callback = function(value)
		getgenv().autoPlace = Value
		if Value then
			autoPlace()
		end
	end,
}, "AutoPlace")

sections.MainSection21:Toggle({
	Name = "Only Start Place in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().OnlyautoPlace = Value
	end,
}, "OnlyStartPlaceInXWave")

sections.MainSection21:Input({
	Name = "Start Upgrade at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
        selectedWaveToUpgrade = Value
	end,
	onChanged = function(input)
        selectedWaveToUpgrade = Value
	end,
}, "inputAutoUpgradeWaveX")

sections.MainSection21:Toggle({
	Name = "Focus Farm",
	Default = false,
	Callback = function(value)
		getgenv().focusFarm = Value
	end,
}, "FocusInFarm")

sections.MainSection21:Toggle({
	Name = "Focus Griffith",
	Default = false,
	Callback = function(value)
		getgenv().focusGriffith = Value
	end,
}, "FocusInGriffith")

sections.MainSection21:Toggle({
	Name = "Auto Upgrade",
	Default = false,
	Callback = function(value)
		getgenv().autoUpgrade = Value
		autoUpgrade()
	end,
}, "AutoUpgrade")

sections.MainSection21:Toggle({
	Name = "Only Upgrade in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlyupgradeinXwave = Value
	end,
}, "OnlyUpgradeInXWave")

sections.MainSection21:Input({
	Name = "Start Sell at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
        selectedWaveToSell = Value
	end,
	onChanged = function(input)
        selectedWaveToSell = Value
	end,
}, "inputAutoSellWaveX")

sections.MainSection21:Toggle({
	Name = "Auto Sell",
	Default = false,
	Callback = function(value)
		getgenv().autoSell = Value
		autoSell()
	end,
}, "AutoSell")

sections.MainSection21:Toggle({
	Name = "Only Sell in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlysellinXwave = Value
	end,
}, "OnlySellInXWave")

sections.MainSection22:Header({
	Name = "Skill"
})

sections.MainSection22:Input({
	Name = "Start Skill at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
        selectedWaveToUniversalSkill = Value
	end,
	onChanged = function(input)
        selectedWaveToUniversalSkill = Value
	end,
}, "inputAutoSkillWaveX")

sections.MainSection22:Toggle({
	Name = "Auto Universal Skill",
	Default = false,
	Callback = function(value)
		getgenv().universalSkill = Value
		universalSkill()
	end,
}, "AutoUniversalSkill")

sections.MainSection22:Toggle({
	Name = "Only Universal Skill in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().universalSkillinXWave = Value
	end,
}, "OnlyUniversalSkillinXWave")

sections.MainSection22:Toggle({
	Name = "Auto Sacrifice Griffith",
	Default = false,
	Callback = function(value)
		getgenv().autoSacrificeGriffith = Value
		autoSacrificeGriffith()
	end,
}, "AutoSacrificeGriffith")

sections.MainSection22:Toggle({
	Name = "Auto Buff Erwin",
	Default = false,
	Callback = function(value)
		toggle = Value
		if toggle then
			UseActiveAttackE()
		end
	end,
}, "AutoBuffErwin")

sections.MainSection22:Toggle({
	Name = "Auto Buff Wenda",
	Default = false,
	Callback = function(value)
		toggle2 = Value
		if toggle2 then
			UseActiveAttackW()
		end
	end,
}, "AutoBuffWenda")

sections.MainSection22:Toggle({
	Name = "Auto Buff Leafy",
	Default = false,
	Callback = function(value)
		toggle3 = Value
		if toggle3 then
			UseActiveAttackL()
		end
	end,
}, "AutoBuffLeafy")

sections.MainSection23:Header({
	Name = "Macro (Coming soon)"
})

sections.MainSection24:Header({
	Name = "Shop"
})

local Dropdown = sections.MainSection24:Dropdown({
	Name = "Select Capsule to Open",
	Multi = false,
	Required = true,
	Options = ValuesCapsules,
	Default = None,
	Callback = function(value)
		selectedCapsule = Value
	end,
}, "dropdownSelectCapsule")

sections.MainSection24:Toggle({
	Name = "Auto Open Capsule",
	Default = false,
	Callback = function(value)
		getgenv().autoOpenCapsule = Value
		autoOpenCapsule()
	end,
}, "AutoOpenCapsule")

local Dropdown = sections.MainSection24:Dropdown({
	Name = "Select Shard to Craft",
	Multi = false,
	Required = true,
	Options = shardsValues,
	Default = None,
	Callback = function(value)
		selectedShardtoCraft = Value
	end,
}, "dropdownSelectShardToCraft")

sections.MainSection24:Toggle({
	Name = "Auto Craft Shards",
	Default = false,
	Callback = function(value)
		getgenv().autoCraftShard = Value
		autoCraftShard()
	end,
}, "autoCraftShards")

local Dropdown = sections.MainSection24:Dropdown({
	Name = "Select Item",
	Multi = false,
	Required = true,
	Options = ValuesItemsToFeed,
	Default = None,
	Callback = function(value)
		selectedItemToBuy = Value
	end,
}, "dropdownSelectItemToBuy")

sections.MainSection24:Toggle({
	Name = "Auto Buy",
	Default = false,
	Callback = function(value)
		getgenv().autoBuy = Value
		autoBuy()
	end,
}, "AutoBuy")

sections.MainSection24:Toggle({
	Name = "Auto Roll Sakamoto Event",
	Default = false,
	Callback = function(value)
		getgenv().autoRollSakamotoBanner = Value
		autoRollSakamotoBanner()
	end,
}, "autoRollSakamotoBanner")

--UI IMPORTANT THINGS

MacLib:SetFolder("Maclib")
tabs.Settings:InsertConfigSection("Left")

sections.MainSection25:Toggle({
	Name = "Hide UI when Execute",
	Default = false,
	Callback = function(value)
		getgenv().hideUIExec = value
		hideUIExec()
	end,
}, "HideUiWhenExecute")

sections.MainSection25:Toggle({
	Name = "Auto Execute",
	Default = false,
	Callback = function(value)
		getgenv().aeuat = Value
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
        getgenv().fpsBoost = Value
		fpsBoost()
	end,
}, "FPSBoost")

sections.MainSection25:Toggle({
	Name = "Better FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().betterFpsBoost = Value
		betterFpsBoost()
	end,
}, "BetterFPSBoost")

sections.MainSection25:Toggle({
	Name = "REALLY Better FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().extremeFpsBoost = Value
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
MacLib:SetFolder("Tempest Hub/_JJI_1")
local GameConfigName = "_JJI_1"
local player = game.Players.LocalPlayer
MacLib:LoadConfig(player.Name .. GameConfigName)
spawn(function()
	while task.wait(1) do
		if Window.Unloaded then
			break
		end
		MacLib:SaveConfig(player.Name .. GameConfigName)
	end
end)

--Anti AFK
for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end
warn("[TEMPEST HUB] Loaded")
createBC()
createInfoUnit()
