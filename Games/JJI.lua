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
	Title = "Tempest Hub | Jujutsu Infinite",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

Library:Notify("Loading Jujutsu Infinite Script", 5)
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
local speed = 10000

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
                    wait(1)
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

function HitKill()
	while getgenv().HitKill == true do
		local mobs = workspace.Objects:FindFirstChild("Mobs")

		if mobs then
			for i, v in pairs(mobs:GetChildren()) do
				local health = v.Humanoid
				health.Health = 0
			end
		end
		wait()
	end
end

function getSkill()
	local keybinds = game:GetService("Players").LocalPlayer.ReplicatedData.techniques.innates

	for i, v in pairs(keybinds:GetChildren()) do
		if selectedKeybind == v.Name then
			print(selectedKeybind)
			print(selectedInate)
			v.Value = selectedInate
			print(v.Value)
		end
	end
	wait()
end

function tpToItem()
	local drops = workspace.Objects.Drops


	for i,v in pairs(drops:GetChildren())do
		if selectedItem == v.Name then
			print(selectedItem)
			print(v.Name)
			local teleportCFrame = GetCFrame(v.Root)
			print(teleportCFrame)
			local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
			tween:Play()
			tween.Completed:Wait()
			break
		end
	end
end

local ValuesInates = {}
local ValuesKeybinds = {}
local keybinds = game:GetService("Players").LocalPlayer.ReplicatedData.techniques.innates

for i, v in pairs(keybinds:GetChildren()) do
	table.insert(ValuesKeybinds, v.Name)
end

local skills = game:GetService("ReplicatedStorage").Skills

for i, v in pairs(skills:GetChildren()) do
	table.insert(ValuesInates, v.Name)
end

local drops = workspace.Objects.Drops
local ValuesDrops = {}

local function contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

for _, v in pairs(drops:GetChildren()) do

    if not contains(ValuesDrops, v.Name) then
        table.insert(ValuesDrops, v.Name)
    end
end

local Tabs = {
	Main = Window:AddTab("Main"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Player")

LeftGroupBox:AddToggle("HK", {
	Text = "Hit Kill",
	Default = false,
	Callback = function(Value)
		getgenv().HitKill = Value
		HitKill()
	end,
})

LeftGroupBox:AddDropdown("FeedUnit", {
	Values = ValuesKeybinds,
	Default = "None",
	Multi = false,
	Text = "Select Keybind",

	Callback = function(value)
		selectedKeybind = value
	end,
})

LeftGroupBox:AddDropdown("dropdownSelectItemsToFeed", {
	Values = ValuesInates,
	Default = "None",
	Multi = false,
	Text = "Select Inate Skill",
	Callback = function(Value)
		selectedInate = Value
	end,
})

local MyButton = LeftGroupBox:AddButton({
	Text = "Set Skill",
	Func = function()
		getSkill()
	end,
	DoubleClick = false,
})

LeftGroupBox:AddDropdown("dropdownSelectItemsToFeed", {
	Values = ValuesDrops,
	Default = "None",
	Multi = false,
	Text = "Select Item To Tp",
	Callback = function(Value)
		selectedItem = Value
	end,
})

local MyButton = LeftGroupBox:AddButton({
	Text = "Tp to Item",
	Func = function()
		tpToItem()
	end,
	DoubleClick = false,
})

local MyButton = LeftGroupBox:AddButton({
	Text = "Refresh Items Dropdown",
	Func = function()
		Options.dropdownSelectItemsToFeed:SetValue(ValuesDrops)
	end,
	DoubleClick = false,
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
SaveManager:SetFolder("Tempest Hub/_JJI_")

SaveManager:BuildConfigSection(TabsUI["UI Settings"])

ThemeManager:ApplyToTab(TabsUI["UI Settings"])

SaveManager:LoadAutoloadConfig()

local GameConfigName = "_JJI_"
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
