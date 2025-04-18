repeat task.wait() until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()

local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled
local pcSize = UDim2.fromOffset(868, 650)
local mobileSize = UDim2.fromOffset(800, 550)
local currentSize = isMobile and mobileSize or pcSize
getgenv().hideInfoPlayer = false
getgenv().autoWalk = false
getgenv().securityMode = false
getgenv().deletemap = false
getgenv().autoleave = false
getgenv().autoreplay = false
getgenv().autonext = false
getgenv().autoNextPortal = false
getgenv().autoNextContrato = false
getgenv().autostart = false
getgenv().autoskipwave = false
getgenv().autoGetBattlepass = false
getgenv().autoGetQuest = false
getgenv().disableNotifications = false
getgenv().placeInRedZones = false
getgenv().showInfoUnits = false
getgenv().autoGivePresents = false
getgenv().autoRollPassive = false
getgenv().autoFeed = false
getgenv().webhook = ""
getgenv().pingUser = ""
getgenv().autoEnterPortal = false
getgenv().AutoMatchmaking = false
getgenv().autoContractMatchmaking = false
getgenv().autoContract = false
getgenv().selectedHardInfCastle = false
getgenv().autoEnterInfiniteCastle = false
getgenv().autoJoinCursedWomb = false
getgenv().autoEnter = false
getgenv().autoEquipTeam = false
getgenv().dupeGriffith = false
getgenv().dupeVegeto = false
getgenv().InfRange = false
getgenv().autoChooseCard = false
getgenv().focusBuff = false
getgenv().focusDebuff = false
getgenv().autoPlace = false
getgenv().OnlyautoPlace = false
getgenv().autoUpgrade = false
getgenv().onlyupgradeinXwave = false
getgenv().autoSell = false
getgenv().autoSellFarmWaveX = false
getgenv().autoLeaveInXWave = false
getgenv().universalSkill = false
getgenv().universalSkillinXWave = false
getgenv().autoSacrificeGriffith = false
getgenv().autoBuffErwin = false
getgenv().autoBuffWenda = false
getgenv().autoBuffLeafy = false
getgenv().autoOpenCapsule = false
getgenv().autoCraftShard = false
getgenv().autoBuy = false
getgenv().autoRollSakamotoBanner = false
getgenv().hideUIExec = false

local distancePercentage
local GroundPercentage
local HillPercentage

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
				wait(1)
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

local UnitManagerGui = Instance.new("ScreenGui")
local BackgroundUnitManagerFrame = Instance.new("Frame")
local NameFrame = Instance.new("Frame")
local NameLabel = Instance.new("TextLabel")
local UIPadding = Instance.new("UIPadding")
local UnitsFrame = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIGridLayout = Instance.new("UIGridLayout")
local Template = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local TextLabel = Instance.new("TextLabel")
local Buttons = Instance.new("Frame")
local upgradeImageButton = Instance.new("ImageButton")
local sellImageButton = Instance.new("ImageButton")
local skillImageButton = Instance.new("ImageButton")
local UIGridLayout = Instance.new("UIGridLayout")
local UIGridLayout_2 = Instance.new("UIGridLayout")
local UIGridLayout_3 = Instance.new("UIGridLayout")
local UIGridLayout_4 = Instance.new("UIGridLayout")
local UIGridLayout_5 = Instance.new("UIGridLayout")
local UIGridLayout_6 = Instance.new("UIGridLayout")
local UIListLayout = Instance.new("UIListLayout")
local BottomButtons = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local SellAllButton = Instance.new("TextButton")
local BackgroundOpenUnitManagerFrame = Instance.new("Frame")
local backgroundBUttonPressFrame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")
local UICorner4 = Instance.new("UICorner")
local UICorner5 = Instance.new("UICorner")
local UICorner6 = Instance.new("UICorner")

UnitManagerGui.Name = "UnitManagerGui"
UnitManagerGui.Parent = game.Players.LocalPlayer.PlayerGui
UnitManagerGui.IgnoreGuiInset = true

BackgroundUnitManagerFrame.Name = "BackgroundUnitManagerFrame"
BackgroundUnitManagerFrame.Parent = UnitManagerGui
BackgroundUnitManagerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundUnitManagerFrame.BackgroundColor3 = Color3.new(0.239216, 0.239216, 0.239216)
BackgroundUnitManagerFrame.BackgroundTransparency = 1
BackgroundUnitManagerFrame.BorderColor3 = Color3.new(0, 0, 0)
BackgroundUnitManagerFrame.BorderSizePixel = 0
BackgroundUnitManagerFrame.Position = UDim2.new(1, 0, 0.5, 0)
BackgroundUnitManagerFrame.Size = UDim2.new(0, 300, 1, 0)
BackgroundUnitManagerFrame.Visible = false

NameFrame.Name = "NameFrame"
NameFrame.Parent = BackgroundUnitManagerFrame
NameFrame.AnchorPoint = Vector2.new(0.5, 0)
NameFrame.BackgroundColor3 = Color3.new(0.164706, 0.164706, 0.164706)
NameFrame.BackgroundTransparency = 0.5
NameFrame.BorderColor3 = Color3.new(0, 0, 0)
NameFrame.BorderSizePixel = 0
NameFrame.Position = UDim2.new(0.5, 0, 0, 10)
NameFrame.Size = UDim2.new(1, -20, 0, 100)
UICorner.Parent = NameFrame

NameLabel.Name = "NameLabel"
NameLabel.Parent = NameFrame
NameLabel.AnchorPoint = Vector2.new(0.5, 0.5)
NameLabel.BackgroundColor3 = Color3.new(1, 1, 1)
NameLabel.BackgroundTransparency = 1
NameLabel.BorderColor3 = Color3.new(0, 0, 0)
NameLabel.BorderSizePixel = 0
NameLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
NameLabel.Size = UDim2.new(1, 0, 1, 0)
NameLabel.Font = Enum.Font.Unknown
NameLabel.Text = "Unit Manager"
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.TextScaled = true
NameLabel.TextSize = 60
NameLabel.TextWrapped = true
UIPadding.Parent = NameLabel
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.PaddingTop = UDim.new(0, 10)

UnitsFrame.Name = "UnitsFrame"
UnitsFrame.Parent = BackgroundUnitManagerFrame
UnitsFrame.AnchorPoint = Vector2.new(0.5, 0)
UnitsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
UnitsFrame.BackgroundTransparency = 1
UnitsFrame.BorderColor3 = Color3.new(0, 0, 0)
UnitsFrame.BorderSizePixel = 0
UnitsFrame.Position = UDim2.new(0.5, 0, 0, 120)
UnitsFrame.Size = UDim2.new(1, 0, 1, -200)

ScrollingFrame.Parent = UnitsFrame
ScrollingFrame.Active = true
ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderColor3 = Color3.new(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0.5, 100)
ScrollingFrame.ScrollBarThickness = 7
ScrollingFrame.AutomaticCanvasSize = "Y"
ScrollingFrame.ScrollingDirection = "Y"

BottomButtons.Name = "BottomButtons"
BottomButtons.Parent = BackgroundUnitManagerFrame
BottomButtons.AnchorPoint = Vector2.new(0.5, 1)
BottomButtons.BackgroundColor3 = Color3.new(1, 1, 1)
BottomButtons.BackgroundTransparency = 1
BottomButtons.BorderColor3 = Color3.new(0, 0, 0)
BottomButtons.BorderSizePixel = 0
BottomButtons.Position = UDim2.new(0.5, 0, 1, 0)
BottomButtons.Size = UDim2.new(1, 0, 0, 75)

CloseButton.Name = "CloseButton"
CloseButton.Parent = BottomButtons
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
CloseButton.BorderColor3 = Color3.new(0, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.5, 0, 0.5, 0)
CloseButton.Size = UDim2.new(0, 200, 0, 50)
CloseButton.Font = Enum.Font.Unknown
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 30
CloseButton.TextWrapped = true
UICorner2.Parent = CloseButton

SellAllButton.Name = "SellAllButton"
SellAllButton.Parent = BottomButtons
SellAllButton.AnchorPoint = Vector2.new(0.5, 0.5)
SellAllButton.BackgroundColor3 = Color3.new(0.67451, 0, 0)
SellAllButton.BorderColor3 = Color3.new(0, 0, 0)
SellAllButton.BorderSizePixel = 0
SellAllButton.Position = UDim2.new(0.5, 0, 0.5, 0)
SellAllButton.Size = UDim2.new(0, 200, 0, 50)
SellAllButton.Font = Enum.Font.Unknown
SellAllButton.Text = "Sell All"
SellAllButton.TextColor3 = Color3.new(1, 1, 1)
SellAllButton.TextSize = 25
SellAllButton.TextWrapped = true
UICorner3.Parent = SellAllButton

UIGridLayout_3.Parent = BottomButtons
UIGridLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout_3.VerticalAlignment = Enum.VerticalAlignment.Center
UIGridLayout_3.CellPadding = UDim2.new(0.100000001, 5, 0, 5)
UIGridLayout_3.CellSize = UDim2.new(0.400000006, 0, 0.800000012, 0)

BackgroundOpenUnitManagerFrame.Name = "BackgroundOpenUnitManagerFrame"
BackgroundOpenUnitManagerFrame.Parent = UnitManagerGui
BackgroundOpenUnitManagerFrame.AnchorPoint = Vector2.new(0, 0.5)
BackgroundOpenUnitManagerFrame.BackgroundColor3 = Color3.new(0, 0, 0)
BackgroundOpenUnitManagerFrame.BorderColor3 = Color3.new(0, 0, 0)
BackgroundOpenUnitManagerFrame.BorderSizePixel = 0
BackgroundOpenUnitManagerFrame.Position = UDim2.new(0, 0, 0.5, 0)
BackgroundOpenUnitManagerFrame.Size = UDim2.new(0, 100, 0, 40)
UICorner4.Parent = BackgroundOpenUnitManagerFrame

backgroundBUttonPressFrame.Name = "backgroundBUttonPressFrame"
backgroundBUttonPressFrame.Parent = BackgroundOpenUnitManagerFrame
backgroundBUttonPressFrame.BackgroundColor3 = Color3.new(0, 0, 0)
backgroundBUttonPressFrame.BorderColor3 = Color3.new(0, 0, 0)
backgroundBUttonPressFrame.BorderSizePixel = 0
backgroundBUttonPressFrame.Position = UDim2.new(0.5, 35, 0.5, 0)
backgroundBUttonPressFrame.Size = UDim2.new(0, 30, 0, 30)
UICorner5.Parent = backgroundBUttonPressFrame

TextLabel.Parent = backgroundBUttonPressFrame
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "F"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 14
TextLabel.TextWrapped = true
UICorner6.Parent = TextLabel

TextButton.Parent = BackgroundOpenUnitManagerFrame
TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton.BackgroundTransparency = 1
TextButton.BorderColor3 = Color3.new(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.5, 0, 0.5, 0)
TextButton.Size = UDim2.new(0.5, 50, 1, 0)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "Open Unit Manager"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.TextScaled = true
TextButton.TextSize = 14
TextButton.TextWrapped = true

Template.Name = "Template"
Template.Parent = ScrollingFrame
Template.AnchorPoint = Vector2.new(0.5, 0.5)
Template.BackgroundColor3 = Color3.new(1, 1, 1)
Template.BackgroundTransparency = 1
Template.BorderColor3 = Color3.new(0, 0, 0)
Template.BorderSizePixel = 0
Template.Position = UDim2.new(0.180000007, 0, 0.0659999996, 0)
Template.Size = UDim2.new(0, 150, 0, 140)
Template.Visible = false

Buttons.Name = "ZButtons"
Buttons.Parent = Template
Buttons.AnchorPoint = Vector2.new(0.5, 0.5)
Buttons.BackgroundColor3 = Color3.new(1, 1, 1)
Buttons.BackgroundTransparency = 1
Buttons.BorderColor3 = Color3.new(0, 0, 0)
Buttons.BorderSizePixel = 0
Buttons.ClipsDescendants = true
Buttons.Size = UDim2.new(0, 100, 0, 100)

upgradeImageButton.Name = "upgradeImageButton"
upgradeImageButton.Parent = Buttons
upgradeImageButton.BackgroundColor3 = Color3.new(1, 1, 1)
upgradeImageButton.BorderColor3 = Color3.new(0, 0, 0)
upgradeImageButton.BorderSizePixel = 0
upgradeImageButton.Size = UDim2.new(0, 100, 0, 100)
upgradeImageButton.Transparency = 1
upgradeImageButton.Image = "http://www.roblox.com/asset/?id=15640528020"

sellImageButton.Name = "sellImageButton"
sellImageButton.Parent = Buttons
sellImageButton.BackgroundColor3 = Color3.new(1, 1, 1)
sellImageButton.BorderColor3 = Color3.new(0, 0, 0)
sellImageButton.BorderSizePixel = 0
sellImageButton.Size = UDim2.new(0, 100, 0, 100)
sellImageButton.Transparency = 1
sellImageButton.Image = "http://www.roblox.com/asset/?id=12086987759"

skillImageButton.Name = "skillImageButton"
skillImageButton.Parent = Buttons
skillImageButton.BackgroundColor3 = Color3.new(1, 1, 1)
skillImageButton.BorderColor3 = Color3.new(0, 0, 0)
skillImageButton.BorderSizePixel = 0
skillImageButton.Size = UDim2.new(0, 100, 0, 100)
skillImageButton.Transparency = 1
skillImageButton.Image = "http://www.roblox.com/asset/?id=13321880274"

UIGridLayout_6.Parent = Buttons
UIGridLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout_6.CellSize = UDim2.new(0.2, 10, 0.2, 5)

UIGridLayout_4.Parent = Template
UIGridLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_4.SortOrder = Enum.SortOrder.Name
UIGridLayout_4.CellSize = UDim2.new(0.5, 50, 0.2, 60)

UIGridLayout_5.Parent = ScrollingFrame
UIGridLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout_5.CellSize = UDim2.new(0, 120, 0, 150)


local bcUMFrame = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundUnitManagerFrame
local bcOUMFrame = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundOpenUnitManagerFrame.TextButton
local closeUnitManager = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundUnitManagerFrame.BottomButtons.CloseButton
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local u = game:GetService("UserInputService")
local units = workspace._UNITS

function toggleGui()
	bcUMFrame.Visible = not bcUMFrame.Visible
	local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local ScreenGui = PlayerGui:WaitForChild("UnitManagerGui")
	local object = ScreenGui:WaitForChild("BackgroundUnitManagerFrame")

	if object.Visible == true then
		object.AnchorPoint = Vector2.new(0.5, 0.5)

		local targetPosition = UDim2.new(1, -150, 0.5, 0)

		local tweenInfo1 = TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false)
		local tween = TweenService:Create(object, tweenInfo1, {Position = targetPosition})

		local targetTransparency = 0.3

		local tweenInfo2 = TweenInfo.new(1)
		local tween2 = TweenService:Create(object, tweenInfo2, {BackgroundTransparency = targetTransparency})

		tween:Play()
		tween2:Play()
	else
		object.AnchorPoint = Vector2.new(1, 0.5)
		local targetPosition = UDim2.new(1, 0, 0.5, 0)
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 0, false)
		local tween = TweenService:Create(object, tweenInfo, {Position = targetPosition})

		local targetTransparency2 = 1

		local tweenInfo2 = TweenInfo.new(1)
		local tween2 = TweenService:Create(object, tweenInfo2, {BackgroundTransparency = targetTransparency2})

		tween:Play()
		tween2:Play()
	end
end

bcOUMFrame.MouseButton1Up:Connect(function()
	toggleGui()
end)

closeUnitManager.MouseButton1Up:Connect(function()
	toggleGui()
end)

u.InputBegan:Connect(function(input)
	if input.KeyCode ~= Enum.KeyCode.F then return end
	toggleGui()
end)

local unitTable = {}

function templateClone(unitName, upgrade, imagePut) 
	if not Template then
		warn("Template não encontrado!")
		return
	end
	
	local clonado = Template:Clone()
	clonado.Name = unitName
	clonado.Visible = true
	
	local clonadoImg = imagePut:Clone()
	clonadoImg.Parent = clonado
	
	table.insert(unitTable, clonado)
	
	if ScrollingFrame then
		clonado.Parent = ScrollingFrame
	else
		warn("ScrollingFrame não definido!")
	end	

	local textLabelImg = Instance.new("TextLabel")
	textLabelImg.Parent = clonadoImg:FindFirstChild("Main")
	textLabelImg.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabelImg.BackgroundColor3 = Color3.new(1, 1, 1)
	textLabelImg.BackgroundTransparency = 1
	textLabelImg.BorderColor3 = Color3.new(0, 0, 0)
	textLabelImg.BorderSizePixel = 0
	textLabelImg.Position = UDim2.new(0.5, 7, 0.1, 5)
	textLabelImg.Size = UDim2.new(0, 120, 0, 20)
	textLabelImg.Font = Enum.Font.Merriweather
	textLabelImg.Text = "Upgrade: " .. upgrade
	textLabelImg.TextColor3 = Color3.new(255, 255, 255)
	textLabelImg.TextScaled = true
	textLabelImg.TextSize = 14
	textLabelImg.TextWrapped = true
	textLabelImg.TextXAlignment = Enum.TextXAlignment.Left
	textLabelImg.ZIndex = 15
	textLabelImg.TextBold = true	
	
	local textLabel = clonadoImg.Main:FindFirstChild("TextLabel")
	if textLabel then
		textLabel.Text = "Upgrade: " .. tostring(upgrade)
	else
		warn("TextLabel não encontrado!")
	end

	function updateUnitStats(upgrade)
		local upgradeValue = upgrade
		textLabelImg.Text = "Upgrade: " .. upgradeValue
	end

    local upgradeImageButton = clonado:FindFirstChild("UpgradeButton")
    if upgradeImageButton then
        upgradeImageButton.MouseButton1Click:Connect(function()
            local unitIndex = #unitTable
            upgradeUnit(unitIndex)
        end)
    end

    local sellImageButton = clonado:FindFirstChild("SellButton")
    if sellImageButton then
        sellImageButton.MouseButton1Click:Connect(function()
            local unitIndex = #unitTable
            sellUnit(unitIndex, clonado)
        end)
    end

    local skillImageButton = clonado:FindFirstChild("SkillButton")
    if skillImageButton then
        skillImageButton.MouseButton1Click:Connect(function()
            local unitIndex = #unitTable
            useSkillOnUnit(unitIndex)
        end)
    end
end

if SellAllButton then
    SellAllButton.MouseButton1Click:Connect(function()
        useSellAll()
    end)
end

function upgradeUnit(unitIndex)
    local unit = unitTable[unitIndex]
    if unit then
        local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(unit)) }
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end)
    end
end

function sellUnit(unitIndex, clonado)
    local unit = unitTable[unitIndex]
    if unit then
        local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(unit)) }
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end)

        if clonado then
            clonado:Destroy()
        end
    end
end

function useSkillOnUnit(unitIndex)
    local unit = unitTable[unitIndex]
    if unit then
        local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(unit)) }
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end)
    end
end

function useSellAll()
    for i, unit in ipairs(unitTable) do
        if unit then
            local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(unit)) }
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
            end)

            if not success then
                warn("Erro ao vender unidade", unit.Name, err)
            end
        end
    end
end

units.ChildAdded:Connect(function(unit)
    local stats = unit:FindFirstChild("_stats") or unit:WaitForChild("_stats", 5)
    if stats then
        local uuid = stats:FindFirstChild("uuid")
        if uuid and uuid.Value ~= "neutral" then
            local upgrade = stats:FindFirstChild("upgrade")
            if upgrade then
                local unitName = unit.Name
                local imageGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("UnitUpgrade")
                local imagePut = imageGui.Primary.Container.Main.Main.Icon.Common
				templateClone(unitName, upgrade.Value, imagePut)
				while true do
					local units2 = units:GetChildren()
					local stats = units2:FindFirstChild("_stats") or units2:WaitForChild("_stats", 5)
					if stats then
						local uuid = stats:FindFirstChild("uuid")
						if uuid and uuid.Value ~= "neutral" then
							local upgrade = stats:FindFirstChild("upgrade")
							if upgrade then
								if upgrade > 0 then
									updateUnitStats(upgrade)
								end
							end
						end
					end
					wait()
				end
            end
        end
    end
end)

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
        local levelText = player.PlayerGui:FindFirstChild("spawn_units") and player.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text
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
		if getgenv().loadedallscript == true then
			removeTexturesAndHeavyObjects(workspace)
		end
		wait()
	end
end

function betterFpsBoost()
	while getgenv().betterFpsBoost == true do
		if getgenv().loadedallscript == true then
			removeTexturesAndHeavyObjects(workspace)
			local enemiesAndUnits = workspace:FindFirstChild("_UNITS")

			if enemiesAndUnits then
				for i,v in pairs(enemiesAndUnits:GetChildren())do
					v:Destroy()
				end
			end
		end
		wait()
	end
end

function extremeFpsBoost()
    while getgenv().extremeFpsBoost == true do
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
		wait()
    end
end

function autoWalk()
	while getgenv().autoWalk == true do
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
		if getgenv().loadedallscript == true then
			if #players:GetPlayers() >= selecteQuantityPlayer then
				local player1 = players:GetPlayers()[1]
				local targetPlaceId = 8304191830

				if game.PlaceId ~= targetPlaceId and not isPlaceIdIgnored(game.PlaceId) then
					game:GetService("TeleportService"):Teleport(targetPlaceId, player1)
				end
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
			local petInGame = workspace:FindFirstChild(player)
		
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
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function UpdatePriorityList(category, selectedList)
    selectedPriorities[category] = selectedList
end

function autoChooseCard()
    while getgenv().autoChooseCard == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
    end
end

function autoGetQuest()
	while getgenv().autoGetQuest == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autostart()
	while getgenv().autostart == true do
		if getgenv().loadedallscript == true then
			game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
		end
		wait()
	end
end

function autoskipwave()
	while getgenv().autoskipwave == true do
		if getgenv().loadedallscript == true then
			game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_wave_skip:InvokeServer()
		end
		wait()
	end
end

function autoreplay()
	while getgenv().autoreplay == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoleave()
	while getgenv().autoleave == true do
		if getgenv().loadedallscript == true then
			local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI
			if resultUI and resultUI.Enabled == true then
				wait(3)
				game:GetService("ReplicatedStorage").endpoints.client_to_server.teleport_back_to_lobby:InvokeServer("leave")
			end
		end
		wait()
	end
end

function autoLeaveInXWave()
	while getgenv().autoLeaveInXWave == true do
		if getgenv().loadedallscript == true then
			local wave = workspace:FindFirstChild("_wave_num")
			if wave and wave == selectedWaveToLeave then
				game:GetService("ReplicatedStorage").endpoints.client_to_server.teleport_back_to_lobby:InvokeServer("leave")
			end
		end
		wait()
	end
end

function autonext()
	while getgenv().autonext == true do
		if getgenv().loadedallscript == true then
			local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI
			if resultUI and resultUI.Enabled == true then
				wait(3)
				local args = {
					[1] = "next_story",
				}

				game:GetService("ReplicatedStorage").endpoints.client_to_server.set_game_finished_vote
					:InvokeServer(unpack(args))
			end
		end
		wait()
	end
end

function autoJoinPlayer()
	while getgenv().autoJoinPlayer == true do
		if getgenv().loadedallscript == true then
			local ownerStory = workspace:FindFirstChild("_LOBBIES"):FindFirstChild("Story")
			local ownerRaid = workspace._RAID.Raid
			local ownerDungeon = workspace._DUNGEONS.Lobbies
			local ownerChallenge = workspace._CHALLENGES.Challenges
			local ownerDailyChallenge = workspace._CHALLENGES.DailyChallenge
			local ownerEvent = workspace._EVENT_CHALLENGES.Lobbies
			local TempestGpo2 = game.Players:FindFirstChild(LocalPlayer)
			
			function checkOwner(owner)
				if owner then
					for i, v in pairs(owner:GetChildren()) do
						if v:FindFirstChild("Owner") and v.Owner.Value == TempestGpo2 then
							local args = {
								[1] = v
							}
							
							game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_join_lobby"):InvokeServer(unpack(args))	
						end
					end
				end
			end

			checkOwner(ownerStory)
			checkOwner(ownerRaid)
			checkOwner(ownerDungeon)
			checkOwner(ownerChallenge)
			checkOwner(ownerDailyChallenge)
			checkOwner(ownerEvent)
		end
		wait()
	end
end

function autoEnter()
	while getgenv().autoEnter == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
	end
end

function autoEnterChallenge()
    while getgenv().autoEnterChallenge == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
    end
end

function autoEnterDailyChallenge()
	while getgenv().autoEnterDailyChallenge == true do
		if getgenv().loadedallscript == true then
			local args = {
				[1] = "_lobbytemplate320"
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("request_join_lobby"):InvokeServer(unpack(args))
		end
		wait()
	end
end

function autoMatchmakingDailyChallenge()
	while getgenv().autoMatchmakingDailyChallenge == true do
		if getgenv().loadedallscript == true then
			game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer("__DAILY_CHALLENGE")
		end
		wait()
	end
end

function autoEnterInfiniteCastle()
	while getgenv().autoEnterInfiniteCastle == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoEnterRaid()
	while getgenv().autoEnterRaid == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoEnterLegendStage()
	while getgenv().autoEnterLegendStage == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoEnterPortal()
    while getgenv().autoEnterPortal == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
    end
end

function autoNextContrato()
	while getgenv().autoNextContrato == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoNextPortal()
	while getgenv().autoNextPortal == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoCraftShard()
	while getgenv().autoCraftShard == true do
		if getgenv().loadedallscript == true then
			local args = {
				[1] = selectedShardtoCraft,
				[2] = {
					["use10"] = false
				}
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_item"):InvokeServer(unpack(args))
		end
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
		if getgenv().loadedallscript == true then
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
		if getgenv().loadedallscript == true then
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
		if getgenv().loadedallscript == true then
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
		end
		wait(1)
	end
end

function autoGetBattlepass()
	while getgenv().autoGetBattlepass == true do
		if getgenv().loadedallscript == true then
			game:GetService("ReplicatedStorage")
				:WaitForChild("endpoints")
				:WaitForChild("client_to_server")
				:WaitForChild("claim_battlepass_rewards")
				:InvokeServer()
		end
		wait(10)
	end
end

function autoGivePresents()
	while getgenv().autoGivePresents == true do
		if getgenv().loadedallscript == true then
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("feed_easter_meter"):InvokeServer()
		end
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
		if getgenv().loadedallscript == true then
			game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer(selectedMatchmakingMap)
		end
        wait()
    end
end

function autoMatchmakingHolidayEvent()
    while getgenv().matchmakingHoliday == true do
		if getgenv().loadedallscript == true then
        	game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer("christmas_event")
		end
        wait()
    end
end

function autoBuy()
	while getgenv().autoBuy == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoOpenCapsule()
	while getgenv().autoOpenCapsule == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoFeed()
	while getgenv().autoFeed == true do
		if getgenv().loadedallscript == true then
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
		end
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
		if getgenv().loadedallscript == true then	
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
							local selectedWaypointIndex = math.clamp(math.floor(distancePercentage * waypointStep), 1, totalWaypoints)
							local selectedRadius = math.clamp(GroundPercentage * radiusStep, 1, radiusMax)
							local waypoint = waypoints[selectedWaypointIndex]
							placeUnit(unitID, waypoint, selectedRadius)
						end
					end
					
					if StatsServiceClient and StatsServiceClient.module and StatsServiceClient.module.session and StatsServiceClient.module.session.collection and StatsServiceClient.module.session.collection.collection_profile_data and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units then
						local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
						local lanes = workspace._BASES.pve.LANES:FindFirstChild("1")
						local waypoints = lanes:GetChildren()
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
						local selectedWaypointIndex = math.clamp(math.floor(distancePercentage * waypointStep), 1, totalWaypoints)
						local selectedRadius = math.clamp(GroundPercentage * radiusStep, 1, radiusMax)
						local waypoint = waypoints[selectedWaypointIndex]
						placeUnit(unitID, waypoint, selectedRadius)
					end
				end
				
				if StatsServiceClient and StatsServiceClient.module and StatsServiceClient.module.session and StatsServiceClient.module.session.collection and StatsServiceClient.module.session.collection.collection_profile_data and StatsServiceClient.module.session.collection.collection_profile_data.equipped_units then
					local equippedUnits = StatsServiceClient.module.session.collection.collection_profile_data.equipped_units
					local lanes = workspace._BASES.pve.LANES:FindFirstChild("1")
					local waypoints = lanes:GetChildren()
					local radiusMax = 15
				
					placeUnitsWithFemtoPriority(equippedUnits, waypoints, radiusMax)
				end
			end
		end
		wait()
	end
end

function autoUpgrade()
    while getgenv().autoUpgrade == true do
		if getgenv().loadedallscript == true then
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
		end
        wait(1)
    end
end


function autoSell()
    while getgenv().autoSell == true do
		if getgenv().loadedallscript == true then
			local units = workspace:FindFirstChild("_UNITS")
			if units and units._stats.uuid.Value ~= "neutral" then
				local wave = workspace:FindFirstChild("_wave_num")
				if getgenv().onlysellinXwave == true then
					if selectedWaveToSell == wave then
						for _, v in pairs(units:GetChildren()) do
							local args = {
								[1] = game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"):WaitForChild(v)
							}
							game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("sell_unit_ingame"):InvokeServer(unpack(args))
						end
					end
				else
					for _, v in pairs(units:GetChildren()) do
						local args = {
							[1] = game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"):WaitForChild(v)
						}
						game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("sell_unit_ingame"):InvokeServer(unpack(args))
					end
				end
			end
		end
        wait()
    end
end

function autoSellFarmWaveX()
    while getgenv().autoSellFarmWaveX == true do
		if getgenv().loadedallscript == true then
			local wave = workspace:FindFirstChild("_wave_num")
			if wave and wave == onlysellFarminXwave then
				local units = workspace:FindFirstChild("_UNITS")
				if units and units._stats.uuid.Value ~= "neutral" then
					for _, v in pairs(units:GetChildren()) do
						if v.Name == "speedwagon" or v.Name == "bulma" then
							local args = {
								[1] = game:GetService("ReplicatedStorage"):WaitForChild("_DEAD_UNITS"):WaitForChild(v)
							}
							game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("sell_unit_ingame"):InvokeServer(unpack(args))
						end
					end
				end
			end
		end
        wait()
    end
end

function universalSkill()
    while getgenv().universalSkill == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
    end
end

function dupeVegeto()
    while getgenv().dupeVegeto == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
    end
end

function dupeGriffith()
    while getgenv().dupeGriffith == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
    end
end

function autoSacrificeGriffith()
    while getgenv().autoSacrificeGriffith == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
    end
end

function autoContractMatchmaking()
    while getgenv().autoContractMatchmaking == true do
		if getgenv().loadedallscript == true then
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
		end
        wait()
    end
end

function autoContract()
    while getgenv().autoContract == true do
		if getgenv().loadedallscript == true then
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
		end
        wait(1)
    end
end

function autoEquipTeam()
	while getgenv().autoEquipTeam == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function autoRollPassive()
	while getgenv().autoRollPassive == true do
		if getgenv().loadedallscript == true then
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
		end
		wait()
	end
end

function webhook()
    while getgenv().webhook == true do
		if getgenv().loadedallscript == true then
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
		if getgenv().loadedallscript == true then
			local args = {
				[1] = "SakamotoEvent",
				[2] = "gems10"
			}
			
			game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("buy_from_banner"):InvokeServer(unpack(args))
		end
		wait()
	end
end

-- Get Informations for Dropdown or other things

function safeGetChildren(parent, name)
    local object = parent:FindFirstChild(name)
    if object then
        return object:GetChildren()
    else
        return {}
    end
end

function printChallenges(module)
    local challengesKeys = {}
    if module.challenges then
        for key, value in pairs(module.challenges) do
            table.insert(challengesKeys, key)
        end
    end
    return challengesKeys
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
        if not string.find(key, "bundle") and not string.find(key, "gift") then
            table.insert(ValuesItemShop, key)
        end
    end
else
    warn("ShopItems module not found.")
end

local itemModels = safeGetChildren(game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("assets"), "ItemModels")
local ValuesItemsToFeed = {}
for i, v in pairs(itemModels) do
    table.insert(ValuesItemsToFeed, v.Name)
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

local namePortal = safeGetChildren(game:GetService("ReplicatedStorage").packages.assets, "ItemModels")
local ValuesPortalName = {}
for i, v in pairs(namePortal) do
    if string.find(v.Name:lower(), "portal") then
        table.insert(ValuesPortalName, v.Name)
    end
end

local Players = game.Players
local ValuesPlayersName = {}
for i, v in pairs(Players:GetChildren()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
        table.insert(ValuesPlayersName, v.Name)
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
	MainSection26 = tabs.Settings:Section({ Side = "Left" }),
}

sections.MainSection1:Header({
	Name = "Player"
})

sections.MainSection1:Toggle({
	Name = "Hide Player Info",
	Default = false,
	Callback = function(value)
		getgenv().hideInfoPlayer = value
		hideInfoPlayer()
	end,
}, "HidePlayerInfo")

sections.MainSection1:Toggle({
	Name = "Auto Walk",
	Default = false,
	Callback = function(value)
		getgenv().autoWalk = value
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
		selecteQuantityPlayer = value
	end,
}, "dropdownSelectPlayer")

sections.MainSection1:Toggle({
	Name = "Security Mode",
	Default = false,
	Callback = function(value)
		getgenv().securityMode = value
		securityMode()
	end,
}, "SecurityMode")

sections.MainSection1:Toggle({
	Name = "Delete Map",
	Default = false,
	Callback = function(value)
		getgenv().deletemap = value
		deletemap()
	end,
}, "DeleteMap")

sections.MainSection1:Toggle({
	Name = "Auto Leave",
	Default = false,
	Callback = function(value)
		getgenv().autoleave = value
		autoleave()
	end,
}, "AutoLeave")

sections.MainSection1:Toggle({
	Name = "Auto Replay",
	Default = false,
	Callback = function(value)
		getgenv().autoreplay = value
		autoreplay()
	end,
}, "AutoReplay")

sections.MainSection1:Toggle({
	Name = "Auto Next",
	Default = false,
	Callback = function(value)
		getgenv().autonext = value
		autonext()
	end,
}, "AutoNext")

sections.MainSection1:Toggle({
	Name = "Auto Next Portal",
	Default = false,
	Callback = function(value)
		getgenv().autoNextPortal = value
		autoNextPortal()
	end,
}, "AutoNextPortal")

sections.MainSection1:Toggle({
	Name = "Auto Next Contract",
	Default = false,
	Callback = function(value)
		getgenv().autoNextContrato = value
		autoNextContrato()
	end,
}, "AutoNextContract")

sections.MainSection1:Toggle({
	Name = "Auto Start",
	Default = false,
	Callback = function(value)
		getgenv().autostart = value
		autostart()
	end,
}, "AutoStart")

sections.MainSection1:Toggle({
	Name = "Auto Skip Wave",
	Default = false,
	Callback = function(value)
		getgenv().autoskipwave = value
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
		getgenv().autoGetBattlepass = value
		autoGetBattlepass()
	end,
}, "autoGetBattlepass")

sections.MainSection2:Toggle({
	Name = "Auto Get Quest",
	Default = false,
	Callback = function(value)
		getgenv().autoGetQuest = value
		autoGetQuest()
	end,
}, "autoGetQuest")

sections.MainSection2:Toggle({
	Name = "Disable Notifications",
	Default = false,
	Callback = function(value)
		getgenv().disableNotifications = value
		disableNotifications()
	end,
}, "DisableNotifications")

sections.MainSection2:Toggle({
	Name = "Place In Red Zones",
	Default = false,
	Callback = function(value)
		getgenv().placeInRedZones = value
		placeInRedZones()
	end,
}, "PlaceInRedZones")

sections.MainSection2:Toggle({
	Name = "Show Info Units",
	Default = false,
	Callback = function(value)
		getgenv().showInfoUnits = value
		showInfoUnits()
	end,
}, "ShowInfoUnits")

sections.MainSection2:Toggle({
	Name = "Friends Only",
	Default = false,
	Callback = function(value)
		selectedFriendsOnly = value
	end,
}, "FriendsOnly")

sections.MainSection2:Toggle({
	Name = "Auto Give Presents",
	Default = false,
	Callback = function(value)
		getgenv().autoGivePresents = value
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
	Options = valuesUnitId,
	Default = None,
	Callback = function(value)
		selectedUnitToRoll = value:match(".* | .* | (.+)")
	end,
}, "RollUnit")

local Dropdown = sections.MainSection4:Dropdown({
	Name = "Select Passive",
	Multi = true,
	Required = true,
	Options = passivesvalues,
	Default = None,
	Callback = function(value)
		selectedPassiveToRoll = value
	end,
}, "dropdownSelectPassiveToRoll")

sections.MainSection4:Toggle({
	Name = "Auto Roll",
	Default = false,
	Callback = function(value)
		getgenv().autoRollPassive = value
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
	Options = valuesUnitId,
	Default = None,
	Callback = function(value)
		selectedUnitToRoll = value:match(".* | .* | (.+)")
	end,
}, "FeedUnit")

local Dropdown = sections.MainSection5:Dropdown({
	Name = "Select Unit to Feed",
	Multi = true,
	Required = true,
	Options = valuesItemsToFeed,
	Default = None,
	Callback = function(value)
		selectedFeed = value
	end,
}, "dropdownSelectItemsToFeed")

sections.MainSection5:Toggle({
	Name = "Auto Feed",
	Default = false,
	Callback = function(value)
		getgenv().autoFeed = value
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
	Callback = function(value)
		urlwebhook = value
	end,
	onChanged = function(value)
        urlwebhook = value
	end,
}, "WebhookURL")

sections.MainSection3:Input({
	Name = "User ID",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
		urlwebhook = value
	end,
	onChanged = function(value)
        urlwebhook = value
	end,
}, "pingUser@")

sections.MainSection3:Toggle({
	Name = "Send Webhook when finish game",
	Default = false,
	Callback = function(value)
        getgenv().webhook = value
        webhook()
	end,
}, "WebhookFinishGame")

sections.MainSection3:Toggle({
	Name = "Ping user",
	Default = false,
	Callback = function(value)
        getgenv().pingUser = value
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
	Options = PortalMapvalues,
	Default = None,
	Callback = function(value)
		selectedPortalMap = value
	end,
}, "dropdownPortalMap")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Tier",
	Multi = true,
	Required = true,
	Options = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"},
	Default = None,
	Callback = function(value)
		selectedTierPortal = value
	end,
}, "dropdownTierPortal")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Ignore Difficulty",
	Multi = true,
	Required = true,
	Options = challengevalues,
	Default = None,
	Callback = function(value)
        selectedPortalDiff = value
	end,
}, "dropdownSelectChallengePortal")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Ignore Dmg bonus",
	Multi = true,
	Required = true,
	Options = dmgBonus,
	Default = None,
	Callback = function(value)
		selectedIgnoreDmgBonus = value
	end,
}, "dropdownIgnoreDmgBonusPortal")

sections.MainSection6:Toggle({
	Name = "Auto Open Portal",
	Default = false,
	Callback = function(value)
		getgenv().autoEnterPortal = value
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
		selectedMatchmakingMap = value
	end,
}, "dropdownMatchmakingMap")

sections.MainSection7:Toggle({
	Name = "Auto Matchmaking",
	Default = false,
	Callback = function(value)
		getgenv().AutoMatchmaking = value
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
        selectedTierContract = value
	end,
}, "dropdownSelectTierContract")

local Dropdown = sections.MainSection8:Dropdown({
	Name = "Select Ignore Challenge",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
        selectedIgnoreContractChallenge = value
	end,
}, "dropdownSelectIgnoreChallengeContract")


sections.MainSection8:Toggle({
	Name = "Auto Matchmaking Contract",
	Default = false,
	Callback = function(value)
        getgenv().autoContractMatchmaking = value
        autoContractMatchmaking()
	end,
}, "AutoMatchmakingContract")

sections.MainSection8:Toggle({
	Name = "Auto Contract",
	Default = false,
	Callback = function(value)
        getgenv().autoContract = value
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
		getgenv().selectedHardInfCastle = value
	end,
}, "HardInfCastle")

sections.MainSection9:Toggle({
	Name = "Auto Enter Inf Castle",
	Default = false,
	Callback = function(value)
		getgenv().autoEnterInfiniteCastle = value
		autoEnterInfiniteCastle()
	end,
}, "AutoEnterInfCastle")


sections.MainSection9:Toggle({
	Name = "Auto Join Cursed Womb",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinCursedWomb = value
		autoJoinCursedWomb()
	end,
}, "AutoJoinCursedWomb")

local Dropdown = sections.MainSection8:Dropdown({
	Name = "Select Player",
	Multi = true,
	Required = true,
	Options = ValuesPlayersName,
	Default = None,
	Callback = function(value)
        selectedPlayerToJoin = value
	end,
}, "drodpownPlayerToJoin")

sections.MainSection9:Toggle({
	Name = "Auto Join Player",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinPlayer = value
		autoJoinPlayer()
	end,
}, "AutoJoinPlayer")

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
		selectedMap = value
	end,
}, "dropdownStoryMap")

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Difficulty",
	Multi = false,
	Required = true,
	Options = {"Normal", "Hard"},
	Default = None,
	Callback = function(value)
		selectedDifficulty = value
	end,
}, "dropdownSelectDifficultyStory")

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = {"1", "2", "3", "4", "5", "6", "Infinite"},
	Default = None,
	Callback = function(value)
		selectedAct = value
	end,
}, "dropdownSelectActStory")

sections.MainSection10:Toggle({
	Name = "Auto Enter",
	Default = false,
	Callback = function(value)
		getgenv().autoEnter = value
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
        selectedMapChallenges = value
	end,
}, "dropdownChallengeMap")

local Dropdown = sections.MainSection11:Dropdown({
	Name = "Select Difficulty",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
        selectedChallengesDiff = value
	end,
}, "dropdownSelectChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Enter Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterChallenge = value
        autoEnterChallenge()
	end,
}, "AutoEnterChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Enter Daily Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterDailyChallenge = value
        autoEnterDailyChallenge()
	end,
}, "AutoEnterDailyChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Matchmaking Daily Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoMatchmakingDailyChallenge = value
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
        selectedRaidMap = value
	end,
}, "dropdownSelectRaid")

sections.MainSection12:Toggle({
	Name = "Auto Enter Raid",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterRaid = value
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
        selectedLegendStageMap = value
	end,
}, "dropdownSelectLegendStage")

sections.MainSection13:Toggle({
	Name = "Auto Enter Legend Stage",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterLegendStage = value
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
		selectedTeamStoryInf = value
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
		selectedTeamInfTower = value
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
		selectedTeamPhysicContract = value
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
		selectedTeamMagicContract = value
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
		selectedTeamPhysicChallengeDailyChallenge = value
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
		selectedTeamMagicChallengeDailyChallenge = value
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
		selectedTeamChallengeDailyChallenge = value
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
		selectedTeamRaid = value
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
		getgenv().dupeGriffith = value
		dupeGriffith()
	end,
}, "DupeGriffith")

sections.MainSection19:Toggle({
	Name = "Dupe Vegeto",
	Default = false,
	Callback = function(value)
		getgenv().dupeVegeto = value
		dupeVegeto()
	end,
}, "DupeVegeto")

sections.MainSection19:Toggle({
	Name = "Inf Range",
	Default = false,
	Callback = function(value)
		getgenv().InfRange = value
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
        getgenv().autoChooseCard = value
        if value then
            autoChooseCard()
        end
	end,
}, "AutoCard")

sections.MainSection20:Toggle({
	Name = "Focus Buff",
	Default = false,
	Callback = function(value)
        getgenv().focusBuff = value
	end,
}, "FocusBuff")

sections.MainSection20:Toggle({
	Name = "Focus Debuff",
	Default = false,
	Callback = function(value)
        getgenv().focusDebuff = value
	end,
}, "FocusDebuff")

sections.MainSection21:Header({
	Name = "Unit"
})

sections.MainSection21:Input({
	Name = "Start Place at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        selectedWaveToPlace = value
	end,
	onChanged = function(value)
        selectedWaveToPlace = value
	end,
}, "inputAutoPlaceWaveX")

sections.MainSection21:Slider({
	Name = "Distance Percentage",
	Default = distancePercentage or 50,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percent",
	Precision = 1,
	Callback = function(Value)
		distancePercentage = math.round(Value) or MacLib.Options.distancePercentage.Value
	end
}, "distancePercentage")

sections.MainSection21:Slider({
	Name = "Ground Percentage",
	Default = GroundPercentage or 50,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percent",
	Precision = 1,
	Callback = function(Value)
		GroundPercentage = math.round(Value) or MacLib.Options.GroundPercentage.Value
	end,
}, "GroundPercentage")

sections.MainSection21:Slider({
	Name = "Hill Percentage",
	Default = HillPercentage or 50,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percent",
	Precision = 1,
	Callback = function(Value)
		HillPercentage = math.round(Value) or MacLib.Options.HillPercentage.Value
	end,
}, "HillPercentage")

sections.MainSection21:Toggle({
    Name = "Auto Place",
    Default = false,
    Callback = function(value)
        getgenv().autoPlace = value
        if value then
			distancePercentage = MacLib.Options.distancePercentage.Value
            GroundPercentage = MacLib.Options.GroundPercentage.Value
            HillPercentage = MacLib.Options.HillPercentage.Value
            autoPlace()
        end
    end,
}, "AutoPlace")

sections.MainSection21:Toggle({
	Name = "Only Start Place in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().OnlyautoPlace = value
	end,
}, "OnlyStartPlaceInXWave")

sections.MainSection21:Input({
	Name = "Start Upgrade at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        selectedWaveToUpgrade = value
	end,
	onChanged = function(value)
        selectedWaveToUpgrade = value
	end,
}, "inputAutoUpgradeWaveX")

sections.MainSection21:Toggle({
	Name = "Focus Farm",
	Default = false,
	Callback = function(value)
		getgenv().focusFarm = value
	end,
}, "FocusInFarm")

sections.MainSection21:Toggle({
	Name = "Focus Griffith",
	Default = false,
	Callback = function(value)
		getgenv().focusGriffith = value
	end,
}, "FocusInGriffith")

sections.MainSection21:Toggle({
	Name = "Auto Upgrade",
	Default = false,
	Callback = function(value)
		getgenv().autoUpgrade = value
		autoUpgrade()
	end,
}, "AutoUpgrade")

sections.MainSection21:Toggle({
	Name = "Only Upgrade in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlyupgradeinXwave = value
	end,
}, "OnlyUpgradeInXWave")

sections.MainSection21:Input({
	Name = "Start Sell at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        selectedWaveToSell = value
	end,
	onChanged = function(value)
        selectedWaveToSell = value
	end,
}, "inputAutoSellWaveX")

sections.MainSection21:Toggle({
	Name = "Auto Sell",
	Default = false,
	Callback = function(value)
		getgenv().autoSell = value
		autoSell()
	end,
}, "AutoSell")

sections.MainSection21:Input({
	Name = "Only Sell Farm in X Wavee",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        onlysellFarminXwave = value
	end,
	onChanged = function(value)
        onlysellFarminXwave = value
	end,
}, "OnlySellFarmInXWave")

sections.MainSection21:Toggle({
	Name = "Auto Sell Farm",
	Default = false,
	Callback = function(value)
		getgenv().autoSellFarmWaveX = value
		autoSellFarmWaveX()
	end,
}, "autoSellFarmWaveX")

sections.MainSection21:Input({
	Name = "Auto Leave at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        selectedWaveToLeave = value
	end,
	onChanged = function(value)
        selectedWaveToLeave = value
	end,
}, "inputAutoSellWaveX")

sections.MainSection21:Toggle({
	Name = "Auto Leave",
	Default = false,
	Callback = function(value)
		getgenv().autoLeaveInXWave = value
		autoLeaveInXWave()
	end,
}, "AutoLeaveInXWave")

sections.MainSection22:Header({
	Name = "Skill"
})

sections.MainSection22:Input({
	Name = "Start Skill at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(value)
        selectedWaveToUniversalSkill = value
	end,
	onChanged = function(value)
        selectedWaveToUniversalSkill = value
	end,
}, "inputAutoSkillWaveX")

sections.MainSection22:Toggle({
	Name = "Auto Universal Skill",
	Default = false,
	Callback = function(value)
		getgenv().universalSkill = value
		universalSkill()
	end,
}, "AutoUniversalSkill")

sections.MainSection22:Toggle({
	Name = "Only Universal Skill in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().universalSkillinXWave = value
	end,
}, "OnlyUniversalSkillinXWave")

sections.MainSection22:Toggle({
	Name = "Auto Sacrifice Griffith",
	Default = false,
	Callback = function(value)
		getgenv().autoSacrificeGriffith = value
		autoSacrificeGriffith()
	end,
}, "AutoSacrificeGriffith")

sections.MainSection22:Toggle({
	Name = "Auto Buff Erwin",
	Default = false,
	Callback = function(value)
		toggle = value
		if toggle then
			UseActiveAttackE()
		end
	end,
}, "AutoBuffErwin")

sections.MainSection22:Toggle({
	Name = "Auto Buff Wenda",
	Default = false,
	Callback = function(value)
		toggle2 = value
		if toggle2 then
			UseActiveAttackW()
		end
	end,
}, "AutoBuffWenda")

sections.MainSection22:Toggle({
	Name = "Auto Buff Leafy",
	Default = false,
	Callback = function(value)
		toggle3 = value
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
		selectedCapsule = value
	end,
}, "dropdownSelectCapsule")

sections.MainSection24:Toggle({
	Name = "Auto Open Capsule",
	Default = false,
	Callback = function(value)
		getgenv().autoOpenCapsule = value
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
		selectedShardtoCraft = value
	end,
}, "dropdownSelectShardToCraft")

sections.MainSection24:Toggle({
	Name = "Auto Craft Shards",
	Default = false,
	Callback = function(value)
		getgenv().autoCraftShard = value
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
		selectedItemToBuy = value
	end,
}, "dropdownSelectItemToBuy")

sections.MainSection24:Toggle({
	Name = "Auto Buy",
	Default = false,
	Callback = function(value)
		getgenv().autoBuy = value
		autoBuy()
	end,
}, "AutoBuy")

sections.MainSection24:Toggle({
	Name = "Auto Roll Sakamoto Event",
	Default = false,
	Callback = function(value)
		getgenv().autoRollSakamotoBanner = value
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
		getgenv().aeuat = value
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
        getgenv().fpsBoost = value
		fpsBoost()
	end,
}, "FPSBoost")

sections.MainSection25:Toggle({
	Name = "Better FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().betterFpsBoost = value
		betterFpsBoost()
	end,
}, "BetterFPSBoost")

sections.MainSection25:Toggle({
	Name = "REALLY Better FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().extremeFpsBoost = value
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
MacLib:SetFolder("Tempest Hub/_AA_")
local GameConfigName = "_AA_"
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
createBC()
createInfoUnit()
hideUI()
getgenv().loadedallscript = true