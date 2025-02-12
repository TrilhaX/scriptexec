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
local TextLabel = Instance.new("TextLabel")
local Buttons = Instance.new("Frame")
local upgradeImageButton = Instance.new("ImageButton")
local sellImageButton = Instance.new("ImageButton")
local skillImageButton = Instance.new("ImageButton")
local UIGridLayout = Instance.new("UIGridLayout")
local UIGridLayout_2 = Instance.new("UIGridLayout")
local UIGridLayout_3 = Instance.new("UIGridLayout")
local UIGridLayout_4 = Instance.new("UIGridLayout")
local UIGridLayout_5 = Instance.new("UIGridLayout")
local UIGridLayout_6 = Instance.new("UIGridLayout")
local UIListLayout = Instance.new("UIListLayout")
local BottomButtons = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local SellAllButton = Instance.new("TextButton")
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
ScrollingFrame.AutomaticCanvasSize = "Y"

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

Template.Name = "Template"
Template.Parent = ScrollingFrame
Template.AnchorPoint = Vector2.new(0.5, 0.5)
Template.BackgroundColor3 = Color3.new(1, 1, 1)
Template.BackgroundTransparency = 1
Template.BorderColor3 = Color3.new(0, 0, 0)
Template.BorderSizePixel = 0
Template.Position = UDim2.new(0.180000007, 0, 0.0659999996, 0)
Template.Size = UDim2.new(0, 150, 0, 140)
Template.Visible = false

TextLabel.Parent = ImageLabel
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.5, 12, 0.100000001, 5)
TextLabel.Size = UDim2.new(0, 120, 0, 20)
TextLabel.Font = Enum.Font.Unknown
TextLabel.Text = "Upgrade: "
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14
TextLabel.TextWrapped = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

Buttons.Name = "ZButtons"
Buttons.Parent = Template
Buttons.AnchorPoint = Vector2.new(0.5, 0.5)
Buttons.BackgroundColor3 = Color3.new(1, 1, 1)
Buttons.BackgroundTransparency = 1
Buttons.BorderColor3 = Color3.new(0, 0, 0)
Buttons.BorderSizePixel = 0
Buttons.ClipsDescendants = true
Buttons.Size = UDim2.new(0, 100, 0, 100)

upgradeImageButton.Name = "upgradeImageButton"
upgradeImageButton.Parent = Buttons
upgradeImageButton.BackgroundColor3 = Color3.new(1, 1, 1)
upgradeImageButton.BorderColor3 = Color3.new(0, 0, 0)
upgradeImageButton.BorderSizePixel = 0
upgradeImageButton.Size = UDim2.new(0, 100, 0, 100)
upgradeImageButton.Transparency = 1
upgradeImageButton.Image = "http://www.roblox.com/asset/?id=15640528020"

sellImageButton.Name = "sellImageButton"
sellImageButton.Parent = Buttons
sellImageButton.BackgroundColor3 = Color3.new(1, 1, 1)
sellImageButton.BorderColor3 = Color3.new(0, 0, 0)
sellImageButton.BorderSizePixel = 0
sellImageButton.Size = UDim2.new(0, 100, 0, 100)
sellImageButton.Transparency = 1
sellImageButton.Image = "http://www.roblox.com/asset/?id=12086987759"

skillImageButton.Name = "skillImageButton"
skillImageButton.Parent = Buttons
skillImageButton.BackgroundColor3 = Color3.new(1, 1, 1)
skillImageButton.BorderColor3 = Color3.new(0, 0, 0)
skillImageButton.BorderSizePixel = 0
skillImageButton.Size = UDim2.new(0, 100, 0, 100)
skillImageButton.Transparency = 1
skillImageButton.Image = "http://www.roblox.com/asset/?id=13321880274"

UIGridLayout_6.Parent = Buttons
UIGridLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout_6.CellSize = UDim2.new(0.2, 10, 0.2, 5)

UIGridLayout_4.Parent = Template
UIGridLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_4.SortOrder = Enum.SortOrder.Name
UIGridLayout_4.CellSize = UDim2.new(0.5, 50, 0.2, 60)

UIGridLayout_5.Parent = ScrollingFrame
UIGridLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout_5.CellSize = UDim2.new(0, 120, 0, 150)


local bcUMFrame = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundUnitManagerFrame
local bcOUMFrame = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundOpenUnitManagerFrame.TextButton
local closeUnitManager = game.Players.LocalPlayer.PlayerGui.UnitManagerGui.BackgroundUnitManagerFrame.BottomButtons.CloseButton
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local u = game:GetService("UserInputService")
local units = workspace._UNITS

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

local unitTable = {}

function templateClone(unitName, upgrade, imageGui) 
    if not Template then
        warn("Template não encontrado!")
        return
    end

    local clonado = Template:Clone()
    clonado.Name = unitName
    clonado.Visible = true

    local clonadoImg = imageGui:Clone()
    clonadoImg.Parent = clonado

    local textLabel = clonadoImg:FindFirstChild("TextLabel")
    if textLabel then
        textLabel.Text = "Upgrade: " .. tostring(upgrade)
    else
        warn("TextLabel não encontrado!")
    end

    table.insert(unitTable, clonado)

    if ScrollingFrame then
        clonado.Parent = ScrollingFrame
    else
        warn("ScrollingFrame não definido!")
    end

    local upgradeImageButton = clonado:FindFirstChild("UpgradeButton")
    if upgradeImageButton then
        upgradeImageButton.MouseButton1Click:Connect(function()
            local unitIndex = #unitTable
            upgradeUnit(unitIndex)
        end)
    end

    local sellImageButton = clonado:FindFirstChild("SellButton")
    if sellImageButton then
        sellImageButton.MouseButton1Click:Connect(function()
            local unitIndex = #unitTable
            sellUnit(unitIndex, clonado)
        end)
    end

    local skillImageButton = clonado:FindFirstChild("SkillButton")
    if skillImageButton then
        skillImageButton.MouseButton1Click:Connect(function()
            local unitIndex = #unitTable
            useSkillOnUnit(unitIndex)
        end)
    end
end

if SellAllButton then
    SellAllButton.MouseButton1Click:Connect(function()
        useSellAll()
    end)
end

function upgradeUnit(unitIndex)
    local unit = unitTable[unitIndex]
    if unit then
        local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(unit)) }
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end)
    end
end

function sellUnit(unitIndex, clonado)
    local unit = unitTable[unitIndex]
    if unit then
        local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(unit)) }
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end)

        if clonado then
            clonado:Destroy()
        end
    end
end

function useSkillOnUnit(unitIndex)
    local unit = unitTable[unitIndex]
    if unit then
        local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(unit)) }
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
        end)
    end
end

function useSellAll()
    for i, unit in ipairs(unitTable) do
        if unit then
            local args = { [1] = workspace:WaitForChild("_UNITS"):WaitForChild(tostring(unit)) }
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("endpoints"):WaitForChild("client_to_server"):WaitForChild("use_active_attack"):InvokeServer(unpack(args))
            end)

            if not success then
                warn("Erro ao vender unidade", unit.Name, err)
            end
        end
    end
end

units.ChildAdded:Connect(function(unit)
    local stats = unit:FindFirstChild("_stats") or unit:WaitForChild("_stats", 5)
    if stats then
        local uuid = stats:FindFirstChild("uuid")
        if uuid and uuid.Value ~= "neutral" then
            local upgrade = stats:FindFirstChild("upgrade")
            if upgrade then
                local unitName = unit.Name
                local imageGui = game:GetService("Players").LocalPlayer.PlayerGui.UnitUpgrade.Primary.Container.Main.Main.Icon.Common
                if imageGui then
                    templateClone(unitName, upgrade.Value, imageGui)
                end
            end
        end
    end
end)