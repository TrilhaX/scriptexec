local UnitManagerGui = Instance.new("ScreenGui")
local BackgroundUnitManagerFrame = Instance.new("Frame")
local NameFrame = Instance.new("Frame")
local NameLabel = Instance.new("TextLabel")
local UIPadding = Instance.new("UIPadding")
local UnitsFrame = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIGridLayout = Instance.new("UIGridLayout")
local Template = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local upgradeLabel = Instance.new("TextLabel")
local Buttons = Instance.new("Frame")
local upgradeImageButton = Instance.new("ImageButton")
local sellImageButton = Instance.new("ImageButton")
local skillImageButton = Instance.new("ImageButton")
local UIGridLayout_2 = Instance.new("UIGridLayout")
local UIListLayout = Instance.new("UIListLayout")
local BottomButtons = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local SellAllButton = Instance.new("TextButton")
local UIGridLayout_3 = Instance.new("UIGridLayout")
local BackgroundOpenUnitManagerFrame = Instance.new("Frame")
local backgroundBUttonPressFrame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")
local UICorner4 = Instance.new("UICorner")
local UICorner5 = Instance.new("UICorner")
local UICorner6 = Instance.new("UICorner")

local bcUMFrame = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundUnitManagerFrame
local bcOUMFrame = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundOpenUnitManagerFrame.TextButton
local closeUnitManager = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundUnitManagerFrame.BottomButtons.CloseButton
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local u = game:GetService("UserInputService")
local units = workspace._UNITS

UnitManagerGui.Name = "UnitManagerGui"
UnitManagerGui.Parent = game.Players.LocalPlayer.PlayerGui
UnitManagerGui.IgnoreGuiInset = true

BackgroundUnitManagerFrame.Name = "BackgroundUnitManagerFrame"
BackgroundUnitManagerFrame.Parent = UnitManagerGui
BackgroundUnitManagerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundUnitManagerFrame.BackgroundColor3 = Color3.new(0.239216, 0.239216, 0.239216)
BackgroundUnitManagerFrame.BackgroundTransparency = 1
BackgroundUnitManagerFrame.BorderColor3 = Color3.new(0, 0, 0)
BackgroundUnitManagerFrame.BorderSizePixel = 0
BackgroundUnitManagerFrame.Position = UDim2.new(1, 0, 0.5, 0)
BackgroundUnitManagerFrame.Size = UDim2.new(0, 300, 1, 0)
BackgroundUnitManagerFrame.Visible = false

NameFrame.Name = "NameFrame"
NameFrame.Parent = BackgroundUnitManagerFrame
NameFrame.AnchorPoint = Vector2.new(0.5, 0)
NameFrame.BackgroundColor3 = Color3.new(0.164706, 0.164706, 0.164706)
NameFrame.BackgroundTransparency = 0.5
NameFrame.BorderColor3 = Color3.new(0, 0, 0)
NameFrame.BorderSizePixel = 0
NameFrame.Position = UDim2.new(0.5, 0, 0, 10)
NameFrame.Size = UDim2.new(1, -20, 0, 100)
UICorner.Parent = NameFrame

NameLabel.Name = "NameLabel"
NameLabel.Parent = NameFrame
NameLabel.AnchorPoint = Vector2.new(0.5, 0.5)
NameLabel.BackgroundColor3 = Color3.new(1, 1, 1)
NameLabel.BackgroundTransparency = 1
NameLabel.BorderColor3 = Color3.new(0, 0, 0)
NameLabel.BorderSizePixel = 0
NameLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
NameLabel.Size = UDim2.new(1, 0, 1, 0)
NameLabel.Font = Enum.Font.Unknown
NameLabel.Text = "Unit Manager"
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.TextScaled = true
NameLabel.TextSize = 60
NameLabel.TextWrapped = true
UIPadding.Parent = NameLabel
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.PaddingTop = UDim.new(0, 10)

UnitsFrame.Name = "UnitsFrame"
UnitsFrame.Parent = BackgroundUnitManagerFrame
UnitsFrame.AnchorPoint = Vector2.new(0.5, 0)
UnitsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
UnitsFrame.BackgroundTransparency = 1
UnitsFrame.BorderColor3 = Color3.new(0, 0, 0)
UnitsFrame.BorderSizePixel = 0
UnitsFrame.Position = UDim2.new(0.5, 0, 0, 120)
UnitsFrame.Size = UDim2.new(1, 0, 1, -200)

ScrollingFrame.Parent = UnitsFrame
ScrollingFrame.Active = true
ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderColor3 = Color3.new(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 7

UIGridLayout.Parent = ScrollingFrame
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellPadding = UDim2.new(0.0500000000, 5, 0.0500000000, 5)
UIGridLayout.CellSize = UDim2.new(0, 120, 0, 120)

BottomButtons.Name = "BottomButtons"
BottomButtons.Parent = BackgroundUnitManagerFrame
BottomButtons.AnchorPoint = Vector2.new(0.5, 1)
BottomButtons.BackgroundColor3 = Color3.new(1, 1, 1)
BottomButtons.BackgroundTransparency = 1
BottomButtons.BorderColor3 = Color3.new(0, 0, 0)
BottomButtons.BorderSizePixel = 0
BottomButtons.Position = UDim2.new(0.5, 0, 1, 0)
BottomButtons.Size = UDim2.new(1, 0, 0, 75)

CloseButton.Name = "CloseButton"
CloseButton.Parent = BottomButtons
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
CloseButton.BorderColor3 = Color3.new(0, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.5, 0, 0.5, 0)
CloseButton.Size = UDim2.new(0, 200, 0, 50)
CloseButton.Font = Enum.Font.Unknown
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 30
CloseButton.TextWrapped = true
UICorner2.Parent = CloseButton

SellAllButton.Name = "SellAllButton"
SellAllButton.Parent = BottomButtons
SellAllButton.AnchorPoint = Vector2.new(0.5, 0.5)
SellAllButton.BackgroundColor3 = Color3.new(0.67451, 0, 0)
SellAllButton.BorderColor3 = Color3.new(0, 0, 0)
SellAllButton.BorderSizePixel = 0
SellAllButton.Position = UDim2.new(0.5, 0, 0.5, 0)
SellAllButton.Size = UDim2.new(0, 200, 0, 50)
SellAllButton.Font = Enum.Font.Unknown
SellAllButton.Text = "Sell All"
SellAllButton.TextColor3 = Color3.new(1, 1, 1)
SellAllButton.TextSize = 25
SellAllButton.TextWrapped = true
UICorner3.Parent = SellAllButton

UIGridLayout_3.Parent = BottomButtons
UIGridLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout_3.VerticalAlignment = Enum.VerticalAlignment.Center
UIGridLayout_3.CellPadding = UDim2.new(0.100000001, 5, 0, 5)
UIGridLayout_3.CellSize = UDim2.new(0.400000006, 0, 0.800000012, 0)

BackgroundOpenUnitManagerFrame.Name = "BackgroundOpenUnitManagerFrame"
BackgroundOpenUnitManagerFrame.Parent = UnitManagerGui
BackgroundOpenUnitManagerFrame.AnchorPoint = Vector2.new(0, 0.5)
BackgroundOpenUnitManagerFrame.BackgroundColor3 = Color3.new(0, 0, 0)
BackgroundOpenUnitManagerFrame.BorderColor3 = Color3.new(0, 0, 0)
BackgroundOpenUnitManagerFrame.BorderSizePixel = 0
BackgroundOpenUnitManagerFrame.Position = UDim2.new(0, 0, 0.5, 0)
BackgroundOpenUnitManagerFrame.Size = UDim2.new(0, 100, 0, 40)
UICorner4.Parent = BackgroundOpenUnitManagerFrame

backgroundBUttonPressFrame.Name = "backgroundBUttonPressFrame"
backgroundBUttonPressFrame.Parent = BackgroundOpenUnitManagerFrame
backgroundBUttonPressFrame.BackgroundColor3 = Color3.new(0, 0, 0)
backgroundBUttonPressFrame.BorderColor3 = Color3.new(0, 0, 0)
backgroundBUttonPressFrame.BorderSizePixel = 0
backgroundBUttonPressFrame.Position = UDim2.new(0.5, 35, 0.5, 0)
backgroundBUttonPressFrame.Size = UDim2.new(0, 30, 0, 30)
UICorner5.Parent = backgroundBUttonPressFrame

TextLabel.Parent = backgroundBUttonPressFrame
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "F"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 14
TextLabel.TextWrapped = true
UICorner6.Parent = TextLabel

TextButton.Parent = BackgroundOpenUnitManagerFrame
TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton.BackgroundTransparency = 1
TextButton.BorderColor3 = Color3.new(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.5, 0, 0.5, 0)
TextButton.Size = UDim2.new(0.5, 50, 1, 0)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "Open Unit Manager"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.TextScaled = true
TextButton.TextSize = 14
TextButton.TextWrapped = true

function templateClone(unitName, upgrade)
    Template.Name = unitName
    Template.Parent = ScrollingFrame
    Template.AnchorPoint = Vector2.new(0.5, 0.5)
    Template.BackgroundColor3 = Color3.new(1, 1, 1)
    Template.BackgroundTransparency = 1
    Template.BorderColor3 = Color3.new(0, 0, 0)
    Template.BorderSizePixel = 0
    Template.Position = UDim2.new(0.180000007, 0, 0.0659999996, 0)
    Template.Size = UDim2.new(0, 150, 0, 140)

    ImageLabel.Parent = Template
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    ImageLabel.BorderColor3 = Color3.new(0, 0, 0)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Position = UDim2.new(0.5, 0, 0.307970852, 0)
    ImageLabel.Size = UDim2.new(0, 120, 0, 120)

    upgradeLabel.Parent = Template
    upgradeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    upgradeLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    upgradeLabel.BackgroundTransparency = 1
    upgradeLabel.BorderColor3 = Color3.new(0, 0, 0)
    upgradeLabel.BorderSizePixel = 0
    upgradeLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
    upgradeLabel.Size = UDim2.new(0, 120, 0, 20)
    upgradeLabel.Font = Enum.Font.SourceSans
    upgradeLabel.Text = "Upgrade: " .. upgrade
    upgradeLabel.TextColor3 = Color3.new(1, 1, 1)
    upgradeLabel.TextSize = 14
    upgradeLabel.TextWrapped = true
end

function toggleGui()
	bcUMFrame.Visible = not bcUMFrame.Visible
	local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local ScreenGui = PlayerGui:WaitForChild("UnitManagerGui")
	local object = ScreenGui:WaitForChild("BackgroundUnitManagerFrame")

	if object.Visible == true then
		object.AnchorPoint = Vector2.new(0.5, 0.5)

		local targetPosition = UDim2.new(1, -150, 0.5, 0)

		local tweenInfo1 = TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false)
		local tween = TweenService:Create(object, tweenInfo1, {Position = targetPosition})

		local targetTransparency = 0.3

		local tweenInfo2 = TweenInfo.new(1)
		local tween2 = TweenService:Create(object, tweenInfo2, {BackgroundTransparency = targetTransparency})

		tween:Play()
		tween2:Play()
	else
		object.AnchorPoint = Vector2.new(1, 0.5)
		local targetPosition = UDim2.new(1, 0, 0.5, 0)
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 0, false)
		local tween = TweenService:Create(object, tweenInfo, {Position = targetPosition})

		local targetTransparency2 = 1

		local tweenInfo2 = TweenInfo.new(1)
		local tween2 = TweenService:Create(object, tweenInfo2, {BackgroundTransparency = targetTransparency2})

		tween:Play()
		tween2:Play()
	end
end

bcOUMFrame.MouseButton1Up:Connect(function()
	toggleGui()
end)

closeUnitManager.MouseButton1Up:Connect(function()
	toggleGui()
end)

u.InputBegan:Connect(function(input)
	if input.KeyCode ~= Enum.KeyCode.F then return end
	toggleGui()
end)

units.ChildAdded:Connect(function(unit)
    local stats = unit:FindFirstChild("_stats")
    if stats then
        local uuid = stats:FindFirstChild("uuid")
        if uuid and uuid.Value ~= "neutral" then
            local upgrade = unit._stats.upgrade.Value
            local unitName = unit.Name
            templateClone(unitName, upgrade)
        end
    end
end)