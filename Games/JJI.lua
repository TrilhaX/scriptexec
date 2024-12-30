repeat task.wait() until game:IsLoaded()
wait(10)
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
local speed = 1000

--START OF FUNCTIONS
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
					game:GetService('VirtualInputManager'):SendKeyEvent(true, 'E', false, game)
					game:GetService('VirtualInputManager'):SendKeyEvent(false, 'E', false, game)
					wait(.5)
					if loot.Enabled == true then
						while loot.Enabled == true do
							GuiService.SelectedObject = loot.Frame.Flip
							VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
							VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
							wait(.5)
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
				wait(.5)
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
                    local decrement = 500
                    local delay = 0.05

                    while humanoid.Health > targetHealth do
                        humanoid.Health = math.max(humanoid.Health - decrement, targetHealth)
                        wait(delay)
                    end
                end
            end
        end
        wait(delaytoAttack)
    end
end

function HitKillInvestigation()
    while getgenv().HitKillInvestigation == true do
        local mobs = workspace.Objects:FindFirstChild("Mobs")

        if mobs then
            local mobList = mobs:GetChildren()
            
            for _, mob in pairs(mobList) do
                local humanoid = mob:FindFirstChild("Humanoid")
                if humanoid then
                    local targetCFrame = GetCFrame(mob, 15)
                    local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
                    tween:Play()
                    tween.Completed:Wait()
                    
                    local changeWeaponArgs = {
                        [1] = "Fists"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Combat"):WaitForChild("ChangeWeapon"):FireServer(unpack(changeWeaponArgs))
                    wait(0.2)
                    
                    local attackArgs = {
                        [1] = 1,
                        [2] = {}
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Combat"):WaitForChild("M1"):FireServer(unpack(attackArgs))
                    wait(0.2)

                    local targetHealth = 0
                    local decrement = 500
                    local delay = 0.05

                    while humanoid.Health > targetHealth do
                        humanoid.Health = math.max(humanoid.Health - decrement, targetHealth)
                        wait(delay)
                    end
                end
                wait(1)
            end
        end
        wait(delaytoAttack)
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
                wait(0.5)

                local changeWeaponArgs = {
                    [1] = "Fists"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Combat"):WaitForChild("ChangeWeapon"):FireServer(unpack(changeWeaponArgs))
                wait(0.3)

                local attackArgs = {
                    [1] = 1,
                    [2] = {}
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Combat"):WaitForChild("M1"):FireServer(unpack(attackArgs))

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
        wait(delaytoAttack)
    end
end

function autoInvestigation()
	while getgenv().autoInvestigation == true do
		local missionItems = workspace.Objects:FindFirstChild("MissionItems")
	
		if missionItems then
			local items = missionItems:GetChildren()
	
			for _, v in pairs(items) do
				if v.Name == "Civilian" then
					local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")
					if HumanoidRootPart then
						local teleportCFrame = HumanoidRootPart.CFrame
						local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
						tween:Play()
						tween.Completed:Wait()
						game:GetService('VirtualInputManager'):SendKeyEvent(true, 'E', false, game)
						wait(.5)
						game:GetService('VirtualInputManager'):SendKeyEvent(false, 'E', false, game)
						wait(1)
						local teleportCFrame2 = workspace.Map.Parts.SpawnLocation.CFrame
						local tween2 = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame2)
						tween2:Play()
						tween2.Completed:Wait()
					end
				else
					local teleportCFrame = v.CFrame
					local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
					tween:Play()
					tween.Completed:Wait()
					game:GetService('VirtualInputManager'):SendKeyEvent(true, 'E', false, game)
					wait(.3)
					game:GetService('VirtualInputManager'):SendKeyEvent(false, 'E', false, game)
				end
				wait(1)
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
	while getgenv().tpToItem == true do
		local drops = workspace.Objects.Drops


		for i,v in pairs(drops:GetChildren())do
			local teleportCFrame = GetCFrame(v.Root)
			local tween = tweenModel(game.Players.LocalPlayer.Character, teleportCFrame)
			tween:Play()
			tween.Completed:Wait()
			if v.Root then
				game:GetService('VirtualInputManager'):SendKeyEvent(true, 'E', false, game)
				wait(.3)
				game:GetService('VirtualInputManager'):SendKeyEvent(false, 'E', false, game)
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

function autoSkipDialogue()
	while getgenv().autoSkipDialogue == true do
		local skipButton = game:GetService("Players").LocalPlayer.PlayerGui.StorylineDialogue.Frame.Dialogue:FindFirstChild("Skip")

		if skipButton and skipButton.Visible == true then
			if skipButton.TextLabel.Text == "Skip (0/1)" and skipButton.Visible == true then
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("StorylineDialogueSkip"):FireServer()
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
                    tostring(deaths.Text), tostring(kills.Text), tostring(playerCount.Text), tostring(score.Text), tostring(timeSpent.Text)
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
                                value = "https://discord.gg/ey83AwMvAn"
                            }
                        },
                        author = {
                            name = "Jujutsu Infinite"
                        },
                        thumbnail = {
                            url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png?ex=673e5b4c&is=673d09cc&hm=1d58485280f1d6a376e1bee009b21caa0ae5cad9624832dd3d921f1e3b2217ce&"
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

function autoQuest()
	while getgenv().autoQuest == true do
		local player = game.Players.LocalPlayer
			local character = player.Character or player.CharacterAdded:Wait()
			local questFrame = player:WaitForChild("PlayerGui"):WaitForChild("StorylineDialogue"):WaitForChild("Frame"):FindFirstChild("QuestFrame")
			local targetCFrame = CFrame.new(-514.074402, 4470.24658, -15614.0771, 0.695504665, -2.04219823e-08, 0.718521595, 4.03495043e-10, 1, 2.80316552e-08, -0.718521595, -1.92062277e-08, 0.695504665)
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

			game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Data"):WaitForChild("TakeQuest"):InvokeServer(unpack(args))
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

LeftGroupBox:AddToggle("HKII", {
	Text = "Hit Kill In Investigation",
	Default = false,
	Callback = function(Value)
		getgenv().HitKillInvestigation = Value
		HitKillInvestigation()
	end,
})

LeftGroupBox:AddInput('DTHKM', {
    Default = '',
    Text = "Delay to Hit Kill mobs",
    Numeric = true,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        delaytoAttack = Value
    end
})

LeftGroupBox:AddToggle("ASD", {
	Text = "Auto Skip Dialogue",
	Default = false,
	Callback = function(Value)
		getgenv().autoSkipDialogue = Value
		autoSkipDialogue()
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

LeftGroupBox:AddToggle("AFI", {
	Text = "Auto Farm Items",
	Default = false,
	Callback = function(Value)
		getgenv().tpToItem = Value
		tpToItem()
	end,
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

    Text = "Select Boss or Act",

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

RightGroupbox:AddToggle("AJ", {
    Text = "Auto Join",
    Default = false,
    Callback = function(Value)
        getgenv().autoJoin = Value
        autoJoin()
    end,
})

RightGroupbox:AddToggle("AUTOINVESTIGATION", {
    Text = "Auto Investigation",
    Default = false,
    Callback = function(Value)
        getgenv().autoInvestigation = Value
        autoInvestigation()
    end,
})

RightGroupbox:AddToggle("AB", {
    Text = "Auto Quest (IN REWORK)",
    Default = false,
    Callback = function(Value)
		print("W.I.P")
    end,
})

local RightGroupbox = Tabs.Main:AddRightGroupbox("Webhook")

RightGroupbox:AddInput('WebhookURL', {
    Default = '',
    Text = "Webhook URL",
    Numeric = false,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        urlwebhook = Value
    end
})

RightGroupbox:AddInput('pingUser@', {
    Default = '',
    Text = "User ID",
    Numeric = false,
    Finished = false,
    Placeholder = 'Press enter after paste',
    Callback = function(Value)
        getgenv().pingUserId = Value
    end
})

RightGroupbox:AddToggle("WebhookFG", {
    Text = "Send Webhook when finish investigation",
    Default = false,
    Callback = function(Value)
        getgenv().webhook = Value
        webhook()
    end,
})

RightGroupbox:AddToggle("pingUser", {
    Text = "Ping user",
    Default = false,
    Callback = function(Value)
        getgenv().pingUser = Value
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