repeat task.wait() until game:IsLoaded()
wait(10)
warn("[TEMPEST HUB] Loading Ui")
wait()
local MacLib =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

--Loading UI Library
local Window = MacLib:Window({
	Title = "Tempest Hub",
	Subtitle = "Jujutsu Infinite",
	Size = UDim2.fromOffset(900, 500),
	DragStyle = 1,
	DisabledWindowControls = {},
	ShowUserInfo = true,
	Keybind = Enum.KeyCode.RightControl,
	AcrylicBlur = true,
})

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
			Window:SetUserInfoState(bool)
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

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local speed = 200

--START OF FUNCTIONS
function hideUIExec()
	if getgenv().hideUIExec then
		local success, errorMsg = pcall(function()
			local coreGui = game:GetService("CoreGui")
			local maclib = coreGui.RobloxGui:FindFirstChild("MaclibGui")
			if maclib then
				maclib.Base.Visible = false
				maclib.Notifications.Visible = false
			else
				warn("MaclibGui not found in CoreGui.")
			end
		end)

		if not success then
			warn("Error hiding UI: " .. errorMsg)
		end
	else
		warn("getgenv().hideUIExec is not set or is false.")
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
                    wait(3)
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

function hideUI()
	local success, coreGui = pcall(function()
		return game:GetService("CoreGui")
	end)
	if not success or not coreGui then
		warn("CoreGui not accessible.")
		return
	end

	local successRobloxGui, robloxGui = pcall(function()
		return coreGui:FindFirstChild("RobloxGui")
	end)
	if not successRobloxGui or not robloxGui then
		warn("RobloxGui not found in CoreGui.")
		return
	end

	local successMaclibGui, maclibGui = pcall(function()
		return robloxGui:FindFirstChild("MaclibGui")
	end)
	if not successMaclibGui or not maclibGui then
		warn("MaclibGui not found in RobloxGui.")
		return
	end

	local UICorner1 = Instance.new("UICorner")
	local UICorner2 = Instance.new("UICorner")
	local backgroundFrame = Instance.new("Frame")
	local tempestButton = Instance.new("TextButton")
	local UIPadding = Instance.new("UIPadding")

	backgroundFrame.Name = "backgroundFrame"
	backgroundFrame.Parent = maclibGui
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
		local successMaclib, maclib = pcall(function()
			return robloxGui:FindFirstChild("MaclibGui")
		end)
		if successMaclib and maclib then
			maclib.Base.Visible = not maclib.Base.Visible
			maclib.Notifications.Visible = not maclib.Notifications.Visible
		else
			warn("MaclibGui not found during button activation.")
		end
	end)
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

function ServerHop()
	loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Server-hop-7401"))()
end

function autoUseBuff()
	while getgenv().autoUseBuff do
		local consumables = game:GetService("ReplicatedStorage").ReplicatedAssets.VFX:FindFirstChild("ConsumableModels")

		if consumables then
			for _, v in pairs(consumables:GetChildren()) do
				local args = {
					[1] = v.Name
				}
		
				local success, errorMessage = pcall(function()
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
						:WaitForChild("Server"):WaitForChild("Data")
						:WaitForChild("EquipItem"):InvokeServer(unpack(args))
				end)
		
				if success then
					print(v.Name .. " used successfully.")
				else
					warn("Failed to use " .. v.Name .. ": " .. errorMessage)
				end
			end
		else
			warn("No consumables found!")
		end		
		wait(1)
	end
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
						GuiService.SelectedObject = buttonRetry
						VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
						VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
					end
				else
					local GuiService = game:GetService("GuiService")
					local VirtualInputManager = game:GetService("VirtualInputManager")
					GuiService.SelectedObject = buttonRetry
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
			local buttonLeave = ReadyScreen.Frame.Teleport
			if buttonLeave and buttonLeave.Visible == true then
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
								GuiService.SelectedObject = buttonLeave
								VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
								VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
							end
						end
					end
				end
			else
				GuiService.SelectedObject = buttonLeave
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

		local dropsChildren = Drops:GetChildren()
		if #dropsChildren ~= 0 or loot.Enabled == true then
			for i, v in pairs(Drops:GetChildren()) do
				if v:FindFirstChild("PlayerOwned") and v.PlayerOwned.Value == game.Players.LocalPlayer then
					game:GetService("ReplicatedStorage").Remotes.Client.CollectChest.OnClientInvoke = function()
						return 0
					end
					local pr = v:FindFirstChild("Collect")
					fireproximityprompt(pr, 15, true)
					wait(0.5)
					if loot.Enabled == true then
						while loot.Enabled == true do
							GuiService.SelectedObject = loot.Frame.Flip
							VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
							VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
							wait(0.5)
						end
					end
				else
					if loot.Enabled == true then
						GuiService.SelectedObject = loot.Frame.Flip
						VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
						VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
					end
				end
			end
			while loot.Enabled == true do
				GuiService.SelectedObject = loot.Frame.Flip
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				wait(0.5)
			end
		end
		wait()
	end
end

function HitKill()
	while getgenv().HitKill == true do
		local mobs = workspace.Objects:FindFirstChild("Mobs")

		if mobs then
			for _, v in pairs(mobs:GetChildren()) do
				local humanoid = v:FindFirstChild("Humanoid")
				if humanoid then
					local targetHealth = 0
					local decrement = 1000
					local delay = 0.1

					while humanoid.Health > targetHealth do
						humanoid.Health = math.max(humanoid.Health - decrement, targetHealth)
						wait()
					end
				end
			end
		end
		wait(delaytoAttack)
	end
end

function autoBoss()
	while getgenv().autoBoss == true do
		wait(delaytoAttackMob)
		local mobs = workspace.Objects:FindFirstChild("Mobs")

		if mobs then
			local bossSpawn = workspace.Objects.Spawns:FindFirstChild("BossSpawn")
			if bossSpawn then
				local targetCFrame = GetCFrame(bossSpawn)
				local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
				tween:Play()
				tween.Completed:Wait()
				wait(0.5)

				local changeWeaponArgs = {
					[1] = "Fists",
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Server")
					:WaitForChild("Combat")
					:WaitForChild("ChangeWeapon")
					:FireServer(unpack(changeWeaponArgs))
				wait(0.3)

				local attackArgs = {
					[1] = 1,
					[2] = {},
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Server")
					:WaitForChild("Combat")
					:WaitForChild("M1")
					:FireServer(unpack(attackArgs))

				for _, mob in pairs(mobs:GetChildren()) do
					local humanoid = mob:FindFirstChild("Humanoid")

					if humanoid and not mob:FindFirstChild("BossSpawn") then
						local targetHealth = 0
						local decrement = 500
						local delay = 0.05
						while humanoid.Health > targetHealth do
							humanoid.Health = math.max(humanoid.Health - decrement, targetHealth)
							wait(delay)
						end
					end
				end
			end
		end
		wait(1)
	end
end

function autoInvestigation()
	while getgenv().autoInvestigation == true do
		wait(delaytoAttackMob)
		local ReadyScreen = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ReadyScreen")
		if ReadyScreen and ReadyScreen.Enabled == true then
			break
		end

		local missionItems = workspace.Objects:FindFirstChild("MissionItems")

		if missionItems then
			local items = missionItems:GetChildren()

			if #items > 0 then
				for _, v in ipairs(items) do
					if v.Name == "Civilian" then
						local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")
						if HumanoidRootPart then
							local teleportCFrame = HumanoidRootPart.CFrame
							local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
							tween:Play()
							tween.Completed:Wait()
							local pr = v:FindFirstChild("PickUp")
							if pr then
								fireproximityprompt(pr, 5, true)
							end
							local teleportCFrame2 = workspace.Map.Parts.SpawnLocation.CFrame
							local tween2 = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame2)
							tween2:Play()
							tween2.Completed:Wait()
						end
					elseif v.Name == "CursedObject" then
						local pr = v:FindFirstChild("Collect")
						local teleportCFrame = v.CFrame
						local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
						tween:Play()
						tween.Completed:Wait()
						if pr then
							fireproximityprompt(pr, 5, true)
						end
					end
				end
			else
				print("Nenhum item dentro de MissionItems.")
			end
		else
			print("MissionItems não encontrados. Indo atrás do mob com maior vida.")
		end

		local mobs = workspace.Objects:FindFirstChild("Mobs")
		if mobs then
			local mobList = mobs:GetChildren()
			local highestHealthMob = nil
			local highestHealth = -1

			for _, mob in ipairs(mobList) do
				local success, humanoid = pcall(function()
					return mob:FindFirstChild("Humanoid")
				end)

				if success and humanoid and humanoid:IsA("Humanoid") and humanoid.Health > highestHealth then
					highestHealth = humanoid.Health
					highestHealthMob = mob
				end
			end

			if highestHealthMob then
				local targetCFrame = GetCFrame(highestHealthMob, 15)
				local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
				tween:Play()
				tween.Completed:Wait()

				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Server")
					:WaitForChild("Combat")
					:WaitForChild("ChangeWeapon")
					:FireServer("Fists")
				wait(0.2)

				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Server")
					:WaitForChild("Combat")
					:WaitForChild("M1")
					:FireServer(1, {})
				wait(0.2)

				while highestHealthMob:FindFirstChild("Humanoid") and highestHealthMob.Humanoid.Health > 0 do
					highestHealthMob.Humanoid.Health = math.max(highestHealthMob.Humanoid.Health - 500, 0)
					wait(0.05)
				end
			else
				print("Nenhum mob encontrado com vida válida.")
			end
		else
			print("Nenhum mob encontrado na área.")
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
	while getgenv().tpToItem == true do
		local drops = workspace.Objects.Drops
		if getgenv().IgnoreTalisman and not getgenv().ServerHopToItems then
			for i, v in pairs(drops:GetChildren()) do
				if v.Name ~= "Talisman" then
					local teleportCFrame = GetCFrame(v.Root)
					local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
					tween:Play()
					tween.Completed:Wait()
					if v.Root then
						fireproximityprompt(v.Collect, 3, true)
					end
				end
			end
		elseif getgenv().IgnoreTalisman and getgenv().ServerHopToItems then
			local foundItems = false
			for i, v in pairs(drops:GetChildren()) do
				if v.Name ~= "Talisman" then
					foundItems = true
					local teleportCFrame = GetCFrame(v.Root)
					local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
					tween:Play()
					tween.Completed:Wait()
					if v.Root then
						fireproximityprompt(v.Collect, 3, true)
					end
				end
			end
			if not foundItems then
				ServerHop()
			end
		elseif not getgenv().IgnoreTalisman and not getgenv().ServerHopToItems then
			for i, v in pairs(drops:GetChildren()) do
				local teleportCFrame = GetCFrame(v.Root)
				local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
				tween:Play()
				tween.Completed:Wait()
				if v.Root then
					fireproximityprompt(v.Collect, 3, true)
				end
			end
		elseif not getgenv().IgnoreTalisman and getgenv().ServerHopToItems then
			local foundItems = false
			for i, v in pairs(drops:GetChildren()) do
				foundItems = true
				local teleportCFrame = GetCFrame(v.Root)
				local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
				tween:Play()
				tween.Completed:Wait()
				if v.Root then
					fireproximityprompt(v.Collect, 3, true)
				end
			end
			if not foundItems then
				ServerHop()
			end
		else
			for i, v in pairs(drops:GetChildren()) do
				print("Checking drop:", v.Name)
				local teleportCFrame = GetCFrame(v.Root)
				print("Teleporting to:", teleportCFrame)
				local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
				tween:Play()
				tween.Completed:Wait()
				if v.Root then
					fireproximityprompt(v.Collect, 3, true)
				end
			end
		end
		wait()
	end
end

function autoJoin()
	if getgenv().autoJoin == true then
		local args = {
			[1] = selectedType,
			[2] = selectedBoss,
			[3] = selectedDifficulty,
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("Server")
			:WaitForChild("Raids")
			:WaitForChild("QuickStart")
			:InvokeServer(unpack(args))
		wait()
	end
end

function autoSkipDialogue()
	while getgenv().autoSkipDialogue == true do
		local skipButton = game:GetService("Players").LocalPlayer.PlayerGui.StorylineDialogue.Frame.Dialogue
			:FindFirstChild("Skip")

		if skipButton and skipButton.Visible == true then
			if skipButton.TextLabel.Text == "Skip (0/1)" and skipButton.Visible == true then
				game:GetService("ReplicatedStorage")
					:WaitForChild("Remotes")
					:WaitForChild("Client")
					:WaitForChild("StorylineDialogueSkip")
					:FireServer()
				wait(5)
			else
				print("No Dialogue")
			end
		end
		wait(1)
	end
end

function webhook()
	while getgenv().webhook == true do
		local discordWebhookUrl = urlwebhook
		local resultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Results")

		local numberAndAfter = {}
		local statsString = {}
		local mapConfigString = {}

		if resultUI and resultUI.Enabled == true then
			local name = game:GetService("Players").LocalPlayer.Name
			local formattedName = "||" .. name .. "||"

			local player = game:GetService("Players").LocalPlayer
			local levelPlayer = player.PlayerGui.Main.Frame.BottomLeft.Menu:FindFirstChild("TextLabel")

			if levelPlayer then
				table.insert(numberAndAfter, levelPlayer.Text)
			end

			local grade = game:GetService("Players").LocalPlayer.ReplicatedData:FindFirstChild("grade")
			local cash = game:GetService("Players").LocalPlayer.ReplicatedData:FindFirstChild("cash")

			if grade and cash then
				table.insert(statsString, grade.Value .. "\n" .. "Cash: $" .. cash.Value)
			end

			local frame = game:GetService("Players").LocalPlayer.PlayerGui.Results.Frame:FindFirstChild("Stats")

			if frame then
				local deaths = frame:FindFirstChild("Deaths") and frame.Deaths.Value or 0
				local kills = frame:FindFirstChild("Kills") and frame.Kills.Value or 0
				local playerCount = frame:FindFirstChild("PlayerCount") and frame.PlayerCount.Value or 0
				local score = frame:FindFirstChild("Score") and frame.Score.Value or 0
				local timeSpent = frame:FindFirstChild("TimeSpent") and frame.TimeSpent.Value or 0

				local output = string.format(
					"\nDeaths: %s\nKills: %s\nPlayerCount: %s\nScore: %s\nTimeSpent: %s",
					tostring(deaths.Text),
					tostring(kills.Text),
					tostring(playerCount.Text),
					tostring(score.Text),
					tostring(timeSpent.Text)
				)
				table.insert(mapConfigString, output)
			end

			local payload = {
				content = pingContent,
				embeds = {
					{
						description = string.format(
							"User: %s\nLevel: %s\n\nPlayer Stats:\n%s\n\nMatch Result%s",
							formattedName,
							table.concat(numberAndAfter, ", "),
							table.concat(statsString, "\n"),
							table.concat(mapConfigString, "\n")
						),
						color = color,
						fields = {
							{
								name = "Discord",
								value = "https://discord.gg/ey83AwMvAn",
							},
						},
						author = {
							name = "Jujutsu Infinite",
						},
						thumbnail = {
							url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png?ex=673e5b4c&is=673d09cc&hm=1d58485280f1d6a376e1bee009b21caa0ae5cad9624832dd3d921f1e3b2217ce&",
						},
					},
				},
				attachments = {},
			}

			local payloadJson = HttpService:JSONEncode(payload)

			if syn and syn.request then
				local response = syn.request({
					Url = discordWebhookUrl,
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json",
					},
					Body = payloadJson,
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
						["Content-Type"] = "application/json",
					},
					Body = payloadJson,
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

function autoQuest()
	while getgenv().autoQuest == true do
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local questFrame = player
			:WaitForChild("PlayerGui")
			:WaitForChild("StorylineDialogue")
			:WaitForChild("Frame")
			:FindFirstChild("QuestFrame")
		local targetCFrame = CFrame.new(
			-514.074402,
			4470.24658,
			-15614.0771,
			0.695504665,
			-2.04219823e-08,
			0.718521595,
			4.03495043e-10,
			1,
			2.80316552e-08,
			-0.718521595,
			-1.92062277e-08,
			0.695504665
		)
		if questFrame and not questFrame.Visible then
			local tween = tweenModel(character, targetCFrame)
			tween:Play()
			tween.Completed:Wait()
			wait(1)

			local args = {
				[1] = {
					type = "Capture",
					set = "Shijo Town Set",
					rewards = {
						essence = 10,
						cash = 6870,
						exp = 767376,
						chestMeter = 55,
					},
					rewardsText = "$6870 | 767376 EXP | 10 Mission Essence",
					difficulty = 2,
					title = "Capture",
					level = 292,
					subtitle = "a point",
					grade = "Grade 1",
				},
			}

			game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("Server")
				:WaitForChild("Data")
				:WaitForChild("TakeQuest")
				:InvokeServer(unpack(args))
		else
			local missionItems = workspace:FindFirstChild("Objects"):FindFirstChild("MissionItems")
			if missionItems then
				for _, item in ipairs(missionItems:GetChildren()) do
					if item.Name == player.Name then
						local tween = tweenModel(character, item.CFrame)
						tween:Play()
						tween.Completed:Wait()
						wait()
					end
				end
			end
		end
		wait()
	end
end

local ValuesInates = {}
local ValuesKeybinds = {}
local ValuesDrops = {}
local ValuesBoss = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local ReplicatedData = LocalPlayer:FindFirstChild("ReplicatedData")

if ReplicatedData then
	local techniques = ReplicatedData:FindFirstChild("techniques")
	if techniques then
		local innates = techniques:FindFirstChild("innates")
		if innates and innates:IsA("Folder") and #innates:GetChildren() > 0 then
			for _, v in ipairs(innates:GetChildren()) do
				table.insert(ValuesKeybinds, v.Name)
			end
		end
	end
end

local skills = ReplicatedStorage:FindFirstChild("Skills")
if skills and skills:IsA("Folder") then
	for _, v in ipairs(skills:GetChildren()) do
		table.insert(ValuesInates, v.Name)
	end
end

local drops = workspace:FindFirstChild("Objects")
if drops and drops:IsA("Folder") then
	local dropsFolder = drops:FindFirstChild("Drops")
	if dropsFolder and dropsFolder:IsA("Folder") then
		local function contains(table, value)
			for _, v in pairs(table) do
				if v == value then
					return true
				end
			end
			return false
		end

		for _, v in ipairs(dropsFolder:GetChildren()) do
			if not contains(ValuesDrops, v.Name) then
				table.insert(ValuesDrops, v.Name)
			end
		end
	end
end

local RaidInfo = ReplicatedStorage:FindFirstChild("Dependencies")
if RaidInfo and RaidInfo:IsA("Folder") then
	local raidInfoScript = RaidInfo:FindFirstChild("RaidInfo")
	if raidInfoScript and raidInfoScript:IsA("ModuleScript") then
		local success, raidData = pcall(require, raidInfoScript)
		if success and typeof(raidData) == "table" then
			for k, _ in pairs(raidData) do
				table.insert(ValuesBoss, k)
			end
		else
			warn("Erro ao carregar o módulo RaidInfo:", raidData)
		end
	else
		warn("RaidInfo não é um ModuleScript ou não existe.")
	end
else
	warn("Dependencies ou RaidInfo não encontrados no ReplicatedStorage.")
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
	Name = "Kill Aura",
	Default = false,
	Callback = function(value)
		getgenv().HitKill = value
		HitKill()
	end,
}, "hitKillMobs")

sections.MainSection1:Slider({
	Name = "Delay to Hit Kill Mobs",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Round",
	Precision = 0,
	Callback = function(value)
		delaytoAttack = value
	end,
}, "DTHKM")

sections.MainSection1:Toggle({
	Name = "Auto Skip Dialogue",
	Default = false,
	Callback = function(value)
		getgenv().autoSkipDialogue = value
		autoSkipDialogue()
	end,
}, "autoSkipDialogue")

sections.MainSection1:Toggle({
	Name = "Auto Retry",
	Default = false,
	Callback = function(value)
		getgenv().autoRetry = value
		autoRetry()
	end,
}, "autoRetry")

sections.MainSection1:Toggle({
	Name = "Auto Leave",
	Default = false,
	Callback = function(value)
		getgenv().autoLeave = value
		autoLeave()
	end,
}, "autoLeave")

sections.MainSection1:Toggle({
	Name = "Auto Get Chest",
	Default = false,
	Callback = function(value)
		getgenv().autoChest = value
		autoChest()
	end,
}, "autoGetChest")

sections.MainSection1:Toggle({
	Name = "Auto Use Buff",
	Default = false,
	Callback = function(value)
		getgenv().autoUseBuff = value
		autoUseBuff()
	end,
}, "autoUseBuff")

local Dropdown = sections.MainSection1:Dropdown({
	Name = "Select Keybind",
	Multi = false,
	Required = true,
	Options = ValuesKeybinds,
	Default = None,
	Callback = function(value)
		selectedKeybind = value
	end,
}, "selectKeybind")

local Dropdown = sections.MainSection1:Dropdown({
	Name = "Select Skill",
	Multi = false,
	Required = true,
	Options = ValuesInates,
	Default = None,
	Callback = function(value)
		selectedInate = value
	end,
}, "selectSkill")

sections.MainSection1:Button({
	Name = "Set Skill",
	Callback = function()
		getSkill()
	end,
})

sections.MainSection1:Toggle({
	Name = "Auto Farm Items",
	Default = false,
	Callback = function(value)
		getgenv().tpToItem = value
		tpToItem()
	end,
}, "autoFarmItems")

sections.MainSection1:Toggle({
	Name = "Ignore Talisman",
	Default = false,
	Callback = function(value)
		getgenv().IgnoreTalisman = value
	end,
}, "ignoreTalisman")

sections.MainSection1:Toggle({
	Name = "Server Hop To Items",
	Default = false,
	Callback = function(value)
		getgenv().ServerHopToItems = value
	end,
}, "serverHopToItems")

sections.MainSection2:Header({
	Name = "Farm",
})

local Dropdown = sections.MainSection2:Dropdown({
	Name = "Select Type",
	Multi = false,
	Required = true,
	Options = { "Boss", "Investigation" },
	Default = None,
	Callback = function(value)
		selectedType = value
	end,
}, "selectType")

local Dropdown = sections.MainSection2:Dropdown({
	Name = "Select Boss or Act",
	Multi = false,
	Required = true,
	Options = ValuesBoss,
	Default = None,
	Callback = function(value)
		selectedBoss = value
	end,
}, "selectBossOrAct")

local Dropdown = sections.MainSection2:Dropdown({
	Name = "Select Difficulty",
	Multi = false,
	Required = true,
	Options = { "easy", "medium", "hard", "nightmare" },
	Default = None,
	Callback = function(value)
		selectedDifficulty = value
	end,
}, "selectDifficulty")

sections.MainSection2:Toggle({
	Name = "Auto Join",
	Default = false,
	Callback = function(value)
		getgenv().autoJoin = value
		autoJoin()
	end,
}, "autoJoin")

sections.MainSection2:Toggle({
	Name = "Auto Boss",
	Default = false,
	Callback = function(value)
		getgenv().autoBoss = value
		autoBoss()
	end,
}, "autoBoss")

sections.MainSection2:Toggle({
	Name = "Auto Investigation",
	Default = false,
	Callback = function(value)
		getgenv().autoInvestigation = value
		autoInvestigation()
	end,
}, "autoInvestigation")

sections.MainSection2:Slider({
	Name = "Delay to Start Invest/Boss",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Round",
	Precision = 0,
	Callback = function(value)
		delaytoAttackMob = value
	end,
}, "delayToInvest/Boss")

sections.MainSection2:Toggle({
	Name = "Auto Quest (IN REWORK)",
	Default = false,
	Callback = function(value)
		Window:Notify({
			Title = "REWORKING",
			Description = "COMING SOON",
			Lifetime = 5,
		})
	end,
}, "autoQuest")

sections.MainSection3:Header({
	Name = "Webhook",
})

sections.MainSection3:Input({
	Name = "Webhook Url",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "All",
	Callback = function(value)
		urlwebhook = value
	end,
	onChanged = function(value)
		urlwebhook = value
	end,
}, "webhookURl")

sections.MainSection3:Input({
	Name = "User ID",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Numeric",
	Callback = function(value)
		getgenv().pingUserId = value
	end,
	onChanged = function(value)
		getgenv().pingUserId = value
	end,
}, "userID")

sections.MainSection3:Toggle({
	Name = "Send Webhook when finish investigation",
	Default = false,
	Callback = function(value)
		getgenv().webhook = value
		webhook()
	end,
}, "webhookToggle")

sections.MainSection3:Toggle({
	Name = "Ping user",
	Default = false,
	Callback = function(value)
		getgenv().pingUser = value
	end,
}, "pingUserToggle")

MacLib:SetFolder("Maclib")
tabs.Settings:InsertConfigSection("Left")

sections.MainSection4:Toggle({
	Name = "Hide UI when Execute",
	Default = false,
	Callback = function(value)
		getgenv().hideUIExec = value
		hideUIExec()
	end,
}, "HideUiWhenExecute")

sections.MainSection4:Toggle({
	Name = "Auto Execute",
	Default = false,
	Callback = function(value)
		getgenv().aeuat = value
		aeuat()
	end,
}, "AutoExecute")

sections.MainSection4:Button({
	Name = "Unload UI",
	Callback = function()
		Window.onUnloaded(function()
			print("Unloaded!")
		end)
	end,
})

tabs.Main:Select()

MacLib:SetFolder("Tempest Hub")
MacLib:SetFolder("Tempest Hub/_JJI_")

local GameConfigName = "_JJI_"
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
hideUI()
