local repo = "https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
wait(1)
Library:Notify("Welcome to Tempest Hub", 3)
warn("[TEMPEST HUB] Loading Ui")
wait(1)

local Window = Library:CreateWindow({
	Title = "Tempest Hub | Anime Vanguards",
	Center = false,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

Library:Notify("Loading Anime Vanguards Script", 2)
warn("[TEMPEST HUB] Loading Function")
wait(1)
warn("[TEMPEST HUB] Loading Toggles")
wait(1)
warn("[TEMPEST HUB] Last Checking")
wait(1)

function HidePlayer()
	local Player = game.Players.LocalPlayer
	local character = Player.Character
	local Tag = character:FindFirstChild("Torso") and character.Torso:FindFirstChild("Tag")
	local LevelPlayer = Player.PlayerGui:FindFirstChild("HUD")
		and Player.PlayerGui.HUD.Main:FindFirstChild("Level")
		and Player.PlayerGui.HUD.Main.Level.Level
	local Currencies = Player.PlayerGui:FindFirstChild("HUD") and Player.PlayerGui.HUD.Main:FindFirstChild("Currencies")
	local Gold = Currencies and Currencies:FindFirstChild("Coins")
	local Gems = Currencies and Currencies:FindFirstChild("Gems")
	local Units = Player.PlayerGui:FindFirstChild("HUD") and Player.PlayerGui.HUD.Main:FindFirstChild("Units")
	local UnitsFolder = workspace:FindFirstChild("PetFolder")
	local blacklist = {
		"UIAspectRatioConstraint",
		"UIListLayout",
		"Highlight",
	}

	local locations = {
		Tag,
		LevelPlayer,
		Gold,
		Gems,
		Units,
		UnitsFolder,
	}

	for _, location in pairs(locations) do
		if not location then
			print("Um local não existe ou já foi usado.")
			return
		end
	end

	for i, v in pairs(Units:GetChildren()) do
		if not table.find(blacklist, v.ClassName) then
			local imageHolder = v:FindFirstChild("UnitTemplate")
			if imageHolder and imageHolder:FindFirstChild("Holder") and imageHolder.Holder:FindFirstChild("Main") then
				local unitImage = imageHolder.Holder.Main:FindFirstChild("UnitImage")
				if unitImage and unitImage.Image ~= "" then
					unitImage:Destroy()
					imageHolder.Holder.Main.Price:Destroy()
					imageHolder.Holder.Main.LevelFrame:Destroy()
					LevelPlayer:Destroy()
					Gold.Coins.Text = "9999999999999"
					Gems.Gems.Text = "9999999999999"
					Tag:Destroy()
					print("Hide Player Actived")
					for J, K in pairs(UnitsFolder:GetChildren()) do
						if not table.find(blacklist, K.ClassName) then
							K:Destroy()
						end
					end
				else
					wait(1)
				end
			end
		end
		wait()
	end
end

function deleteMap()
	local trees = workspace.Map.Trees
	local structures = workspace.Map["Namek Structures"]
	local Effects = workspace.Map.Effects
	local otherProps = workspace.Map["Other Props"]
	local bases = workspace.Map.Bases

	if trees and structures and Effects and otherProps and bases then
		trees:Destroy()
		structures:Destroy()
		Effects:Destroy()
		otherProps:Destroy()
		bases:Destroy()
		print("All deleted")
	else
		print("One or more objects do not exist")
	end
end

function securityMode()
	print("Security Mode Actived")
	local players = game:GetService("Players")

	if #players:GetPlayers() >= 2 then
		local player1 = players:GetPlayers()[1]
		local targetPlaceId = 16146832113

		if game.PlaceId ~= targetPlaceId then
			game:GetService("TeleportService"):Teleport(targetPlaceId, player1)
		end
	end
end

function joinLobby()
	while getgenv().joinLobby == true do
		local blacklist = {
			"Misc",
			"Invisible",
		}
		local mapas = game:GetService("ReplicatedStorage").Assets.Models.Enemies

		for i, v in pairs(mapas:GetChildren()) do
			if not table.find(blacklist, v.name) then
				print(v.name)
				local args = {
					[1] = "Enter",
					[2] = workspace.MainLobby.Lobby.Lobby,
				}

				game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(args))
				wait(1)
				local args = {
					[1] = "Confirm",
					[2] = {
						[1] = "Story",
						[2] = stagioLobby,
						[3] = actLobby,
						[4] = difficultyLobby,
						[5] = 4,
						[6] = 0,
						[7] = false,
					},
				}

				game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(args))
				wait(1)
				local args = {
					[1] = "Start",
				}

				game:GetService("ReplicatedStorage").Networking.LobbyEvent:FireServer(unpack(args))
			end
		end
		wait(1)
	end
end

function leave()
	while getgenv().leave == true do
		local args = {
			[1] = "Lobby",
		}

		game:GetService("ReplicatedStorage").Networking.TeleportEvent:FireServer(unpack(args))
		wait(1)
	end
end

function replay()
	while getgenv().replay == true do
		local args = {
			[1] = "Replay",
		}

		game:GetService("ReplicatedStorage").Networking.TeleportEvent:FireServer(unpack(args))
		wait(1)
	end
end

function autoNext()
	while getgenv().autoNext == true do
		local args = {
			[1] = "Next",
		}

		game:GetService("ReplicatedStorage").Networking.TeleportEvent:FireServer(unpack(args))
		wait(1)
	end
end

function SkipWave()
	while getgenv().SkipWave == true do
		local args = {
			[1] = "Skip",
		}

		game:GetService("ReplicatedStorage").Networking.SkipWaveEvent:FireServer(unpack(args))
		wait(1)
	end
end

function disableNot()
	local notInfo = game:GetService("Players").LocalPlayer.PlayerGui.Notification
	local itemNot = game:GetService("Players").LocalPlayer.PlayerGui.ItemNotifications

	if notInfo and itemNot then
		notInfo:Destroy()
		itemNot:Destroy()
		print("Disabling Notifications...")
	else
		print("Already Disabled Notifications")
	end
end

function autoUpgrade()
	while getgenv().autoUpgrade == true do
		local unitsInMap = workspace.Units
		local wave = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Map.WavesAmount

		if tonumber(wave.Text) >= 9 then
			for i, v in pairs(unitsInMap:GetChildren()) do
				local args = {
					[1] = "Upgrade",
					[2] = tostring(v),
				}

				game:GetService("ReplicatedStorage").Networking.UnitEvent:FireServer(unpack(args))
				wait(0.5)
			end
		end
		wait(0.5)
	end
end

function autoSell()
	while getgenv().autoSell == true do
		local unitsInMap = workspace.Units
		local wave = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Map.WavesAmount

		if tonumber(wave.Text) >= 9 then
			for i, v in pairs(unitsInMap:GetChildren()) do
				local args = {
					[1] = "Sell",
					[2] = tostring(v),
				}

				game:GetService("ReplicatedStorage").Networking.UnitEvent:FireServer(unpack(args))
				wait(0.5)
			end
		end
		wait(0.5)
	end
end

function autoSummon()
	while getgenv().autoSummon == true do
		local unitsBanner = game:GetService("Players").LocalPlayer.PlayerGui.SummonBillboard.Main
		local left = unitsBanner.Left.UnitName
		local middle = unitsBanner.Middle.UnitName
		local right = unitsBanner.Right.UnitName

		if left and middle and right then
			if selectedUnit then
				print("Unit in Banner")
				local args = {
					[1] = typeSummon,
					[2] = "Special",
				}

				game:GetService("ReplicatedStorage").Networking.Units.SummonEvent:FireServer(unpack(args))
				wait(1)
			else
				print("Nothing in Banner")
			end
		else
			print("No banner here")
		end

		wait(1)
	end
end

function getQuest()
	while getgenv().getQuest == true do
		local quests = game:GetService("Players").LocalPlayer.PlayerGui.Windows.Quests.Holder.Main.Quests

		for i, v in pairs(quests:GetChildren()) do
			local args = {
				[1] = v,
			}

			game:GetService("ReplicatedStorage").Networking.Quests.ClaimQuest:FireServer(unpack(args))
		end
		wait(0.5)
	end
end

local ValuesGamemode = {}
local ValuesStagios = {}
local ValuesAct = {}
local ValuesDifficulty = {}
local ValueUnitsToGet = {}

local Stages = game:GetService("ReplicatedStorage").Modules.Data.StagesData.Story
local printedNames = {}

for _, stage in pairs(Stages:GetChildren()) do
	table.insert(ValuesStagios, stage.Name)
	for _, childContainer in pairs(stage:GetChildren()) do
		if childContainer:IsA("Folder") or childContainer:IsA("Model") then
			for _, act in pairs(childContainer:GetChildren()) do
				if not printedNames[act.Name] then
					table.insert(ValuesAct, act.Name)
					printedNames[act.Name] = true
				end
			end
		end
	end
end

local units = game:GetService("ReplicatedStorage").Assets.Models.Units
local blacklist = {
	"Shiny",
	"Evolved",
}

for i, v in pairs(units:GetChildren()) do
	if not table.find(blacklist, v.name) then
		table.insert(ValueUnitsToGet, v.name)
	end
end

local Tabs = {
	Main = Window:AddTab("Main"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Player")

LeftGroupBox:AddToggle("AutoJoinMap", {
	Text = "Hide Player",
	Default = false,
	Callback = function(Value)
		getgenv().HidePlayer = Value
		HidePlayer()
	end,
})

LeftGroupBox:AddToggle("AutoJoinMap", {
	Text = "Security Mode",
	Default = false,
	Callback = function(Value)
		getgenv().securityMode = Value
		securityMode()
	end,
})

LeftGroupBox:AddToggle("AutoJoinMap", {
	Text = "Delete Map",
	Default = false,
	Callback = function(Value)
		getgenv().deleteMap = Value
		deleteMap()
	end,
})

LeftGroupBox:AddToggle("AutoJoinMap", {
	Text = "Disable Notifications",
	Default = false,
	Callback = function(Value)
		getgenv().disableNot = Value
		disableNot()
	end,
})

LeftGroupBox:AddToggle("AutoJoinMap", {
	Text = "Auto Leave",
	Default = false,
	Callback = function(Value)
		getgenv().leave = Value
		leave()
	end,
})

LeftGroupBox:AddToggle("AutoJoinMap", {
	Text = "Auto Replay",
	Default = false,
	Callback = function(Value)
		getgenv().replay = Value
		replay()
	end,
})

LeftGroupBox:AddToggle("AutoJoinMap", {
	Text = "Auto Next",
	Default = false,
	Callback = function(Value)
		getgenv().autoNext = Value
		autoNext()
	end,
})

local RightGroupBox = Tabs.Main:AddRightGroupbox("Auto Enter")

RightGroupBox:AddDropdown("VS", {
	Values = ValuesStagios,
	Default = "None",
	Multi = false,
	Text = "Choose Stage",
	Callback = function(value)
		stageLobby = value
	end,
})

RightGroupBox:AddDropdown("VA", {
	Values = ValuesAct,
	Default = "None",
	Multi = false,
	Text = "Choose Act",
	Callback = function(value)
		actLobby = value
	end,
})

RightGroupBox:AddDropdown("VD", {
	Values = { "Normal", "Nightmare" },
	Default = "None",
	Multi = false,
	Text = "Choose Difficulty",
	Callback = function(value)
		difficultyLobby = value
	end,
})

RightGroupBox:AddToggle("AutoJoinMap", {
	Text = "Auto Join Map",
	Default = false,
	Callback = function(Value)
		getgenv().joinLobby = Value
		joinLobby()
	end,
})

local RightGroupBox = Tabs.Main:AddRightGroupbox("Misc")

RightGroupBox:AddInput("WaveUpgrade", {
	Default = "",
	Numeric = true,
	Finished = true,

	Text = "Select Wave To Upgrade Units",

	Placeholder = "Press Enter To Save",

	Callback = function(Value)
		waveSelectedUpgrade = Value
	end,
})

RightGroupBox:AddToggle("AutoJoinMap", {
	Text = "Auto Upgrade",
	Default = false,
	Callback = function(Value)
		getgenv().autoUpgrade = Value
		autoUpgrade()
	end,
})

RightGroupBox:AddInput("WaveUpgrade", {
	Default = "",
	Numeric = true,
	Finished = true,

	Text = "Select Wave To Sell Units",

	Placeholder = "Press Enter To Save",

	Callback = function(Value)
		waveSelectedSell = Value
	end,
})

RightGroupBox:AddToggle("AutoJoinMap", {
	Text = "Auto Sell Units",
	Default = false,
	Callback = function(Value)
		getgenv().autoSell = Value
		autoSell()
	end,
})

local Tabs = {
	Main = Window:AddTab("Shop"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Unit')

LeftGroupBox:AddDropdown("VD", {
	Values = { "Soon"},
	Default = "None",
	Multi = false,
	Text = "Choose Food",
	Callback = function(value)
		selectedFood = value
	end,
})

LeftGroupBox:AddToggle("AutoJoinMap", {
	Text = "Auto Feed Unit",
	Default = false,
	Callback = function(Value)
        print("Soon")
	end,
})

local RightGroupBox = Tabs.Main:AddRightGroupbox("Roll")

RightGroupBox:AddDropdown("VS", {
	Values = ValueUnitsToGet,
	Default = "None",
	Multi = false,
	Text = "Choose Unit",
	Callback = function(value)
		selectedUnit = value
	end,
})

RightGroupBox:AddDropdown("VS", {
	Values = { "1", "10" },
	Default = "None",
	Multi = false,
	Text = "Choose Type of Summon",
	Callback = function(value)
		if value == "1" then
			typeSummon = "SummonOne"
		elseif value == "10" then
			typeSummon = "SummonTen"
		end
	end,
})

RightGroupBox:AddToggle("autoRoll", {
	Text = "Auto Summon",
	Default = false,
	Callback = function(Value)
		getgenv().autoSummon = Value
		autoSummon()
	end,
})

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

	Library:SetWatermark(
		("Tempest Hub | %s fps | %s ms"):format(
			math.floor(FPS),
			math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
		)
	)
end

-- Connect the function to the RenderStepped event
WatermarkConnection = game:GetService("RunService").RenderStepped:Connect(UpdateWatermark)

-- Create tabs for UI settings
local TabsUI = {
	["UI Settings"] = Window:AddTab("UI Settings"),
}

-- Unload function
local function Unload()
	WatermarkConnection:Disconnect()
	print("Unloaded!")
	Library.Unloaded = true
end

-- UI Settings
local MenuGroup = TabsUI["UI Settings"]:AddLeftGroupbox("Menu")

-- Add an unload button
MenuGroup:AddButton("Unload", Unload)

-- Add a label and key picker for the menu keybind
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "End", NoUI = true, Text = "Menu keybind" })

-- Define the ToggleKeybind variable
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder("Tempest Hub")
SaveManager:SetFolder("Tempest Hub/_AV_")

SaveManager:BuildConfigSection(TabsUI["UI Settings"])

ThemeManager:ApplyToTab(TabsUI["UI Settings"])

SaveManager:LoadAutoloadConfig()

local GameConfigName = "_AV_"
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

-- Disable player idling
for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end
warn("[TEMPEST HUB] Loaded")