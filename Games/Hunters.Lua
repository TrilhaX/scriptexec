--Checking if game is loaded
repeat
	task.wait()
until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()

--Starting Script
local MacLib =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled
local pcSize = UDim2.fromOffset(868, 650)
local mobileSize = UDim2.fromOffset(800, 550)
local currentSize = isMobile and mobileSize or pcSize

local Window = MacLib:Window({
	Title = "Tempest Hub",
	Subtitle = "Anime Last Stand",
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

--Locals
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local speed = 200
local waitTime = 1

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

function fireproximityprompt(Obj, Amount, Skip)
	if not Obj then
		return warn("userdata<ProximityPrompt> expected")
	end
	local Obj = Obj:IsA("ProximityPrompt") and Obj or Obj:FindFirstChildWhichIsA("ProximityPrompt")
	if Obj and Obj.ClassName == "ProximityPrompt" then
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
		return warn("userdata<ProximityPrompt> expected")
	end
end

function hideUI()
	local UICorner1 = Instance.new("UICorner")
	local backgroundFrame = Instance.new("Frame")
	local tempestButton = Instance.new("TextButton")
	local UIPadding = Instance.new("UIPadding")

	local coreGui = game:GetService("CoreGui")
	local maclibGui = coreGui:FindFirstChild("MaclibGui")

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
	print("Criado")
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

hideUI()

function hideUIExec()
	while getgenv().hideUIExecGG == true do
		if getgenv().loadedallscript == true then
			local coreGui = game:GetService("CoreGui").RobloxGui
			local Base = nil

			if coreGui:FindFirstChild("MaclibGui") then
				Base = coreGui.MaclibGui:FindFirstChild("Base")
			end

			if Base then
				Base.Visible = false
			else
				warn("Base não encontrado.")
			end
		end
		wait()
	end
end

function aeuat()
	while getgenv().aeuatGG == true do
		if getgenv().loadedallscript == true then
			local teleportQueued = false
			game.Players.LocalPlayer.OnTeleport:Connect(function(State)
				if
					(State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress)
					and not teleportQueued
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
		end
		wait()
	end
end

function firebutton(Button, method)
	if not Button then
		warn("firebutton: Botão inválido ou não encontrado.")
		return
	end

	local a = Button

	if getconnections and method == "getconnections" then
		if Button.Activated then
			for i, v in pairs(getconnections(Button.Activated)) do
				wait()
				v.Function()
			end
		end
	elseif firesignal and method == "firesignal" then
		local events = { "MouseButton1Click", "MouseButton1Down", "Activated" }
		for _, v in pairs(events) do
			if Button[v] then
				print("[DEBUG] Disparando evento:", v)
				firesignal(Button[v])
			end
		end
	elseif VirtualInputManager and method == "VirtualInputManager" then
		game:GetService("GuiService").SelectedObject = Button
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
		wait(1)
		game:GetService("GuiService").SelectedObject = nil
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
	while getgenv().fpsBoostGG == true do
		if getgenv().loadedallscript == true then
			removeTexturesAndHeavyObjects(workspace)
		end
		break
	end
end

function betterFpsBoost()
	while getgenv().betterFpsBoostGG == true do
		if getgenv().loadedallscript == true then
			removeTexturesAndHeavyObjects(workspace)
			local enemiesAndUnits = workspace:FindFirstChild("_UNITS")

			if enemiesAndUnits then
				for i, v in pairs(enemiesAndUnits:GetChildren()) do
					v:Destroy()
				end
			end
		end
		break
	end
end

function extremeFpsBoost()
	while getgenv().extremeFpsBoostGG == true do
		if getgenv().loadedallscript == true then
			removeTexturesAndHeavyObjects(workspace)
			local enemiesAndUnits = workspace:FindFirstChild("_UNITS")

			if enemiesAndUnits then
				for i, v in pairs(enemiesAndUnits:GetChildren()) do
					v:Destroy()
				end
			end
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

			game.Lighting.GlobalShadows = false
			game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)

			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
					obj.Material = Enum.Material.SmoothPlastic
					obj.Color = Color3.new(0.5, 0.5, 0.5)
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
		break
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

function GetPositionFARMMETHOD(Mob, Method, offset) --Dont Put offset = 0
    if not Mob then
        return
    end

    local MobCFrame = GetCFrame(Mob)
    if not MobCFrame then
        return
    end

    local MobPosition = MobCFrame.Position
    offset = offset
    Method = Method

    local function positionCharacter(position)
        local lookVector = (MobPosition - position).Unit
        return CFrame.new(position, position + lookVector)
    end

    local Pos
    if Method == 'Above' then
        Pos = positionCharacter(MobPosition + Vector3.new(0, offset, 0))
    elseif Method == 'Below' then
        Pos = positionCharacter(MobPosition - Vector3.new(0, offset, 0))
    elseif Method == 'Front' then
        Pos = positionCharacter(MobPosition + MobCFrame.LookVector * offset)
    elseif Method == 'Behind' then
        Pos = positionCharacter(MobPosition - MobCFrame.LookVector * offset)
    else
        print("Invalid Method")
    end

    return Pos
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

-- Game Functions

function hidePlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character

    if character then
        local head = character.Head
        local humanoidrootpart = character.HumanoidRootPart
        for i, v in pairs(head:GetChildren())do
            if v.ClassName == "BillboardGui" or v.ClassName == "Decal" then
                v:Destroy()
            end
        end
                for i, v in pairs(humanoidrootpart:GetChildren())do
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

function killAura()
    while getgenv().killAuraGG == true do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Combat"):FireServer()
        wait()
    end
end

function autoDungeon()
    while getgenv().autoDungeonGG == true do
        local mobs = workspace.Mobs
        local mobChildren = mobs and mobs:GetChildren() or {}
        
        if #mobChildren > 0 then
            local mobTp = mobChildren[1]
            local GetMobCFrame = GetPositionFARMMETHOD(mobTp, 'Above', 7)
            local tween = tweenModel(game.Players.LocalPlayer.Character, GetMobCFrame)
            tween:Play()
            tween.Completed:Wait()
        end
        
        wait()
    end
end

local tabGroups = {
	TabGroup1 = Window:TabGroup(),
}

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
	Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" }),
}

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
	MainSection2 = tabs.Main:Section({ Side = "Right" }),
	MainSection3 = tabs.Main:Section({ Side = "Right" }),
	MainSection4 = tabs.Settings:Section({ Side = "Right" }),
}

sections.MainSection1:Header({
	Name = "Player",
})

sections.MainSection1:Toggle({
	Name = "Hide Player",
	Default = false,
	Callback = function(value)
        hidePlayer()
	end,
}, "HidePlayer")

sections.MainSection1:Toggle({
	Name = "Kill Aura",
	Default = false,
	Callback = function(value)
		getgenv().killAuraGG = value
		killAura()
	end,
}, "KillAura")

sections.MainSection1:Toggle({
	Name = "Auto Dungeon",
	Default = false,
	Callback = function(value)
		getgenv().autoDungeonGG = value
		autoDungeon()
	end,
}, "autoDungeon")

--UI IMPORTANT THINGS

MacLib:SetFolder("Maclib")
tabs.Settings:InsertConfigSection("Left")

sections.MainSection25:Toggle({
	Name = "Hide UI when Execute",
	Default = false,
	Callback = function(value)
		getgenv().hideUIExecGG = value
		hideUIExec()
	end,
}, "HideUiWhenExecute")

sections.MainSection25:Toggle({
	Name = "Auto Execute",
	Default = false,
	Callback = function(value)
		getgenv().aeuatGG = value
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
		getgenv().fpsBoostGG = value
		fpsBoost()
	end,
}, "FPSBoost")

sections.MainSection25:Toggle({
	Name = "Better FPS Boost",
	Default = false,
	Callback = function(value)
		getgenv().betterFpsBoostGG = value
		betterFpsBoost()
	end,
}, "BetterFPSBoost")

sections.MainSection25:Toggle({
	Name = "REALLY Better FPS Boost",
	Default = false,
	Callback = function(value)
		getgenv().extremeFpsBoostGG = value
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
	end,
}, "changeUISize")

Window.onUnloaded(function()
	print("Unloaded!")
end)

tabs.Main:Select()

MacLib:SetFolder("Tempest Hub")
MacLib:SetFolder("Tempest Hub/_ALS_")
local GameConfigName = "_ALS_"
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
getgenv().loadedallscript = true