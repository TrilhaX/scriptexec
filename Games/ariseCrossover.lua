repeat
	task.wait()
until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()

local MacLib =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled
local pcSize = UDim2.fromOffset(868, 650)
local mobileSize = UDim2.fromOffset(800, 550)
local currentSize = isMobile and mobileSize or pcSize

local Window = MacLib:Window({
	Title = "Tempest Hub",
	Subtitle = "Arise Crossover",
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
			Lifetime = 3,
		})
	end
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
			Window:SetUserInfoState(false)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Showing" or "Redacted") .. " User Info",
				Lifetime = 5,
			})
		end,
	}),
}
warn("[TEMPEST HUB] Loading Function")
wait()
warn("[TEMPEST HUB] Loading Toggles")
wait()
warn("[TEMPEST HUB] Last Checking")
wait()

local petsFolder = workspace:FindFirstChild("__Main"):FindFirstChild("__Pets")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidPlayer = character:FindFirstChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")
local speed = 200
local currentTarget = nil
local isTweening = false

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

function hidePlayer()
	local player = game.Players.LocalPlayer
	local character = player.Character

	if character then
		local head = character.Head
		local humanoidrootpart = character.HumanoidRootPart
		for i, v in pairs(head:GetChildren()) do
			if v.ClassName == "BillboardGui" or v.ClassName == "Decal" then
				v:Destroy()
			end
		end
		for i, v in pairs(humanoidrootpart:GetChildren()) do
			if v.ClassName == "BillboardGui" or v.ClassName == "Decal" then
				v:Destroy()
			end
		end
		for _, obj in ipairs(character:GetChildren()) do
			if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") then
				obj:Destroy()
			end
		end
	end
end

function hitboxExtender()
	while getgenv().hitboxExtenderBoolean == true do
		local enemies = workspace.__Main.__Enemies.Client

		for _, v in pairs(enemies:GetChildren()) do
			local hitbox = v:FindFirstChild("Hitbox")
			if hitbox and hitbox:IsA("BasePart") then
				hitbox.Size = Vector3.new(100, 100, 100)
			end
		end
		wait()
	end
end

function tpShadowsForPlayer(enemy)
	if petsFolder then
		local petPositions = {}

		for _, pet in ipairs(petsFolder:GetChildren()) do
			if pet:IsA("Model") then
				local primaryPart = pet.PrimaryPart or pet:FindFirstChild("HumanoidRootPart")
				if primaryPart then
					petPositions[pet.Name] = primaryPart.Position
				else
					petPositions[pet.Name] = Vector3.new(0, 0, 0)
				end
			end
		end

		for _, pet in ipairs(petsFolder:GetChildren()) do
			for _, folder in ipairs(pet:GetChildren()) do
				if folder:IsA("Folder") then
					for _, obj in ipairs(folder:GetChildren()) do
						if obj:IsA("Model") then
							local humanoidRootPart = obj:FindFirstChild("HumanoidRootPart")
							if humanoidRootPart then
								humanoidRootPart.CFrame = humanoidPlayer.CFrame

								local args = {
									[1] = {
										[1] = {
											["PetPos"] = petPositions,
											["AttackType"] = "All",
											["Event"] = "Attack",
											["Enemy"] = enemy.Name,
										},
										[2] = "\t",
									},
								}

								game:GetService("ReplicatedStorage")
									:WaitForChild("BridgeNet2")
									:WaitForChild("dataRemoteEvent")
									:FireServer(unpack(args))
							end
						end
					end
				end
			end
		end
	end
end

function autoFarmNearest()
	while getgenv().autoFarmNearestBoolean == true do
		if
			not game.Players.LocalPlayer.Character
			or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		then
			task.wait(1)
		end

		local player = game.Players.LocalPlayer
		local playerPos = player.Character.HumanoidRootPart.Position
		local enemies = workspace.__Main.__Enemies.Client:GetChildren()
		local nearestEnemy = nil
		local nearestDistance = math.huge

		for _, enemy in pairs(enemies) do
			local healthBar = enemy:FindFirstChild("HealthBar")
			if healthBar and healthBar.Enabled == true then
				local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
				if enemyRoot then
					local distance = (playerPos - enemyRoot.Position).Magnitude
					if distance < nearestDistance then
						nearestDistance = distance
						nearestEnemy = enemy
					end
				end
			end
		end

		if nearestEnemy then
    	    if currentTarget and currentTarget.HealthBar and currentTarget.HealthBar.Enabled == true then
				if (playerPos - currentTarget.HumanoidRootPart.Position).Magnitude > 10 then
					currentTarget = nil
				else
					task.wait(0.5)
				end
			end

			if not isTweening then
				currentTarget = nearestEnemy
				print("Movendo até novo alvo:", currentTarget.Name)

				local targetCFrame = GetCFrame(currentTarget)
				if targetCFrame then
					isTweening = true
					local tween = tweenModel(player.Character, targetCFrame)
					tween:Play()

					tween.Completed:Wait()
					isTweening = false
                    
					if currentTarget and currentTarget.HealthBar and currentTarget.HealthBar.Enabled == true then
						print("Começando ataque ao alvo:", currentTarget.Name)
						while
							currentTarget
							and currentTarget.Parent
							and currentTarget.HealthBar
							and currentTarget.HealthBar.Enabled == true
							and getgenv().autoFarmNearestBoolean == true
						do
							task.wait(0.1)
						end

						if getgenv().autoFarmNearestBoolean == true then
							tpShadowsForPlayer(currentTarget)
							print("Alvo derrotado!")
						end
					end
				end
			end
		else
			print("Nenhum alvo vivo encontrado. Procurando...")
			task.wait(1)
		end
	end
end

function walkspeed(value)
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidPlayer = character:FindFirstChild("Humanoid")

	if humanoidPlayer then
		while true do
			humanoidPlayer.WalkSpeed = 100
			wait()
		end
	end
end

local tabGroups = {
	TabGroup1 = Window:TabGroup(),
}

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
	Farm = tabGroups.TabGroup1:Tab({ Name = "Farm", Image = "rbxassetid://18821914323" }),
	Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" }),
}

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
	MainSection6 = tabs.Farm:Section({ Side = "Left" }),
	MainSection25 = tabs.Settings:Section({ Side = "Left" }),
	MainSection26 = tabs.Settings:Section({ Side = "Left" }),
}

sections.MainSection1:Header({
	Name = "Player",
})

sections.MainSection1:Toggle({
	Name = "Hide Player Info",
	Default = false,
	Callback = function(value)
		hidePlayer()
	end,
}, "HidePlayerInfo")

sections.MainSection1:Toggle({
	Name = "Hitbox Extender",
	Default = false,
	Callback = function(value)
		getgenv().hitboxExtenderBoolean = value
		hitboxExtender()
	end,
}, "HitBoxExtender")

sections.MainSection1:Slider({
	Name = "Walkspeed",
	Default = distancePercentage or 50,
	Minimum = 0,
	Maximum = 200,
	DisplayMethod = "Number",
	Precision = 1,
	Callback = function(Value)
		walkspeed(Value)
	end,
}, "Walspeed")

sections.MainSection6:Header({
	Name = "Farm",
})

sections.MainSection6:Toggle({
	Name = "Auto Farm Nearest",
	Default = false,
	Callback = function(value)
		getgenv().autoFarmNearestBoolean = value
		autoFarmNearest()
	end,
}, "autoFarmNearest")

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
	end,
}, "changeUISize")

Window.onUnloaded(function()
	print("Unloaded!")
end)

tabs.Main:Select()

MacLib:SetFolder("Tempest Hub")
MacLib:SetFolder("Tempest Hub/_Arise_Crossover_")
local GameConfigName = "_Arise_Crossover_"
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
hideUI()
getgenv().loadedallscript = true
