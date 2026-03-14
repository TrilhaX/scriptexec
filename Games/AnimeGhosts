--Checking if game is loaded
if not game:IsLoaded() then
	game.Loaded:Wait()
end
warn("[VOID HUB] Loading Ui")
task.wait()

--Starting Script
local MacLib =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled
local pcSize = UDim2.fromOffset(850, 650)
local mobileSize = UDim2.fromOffset(650, 400)
local currentSize = isMobile and mobileSize or pcSize

local Window = MacLib:Window({
	Title = "Void Hub",
	Subtitle = "Anime Ghosts [👺]",
	Size = currentSize,
	DragStyle = 1,
	DisabledWindowControls = {},
	ShowUserInfo = false,
	Keybind = Enum.KeyCode.RightControl,
	AcrylicBlur = true,
})

local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))

repeat
	task.wait()
until Library.PlayerData

function findGui(parent, name)
	return parent:FindFirstChild(name, true)
end

function normalize(str)
	return str:gsub("%s+", ""):lower()
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
				Lifetime = 5,
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
				Lifetime = 5,
			})
		end,
	}),
	ShowUserInfo = Window:GlobalSetting({
		Name = "Show User Info",
		Default = Window:GetUserInfoState(),
		Callback = function(bool)
			bool = bool or false
			Window:SetUserInfoState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Showing" or "Redacted") .. " User Info",
				Lifetime = 5,
			})
		end,
	}),
}
warn("[VOID HUB] Loading Function")
wait()
warn("[VOID HUB] Loading Toggles")
wait()
warn("[VOID HUB] Last Checking")
wait()

local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local originalSizes = {}
local pcSize2 = Vector2.new(850, 650)
local mobileSize2 = Vector2.new(750, 500)
local speed = 1000
selectedsAlienUpgrades = {}
selectedPassives = {}
selectedEnchants = {}
selectedWarriorSell = {}
selectedSwordSell = {}

function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function getBaseSize()
	return isMobile() and mobileSize2 or pcSize2
end

function storeOriginalFrameSizes(guiObject)
	for _, obj in ipairs(guiObject:GetDescendants()) do
		if obj:IsA("Frame") then
			if not originalSizes[obj] then
				originalSizes[obj] = obj.Size
			end
		end
	end
end

function resizeFrames(scale)
	local gui = CoreGui:FindFirstChild("MaclibGui")
	if not gui then
		return
	end

	storeOriginalFrameSizes(gui)

	local baseSize = getBaseSize()
	local widthScale = (baseSize.X * scale) / baseSize.X
	local heightScale = (baseSize.Y * scale) / baseSize.Y

	for frame, originalSize in pairs(originalSizes) do
		if frame and frame.Parent then
			frame.Size = UDim2.new(
				originalSize.X.Scale,
				math.floor(originalSize.X.Offset * widthScale),
				originalSize.Y.Scale,
				math.floor(originalSize.Y.Offset * heightScale)
			)
		end
	end
end

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

function fireproximityprompt55(Obj, Amount, Skip)
	if not Obj then
		return
	end
	local Obj = Obj:IsA("ProximityPrompt55") and Obj or Obj:FindFirstChildWhichIsA("ProximityPrompt55")
	if Obj and Obj.ClassName == "ProximityPrompt55" then
		Obj.Enabled = true
		Amount = Amount or 1
		local PromptTime = Obj.HoldDuration
		if typeof(Skip) == "boolean" and Skip then
			Obj.HoldDuration = 0
		end
		for i = 1, Amount do
			Obj:InputHoldBegin()
			if typeof(Skip) == "boolean" and not Skip then
				task.wait(Obj.HoldDuration)
			elseif typeof(Skip) == "number" then
				task.wait(Skip)
			end
			Obj:InputHoldEnd()
		end
		Obj.HoldDuration = PromptTime
	else
		return
	end
end

function hideUIExecFunction()
	while getgenv().hideUIExecEnabled == true do
		local coreGui = CoreGui:FindFirstChild()
		local Base = nil

		if coreGui:FindFirstChild("MaclibGui") then
			Base = coreGui.MaclibGui:FindFirstChild("Base")
		elseif coreGui:FindFirstChild("RobloxGui") and coreGui.RobloxGui:FindFirstChild("MaclibGui") then
			Base = coreGui.RobloxGui.MaclibGui:FindFirstChild("Base")
		end

		if Base then
			Base.Visible = false
		end
		break
	end
end

function aeuatFunction()
	local teleportQueued = false
	game.Players.LocalPlayer.OnTeleport:Connect(function(State)
		if (State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress) and not teleportQueued then
			teleportQueued = true

			queue_on_teleport([[         
                        repeat task.wait() until game:IsLoaded()
                        if getgenv().executedEnabled then return end    
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/VoidHubMain/main/Main"))()
                    ]])

			getgenv().executedEnabled = true
			wait(1)
			teleportQueued = false
		end
	end)
end

function firebutton(Button, method)
	if not Button then
		return
	end

	local a = Button

	if getconnections and method == "getconnections" then
		if Button.Activated then
			for i, v in pairs(getconnections(Button.Activated)) do
				task.wait()
				v.Function()
			end
		end
	elseif firesignal and method == "firesignal" then
		local events = { "MouseButton1Click", "MouseButton1Down", "Activated" }
		for _, v in pairs(events) do
			if Button[v] then
				firesignal(Button[v])
			end
		end
	elseif VirtualInputManager and method == "VirtualInputManager" then
		local GuiService = game:GetService("GuiService")
		repeat
			GuiService.GuiNavigationEnabled = true
			GuiService.SelectedObject = Button
			task.wait()
		until GuiService.SelectedObject == Button
		VirtualInputManager:SendKeyEvent(true, "Return", false, nil)
		VirtualInputManager:SendKeyEvent(false, "Return", false, nil)
		task.wait(0.05)
		GuiService.GuiNavigationEnabled = false
		GuiService.SelectedObject = nil
		wait(1)
	end
end

function tweenModel(model, targetCFrame)
	if not model.PrimaryPart then
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

--Functions of script

function autoSwapTeam(mode)
	while getgenv().autoSwapTeamEnabled do
		if mode == "NormalFarm" then
		end
		if mode == "Raid" then
		end
		if mode == "InfinityCastle" then
		end
		if mode == "Dungeon" then
		end
	end
end

function autoRollAvatarFunction()
	local teleported = false

	while getgenv().autoRollAvatarEnabled do
		if not teleported then
			local args = {
				{
					{
						"TeleportSystem",
						"To",
						"Lobby",
						n = 3,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
			task.wait(2)
			local banner = workspace._MAP.Lobby.Interactions:GetChildren()[6].Rig
			local bannerCFrame = GetCFrame(banner, 0, 0)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
			teleported = true
		end
		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Avatar",
					"Classic",
					{
						TrueQuincy = true,
						Yeager = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						Ruin5 = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						Blessing6 = true,
						Jupiter = true,
						AttackSerum = true,
						Mythical = true,
						Secret = true,
						Earth = true,
						DragonFruit = true,
						PhoenixFruit = true,
						OperationFruit = true,
						Electric5 = true,
						ColossalSerum = true,
						Blessed5 = true,
						TurboGranny = true,
						Haunt6 = true,
						ForceField = true,
						Ruin6 = true,
						Afterlife = true,
						National = true,
						Holy = true,
						Nozarashi = true,
						RedHaki = true,
						Blessing5 = true,
						Ackerman = true,
						Blessing = true,
						Phantom = true,
						Mist = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait()
	end
end

function autoRollSwordFunction()
	local teleported = false

	while getgenv().autoRollSwordEnabled do
		if not teleported then
			local args = {
				{
					{
						"TeleportSystem",
						"To",
						"Lobby",
						n = 3,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
			task.wait(2)
			local banner = workspace._MAP.Lobby.Interactions.Banner.Rig
			local bannerCFrame = GetCFrame(banner, 0, 0)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
			teleported = true
		end
		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Weapon",
					"Blood-Red",
					{
						TrueQuincy = true,
						Yeager = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						Ruin5 = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						Blessing6 = true,
						Jupiter = true,
						AttackSerum = true,
						Mythical = true,
						Secret = true,
						Earth = true,
						DragonFruit = true,
						PhoenixFruit = true,
						OperationFruit = true,
						Electric5 = true,
						ColossalSerum = true,
						Blessed5 = true,
						TurboGranny = true,
						Haunt6 = true,
						ForceField = true,
						Ruin6 = true,
						Afterlife = true,
						National = true,
						Holy = true,
						Nozarashi = true,
						RedHaki = true,
						Blessing5 = true,
						Ackerman = true,
						Blessing = true,
						Phantom = true,
						Mist = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))

		task.wait()
	end
end

function autoRollWarriorsFunction()
	local teleported = false

	while getgenv().autoRollWarriorsEnabled do
		if not teleported then
			local args = {
				{
					{
						"TeleportSystem",
						"To",
						1,
						n = 3,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
			task.wait(2)
			local banner = workspace._MAP["1"].Interactions.Banner.Range
			local bannerCFrame = GetCFrame(banner, 0, 0)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
			teleported = true
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Warrior",
					"Titan",
					{
						TrueQuincy = true,
						Yeager = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						Ruin5 = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						Blessing6 = true,
						Jupiter = true,
						AttackSerum = true,
						Mythical = true,
						Secret = true,
						Earth = true,
						DragonFruit = true,
						PhoenixFruit = true,
						OperationFruit = true,
						Electric5 = true,
						ColossalSerum = true,
						Blessed5 = true,
						TurboGranny = true,
						Haunt6 = true,
						ForceField = true,
						Ruin6 = true,
						Afterlife = true,
						National = true,
						Holy = true,
						Nozarashi = true,
						RedHaki = true,
						Blessing5 = true,
						Ackerman = true,
						Blessing = true,
						Phantom = true,
						Mist = true,
					},
					n = 5,
				},
				"\002",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))

		task.wait()
	end
end

function autoRollBloodlineFunction()
	local teleported = false
	local banner

	while getgenv().autoRollBloodlineEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["1"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local mikasa = v:FindFirstChild("Mikasa")
					if mikasa then
						banner = mikasa
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							1,
							n = 3,
						},
						"\002",
					},
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))
				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Bloodline",
					"Normal",
					{
						TrueQuincy = true,
						Yeager = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						Ruin5 = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						Blessing6 = true,
						Jupiter = true,
						AttackSerum = true,
						Mythical = true,
						Secret = true,
						Earth = true,
						DragonFruit = true,
						PhoenixFruit = true,
						OperationFruit = true,
						Electric5 = true,
						ColossalSerum = true,
						Blessed5 = true,
						TurboGranny = true,
						Haunt6 = true,
						ForceField = true,
						Ruin6 = true,
						Afterlife = true,
						National = true,
						Holy = true,
						Nozarashi = true,
						RedHaki = true,
						Blessing5 = true,
						Ackerman = true,
						Blessing = true,
						Phantom = true,
						Mist = true,
					},
					n = 5,
				},
				"\002",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))

		task.wait()
	end
end

function autoRollTitaSerumFunction()
	local teleported = false
	local banner

	while getgenv().autoRollTitaSerumEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["1"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local mikasa = v:FindFirstChild("Rig")
					if mikasa then
						banner = mikasa
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							1,
							n = 3,
						},
						"\002",
					},
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))
				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Titan Serum",
					"Normal",
					{
						TrueQuincy = true,
						Yeager = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						Ruin5 = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						Blessing6 = true,
						Jupiter = true,
						AttackSerum = true,
						Mythical = true,
						Secret = true,
						Earth = true,
						DragonFruit = true,
						PhoenixFruit = true,
						OperationFruit = true,
						Electric5 = true,
						ColossalSerum = true,
						Blessed5 = true,
						TurboGranny = true,
						Haunt6 = true,
						ForceField = true,
						Ruin6 = true,
						Afterlife = true,
						National = true,
						Holy = true,
						Nozarashi = true,
						RedHaki = true,
						Blessing5 = true,
						Ackerman = true,
						Blessing = true,
						Phantom = true,
						Mist = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait()
	end
end

function autoRollPossesionsFunction()
	local teleported = false
	local banner

	while getgenv().autoRollPossesionsEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["2"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local Possesions = v:FindFirstChild("Rig")
					if Possesions then
						banner = Possesions
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							2,
							n = 3,
						},
						"\002",
					},
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))
				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Possession",
					"Normal",
					{
						TrueQuincy = true,
						Yeager = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						Ruin5 = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						Blessing6 = true,
						Jupiter = true,
						AttackSerum = true,
						Mythical = true,
						Secret = true,
						Earth = true,
						DragonFruit = true,
						PhoenixFruit = true,
						OperationFruit = true,
						Electric5 = true,
						ColossalSerum = true,
						Blessed5 = true,
						TurboGranny = true,
						Haunt6 = true,
						ForceField = true,
						Ruin6 = true,
						Afterlife = true,
						National = true,
						Holy = true,
						Nozarashi = true,
						RedHaki = true,
						Blessing5 = true,
						Ackerman = true,
						Blessing = true,
						Phantom = true,
						Mist = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait()
	end
end

function autoRollPsychicPowersFunction()
	local teleported = false
	local banner
	while getgenv().autoRollPsychicPowersEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["2"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local Momo = v:FindFirstChild("MomoAyase")
					if Momo then
						banner = Momo
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							2,
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)

				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local gachaArgs = {
			{
				{
					"GachaSystem",
					"Spin",
					"Psychic Power",
					"Normal",
					{
						TrueQuincy = true,
						Yeager = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						Ruin5 = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						Blessing6 = true,
						Jupiter = true,
						AttackSerum = true,
						Mythical = true,
						Secret = true,
						Earth = true,
						DragonFruit = true,
						PhoenixFruit = true,
						OperationFruit = true,
						Electric5 = true,
						ColossalSerum = true,
						Blessed5 = true,
						TurboGranny = true,
						Haunt6 = true,
						ForceField = true,
						Ruin6 = true,
						Afterlife = true,
						National = true,
						Holy = true,
						Nozarashi = true,
						RedHaki = true,
						Blessing5 = true,
						Ackerman = true,
						Blessing = true,
						Phantom = true,
						Mist = true,
					},
					n = 5,
				},
				"\002",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(gachaArgs))

		task.wait()
	end
end

function autoRollSoulFoundationFunction()
	local teleported = false
	local banner
	while getgenv().autoRollSoulFoundationEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["3"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local Name = v:GetAttribute("Name")
					if Name == "Soul Fundation" then
						banner = v.Rig
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							3,
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Soul Fundation",
					"Normal",
					{
						AlphaCore = true,
						ForceField = true,
						Phantom = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						OperationFruit = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						N6 = true,
						Jupiter = true,
						Ackerman = true,
						Blessing5 = true,
						Secret = true,
						Earth = true,
						RedHaki = true,
						Holy = true,
						DragonFruit = true,
						Mist = true,
						PhoenixFruit = true,
						Ruin6 = true,
						Yeager = true,
						ColossalSerum = true,
						AdaptiveCore = true,
						TurboGranny = true,
						Haunt6 = true,
						TrueQuincy = true,
						Ruin5 = true,
						Afterlife = true,
						N9 = true,
						Blessed5 = true,
						Nozarashi = true,
						Electric5 = true,
						National = true,
						Mythical = true,
						Blessing = true,
						Blessing6 = true,
						AttackSerum = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))

		task.wait()
	end
end

function autoRollZanpakutoFunction()
	local teleported = false
	local banner
	while getgenv().autoRollZanpakutoEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["3"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local Name = v:GetAttribute("Name")
					if Name == "Zanpakutos" then
						banner = v.Rig
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							3,
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Zanpakuto",
					"Normal",
					{
						AlphaCore = true,
						ForceField = true,
						Phantom = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						OperationFruit = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						N6 = true,
						Jupiter = true,
						Ackerman = true,
						Blessing5 = true,
						Secret = true,
						Earth = true,
						RedHaki = true,
						Holy = true,
						DragonFruit = true,
						Mist = true,
						PhoenixFruit = true,
						Ruin6 = true,
						Yeager = true,
						ColossalSerum = true,
						AdaptiveCore = true,
						TurboGranny = true,
						Haunt6 = true,
						TrueQuincy = true,
						Ruin5 = true,
						Afterlife = true,
						N9 = true,
						Blessed5 = true,
						Nozarashi = true,
						Electric5 = true,
						National = true,
						Mythical = true,
						Blessing = true,
						Blessing6 = true,
						AttackSerum = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait()
	end
end

function autoRollPowerOfThePlanetsFunction()
	local teleported = false
	local banner
	while getgenv().autoRollPowerOfThePlanetsEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["3"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local Name = v:GetAttribute("Name")
					if Name == "Power of the Planets" then
						banner = v.RenjiAbarai
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							3,
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Power of the Planet",
					"Normal",
					{
						AlphaCore = true,
						ForceField = true,
						Phantom = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						OperationFruit = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						N6 = true,
						Jupiter = true,
						Ackerman = true,
						Blessing5 = true,
						Secret = true,
						Earth = true,
						RedHaki = true,
						Holy = true,
						DragonFruit = true,
						Mist = true,
						PhoenixFruit = true,
						Ruin6 = true,
						Yeager = true,
						ColossalSerum = true,
						AdaptiveCore = true,
						TurboGranny = true,
						Haunt6 = true,
						TrueQuincy = true,
						Ruin5 = true,
						Afterlife = true,
						N9 = true,
						Blessed5 = true,
						Nozarashi = true,
						Electric5 = true,
						National = true,
						Mythical = true,
						Blessing = true,
						Blessing6 = true,
						AttackSerum = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait()
	end
end

function autoRollTraitFunction()
	local teleported = false
	local banner

	while getgenv().autoRollTraitEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["Lobby"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local Name = v:GetAttribute("Name")
					if Name == "Traits" then
						banner = v.Rig
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							"Lobby",
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(2)

				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)

				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Trait",
					"Normal",
					{},
					n = 5,
				},
				"\002",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))

		task.wait()
	end
end

function autoRollMountFunction()
	local teleported = false
	local banner
	while getgenv().autoRollMountEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["Lobby"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local Name = v:GetAttribute("Name")
					if Name == "Mounts" then
						banner = v.SungJinWooFinal
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							"Lobby",
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Trait",
					"Normal",
					{
						AlphaCore = true,
						ForceField = true,
						Phantom = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						OperationFruit = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						N6 = true,
						Jupiter = true,
						Ackerman = true,
						Blessing5 = true,
						Secret = true,
						Earth = true,
						RedHaki = true,
						Holy = true,
						DragonFruit = true,
						Mist = true,
						PhoenixFruit = true,
						Ruin6 = true,
						Yeager = true,
						ColossalSerum = true,
						AdaptiveCore = true,
						TurboGranny = true,
						Haunt6 = true,
						TrueQuincy = true,
						Ruin5 = true,
						Afterlife = true,
						N9 = true,
						Blessed5 = true,
						Nozarashi = true,
						Electric5 = true,
						National = true,
						Mythical = true,
						Blessing = true,
						Blessing6 = true,
						AttackSerum = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait()
	end
end

function autoRollHunterRanksFunction()
	local teleported = false
	local banner
	while getgenv().autoRollHunterRanksEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["4"].Interactions:GetChildren()) do
				if v.Name == "Gacha" then
					local Name = v:GetAttribute("Name")
					if Name == "Hunter Ranks" then
						banner = v.Rig
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							4,
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Hunter Rank",
					"Normal",
					{
						AlphaCore = true,
						ForceField = true,
						Phantom = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						OperationFruit = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						N6 = true,
						Jupiter = true,
						Ackerman = true,
						Blessing5 = true,
						Secret = true,
						Earth = true,
						RedHaki = true,
						Holy = true,
						DragonFruit = true,
						Mist = true,
						PhoenixFruit = true,
						Ruin6 = true,
						Yeager = true,
						ColossalSerum = true,
						AdaptiveCore = true,
						TurboGranny = true,
						Haunt6 = true,
						TrueQuincy = true,
						Ruin5 = true,
						Afterlife = true,
						N9 = true,
						Blessed5 = true,
						Nozarashi = true,
						Electric5 = true,
						National = true,
						Mythical = true,
						Blessing = true,
						Blessing6 = true,
						AttackSerum = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait()
	end
end

function autoRollShadowFunction()
	local teleported = false
	local banner
	while getgenv().autoRollShadowEnabled do
		if not teleported then
			for _, v in pairs(workspace._MAP["4"].Interactions:GetChildren()) do
				if v.Name == "Banner" then
					local Name = v:GetAttribute("Name")
					if Name == "Shadows" then
						banner = v.IgrisShadow
						break
					end
				end
			end

			if banner then
				local args = {
					{
						{
							"TeleportSystem",
							"To",
							4,
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(2)
				local bannerCFrame = GetCFrame(banner, 0, 0)
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
				teleported = true
			end
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Warrior",
					"Shadow",
					{
						AlphaCore = true,
						ForceField = true,
						Phantom = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						OperationFruit = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						N6 = true,
						Jupiter = true,
						Ackerman = true,
						Blessing5 = true,
						Secret = true,
						Earth = true,
						RedHaki = true,
						Holy = true,
						DragonFruit = true,
						Mist = true,
						PhoenixFruit = true,
						Ruin6 = true,
						Yeager = true,
						ColossalSerum = true,
						AdaptiveCore = true,
						TurboGranny = true,
						Haunt6 = true,
						TrueQuincy = true,
						Ruin5 = true,
						Afterlife = true,
						N9 = true,
						Blessed5 = true,
						Nozarashi = true,
						Electric5 = true,
						National = true,
						Mythical = true,
						Blessing = true,
						Blessing6 = true,
						AttackSerum = true,
					},
					n = 5,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait()
	end
end

function autoUpgradeShinigamiLevelingFunction()
	while getgenv().autoUpgradeShinigamiLevelingEnabled do
		local args = {
			{
				{
					"UpgradeSystem",
					"Buy",
					"Shinigami Leveling",
					"Damage",
					n = 4,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait(1)
	end
end

function autoAlienUpgradeFunction()
	while getgenv().autoAlienUpgradeEnabled do
		if selectedsAlienUpgrades then
			for _, upgrade in pairs(selectedsAlienUpgrades) do
				local args = {
					{
						{
							"UpgradeSystem",
							"Buy",
							"Alien",
							_,
							n = 4,
						},
						"\002",
					},
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(0.2)
			end
		end

		task.wait(1)
	end
end

function autoDungeonUpgradeFunction()
	while getgenv().autoDungeonUpgradeEnabled do
		if selectedsDungeonUpgrades then
			for _, upgrade in pairs(selectedsDungeonUpgrades) do
				local args = {
					{
						{
							"UpgradeSystem",
							"Buy",
							"Dungeon",
							upgrade,
							n = 4,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))
			end
		end

		task.wait(1)
	end
end

function autoMonarchUpgradeFunction()
	while getgenv().autoMonarchUpgradeEnabled do
		if selectedsMonarchUpgrades then
			for _, upgrade in pairs(selectedsMonarchUpgrades) do
				local args = {
					{
						{
							"UpgradeSystem",
							"Buy",
							"Monarch",
							_,
							n = 4,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))
			end
		end

		task.wait(1)
	end
end

function autoDungeonFunction()
	local teleported = false

	while getgenv().autoDungeonEnabled do
		if not teleported then
			game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer({
				{
					"TeleportSystem",
					"To",
					4,
					n = 3,
				},
				"\002",
			})

			task.wait(2)
			teleported = true
		end

		game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer({
			{
				"GamemodeSystem",
				"Create",
				"Dungeon",
				tostring(getgenv().selectedMapDungeon),
				tostring(getgenv().selectedDiffDungeon),
				n = 6,
			},
			"\002",
		})

		task.wait(1)

		game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer({
			{
				"GamemodeSystem",
				"Start",
				"Dungeon",
				1271973640,
				n = 4,
			},
			"\002",
		})

		task.wait(1)
	end
end

function autoExchangesUpgradeFunction()
	while getgenv().autoExchangesUpgradeEnabled do
		if selectedsExchangesUpgrades then
			for _, upgrade in pairs(selectedsExchangesUpgrades) do
				local args = {
					{
						{
							"UpgradeSystem",
							"Buy",
							"Exchange",
							_,
							n = 4,
						},
						"\002",
					},
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait(0.2)
			end
		end

		task.wait(1)
	end
end

function autoFarmNearMobFunction()
	while getgenv().autoFarmNearMobEnabled do
		local enemiesFolder = workspace._ENEMIES.Client
		local target

		for _, enemy in pairs(enemiesFolder:GetChildren()) do
			if enemy.Name ~= "Highlight" then
				target = enemy
				break
			end
		end

		if target then
			local enemieCFrame = GetCFrame(target, 0, 0)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(enemieCFrame)

			while target and target.Parent == enemiesFolder and getgenv().autoFarmNearMobEnabled do
				local args = {
					{
						{
							"ClickSystem",
							"Execute",
							tostring(target),
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))
				task.wait()
			end
		end
		task.wait(0.1)
	end
end

function autoFarmEspcificMobFunction()
	local enemiesFolder = workspace._ENEMIES.Client
	local target

	while getgenv().autoFarmEspcificMobEnabled do
		local mobName = getgenv().selectedMob

		if not target or target.Parent ~= enemiesFolder then
			target = nil

			for _, enemy in pairs(enemiesFolder:GetChildren()) do
				if enemy.Name ~= "Highlight" then
					local mobTitle = enemy.EnemyBillboard.Title.Text

					if mobTitle == mobName then
						target = enemy
						break
					end
				end
			end
		end

		if target then
			local enemieCFrame = GetCFrame(target, 0, 0)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(enemieCFrame)
			while target and target.Parent == enemiesFolder and getgenv().autoFarmEspcificMobEnabled do
				local args = {
					{
						{
							"ClickSystem",
							"Execute",
							tostring(target),
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				task.wait()
			end
		end

		task.wait(0.1)
	end
end

function getQuests()
	local questGui = game.Players.LocalPlayer.PlayerGui.SideGUI.Content.ActiveQuest
	local quests = {}

	for _, obj in ipairs(questGui:GetDescendants()) do
		if obj:IsA("TextLabel") then
			local text = obj.Text

			if text:find("Defeat") then
				local npc = text:gsub("Defeat%s*", ""):match("^[^%[]+")
				npc = npc and npc:match("^%s*(.-)%s*$")

				local inside = text:match("%[(.-)%]")
				if inside then
					local current, required = inside:match("(%d+)%/(%d+)")
					current = tonumber(current)
					required = tonumber(required)

					table.insert(quests, {
						npc = npc,
						current = current,
						required = required,
					})
				end
			end
		end
	end

	return quests
end

function autoQuestFunction()
	while getgenv().autoQuestEnabled do
		local enemiesFolder = workspace._ENEMIES.Client
		local quests = getQuests()

		for i, quest in ipairs(quests) do
			while quest.current < quest.required and getgenv().autoQuestEnabled do
				local target

				for _, enemy in pairs(enemiesFolder:GetChildren()) do
					if enemy.Name ~= "Highlight" then
						local billboard = enemy:FindFirstChild("EnemyBillboard")

						if billboard and billboard:FindFirstChild("Title") then
							if billboard.Title.Text == quest.npc then
								target = enemy
								break
							end
						end
					end
				end

				if target then
					local enemieCFrame = GetCFrame(target, 0, 0)
					game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(enemieCFrame)
					while target and target.Parent == enemiesFolder and getgenv().autoQuestEnabled do
						local args = {
							{
								{
									"ClickSystem",
									"Execute",
									tostring(target),
									n = 3,
								},
								"\002",
							},
						}

						game:GetService("ReplicatedStorage")
							:WaitForChild("ffrostflame_bridgenet2@1.0.0")
							:WaitForChild("dataRemoteEvent")
							:FireServer(unpack(args))

						task.wait()
					end
				end

				task.wait(0.5)

				quests = getQuests()
				quest = quests[i]

				if not quest then
					break
				end
			end
		end

		task.wait(1)
	end
end

function autoClaimQuestFunction()
	while getgenv().autoClaimQuestEnabled do
		local args = {
			{
				{
					"QuestSystem",
					"Check",
					"Main",
					100,
					n = 4,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait(5)
	end
end

function autoRollEggFunction()
	local teleported = false

	while getgenv().autoRollEggEnabled do
		local eggData = getgenv().selectedEgg

		if eggData then
			local mapFolder = workspace._MAP:FindFirstChild(eggData.MapNumber)

			if mapFolder then
				local eggs = mapFolder:FindFirstChild("Eggs")

				if eggs then
					local egg

					if getgenv().selectedPlace == "1" then
						egg = eggs:GetChildren()[2]
					elseif getgenv().selectedPlace == "2" then
						egg = eggs:FindFirstChild(eggData.EggName)
					end

					if egg and not teleported then
						game.Players.LocalPlayer.Character:PivotTo(egg:GetPivot())
						teleported = true
					end
				end
			end

			local args = {
				{
					{
						"PetSystem",
						"Open",
						eggData.EggName,
						"Twenty",
						n = 4,
					},
					"\002",
				},
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
		end

		task.wait(1)
	end
end

function autoRebirthFunction()
	while getgenv().autoRebirthEnabled do
		local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
		local PlayerData = Library["PlayerData"]

		local rebirthData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.RebirthData.Ascension)

		local currentLevel = PlayerData.Rebirth.Ascension_Normal
		local nextLevel = currentLevel + 1

		local levelData = rebirthData.Types.Normal.Levels[nextLevel]

		if levelData then
			local price = levelData.Price
			local playerMoney = PlayerData.Ghost
			if playerMoney >= price then
				local args = {
					{
						{
							"RebirthSystem",
							"Release",
							"Ascension",
							"Normal",
							n = nextLevel,
						},
						"\002",
					},
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))
			end
		end
		task.wait(0.1)
	end
end

function removeNotify()
	game:GetService("Players").LocalPlayer.PlayerGui.Notification.Enabled = false
end

function equipBestFunction()
	while getgenv().equipBestEnabled do
		local args = {
			{
				{
					"PetSystem",
					"EquipBest",
					n = 2,
				},
				"\002",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))

		local interval = equipBestInterval or 1
		task.wait(interval * 60)
	end
end

function equipBestSwordFunction()
	while getgenv().equipBestSwordEnabled do
		local args = {
			{
				{
					"WeaponSystem",
					"EquipBest",
					n = 2,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		local interval = equipBestInterval or 1
		task.wait(interval * 60)
	end
end

function equipBestWarriorFunction()
	while getgenv().equipBestWarriorEnabled do
		local args = {
			{
				{
					"WarriorSystem",
					"EquipBest",
					n = 2,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		local interval = equipBestInterval or 1
		task.wait(interval * 60)
	end
end

function autoGetDailyRewardsFunction()
	while getgenv().autoGetDailyRewardsEnabled do
		for i = 1, 7 do
			local args = {
				{
					{
						"WeeklyRewardSystem",
						"Claim",
						"Gems",
						i,
						n = 4,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
		end
		task.wait(120)
	end
end

function autoGetTimeRewardsFunction()
	while getgenv().autoGetTimeRewardsEnabled do
		for i = 1, 9 do
			local args = {
				{
					{
						"TimeRewardSystem",
						"Claim",
						"General",
						i,
						n = 4,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
		end
		local args = {
			{
				{
					"TimeRewardSystem",
					"Reset",
					"General",
					n = 3,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait(120)
	end
end

function updateMobDropdownFunction()
	local enemiesFolder = workspace._ENEMIES.Client
	local newMobs = {}
	local added = {}

	for _, enemy in pairs(enemiesFolder:GetChildren()) do
		if enemy.Name ~= "Highlight" then
			local billboard = enemy:FindFirstChild("EnemyBillboard")

			if billboard then
				local title = billboard:FindFirstChild("Title")

				if title and title:IsA("TextLabel") then
					local mobTitle = title.Text

					if not added[mobTitle] then
						added[mobTitle] = true
						table.insert(newMobs, mobTitle)
					end
				end
			end
		end
	end
	ValuesMob = newMobs

	if DropdownMobsSelect then
		DropdownMobsSelect:ClearOptions()
		DropdownMobsSelect:InsertOptions(ValuesMob)
	end
end

function autoRaidFunction()
	local teleported = false
	while getgenv().autoRaidEnabled do
		local selectedMap = getgenv().selectedMapRaid
		local selectedDiff = getgenv().selectedDiffRaid
		local onlyFriends = getgenv().onlyFriednsEnabled or false

		local mapName = tostring(selectedMap):gsub("%s+", "")

		if not teleported then
			local args = {
				{
					{
						"TeleportSystem",
						"To",
						1,
						n = 3,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
			task.wait(2)
			teleported = true
		end

		local argsCreate = {
			{
				{
					"GamemodeSystem",
					"Create",
					"Raid",
					mapName,
					tostring(selectedDiff),
					n = 6,
				},
				"\002",
			},
		}

		local remote = game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")

		remote:FireServer(unpack(argsCreate))

		task.wait(1)

		local argsStart = {
			{
				{
					"GamemodeSystem",
					"Start",
					"Raid",
					10655684557,
					n = 4,
				},
				"\002",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(argsStart))

		task.wait(1)
	end
end

function autoLeaveRaidWaveXFuntion()
	while getgenv().autoLeaveRaidWaveXEnabled do
		local wave = game:GetService("Players").LocalPlayer.PlayerGui.Mode.Content.Start.Label
		local numero
		for n in wave.Text:gmatch("%d+") do
			numero = tonumber(n)
		end

		local selectedWave = getgenv().selectedWave
		if tonumber(selectedWave) == numero then
			local args = {
				{
					{
						"TeleportSystem",
						"To",
						1,
						n = 3,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
		end
		task.wait(1)
	end
end

function autoLeaveDungeonWaveXFuntion()
	while getgenv().autoLeaveDungeonWaveXEnabled do
		local wave = game:GetService("Players").LocalPlayer.PlayerGui.Mode.Content.Start.Label
		local numero
		for n in wave.Text:gmatch("%d+") do
			numero = tonumber(n)
		end

		local selectedWave = getgenv().selectedWaveDungeon
		if tonumber(selectedWave) == numero then
			local args = {
				{
					{
						"TeleportSystem",
						"To",
						1,
						n = 3,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
		end
		task.wait(1)
	end
end

function autoGetAchievementsFunction()
	while getgenv().autoGetAchievementsEnabled do
		local module = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.AchievementData)
		local achievements = {}

		local function dump(tbl, path)
			path = path or ""

			for k, v in pairs(tbl) do
				local newPath = path .. tostring(k)

				if type(v) == "table" then
					dump(v, newPath .. ".")
				else
					if k == "Name" then
						local result = path:match("([^%.]+)%.$")
						if result then
							table.insert(achievements, result)
						end
					end
				end
			end
		end

		dump(module)

		for _, achievement in ipairs(achievements) do
			local args = {
				{
					{
						"AchievementSystem",
						"Claim",
						tostring(achievement),
						n = 3,
					},
					"\002",
				},
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
			task.wait(0.5)
		end
		task.wait(0.1)
	end
end

function hasDesiredPassive(currentPassive)
	for passive, _ in pairs(selectedPassives) do
		if passive == currentPassive then
			return true
		end
	end
	return false
end

function hasDesiredEnchant(currentEnchant)
	for enchant, _ in pairs(selectedEnchants) do
		if enchant == currentEnchant then
			return true
		end
	end
	return false
end

function autoPassiveUnitFunction()
	local teleported = false
	while getgenv().autoPassiveUnitEnabled do
		if not teleported then
			local args = {
				{
					{
						"TeleportSystem",
						"To",
						"Lobby",
						n = 3,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
			task.wait(2)
			local banner = workspace._MAP.Lobby.Interactions:GetChildren()[3].Rig
			local bannerCFrame = GetCFrame(banner, 0, 0)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(bannerCFrame)
			teleported = true
		end
		local PlayerData = Library.PlayerData
		local selectedPet = getgenv().selectedPassiveUnit

		if not PlayerData or not PlayerData.Pets then
			task.wait()
			continue
		end

		local petData = PlayerData.Pets[selectedPet]

		if not petData then
			task.wait()
			continue
		end

		local currentPassive = petData.Buffs and petData.Buffs.Passive
		if currentPassive and hasDesiredPassive(currentPassive) then
			getgenv().autoPassiveUnitEnabled = false
			break
		end

		local args = {
			{
				{
					"GachaSystem",
					"Spin",
					"Passive",
					"Normal",
					{},
					tostring(selectedPet),
					n = 6,
				},
				"\002",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))

		task.wait(1)
	end
end

function autoEnchantSwordFunction()
	local teleported = false
	while getgenv().autoEnchantSwordEnabled do
		local player = game.Players.LocalPlayer
		if not player.Character or not player.Character.PrimaryPart then
			task.wait(0.5)
			continue
		end

		if not teleported then
			local args = {
				{
					{
						"TeleportSystem",
						"To",
						"Lobby",
						n = 3,
					},
					"\002",
				},
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
			wait(2)
			local banner = workspace._MAP.Lobby.Interactions.GachaSelect.Rig
			if banner then
				local bannerCFrame = GetCFrame(banner, 0, 0)
				player.Character:SetPrimaryPartCFrame(bannerCFrame)
			end

			teleported = true
		end

		local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
		local PlayerData = Library.PlayerData
		local selectedSword = getgenv().selectedSword

		if not PlayerData or not PlayerData.Weapons then
			task.wait(1)
			continue
		end

		local swordData = PlayerData.Weapons[selectedSword]
		if not swordData then
			task.wait(1)
			continue
		end

		local currentEnchant = swordData.Buffs and swordData.Buffs.Enchantment

		if currentEnchant and hasDesiredEnchant(currentEnchant) then
			break
		end

		local enchantArgs = {
			{
				{
					"GachaSystem",
					"Spin",
					"Enchantment",
					"Normal",
					{
						TrueQuincy = true,
						Yeager = true,
						BlackHaki = true,
						Electric6 = true,
						Shirayuki = true,
						DarkFruit = true,
						SRank = true,
						Flame = true,
						Singularity = true,
						Blessed6 = true,
						Sonic = true,
						Ruin5 = true,
						Haunt5 = true,
						EvilEye = true,
						Visored = true,
						Blessing6 = true,
						Jupiter = true,
						AttackSerum = true,
						Mythical = true,
						Secret = true,
						Earth = true,
						DragonFruit = true,
						PhoenixFruit = true,
						OperationFruit = true,
						Electric5 = true,
						ColossalSerum = true,
						Blessed5 = true,
						TurboGranny = true,
						Haunt6 = true,
						ForceField = true,
						Ruin6 = true,
						Afterlife = true,
						National = true,
						Holy = true,
						Nozarashi = true,
						RedHaki = true,
						Blessing5 = true,
						Ackerman = true,
						Blessing = true,
						Phantom = true,
						Mist = true,
					},
					tostring(selectedSword),
					n = 6,
				},
				"\002",
			},
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(enchantArgs))

		task.wait(1)
	end
end

function autoSellSwordFunction()
	while getgenv().autoSellSwordEnabled do
		local PlayerData = Library.PlayerData
		local selectedSwords = selectedSwordSell

		if not PlayerData or not PlayerData.Weapons then
			task.wait(1)
			continue
		end

		for uuid, weapon in pairs(PlayerData.Weapons) do
			if selectedSwords[weapon.Id] or selectedSwords[normalize(weapon.Id)] then
				local args = {
					{
						{
							"WeaponSystem",
							"Delete",
							'["' .. uuid .. '"]',
							n = 3,
						},
						"\002",
					},
				}

				local remoteEvent = game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
				remoteEvent:FireServer(unpack(args))
			end
		end
		task.wait(1)
	end
end

function autoSellWarriorsFunction()
	while getgenv().autoSellWarriorEnabled do
		local PlayerData = Library.PlayerData
		local selectedWarriorSell2 = selectedWarriorSell

		if not PlayerData or not PlayerData.Warriors then
			task.wait(1)
			continue
		end

		local soldSomething = false

		for uuid, warrior in pairs(PlayerData.Warriors) do
			if selectedWarriorSell2 and selectedWarriorSell2[warrior.Id] then
				local jsonUuid = '["' .. uuid .. '"]'

				local args = {
					{
						{
							"WarriorSystem",
							"Delete",
							jsonUuid,
							n = 3,
						},
						"\002",
					},
				}

				game:GetService("ReplicatedStorage")
					:WaitForChild("ffrostflame_bridgenet2@1.0.0")
					:WaitForChild("dataRemoteEvent")
					:FireServer(unpack(args))

				soldSomething = true
				task.wait(0.5)
			end
		end

		if not soldSomething then
			task.wait(1)
		end
	end
end

function equipBestAvatarFunction()
	while getgenv().equipBestAvatarEnabled do
		local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
		local PlayerAvatars = Library.PlayerData and Library.PlayerData.Avatars or {}

		local function getBestAvatar(avatars)
			local bestName = nil
			local bestLevel = -1
			local bestXP = -1

			for name, data in pairs(avatars) do
				local level = data.Level or 0
				local xp = data.XP or 0

				if level > bestLevel or (level == bestLevel and xp > bestXP) then
					bestName = name
					bestLevel = level
					bestXP = xp
				end
			end

			return bestName, bestLevel, bestXP
		end

		local bestName = getBestAvatar(PlayerAvatars)

		if bestName and not PlayerAvatars[bestName].Equipped then
			local args = {
				{
					{
						"AvatarSystem",
						"Equip",
						tostring(bestName),
						n = 3,
					},
					"\002",
				},
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("ffrostflame_bridgenet2@1.0.0")
				:WaitForChild("dataRemoteEvent")
				:FireServer(unpack(args))
		end

		local interval = equipBestInterval or 1
		task.wait(interval * 60)
	end
end

function codeFunction()
	local codes = {
		"50KLIKES",
		"DUNGEONSHOP",
		"MILIMSECRET",
		"10MVISITS",
		"45KLIKES",
		"INFINITYCASTLE",
		"40KLIKES",
		"DEVILFRUITS",
		"PIRATELEVEL",
		"35KLIKES",
		"20KPLAYERS",
		"WARRIORS",
		"25KLIKES",
		"30KLIKES",
		"EXCHANGE",
		"20KLIKES",
		"SHUTDOWN",
		"10KLIKES",
		"5KLIKES",
		"RELEASE",
	}
	for i, v in pairs(codes) do
		local args = {
			{
				{
					"CodeSystem",
					"Use",
					v,
					n = 3,
				},
				"\002",
			},
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("ffrostflame_bridgenet2@1.0.0")
			:WaitForChild("dataRemoteEvent")
			:FireServer(unpack(args))
		task.wait(1)
	end
end

local ValuesMob = {}
local added = {}
local enemiesFolder = workspace._ENEMIES.Client

for _, enemy in pairs(enemiesFolder:GetChildren()) do
	if enemy.Name ~= "Highlight" then
		local mobTitle = enemy.EnemyBillboard.Title.Text

		if not added[mobTitle] then
			added[mobTitle] = true
			table.insert(ValuesMob, mobTitle)
		end
	end
end

local mapData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.MapData)
local ValuesEgg = {}
local EggValues = {}
local mapIndex = 1

for _, v in pairs(mapData) do
	if v.Name and v.EggName then
		table.insert(ValuesEgg, v.Name)

		EggValues[v.Name] = {
			EggName = v.EggName,
			MapNumber = tostring(mapIndex),
		}

		mapIndex += 1
	end
end

local raidData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.GamemodeData.Raid)
local ValuesRaid = {}

for name, data in pairs(raidData) do
	if data.Name then
		table.insert(ValuesRaid, data.Name)
	end
end

local dungeonData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.GamemodeData.Dungeon)
local ValuesDungeon = {}

for name, data in pairs(dungeonData) do
	if data.Name then
		table.insert(ValuesDungeon, data.Name)
	end
end

local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
local PlayerData = Library["PlayerData"]

--Sword Enchantments
local weaponsTable = {}
local optionsSword = {}
local swordMap = {}
local unitsTable = {}

for uuid, weapon in pairs(PlayerData.Weapons) do
	table.insert(weaponsTable, {
		Name = weapon.Id,
		UUID = uuid,
	})
end

for _, sword in pairs(weaponsTable) do
	local text = sword.Name .. " | " .. sword.UUID
	table.insert(optionsSword, text)

	swordMap[text] = sword.UUID
end

for uuid, weapon in pairs(PlayerData.Weapons) do
	table.insert(weaponsTable, {
		Name = weapon.Id,
		UUID = uuid,
	})
end

local weaponData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.WeaponData)

local optionsSword2 = {}
local swordMap2 = {}

for swordName, data in pairs(weaponData) do
	table.insert(optionsSword2, swordName)
	swordMap2[swordName] = swordName
end

--Unit Passive
local petsTable = {}
local optionsPets = {}
local petMap = {}

for uuid, pet in pairs(PlayerData.Pets) do
	table.insert(petsTable, {
		Name = pet.Id,
		UUID = uuid,
	})
end

for _, pet in pairs(petsTable) do
	local text = pet.Name .. " | " .. pet.UUID
	table.insert(optionsPets, text)

	petMap[text] = pet.UUID
end

local PassiveData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.GachaData.Passive)
local EnchantData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.GachaData.Enchantment)

local passiveOptions = {}
local enchantOptions = {}

local passiveList = PassiveData[2] and PassiveData[2].Normal
local enchantList = EnchantData[2] and EnchantData[2].Normal

if passiveList then
	for _, data in pairs(passiveList) do
		if #data.Tiers == 1 then
			table.insert(passiveOptions, data.Name)
		else
			for tier = 1, #data.Tiers do
				table.insert(passiveOptions, data.Name .. tier)
			end
		end
	end
end

if enchantList then
	for _, data in pairs(enchantList) do
		for tier = 1, #data.Tiers do
			table.insert(enchantOptions, data.Name .. tier)
		end
	end
end

local WarriorData = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.WarriorData)

local warriorOptions = {}
local warriorMap = {}

for id, data in pairs(WarriorData) do
	if type(data) == "table" and data.Name then
		table.insert(warriorOptions, data.Name)
		warriorMap[data.Name] = id
	end
end

local TraitModule = require(game:GetService("ReplicatedStorage").Framework.Modules.Data.GachaData.Trait)
local optionsTraits = {}

for id, data in pairs(TraitModule[2].Normal) do
	table.insert(optionsTraits, data.Name)
end

local tabGroups = {
	TabGroup1 = Window:TabGroup(),
}

--UI Tabs

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
	Rerolls = tabGroups.TabGroup1:Tab({ Name = "Rerolls", Image = "rbxassetid://11570018265" }),
	Sell = tabGroups.TabGroup1:Tab({ Name = "Sell", Image = "rbxassetid://13555335421" }),
	TeamSwap = tabGroups.TabGroup1:Tab({ Name = "Team Swap", Image = "rbxassetid://15443966088" }),
	Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" }),
}

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
	MainSection2 = tabs.Main:Section({ Side = "Right" }),
	MainSection20 = tabs.Rerolls:Section({ Side = "Left" }),
	MainSection21 = tabs.Rerolls:Section({ Side = "Right" }),
	MainSection22 = tabs.Rerolls:Section({ Side = "Left" }),
	MainSection40 = tabs.Sell:Section({ Side = "Left" }),
	MainSection80 = tabs.TeamSwap:Section({ Side = "Left" }),
	MainSection100 = tabs.Settings:Section({ Side = "Left" }),
	MainSection101 = tabs.Settings:Section({ Side = "Right" }),
}

sections.MainSection1:Toggle({
	Name = "Hide Player Info",
	Default = false,
	Callback = function(value)
		while value do
			for _, character in pairs(workspace._CHARACTERS:GetDescendants()) do
				local gui = character:FindFirstChild("GUI")
				if gui then
					gui.Enabled = false
					break
				end
			end
			MacLib:HidePlayer(value)
			task.wait(0.1)
		end
	end,
}, "HidePlayerInfoToggle")

sections.MainSection1:Toggle({
	Name = "Remove Animation",
	Default = false,
	Callback = function(value)
		while value do
			local animationEgg = game:GetService("Players").LocalPlayer.PlayerGui.CenterGUI:FindFirstChild("Eggs")
			if animationEgg then
				animationEgg:Destroy()
			end
			task.wait(1)
		end
	end,
}, "HidePlayerInfoToggle")

sections.MainSection1:Button({
	Name = "All Gamepass",
	Callback = function()
		local Library = require(game.ReplicatedStorage.Framework.Library)

		for k in pairs(Library.PlayerData.Gamepasses) do
			Library.PlayerData.Gamepasses[k] = true
		end
	end,
})

sections.MainSection1:Toggle({
	Name = "Only Friends",
	Default = false,
	Callback = function(value)
		getgenv().onlyFriednsEnabled = value
	end,
}, "OnlyFriendsRaidToggle")

sections.MainSection1:Toggle({
	Name = "Auto Farm Near Mob",
	Default = false,
	Callback = function(value)
		getgenv().autoFarmNearMobEnabled = value
		if value == true then
			autoFarmNearMobFunction()
		end
	end,
}, "AutoFarmNearMobToggle")

DropdownMobsSelect = sections.MainSection1:Dropdown({
	Name = "Select Mob",
	Search = true,
	Multi = false,
	Required = true,
	Options = ValuesMob,
	Default = None,
	Callback = function(value)
		getgenv().selectedMob = value
	end,
}, "dropdownMobFarm")

sections.MainSection1:Toggle({
	Name = "Auto Farm Selected Mob",
	Default = false,
	Callback = function(value)
		getgenv().autoFarmEspcificMobEnabled = value
		if value == true then
			autoFarmEspcificMobFunction()
		end
	end,
}, "AutoFarmSelectedMobToggle")

sections.MainSection1:Button({
	Name = "Refresh Mob",
	Callback = function()
		updateMobDropdownFunction()
	end,
})

sections.MainSection1:Toggle({
	Name = "Auto Quest",
	Default = false,
	Callback = function(value)
		getgenv().autoQuestEnabled = value
		if value == true then
			autoQuestFunction()
		end
	end,
}, "AutoQuestToggle")

sections.MainSection1:Toggle({
	Name = "Auto Claim Quest",
	Default = false,
	Callback = function(value)
		getgenv().autoClaimQuestEnabled = value
		if value == true then
			autoClaimQuestFunction()
		end
	end,
}, "AutoClaimQuestToggle")

sections.MainSection1:Button({
	Name = "Reedem Codes",
	Callback = function()
		codeFunction()
	end,
})

local DropdownMapRaidSelect = sections.MainSection2:Dropdown({
	Name = "Select Map",
	Search = true,
	Multi = false,
	Required = true,
	Options = ValuesRaid,
	Default = nil,
	Callback = function(value)
		getgenv().selectedMapRaid = value
	end,
}, "dropdownMapRaid")

local DropdownDiffSelect = sections.MainSection2:Dropdown({
	Name = "Select Difficulty",
	Search = true,
	Multi = false,
	Required = true,
	Options = { "Easy", "Normal", "Hard" },
	Default = nil,
	Callback = function(value)
		getgenv().selectedDiffRaid = value
	end,
}, "dropdownDiffRaid")

sections.MainSection2:Toggle({
	Name = "Auto Raid",
	Default = false,
	Callback = function(value)
		getgenv().autoRaidEnabled = value
		if value == true then
			autoRaidFunction()
		end
	end,
}, "AutoRaidToggle")

sections.MainSection2:Slider({
	Name = "Wave X to Leave",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		getgenv().selectedWave = Value
	end,
}, "selectedWaveToggle")

sections.MainSection2:Toggle({
	Name = "Leave in Wave X",
	Default = false,
	Callback = function(value)
		getgenv().autoLeaveRaidWaveXEnabled = value
		if value == true then
			autoLeaveRaidWaveXFuntion()
		end
	end,
}, "AutoLeaveRaidWaveXToggle")

local DropdownMapDungeonSelect = sections.MainSection2:Dropdown({
	Name = "Select Map",
	Search = true,
	Multi = false,
	Required = true,
	Options = ValuesDungeon,
	Default = nil,
	Callback = function(value)
		getgenv().selectedMapDungeon = value:gsub("%s+", "")
	end,
}, "dropdownMapDungeon")

local DropdownDiffDungeonSelect = sections.MainSection2:Dropdown({
	Name = "Select Difficulty",
	Search = true,
	Multi = false,
	Required = true,
	Options = { "Easy", "Normal", "Hard" },
	Default = nil,
	Callback = function(value)
		getgenv().selectedDiffDungeon = value
	end,
}, "dropdownDiffDungeon")

sections.MainSection2:Toggle({
	Name = "Auto Dungeon",
	Default = false,
	Callback = function(value)
		getgenv().autoDungeonEnabled = value
		if value == true then
			autoDungeonFunction()
		end
	end,
}, "AutoDungeonToggle")

sections.MainSection2:Slider({
	Name = "Wave X to Dungeon",
	Default = 1,
	Minimum = 1,
	Maximum = 100,
	DisplayMethod = "Number",
	Precision = 0,
	Callback = function(Value)
		getgenv().selectedWaveDungeon = Value
	end,
}, "selectedWaveDungeonToggle")

sections.MainSection2:Toggle({
	Name = "Leave in Wave X",
	Default = false,
	Callback = function(value)
		getgenv().autoLeaveDungeonWaveXEnabled = value
		if value == true then
			autoLeaveDungeonWaveXFuntion()
		end
	end,
}, "AutoLeaveDungeonWaveXToggle")

local DropdownEggSelect = sections.MainSection20:Dropdown({
	Name = "Select Egg",
	Search = true,
	Multi = false,
	Required = true,
	Options = ValuesEgg,
	Default = nil,
	Callback = function(value)
		getgenv().selectedEgg = EggValues[value]
	end,
}, "dropdownEggRoll")

local DropdownPlaceSelect = sections.MainSection20:Dropdown({
	Name = "Select Place",
	Search = true,
	Multi = false,
	Required = true,
	Options = { "1", "2" },
	Default = nil,
	Callback = function(value)
		getgenv().selectedPlace = value
	end,
}, "dropdownPlaceRoll")

sections.MainSection20:Toggle({
	Name = "Auto Roll Egg",
	Default = false,
	Callback = function(value)
		getgenv().autoRollEggEnabled = value
		if value == true then
			autoRollEggFunction()
		end
	end,
}, "AutoRollEggToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Avatar",
	Default = false,
	Callback = function(value)
		getgenv().autoRollAvatarEnabled = value
		if value == true then
			autoRollAvatarFunction()
		end
	end,
}, "AutoRollAvatarToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Sword",
	Default = false,
	Callback = function(value)
		getgenv().autoRollSwordEnabled = value
		if value == true then
			autoRollSwordFunction()
		end
	end,
}, "AutoRollSwordToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Trait",
	Default = false,
	Callback = function(value)
		getgenv().autoRollTraitEnabled = value
		if value == true then
			autoRollTraitFunction()
		end
	end,
}, "AutoTraitToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Warriors",
	Default = false,
	Callback = function(value)
		getgenv().autoRollWarriorsEnabled = value
		if value == true then
			autoRollWarriorsFunction()
		end
	end,
}, "AutoRollWarriorsToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Bloodlines",
	Default = false,
	Callback = function(value)
		getgenv().autoRollBloodlineEnabled = value
		if value == true then
			autoRollBloodlineFunction()
		end
	end,
}, "AutoRollBloodlinesToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Tita Serum",
	Default = false,
	Callback = function(value)
		getgenv().autoRollTitaSerumEnabled = value
		if value == true then
			autoRollTitaSerumFunction()
		end
	end,
}, "AutoRollTitaSerumToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Possesions",
	Default = false,
	Callback = function(value)
		getgenv().autoRollPossesionsEnabled = value
		if value == true then
			autoRollPossesionsFunction()
		end
	end,
}, "AutoRollPossesionsToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Psychic Powers",
	Default = false,
	Callback = function(value)
		getgenv().autoRollPsychicPowersEnabled = value
		if value == true then
			autoRollPsychicPowersFunction()
		end
	end,
}, "AutoRollPsychicPowersToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Soul Foundation",
	Default = false,
	Callback = function(value)
		getgenv().autoRollSoulFoundationEnabled = value
		if value == true then
			autoRollSoulFoundationFunction()
		end
	end,
}, "AutoRollSoulFoundationToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Zanpakuto",
	Default = false,
	Callback = function(value)
		getgenv().autoRollZanpakutoEnabled = value
		if value == true then
			autoRollZanpakutoFunction()
		end
	end,
}, "AutoRollZanpakutoToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Power of Planets",
	Default = false,
	Callback = function(value)
		getgenv().autoRollPowerOfThePlanetsEnabled = value
		if value == true then
			autoRollPowerOfThePlanetsFunction()
		end
	end,
}, "AutoRollPowerOfThePlanetsToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Hunter Ranks",
	Default = false,
	Callback = function(value)
		getgenv().autoRollHunterRanksEnabled = value
		if value == true then
			autoRollHunterRanksFunction()
		end
	end,
}, "AutoRollHunterRanksToggle")

sections.MainSection21:Toggle({
	Name = "Auto Roll Shadow",
	Default = false,
	Callback = function(value)
		getgenv().autoRollShadowEnabled = value
		if value == true then
			autoRollShadowFunction()
		end
	end,
}, "AutoRollShadowToggle")

sections.MainSection22:Toggle({
	Name = "Auto Upgrade Shinigami Leveling",
	Default = false,
	Callback = function(value)
		getgenv().autoUpgradeShinigamiLevelingEnabled = value
		if value == true then
			autoUpgradeShinigamiLevelingFunction()
		end
	end,
}, "AutoUpgradeShinigamiLevelingToggle")

local DropdownAlienUpgradesSelect = sections.MainSection22:Dropdown({
	Name = "Select Alien Upgrades",
	Search = true,
	Multi = true,
	Required = true,
	Options = { "Energy", "Damage", "Ghost", "Enemy Range" },
	Default = nil,
	Callback = function(value)
		selectedsAlienUpgrades = value
	end,
}, "dropdownAlienUpgrades ")

sections.MainSection22:Toggle({
	Name = "Auto Upgrade Alien Upgrades",
	Default = false,
	Callback = function(value)
		getgenv().autoAlienUpgradeEnabled = value
		if value == true then
			autoAlienUpgradeFunction()
		end
	end,
}, "AutoUpgradeAlienUpgradesToggle")

local DropdownExchangesUpgradesSelect = sections.MainSection22:Dropdown({
	Name = "Select Exchanges Upgrades",
	Search = true,
	Multi = true,
	Required = true,
	Options = { "Energy", "Damage", "Ghost", "Enemy Range" },
	Default = nil,
	Callback = function(value)
		selectedsExchangesUpgrades = value
	end,
}, "dropdownExchangesUpgrades ")

sections.MainSection22:Toggle({
	Name = "Auto Upgrade Exchanges Upgrades",
	Default = false,
	Callback = function(value)
		getgenv().autoExchangesUpgradeEnabled = value
		if value == true then
			autoExchangesUpgradeFunction()
		end
	end,
}, "AutoUpgradeExchangesUpgradesToggle")

local DropdownDungeonUpgradesSelect = sections.MainSection22:Dropdown({
	Name = "Select Dungeon Upgrades",
	Search = true,
	Multi = true,
	Required = true,
	Options = { "Energy", "Damage", "Ghost", "CritDMG", "ModeDelay", "DungeonEnemyScale" },
	Default = nil,
	Callback = function(value)
		selectedsDungeonUpgrades = value
	end,
}, "dropdownDungeonUpgrades ")

sections.MainSection22:Toggle({
	Name = "Auto Upgrade Dungeon Upgrades",
	Default = false,
	Callback = function(value)
		getgenv().autoDungeonUpgradeEnabled = value
		if value == true then
			autoDungeonUpgradeFunction()
		end
	end,
}, "AutoUpgradeDungeonUpgradesToggle")

local DropdownMonarchUpgradesSelect = sections.MainSection22:Dropdown({
	Name = "Select Monarch Upgrades",
	Search = true,
	Multi = true,
	Required = true,
	Options = { "Energy", "Damage", "CritChance", "CritDMG", "AtkSPD" },
	Default = nil,
	Callback = function(value)
		selectedsMonarchUpgrades = value
	end,
}, "dropdownMonarchUpgrades ")

sections.MainSection22:Toggle({
	Name = "Auto Upgrade Monarch Upgrades",
	Default = false,
	Callback = function(value)
		getgenv().autoMonarchUpgradeEnabled = value
		if value == true then
			autoMonarchUpgradeFunction()
		end
	end,
}, "AutoUpgradeMonarchUpgradesToggle")

local DropdownSwordSelect = sections.MainSection22:Dropdown({
	Name = "Select Sword",
	Search = true,
	Multi = false,
	Required = true,
	Options = optionsSword,
	Default = nil,
	Callback = function(value)
		getgenv().selectedSword = swordMap[value]
	end,
}, "dropdownSwordRoll")

local DropdownEnchant = sections.MainSection22:Dropdown({
	Name = "Select Enchant",
	Search = true,
	Multi = true,
	Required = false,
	Options = enchantOptions,
	Default = {},
	Callback = function(values)
		selectedEnchants = values
	end,
}, "dropdownEnchantStop")

sections.MainSection22:Toggle({
	Name = "Auto Enchant Sword",
	Default = false,
	Callback = function(value)
		getgenv().autoEnchantSwordEnabled = value
		if value == true then
			autoEnchantSwordFunction()
		end
	end,
}, "AutoEnchantSwordToggle")

local DropdownSwordSelect = sections.MainSection22:Dropdown({
	Name = "Select Unit",
	Search = true,
	Multi = false,
	Required = true,
	Options = optionsPets,
	Default = nil,
	Callback = function(value)
		getgenv().selectedPassiveUnit = petMap[value]
	end,
}, "dropdownUnitPassiveRoll")

local DropdownPassive = sections.MainSection22:Dropdown({
	Name = "Select Passive",
	Search = true,
	Multi = true,
	Required = false,
	Options = passiveOptions,
	Default = {},
	Callback = function(values)
		selectedPassives = values
	end,
}, "dropdownPassiveStop")

sections.MainSection22:Toggle({
	Name = "Auto Passive Unit",
	Default = false,
	Callback = function(value)
		getgenv().autoPassiveUnitEnabled = value
		if value == true then
			autoPassiveUnitFunction()
		end
	end,
}, "AutoPassiveUnitToggle")

local DropdownSwordSelect = sections.MainSection40:Dropdown({
	Name = "Select Sword",
	Search = true,
	Multi = true,
	Required = true,
	Options = optionsSword2,
	Default = nil,
	Callback = function(values)
		selectedSwordSell = {}

		for name, _ in pairs(values) do
			selectedSwordSell[name] = true
		end
	end,
}, "dropdownSwordSell")

sections.MainSection40:Toggle({
	Name = "Auto Sell Sword",
	Default = false,
	Callback = function(value)
		getgenv().autoSellSwordEnabled = value
		if value == true then
			task.spawn(autoSellSwordFunction)
		end
	end,
}, "AutoSellSwordToggle")

local DropdownWarriorSelect = sections.MainSection40:Dropdown({
	Name = "Select Warrior",
	Search = true,
	Multi = true,
	Required = true,
	Options = warriorOptions,
	Default = nil,
	Callback = function(values)
		selectedWarriorSell = {}
		for name, _ in pairs(values) do
			local id = warriorMap[name]
			if id then
				selectedWarriorSell[id] = true
			end
		end
	end,
}, "dropdownWarriorSell")

sections.MainSection40:Toggle({
	Name = "Auto Sell Warrior",
	Default = false,
	Callback = function(value)
		getgenv().autoSellWarriorEnabled = value
		if value == true then
			autoSellWarriorsFunction()
		end
	end,
}, "AutoSellWarriorToggle")

local DropdownEggSelect = sections.MainSection80:Dropdown({
	Name = "Select Team To Farm",
	Search = true,
	Multi = false,
	Required = true,
	Options = Valuesgg,
	Default = nil,
	Callback = function(value)
		getgenv().selectedTeamToFarm = value
	end,
}, "dropdownTeamToFarm ")

sections.MainSection100:Toggle({
	Name = "Auto Execute",
	Default = false,
	Callback = function(value)
		aeuatFunction()
	end,
}, "AutoExecuteToggle")

sections.MainSection100:Toggle({
	Name = "Hide UI when Execute",
	Default = false,
	Callback = function(value)
		MacLib:HideUI(value)
	end,
}, "HideUiWhenExecuteToggle")

sections.MainSection100:Toggle({
	Name = "Low cpu usage",
	Default = false,
	Callback = function(value)
		MacLib:lowCpuUsage(value)
	end,
}, "LowCpuUsageToggle")

sections.MainSection100:Toggle({
	Name = "FPS Boost",
	Default = false,
	Callback = function(value)
		MacLib:FPSBoost(value)
	end,
}, "FPSBoostToggle")

sections.MainSection100:Slider({
	Name = "Change UI Size",
	Default = 0.75,
	Minimum = 0.5,
	Maximum = 1.5,
	DisplayMethod = "Value",
	Precision = 1,
	Callback = function(Value)
		scale = MacLib.Options.ChangeUISizeSlider.Value
		MacLib:changeUISize(scale)
	end,
}, "ChangeUISizeSlider")

sections.MainSection101:Slider({
	Name = "X Minutes to Equip Best",
	Default = 1,
	Minimum = 0,
	Maximum = 60,
	DisplayMethod = "Value",
	Precision = 0,
	Callback = function(Value)
		getgenv().equipBestInterval = Value
	end,
}, "SliderEquipBest")

sections.MainSection101:Toggle({
	Name = "Equip Best unit",
	Default = false,
	Callback = function(value)
		getgenv().equipBestEnabled = value
		if value then
			equipBestFunction()
		end
	end,
}, "EquipBestUnitToggle")

sections.MainSection101:Toggle({
	Name = "Equip Best Warrior",
	Default = false,
	Callback = function(value)
		getgenv().equipBestWarriorEnabled = value
		if value then
			equipBestWarriorFunction()
		end
	end,
}, "EquipBestWarriorToggle")

sections.MainSection101:Toggle({
	Name = "Equip Best Avatar",
	Default = false,
	Callback = function(value)
		getgenv().equipBestAvatarEnabled = value
		if value then
			equipBestAvatarFunction()
		end
	end,
}, "EquipBestAvatarToggle")

sections.MainSection101:Toggle({
	Name = "Equip Best Sword",
	Default = false,
	Callback = function(value)
		getgenv().equipBestSwordEnabled = value
		if value then
			equipBestSwordFunction()
		end
	end,
}, "EquipBestSwordToggle")

sections.MainSection101:Toggle({
	Name = "Auto Get Daily Rewards",
	Default = false,
	Callback = function(value)
		getgenv().autoGetDailyRewardsEnabled = value
		if value then
			autoGetDailyRewardsFunction()
		end
	end,
}, "AutoDailyRewardsToggle")

sections.MainSection101:Toggle({
	Name = "Auto Get Time Rewards",
	Default = false,
	Callback = function(value)
		getgenv().autoGetTimeRewardsEnabled = value
		if value then
			autoGetTimeRewardsFunction()
		end
	end,
}, "AutoTimeRewardsToggle")

sections.MainSection101:Toggle({
	Name = "Auto Rebirth",
	Default = false,
	Callback = function(value)
		getgenv().autoRebirthEnabled = value
		if value then
			autoRebirthFunction()
		end
	end,
}, "AutoRebirthToggle")

sections.MainSection101:Toggle({
	Name = "Remove Notify",
	Default = false,
	Callback = function(value)
		removeNotify()
	end,
}, "removeNotifyToggle")

sections.MainSection101:Toggle({
	Name = "Auto Get Achievement",
	Default = false,
	Callback = function(value)
		getgenv().autoGetAchievementsEnabled = value
		if value then
			autoGetAchievementsFunction()
		end
	end,
}, "autoGetAchievementToggle")

Window.onUnloaded(function() end)
tabs.Main:Select()

MacLib:SetFolder("Void Hub")
MacLib:SetFolder("Void Hub/_ANIME_GHOSTS")
local GameConfigName = "_ANIME_GHOSTS"
local player = game.Players.LocalPlayer
MacLib:LoadConfig(player.Name .. GameConfigName)
spawn(function()
	while task.wait(1) do
		MacLib:SaveConfig(player.Name .. GameConfigName)
	end
end)

local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = game:GetService("Players").LocalPlayer
LocalPlayer.Idled:Connect(function()
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end)
