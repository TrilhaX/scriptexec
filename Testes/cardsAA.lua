repeat task.wait() until game:IsLoaded()
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
	Title = "Tempest Hub | Anime Adventures",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

Library:Notify("Loading Anime Adventures Script", 5)
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
local chosenCard = nil
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

local Tabs = {
	Main = Window:AddTab("Main"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Player")

function UpdatePriorityList(category, selectedList)
    selectedPriorities[category] = selectedList
end

function autoChooseCard()
    while getgenv().autoChooseCard == true do
        local player = game:GetService("Players").LocalPlayer
        local itemsFrame = player.PlayerGui.RoguelikeSelect.Main.Main.Items
        local foundCards = {}
        local cardPositions = {}
        local index = 1
        for _, frame in ipairs(itemsFrame:GetChildren()) do
            if frame:IsA("Frame") and frame:FindFirstChild("bg") and frame.bg:FindFirstChild("Main") and frame.bg.Main:FindFirstChild("Title") and frame.bg.Main.Title:FindFirstChild("TextLabel") then
                local cardName = frame.bg.Main.Title.TextLabel.Text
                foundCards[index] = cardName
                cardPositions[cardName] = index
                index = index + 1
            end
        end

        local chosenCard = nil
        local chosenCardPosition = nil

        if getgenv().focusBuff then
            for pos, availableCard in pairs(foundCards) do
                for _, priorityBuff in ipairs(selectedPriorities.Buff) do
                    if availableCard == priorityBuff then
                        chosenCard = availableCard
                        chosenCardPosition = pos
                        break
                    end
                end
                if chosenCard then break end
            end
        end

        if not chosenCard and getgenv().focusDebuff then
            for pos, availableCard in pairs(foundCards) do
                for _, priorityDebuff in ipairs(selectedPriorities.Debuff) do
                    if availableCard == priorityDebuff then
                        chosenCard = availableCard
                        chosenCardPosition = pos
                        break
                    end
                end
                if chosenCard then break end
            end
        end

        if not chosenCard then
            for pos, availableCard in pairs(foundCards) do
                for _, priorityBuff in ipairs(selectedPriorities.Buff) do
                    if availableCard == priorityBuff then
                        chosenCard = availableCard
                        chosenCardPosition = pos
                        break
                    end
                end
                if chosenCard then break end
            end
        end

        if not chosenCard then
            for pos, availableCard in pairs(foundCards) do
                for _, priorityDebuff in ipairs(selectedPriorities.Debuff) do
                    if availableCard == priorityDebuff then
                        chosenCard = availableCard
                        chosenCardPosition = pos
                        break
                    end
                end
                if chosenCard then break end
            end
        end

        if chosenCard then
            local args = {
                [1] = tostring(chosenCardPosition)
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("select_roguelike_option"):InvokeServer(unpack(args))            
        end
        wait()
    end
end

LeftGroupBox:AddDropdown("dropdownBuffPriority", {
    Values = Cards.Buff,
    Default = {},
    Multi = true,
    Text = "Select Buff Priority",
    Callback = function(selectedList)
        UpdatePriorityList("Buff", selectedList)
    end,
})

LeftGroupBox:AddDropdown("dropdownDebuffPriority", {
    Values = Cards.Debuff,
    Default = {},
    Multi = true,
    Text = "Select Debuff Priority",
    Callback = function(selectedList)
        UpdatePriorityList("Debuff", selectedList)
    end,
})

LeftGroupBox:AddToggle("AutoCard", {
    Text = "Auto Card",
    Default = false,
    Callback = function(Value)
        getgenv().autoChooseCard = Value
        if Value then
            autoChooseCard()
        end
    end,
})

LeftGroupBox:AddToggle("FocusBuff", {
    Text = "Focus Buff",
    Default = false,
    Callback = function(Value)
        getgenv().focusBuff = Value
    end,
})

LeftGroupBox:AddToggle("FocusDebuff", {
    Text = "Focus Debuff",
    Default = false,
    Callback = function(Value)
        getgenv().focusDebuff = Value
    end,
})

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

MenuGroup:AddToggle("HideUiWhenExecute", {
	Text = "Hide UI When Execute",
	Default = false,
	Callback = function(Value)
		getgenv().hideUIExec = Value
		hideUIExec()
	end,
})

MenuGroup:AddToggle("AutoExecute", {
	Text = "Auto Execute",
	Default = false,
	Callback = function(Value)
		getgenv().aeuat = Value
		aeuat()
	end,
})

MenuGroup:AddToggle("BlackScreen", {
	Text = "Blackscreen",
	Default = false,
	Callback = function(Value)
		blackScreen()
	end,
})

MenuGroup:AddToggle("FPSBoost", {
	Text = "FPS Boost",
	Default = false,
	Callback = function(Value)
        getgenv().fpsBoost = Value
		fpsBoost()
	end,
})

MenuGroup:AddToggle("FPSBoost", {
	Text = "Better FPS Boost",
	Default = false,
	Callback = function(Value)
        getgenv().betterFpsBoost = Value
		betterFpsBoost()
	end,
})

MenuGroup:AddToggle("FPSBoost", {
	Text = "REALLY Better FPS Boost",
	Default = false,
	Callback = function(Value)
        getgenv().extremeFpsBoost = Value
		extremeFpsBoost()
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
SaveManager:SetFolder("Tempest Hub/_AA_")

SaveManager:BuildConfigSection(TabsUI["UI Settings"])

ThemeManager:ApplyToTab(TabsUI["UI Settings"])

SaveManager:LoadAutoloadConfig()

local GameConfigName = "_AA_"
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