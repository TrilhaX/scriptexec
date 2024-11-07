local repo = "https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
wait(1)
Library:Notify("Welcome to Tempest Hub", 3)
warn("[TEMPEST HUB] Loading Ui")
wait(1)

local Window = Library:CreateWindow({
	Title = "Tempest Hub | Anime Strike",
	Center = false,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

Library:Notify("Loading Anime Strike Script", 2)
warn("[TEMPEST HUB] Loading Function")
wait(1)
warn("[TEMPEST HUB] Loading Toggles")
wait(1)
warn("[TEMPEST HUB] Last Checking")
wait(1)

function autoclick()
	while getgenv().autoclick == true do
		local args = {
    		[1] = "Attack",
    		[2] = "Click"
		}

		game:GetService("ReplicatedStorage").Bridge:FireServer(unpack(args))
		wait()
	end
end

function autobest()
	while getgenv().autobest == true do
		local args = {
			[1] = "Pets",
			[2] = "Best"
		}

		game:GetService("ReplicatedStorage").Bridge:FireServer(unpack(args))
		wait()
	end
end

function autoNinjaExam()
	while getgenv().autoNinjaExam == true do
		local args = {
			[1] = "NinjaExam",
			[2] = "StartMode"
		}

		game:GetService("ReplicatedStorage").Bridge:FireServer(unpack(args))
		wait()
	end
end

function autoFarm()
	while getgenv().autoFarm == true do
		if selectedMob == ValueMobsName then
			
		wait()
	end
end

local mobs = workspace.Server.WorldMobs
local printedNames = {}

for i, v in pairs(mobs:GetChildren()) do
    for _, k in pairs(v:GetChildren()) do
        if not printedNames[k.Name] then
            table.insert(k, ValueMobsName)
            printedNames[k.Name] = true
        end
    end
end


RightGroupBox:AddDropdown('mobs', {
    Values = ValueMobsName,
    Default = "None",
    Multi = false,
    Text = 'Choose Mob',
    Callback = function(value)
        selectedMob = value
    end
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
SaveManager:SetFolder("Tempest Hub/_Anime_Strike_")

SaveManager:BuildConfigSection(TabsUI["UI Settings"])

ThemeManager:ApplyToTab(TabsUI["UI Settings"])

SaveManager:LoadAutoloadConfig()

local GameConfigName = "_Anime_Strike_"
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