repeat task.wait() until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()

local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled

local pcSize = UDim2.fromOffset(868, 650)
local mobileSize = UDim2.fromOffset(700, 550)
local currentSize = isMobile and mobileSize or pcSize

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
			Window:SetUserInfoState(bool)
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
	local UICorner1 = Instance.new("UICorner")
	local UICorner2 = Instance.new("UICorner")
	local backgroundFrame = Instance.new("Frame")
	local tempestButton = Instance.new("TextButton")
	local UIPadding = Instance.new("UIPadding")

	backgroundFrame.Name = "backgroundFrame"
	backgroundFrame.Parent = game.CoreGui.RobloxGui.MaclibGui
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
		local coreGui = game:GetService("CoreGui")
		local maclib = coreGui.RobloxGui:FindFirstChild("MaclibGui")
		if maclib then
			maclib.Base.Visible = not maclib.Base.Visible
			maclib.Notifications.Visible = not maclib.Notifications.Visible
		else
			warn("MaclibGui not found in CoreGui.")
		end
	end)
end

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
}

sections.MainSection1:Header({
	Name = "Player"
})

sections.MainSection1:Toggle({
	Name = "Hide Player Info",
	Default = false,
	Callback = function(value)
		getgenv().hideInfoPlayer = Value
		hideInfoPlayer()
	end,
}, "HidePlayerInfo")

sections.MainSection1:Toggle({
	Name = "Auto Walk",
	Default = false,
	Callback = function(value)
		getgenv().autoWalk = Value
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
		selecteQuantityPlayer = Value
	end,
}, "dropdownSelectPlayer")

sections.MainSection1:Toggle({
	Name = "Security Mode",
	Default = false,
	Callback = function(value)
		getgenv().securityMode = Value
		securityMode()
	end,
}, "SecurityMode")

sections.MainSection1:Toggle({
	Name = "Delete Map",
	Default = false,
	Callback = function(value)
		getgenv().deletemap = Value
		deletemap()
	end,
}, "DeleteMap")

sections.MainSection1:Toggle({
	Name = "Auto Leave",
	Default = false,
	Callback = function(value)
		getgenv().autoleave = Value
		autoleave()
	end,
}, "AutoLeave")

sections.MainSection1:Toggle({
	Name = "Auto Replay",
	Default = false,
	Callback = function(value)
		getgenv().autoreplay = Value
		autoreplay()
	end,
}, "AutoReplay")

sections.MainSection1:Toggle({
	Name = "Auto Next",
	Default = false,
	Callback = function(value)
		getgenv().autonext = Value
		autonext()
	end,
}, "AutoNext")

sections.MainSection1:Toggle({
	Name = "Auto Next Portal",
	Default = false,
	Callback = function(value)
		getgenv().autoNextPortal = Value
		autoNextPortal()
	end,
}, "AutoNextPortal")

sections.MainSection1:Toggle({
	Name = "Auto Next Contract",
	Default = false,
	Callback = function(value)
		getgenv().autoNextContrato = Value
		autoNextContrato()
	end,
}, "AutoNextContract")

sections.MainSection1:Toggle({
	Name = "Auto Start",
	Default = false,
	Callback = function(value)
		getgenv().autostart = Value
		autostart()
	end,
}, "AutoStart")

sections.MainSection1:Toggle({
	Name = "Auto Skip Wave",
	Default = false,
	Callback = function(value)
		getgenv().autoskipwave = Value
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
		getgenv().autoGetBattlepass = Value
		autoGetBattlepass()
	end,
}, "autoGetBattlepass")

sections.MainSection2:Toggle({
	Name = "Auto Get Quest",
	Default = false,
	Callback = function(value)
		getgenv().autoGetQuest = Value
		autoGetQuest()
	end,
}, "autoGetQuest")

sections.MainSection2:Toggle({
	Name = "Disable Notifications",
	Default = false,
	Callback = function(value)
		getgenv().disableNotifications = Value
		disableNotifications()
	end,
}, "DisableNotifications")

sections.MainSection2:Toggle({
	Name = "Place In Red Zones",
	Default = false,
	Callback = function(value)
		getgenv().placeInRedZones = Value
		placeInRedZones()
	end,
}, "PlaceInRedZones")

sections.MainSection2:Toggle({
	Name = "Show Info Units",
	Default = false,
	Callback = function(value)
		getgenv().showInfoUnits = Value
		showInfoUnits()
	end,
}, "ShowInfoUnits")

sections.MainSection2:Toggle({
	Name = "Friends Only",
	Default = false,
	Callback = function(value)
		selectedFriendsOnly = Value
	end,
}, "FriendsOnly")

sections.MainSection2:Toggle({
	Name = "Auto Give Presents",
	Default = false,
	Callback = function(value)
		getgenv().autoGivePresents = Value
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
	Options = ValuesUnitId,
	Default = None,
	Callback = function(value)
		selectedUnitToRoll = value:match(".* | .* | (.+)")
	end,
}, "RollUnit")

local Dropdown = sections.MainSection4:Dropdown({
	Name = "Select Passive",
	Multi = true,
	Required = true,
	Options = passivesValues,
	Default = None,
	Callback = function(Value)
		selectedPassiveToRoll = Value
	end,
}, "dropdownSelectPassiveToRoll")

sections.MainSection4:Toggle({
	Name = "Auto Roll",
	Default = false,
	Callback = function(value)
		getgenv().autoRollPassive = Value
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
	Options = ValuesUnitId,
	Default = None,
	Callback = function(value)
		selectedUnitToRoll = value:match(".* | .* | (.+)")
	end,
}, "FeedUnit")

local Dropdown = sections.MainSection5:Dropdown({
	Name = "Select Unit to Feed",
	Multi = true,
	Required = true,
	Options = ValuesItemsToFeed,
	Default = None,
	Callback = function(Value)
		selectedFeed = Value
	end,
}, "dropdownSelectItemsToFeed")

sections.MainSection5:Toggle({
	Name = "Auto Feed",
	Default = false,
	Callback = function(value)
		getgenv().autoFeed = Value
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
	Callback = function(input)
		urlwebhook = Value
	end,
	onChanged = function(input)
        urlwebhook = Value
	end,
}, "WebhookURL")

sections.MainSection3:Input({
	Name = "User ID",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
		urlwebhook = Value
	end,
	onChanged = function(input)
        urlwebhook = Value
	end,
}, "pingUser@")

sections.MainSection3:Toggle({
	Name = "Send Webhook when finish game",
	Default = false,
	Callback = function(value)
        getgenv().webhook = Value
        webhook()
	end,
}, "WebhookFinishGame")

sections.MainSection3:Toggle({
	Name = "Ping user",
	Default = false,
	Callback = function(value)
        getgenv().pingUser = Value
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
	Options = PortalMapValues,
	Default = None,
	Callback = function(value)
		selectedPortalMap = Value
	end,
}, "dropdownPortalMap")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Tier",
	Multi = true,
	Required = true,
	Options = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"},
	Default = None,
	Callback = function(value)
		selectedTierPortal = Values
	end,
}, "dropdownTierPortal")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Ignore Difficulty",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
        selectedPortalDiff = Value
	end,
}, "dropdownSelectChallengePortal")

local Dropdown = sections.MainSection6:Dropdown({
	Name = "Select Ignore Dmg bonus",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
		selectedIgnoreDmgBonus = Values
	end,
}, "dropdownIgnoreDmgBonusPortal")

sections.MainSection6:Toggle({
	Name = "Auto Open Portal",
	Default = false,
	Callback = function(value)
		getgenv().autoEnterPortal = Value
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
		selectedMatchmakingMap = Value
	end,
}, "dropdownMatchmakingMap")

sections.MainSection7:Toggle({
	Name = "Auto Matchmaking",
	Default = false,
	Callback = function(value)
		getgenv().AutoMatchmaking = Value
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
        selectedTierContract = Value
	end,
}, "dropdownSelectTierContract")

local Dropdown = sections.MainSection8:Dropdown({
	Name = "Select Ignore Challenge",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
        selectedIgnoreContractChallenge = Value
	end,
}, "dropdownSelectIgnoreChallengeContract")


sections.MainSection8:Toggle({
	Name = "Auto Matchmaking Contract",
	Default = false,
	Callback = function(value)
        getgenv().autoContractMatchmaking = Value
        autoContractMatchmaking()
	end,
}, "AutoMatchmakingContract")

sections.MainSection8:Toggle({
	Name = "Auto Contract",
	Default = false,
	Callback = function(value)
        getgenv().autoContract = Value
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
		getgenv().selectedHardInfCastle = Value
	end,
}, "HardInfCastle")

sections.MainSection9:Toggle({
	Name = "Auto Enter Inf Castle",
	Default = false,
	Callback = function(value)
		getgenv().autoEnterInfiniteCastle = Value
		autoEnterInfiniteCastle()
	end,
}, "AutoEnterInfCastle")


sections.MainSection9:Toggle({
	Name = "Auto Join Cursed Womb",
	Default = false,
	Callback = function(value)
		getgenv().autoJoinCursedWomb = Value
		autoJoinCursedWomb()
	end,
}, "AutoJoinCursedWomb")

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
		selectedMap = Value
	end,
}, "dropdownStoryMap")

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Difficulty",
	Multi = false,
	Required = true,
	Options = {"Normal", "Hard"},
	Default = None,
	Callback = function(value)
		selectedDifficulty = Values
	end,
}, "dropdownSelectDifficultyStory")

local Dropdown = sections.MainSection10:Dropdown({
	Name = "Select Act",
	Multi = false,
	Required = true,
	Options = {"1", "2", "3", "4", "5", "6", "Infinite"},
	Default = None,
	Callback = function(value)
		selectedAct = Value
	end,
}, "dropdownSelectActStory")

sections.MainSection10:Toggle({
	Name = "Auto Enter",
	Default = false,
	Callback = function(value)
		getgenv().autoEnter = Value
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
        selectedMapChallenges = Values
	end,
}, "dropdownChallengeMap")

local Dropdown = sections.MainSection11:Dropdown({
	Name = "Select Difficulty",
	Multi = true,
	Required = true,
	Options = challengeValues,
	Default = None,
	Callback = function(value)
        selectedChallengesDiff = Value
	end,
}, "dropdownSelectChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Enter Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterChallenge = Value
        autoEnterChallenge()
	end,
}, "AutoEnterChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Enter Daily Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterDailyChallenge = Value
        autoEnterDailyChallenge()
	end,
}, "AutoEnterDailyChallenge")

sections.MainSection11:Toggle({
	Name = "Auto Matchmaking Daily Challenge",
	Default = false,
	Callback = function(value)
        getgenv().autoMatchmakingDailyChallenge = Value
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
        selectedRaidMap = Value
	end,
}, "dropdownSelectRaid")

sections.MainSection12:Toggle({
	Name = "Auto Enter Raid",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterRaid = Value
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
        selectedLegendStageMap = Value
	end,
}, "dropdownSelectLegendStage")

sections.MainSection13:Toggle({
	Name = "Auto Enter Legend Stage",
	Default = false,
	Callback = function(value)
        getgenv().autoEnterLegendStage = Value
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
		selectedTeamStoryInf = Value
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
		selectedTeamInfTower = Value
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
		selectedTeamPhysicContract = Value
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
		selectedTeamMagicContract = Value
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
		selectedTeamPhysicChallengeDailyChallenge = Value
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
		selectedTeamMagicChallengeDailyChallenge = Value
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
		selectedTeamChallengeDailyChallenge = Value
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
		selectedTeamRaid = Value
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
		getgenv().dupeGriffith = Value
		dupeGriffith()
	end,
}, "DupeGriffith")

sections.MainSection19:Toggle({
	Name = "Dupe Vegeto",
	Default = false,
	Callback = function(value)
		getgenv().dupeVegeto = Value
		dupeVegeto()
	end,
}, "DupeVegeto")

sections.MainSection19:Toggle({
	Name = "Inf Range",
	Default = false,
	Callback = function(value)
		getgenv().InfRange = Value
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
        getgenv().autoChooseCard = Value
        if Value then
            autoChooseCard()
        end
	end,
}, "AutoCard")

sections.MainSection20:Toggle({
	Name = "Focus Buff",
	Default = false,
	Callback = function(value)
        getgenv().focusBuff = Value
	end,
}, "FocusBuff")

sections.MainSection20:Toggle({
	Name = "Focus Debuff",
	Default = false,
	Callback = function(value)
        getgenv().focusDebuff = Value
	end,
}, "FocusDebuff")

sections.MainSection21:Header({
	Name = "Unit"
})

sections.MainSection21:Input({
	Name = "Start Place at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
        selectedWaveToPlace = Value
	end,
	onChanged = function(input)
        selectedWaveToPlace = Value
	end,
}, "inputAutoPlaceWaveX")

sections.MainSection21:Slider({
	Name = "Distance Percentage",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Round",
	Precision = 0,
	Callback = function(value)
		selectedDistance = Value
	end,
}, "distancePercentage")

sections.MainSection21:Slider({
	Name = "Ground Percentage",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Round",
	Precision = 0,
	Callback = function(value)
		selectedGroundDistance = Value
	end,
}, "GroundPercentage")

sections.MainSection21:Slider({
	Name = "Hill Percentage",
	Default = 0,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Round",
	Precision = 0,
	Callback = function(value)
		selectedHillDistance = Value
	end,
}, "HillPercentage")

sections.MainSection21:Toggle({
	Name = "Auto Place",
	Default = false,
	Callback = function(value)
		getgenv().autoPlace = Value
		if Value then
			autoPlace()
		end
	end,
}, "AutoPlace")

sections.MainSection21:Toggle({
	Name = "Only Start Place in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().OnlyautoPlace = Value
	end,
}, "OnlyStartPlaceInXWave")

sections.MainSection21:Input({
	Name = "Start Upgrade at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
        selectedWaveToUpgrade = Value
	end,
	onChanged = function(input)
        selectedWaveToUpgrade = Value
	end,
}, "inputAutoUpgradeWaveX")

sections.MainSection21:Toggle({
	Name = "Focus Farm",
	Default = false,
	Callback = function(value)
		getgenv().focusFarm = Value
	end,
}, "FocusInFarm")

sections.MainSection21:Toggle({
	Name = "Focus Griffith",
	Default = false,
	Callback = function(value)
		getgenv().focusGriffith = Value
	end,
}, "FocusInGriffith")

sections.MainSection21:Toggle({
	Name = "Auto Upgrade",
	Default = false,
	Callback = function(value)
		getgenv().autoUpgrade = Value
		autoUpgrade()
	end,
}, "AutoUpgrade")

sections.MainSection21:Toggle({
	Name = "Only Upgrade in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlyupgradeinXwave = Value
	end,
}, "OnlyUpgradeInXWave")

sections.MainSection21:Input({
	Name = "Start Sell at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
        selectedWaveToSell = Value
	end,
	onChanged = function(input)
        selectedWaveToSell = Value
	end,
}, "inputAutoSellWaveX")

sections.MainSection21:Toggle({
	Name = "Auto Sell",
	Default = false,
	Callback = function(value)
		getgenv().autoSell = Value
		autoSell()
	end,
}, "AutoSell")

sections.MainSection21:Toggle({
	Name = "Only Sell in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().onlysellinXwave = Value
	end,
}, "OnlySellInXWave")

sections.MainSection22:Header({
	Name = "Skill"
})

sections.MainSection22:Input({
	Name = "Start Skill at x Wave",
	Placeholder = "Press enter after paste",
	AcceptedCharacters = "Number",
	Callback = function(input)
        selectedWaveToUniversalSkill = Value
	end,
	onChanged = function(input)
        selectedWaveToUniversalSkill = Value
	end,
}, "inputAutoSkillWaveX")

sections.MainSection22:Toggle({
	Name = "Auto Universal Skill",
	Default = false,
	Callback = function(value)
		getgenv().universalSkill = Value
		universalSkill()
	end,
}, "AutoUniversalSkill")

sections.MainSection22:Toggle({
	Name = "Only Universal Skill in X Wave",
	Default = false,
	Callback = function(value)
		getgenv().universalSkillinXWave = Value
	end,
}, "OnlyUniversalSkillinXWave")

sections.MainSection22:Toggle({
	Name = "Auto Sacrifice Griffith",
	Default = false,
	Callback = function(value)
		getgenv().autoSacrificeGriffith = Value
		autoSacrificeGriffith()
	end,
}, "AutoSacrificeGriffith")

sections.MainSection22:Toggle({
	Name = "Auto Buff Erwin",
	Default = false,
	Callback = function(value)
		toggle = Value
		if toggle then
			UseActiveAttackE()
		end
	end,
}, "AutoBuffErwin")

sections.MainSection22:Toggle({
	Name = "Auto Buff Wenda",
	Default = false,
	Callback = function(value)
		toggle2 = Value
		if toggle2 then
			UseActiveAttackW()
		end
	end,
}, "AutoBuffWenda")

sections.MainSection22:Toggle({
	Name = "Auto Buff Leafy",
	Default = false,
	Callback = function(value)
		toggle3 = Value
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
		selectedCapsule = Value
	end,
}, "dropdownSelectCapsule")

sections.MainSection24:Toggle({
	Name = "Auto Open Capsule",
	Default = false,
	Callback = function(value)
		getgenv().autoOpenCapsule = Value
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
		selectedShardtoCraft = Value
	end,
}, "dropdownSelectShardToCraft")

sections.MainSection24:Toggle({
	Name = "Auto Craft Shards",
	Default = false,
	Callback = function(value)
		getgenv().autoCraftShard = Value
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
		selectedItemToBuy = Value
	end,
}, "dropdownSelectItemToBuy")

sections.MainSection24:Toggle({
	Name = "Auto Buy",
	Default = false,
	Callback = function(value)
		getgenv().autoBuy = Value
		autoBuy()
	end,
}, "AutoBuy")

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
		getgenv().aeuat = Value
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
        getgenv().fpsBoost = Value
		fpsBoost()
	end,
}, "FPSBoost")

sections.MainSection25:Toggle({
	Name = "Better FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().betterFpsBoost = Value
		betterFpsBoost()
	end,
}, "BetterFPSBoost")

sections.MainSection25:Toggle({
	Name = "REALLY Better FPS Boost",
	Default = false,
	Callback = function(value)
        getgenv().extremeFpsBoost = Value
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
MacLib:SetFolder("Tempest Hub/_JJI_1")
local GameConfigName = "_JJI_1"
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