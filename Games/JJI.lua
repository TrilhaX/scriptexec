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

function autoRetry()
	while getgenv().autoRetry == true do
		local ReadyScreen = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ReadyScreen")
		if ReadyScreen and ReadyScreen.Enabled == true then
			local buttonRetry = ReadyScreen.Frame.Replay
			if buttonRetry and buttonRetry.Visible == true then
				local Drops = workspace.Objects:FindFirstChild("Drops")
				local chest = Drops and Drops:FindFirstChild("Chest")
				local loot = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Loot")
				wait(2)
				if getgenv().autoChest then
					wait(2)
					local dropsChildren = Drops:GetChildren()
					if #dropsChildren ~= 0 or loot.Enabled == true then
						for i, v in pairs(Drops:GetChildren()) do
							if v:FindFirstChild("PlayerOwned") and v.PlayerOwned.Value == game.Players.LocalPlayer then
								wait()
							elseif loot.Enabled == true then
								wait()
							else
								local GuiService = game:GetService("GuiService")
								local VirtualInputManager = game:GetService("VirtualInputManager")
								GuiService.SelectedObject = buttonRetry
								VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
								VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
								break
							end
						end
					else
						local GuiService = game:GetService("GuiService")
						local VirtualInputManager = game:GetService("VirtualInputManager")
						GuiService.SelectedObject = game:GetService("Players").LocalPlayer.PlayerGui.ReadyScreen.Frame.Replay
						VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
						VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
					end
				else
					local GuiService = game:GetService("GuiService")
					local VirtualInputManager = game:GetService("VirtualInputManager")
					GuiService.SelectedObject = game:GetService("Players").LocalPlayer.PlayerGui.ReadyScreen.Frame.Replay
					VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
					VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
					break
				end
			end
		end
		wait()
	end
end

function autoLeave()
	while getgenv().autoLeave == true do
		local ReadyScreen = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ReadyScreen")
		if ReadyScreen and ReadyScreen.Enabled == true then
			local buttonRetry = ReadyScreen.Frame.Teleport
			if buttonRetry and buttonRetry.Visible == true then
				local Drops = workspace.Objects:FindFirstChild("Drops")
				local chest = Drops and Drops:FindFirstChild("Chest")
				local loot = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Loot")
				wait(2)
				if getgenv().autoChest then
					local dropsChildren = Drops:GetChildren()
					if #dropsChildren ~= 0 or loot.Enabled == true then
						for i, v in pairs(Drops:GetChildren()) do
							if v:FindFirstChild("PlayerOwned") and v.PlayerOwned.Value == game.Players.LocalPlayer then
								wait()
							elseif loot.Enabled == true then
								wait()
							else
								GuiService.SelectedObject = buttonRetry
								VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
								VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
							end
						end
					end
				end
			else
				GuiService.SelectedObject = buttonRetry
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
			end
		end
		wait()
	end
end

function autoChest()
    while getgenv().autoChest == true do
        local GuiService = game:GetService("GuiService")
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local Drops = workspace.Objects:FindFirstChild("Drops")
        local loot = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Loot")

        for i, v in pairs(Drops:GetChildren()) do
            if v:FindFirstChild("PlayerOwned") and v.PlayerOwned.Value == game.Players.LocalPlayer then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, 'E', false, game)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, 'E', false, game)
                wait(.5)
                if loot.Enabled == true then
					while loot.Enabled == true do
						GuiService.SelectedObject = loot.Frame.Flip
						VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
						VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
						wait()
					end
                else
                    print("Loot is disabled, skipping interaction.")
                end
            else
                
                if loot.Enabled == true then
                    GuiService.SelectedObject = loot.Frame.Flip
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                else
                    print("Loot is disabled, skipping interaction.")
                end
            end
        end        
        wait()
    end
end

function HitKill()
	while getgenv().HitKill == true do
		local mobs = workspace.Objects:FindFirstChild("Mobs")

		if mobs then
			for i, v in pairs(mobs:GetChildren()) do
				local humanoid = v:FindFirstChild("Humanoid")
				if humanoid then
					local health = v.Humanoid
					health.Health = 0
				end
			end
		end
		wait()
	end
end

function HitKillBoss()
    while getgenv().HitKillBoss == true do
        local mobs = workspace.Objects:FindFirstChild("Mobs")

        if mobs then
            local bossSpawn = workspace.Objects.Spawns:FindFirstChild("BossSpawn")
            if bossSpawn then
                local targetCFrame = GetCFrame(bossSpawn)
                local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
                tween:Play()
                tween.Completed:Wait()
				wait(.5)
				local args = {
					[1] = "Fists"
				}
				
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Combat"):WaitForChild("ChangeWeapon"):FireServer(unpack(args))
				wait(.3)
				local args = {
					[1] = 1,
					[2] = {}
				}
				
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Combat"):WaitForChild("M1"):FireServer(unpack(args))
				for _, mob in pairs(mobs:GetChildren()) do
					local humanoid = mob:FindFirstChild("Humanoid")
	
					if humanoid then
						if not mob:FindFirstChild("BossSpawn") then
							humanoid.Health = 0
						end
					end
				end
            end

            for _, mob in pairs(mobs:GetChildren()) do
                local humanoid = mob:FindFirstChild("Humanoid")

                if humanoid then
                    if not mob:FindFirstChild("BossSpawn") then
                        humanoid.Health = 0
                    end
                end
            end
        end
        wait()
    end
end


function getSkill()
	local ReplicatedData = game:GetService("Players").LocalPlayer:FindFirstChild("ReplicatedData")
	if ReplicatedData then
		local keybinds = ReplicatedData.techniques.innates
	end

	for i, v in pairs(keybinds:GetChildren()) do
		if selectedKeybind == v.Name then
			v.Value = selectedInate
		end
	end
	wait()
end

function tpToItem()
	local drops = workspace.Objects.Drops


	for i,v in pairs(drops:GetChildren())do
		if selectedItem == v.Name then
			local teleportCFrame = GetCFrame(v.Root)
			local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
			tween:Play()
			tween.Completed:Wait()
			break
		end
	end
end

function autoSelectBoss()
	if getgenv().autoSelectBoss == true then
		local args = {
			[1] = "Boss",
			[2] = selectedBoss,
			[3] = selectedDifficulty,
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Raids"):WaitForChild("QuickStart"):InvokeServer(unpack(args))			
		wait()
	end
end

function unlockAllAbiliti()
	while getgenv().unlockAllAbiliti == true do
		local maestrias = game:GetService("Players").LocalPlayer.ReplicatedData:FindFirstChild("masteries")

		if maestrias then
			for i, v in pairs(maestrias:GetChildren())do
				v.level.Value = 1000
				v.exp.Value = 999999999999999999
			end
		end
		wait()
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

local RaidInfo = game:GetService("ReplicatedStorage").Dependencies.RaidInfo

local ValuesBoss = {}
if RaidInfo:IsA("ModuleScript") then
    local raidData = require(RaidInfo)
    for k, _ in pairs(raidData) do
        table.insert(ValuesBoss, k)
    end
else
    print("RaidInfo não é um módulo script. Tipo:", RaidInfo.ClassName)
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

LeftGroupBox:AddToggle("HKIB", {
	Text = "Hit Kill In Boss",
	Default = false,
	Callback = function(Value)
		getgenv().HitKillBoss = Value
		HitKillBoss()
	end,
})

LeftGroupBox:AddToggle("AR", {
	Text = "Auto Retry",
	Default = false,
	Callback = function(Value)
		getgenv().autoRetry = Value
		autoRetry()
	end,
})

LeftGroupBox:AddToggle("AL", {
	Text = "Auto Leave",
	Default = false,
	Callback = function(Value)
		getgenv().autoLeave = Value
		autoLeave()
	end,
})

LeftGroupBox:AddToggle("UAB", {
	Text = "Unlock All Abilities",
	Default = false,
	Callback = function(Value)
		getgenv().unlockAllAbiliti = Value
		unlockAllAbiliti()
	end,
})

LeftGroupBox:AddToggle("AGC", {
	Text = "Auto Get Chest",
	Default = false,
	Callback = function(Value)
		getgenv().autoChest = Value
		autoChest()
	end,
})

LeftGroupBox:AddDropdown("Keybinds", {
	Values = ValuesKeybinds,
	Default = "None",
	Multi = false,
	Text = "Select Keybind",

	Callback = function(value)
		selectedKeybind = value
	end,
})

LeftGroupBox:AddDropdown("InatesDropdown", {
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

LeftGroupBox:AddDropdown("dropdownDropsItem", {
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
		Options.dropdownDropsItem:SetValue(ValuesDrops)
	end,
	DoubleClick = false,
})

local RightGroupbox = Tabs.Main:AddRightGroupbox("Farm")

RightGroupbox:AddDropdown("dropdownType", {
    Values = {"Boss", "Investigation"},
    Default = "None",
    Multi = false,

    Text = "Select Type",

    Callback = function(Value)
        selectedType = Value
    end,
})

RightGroupbox:AddDropdown("drodpownBosses", {
    Values = ValuesBoss,
    Default = "None",
    Multi = false,

    Text = "Select Boss",

    Callback = function(Value)
        selectedBoss = Value
    end,
})

RightGroupbox:AddDropdown("dropdownDifficultyBosses", {
    Values = {"easy", "medium", "hard", "nightmare"},
    Default = "None",
    Multi = false,

    Text = "Select Difficulty",

    Callback = function(Value)
        selectedDifficulty = Value
    end,
})

RightGroupbox:AddToggle("AB", {
    Text = "Auto Boss",
    Default = false,
    Callback = function(Value)
        getgenv().autoSelectBoss = Value
        autoSelectBoss()
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
