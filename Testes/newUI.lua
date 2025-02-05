repeat task.wait() until game:IsLoaded()
warn("[TEMPEST HUB] Loading Ui")
wait()

local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/maclibTempestHubUI/main/maclib.lua"))()

local isMobile = game:GetService("UserInputService").TouchEnabled

local pcSize = UDim2.fromOffset(868, 650)
local mobileSize = UDim2.fromOffset(600, 450)
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

function changeUISize(percent)
	if Window then
		local scale = percent / 100

		if scale < 0.1 then
			scale = 0.1
		end

		local newWidth = pcSize.X.Offset * scale
		local newHeight = pcSize.Y.Offset * scale

		Window:SetSize(UDim2.fromOffset(newWidth, newHeight))
		Window:Notify({
			Title = "UI Resized",
			Description = "New size: " .. math.floor(percent) .. "%",
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

local tabGroups = {
	TabGroup1 = Window:TabGroup()
}

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Main", Image = "rbxassetid://18821914323" }),
	Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" })
}

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
    MainSection2 = tabs.Main:Section({ Side = "Right" }),
	MainSection3 = tabs.Main:Section({ Side = "Right" }),
	MainSection4 = tabs.Settings:Section({ Side = "Right" }),
}

sections.MainSection1:Header({
	Name = "Player"
})

sections.MainSection1:Toggle({
	Name = "Dupe Griffith",
	Default = false,
	Callback = function(value)
		dupeGriffithMethod = value
        dupeGriffith()
	end,
}, "dupeGriffith")

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
		getgenv().aeuat = Value
		aeuat()
	end,
}, "AutoExecute")

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