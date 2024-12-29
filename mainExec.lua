local AllowedPlaceIds = { 12886143095, 17046374415, 16732694052, 84188796720288, 8304191830, 10450270085 }
local Games = {
	["ALS"] = { 12886143095, 18583778121, 12900046592 },
	["AnimeReborn"] = { 17046374415, 17895401292, 108408425375836, 114706988516358 },
	["Fisch"] = { 16732694052 },
	["AnimeRealms"] = { 84188796720288, 100222912269336 },
	["AA"] = { 8304191830, 8349889591, 14229762361, 14918509670, 14229839966, 3183403065 },
	["JJI"] = { 10450270085, 16379688837, 119359147980471 , 3808223175, 16379684339 }
}

local function IsPlaceAllowed(PlaceId)
	for _, id in ipairs(AllowedPlaceIds) do
		if id == PlaceId then
			return true
		end
	end
	return false
end

local function LoadDirectScript(GameId)
	local GameName = nil
	for name, ids in pairs(Games) do
		for _, id in ipairs(ids) do
			if id == GameId then
				GameName = name
				break
			end
		end
		if GameName then
			break
		end
	end

	if GameName then
		local success, result = pcall(function()
			return loadstring(
				game:HttpGet("https://raw.githubusercontent.com/TrilhaX/scriptexec/main/Games/" .. GameName .. ".lua")
			)()
		end)

		if success then
			print("Script executed successfully for game:", GameName)
		else
			warn("Failed to load script for the game:", result)
		end
	else
		warn("Game not supported. Script not found.")
	end
end

if not IsPlaceAllowed(game.PlaceId) then
	LoadDirectScript(game.PlaceId)
	return
end

local LoaderGui = Instance.new("ScreenGui")
local backgroundFrame = Instance.new("Frame")
local imageLogo = Instance.new("ImageLabel")
local textLoader = Instance.new("TextLabel")
local backgroundBarFrame = Instance.new("Frame")
local barFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")
local UICorner4 = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

LoaderGui.Name = "LoaderGui"
LoaderGui.Parent = game.CoreGui

backgroundFrame.Name = "backgroundFrame"
backgroundFrame.Parent = LoaderGui
backgroundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundFrame.BackgroundColor3 = Color3.new(1, 1, 1)
backgroundFrame.BorderColor3 = Color3.new(0, 0, 0)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
backgroundFrame.Size = UDim2.new(0, 300, 0, 300)

imageLogo.Name = "imageLogo"
imageLogo.Parent = backgroundFrame
imageLogo.AnchorPoint = Vector2.new(0.5, 0.5)
imageLogo.BackgroundColor3 = Color3.new(1, 1, 1)
imageLogo.BorderColor3 = Color3.new(0, 0, 0)
imageLogo.BorderSizePixel = 0
imageLogo.Position = UDim2.new(0.5, 0, 0.35, 0)
imageLogo.Size = UDim2.new(0, 300, 0, 250)
imageLogo.Image = "rbxassetid://127947035573463"

textLoader.Name = "textLoader"
textLoader.Parent = backgroundFrame
textLoader.AnchorPoint = Vector2.new(0.5, 0.5)
textLoader.BackgroundColor3 = Color3.new(1, 1, 1)
textLoader.BorderColor3 = Color3.new(0, 0, 0)
textLoader.BorderSizePixel = 0
textLoader.Position = UDim2.new(0.5, 0, 0.9, 0)
textLoader.Size = UDim2.new(0, 250, 0, 30)
textLoader.Font = Enum.Font.PermanentMarker
textLoader.TextColor3 = Color3.new(0, 0, 0)
textLoader.TextScaled = true
textLoader.TextSize = 14
textLoader.TextWrapped = true

backgroundBarFrame.Name = "backgroundBarFrame"
backgroundBarFrame.Parent = backgroundFrame
backgroundBarFrame.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundBarFrame.BackgroundColor3 = Color3.new(1, 1, 1)
backgroundBarFrame.BorderColor3 = Color3.new(1, 1, 1)
backgroundBarFrame.BorderSizePixel = 0
backgroundBarFrame.Position = UDim2.new(0.5, 0, 0.76, 0)
backgroundBarFrame.Size = UDim2.new(0, 250, 0, 20)

barFrame.Name = "barFrame"
barFrame.Parent = backgroundBarFrame
barFrame.AnchorPoint = Vector2.new(0, 0.5)
barFrame.BackgroundColor3 = Color3.new(85, 0, 127)
barFrame.BorderColor3 = Color3.new(0, 0, 0)
barFrame.BorderSizePixel = 0
barFrame.Position = UDim2.new(0, 0, 0.5, 0)
barFrame.Size = UDim2.new(0, 0, 1, 0)

UICorner.Parent = backgroundBarFrame
UICorner2.Parent = barFrame
UICorner3.Parent = imageLogo
UICorner3.CornerRadius = UDim.new(UICorner3.CornerRadius.Scale, 4)
UICorner4.Parent = backgroundFrame
UIStroke.Parent = backgroundBarFrame
UIStroke.Thickness = 2.5

local TweenService = game:GetService("TweenService")

local function UpdateBar(Progress)
	local goal = { Size = UDim2.new(Progress, 0, 1, 0) }
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(barFrame, tweenInfo, goal)
	tween:Play()
end

local function LoadGame(GameId)
	textLoader.Text = "Checking game"
	wait(1)
	UpdateBar(0.33)

	local GameName = nil

	for name, ids in pairs(Games) do
		for _, id in ipairs(ids) do
			if id == GameId then
				GameName = name
				break
			end
		end
		if GameName then
			break
		end
	end

	if GameName then
		textLoader.Text = "Checked Game: " .. GameName
		wait(1)
		textLoader.Text = "Checking If all is okay"
		UpdateBar(0.66)
		wait(1)
		textLoader.Text = "Everything Ok"
		UpdateBar(0.90)
		textLoader.Text = "Loading Script"
		local success, result = pcall(function()

			return loadstring(
				game:HttpGet("https://raw.githubusercontent.com/TrilhaX/scriptexec/main/Games/" .. GameName .. ".lua")
			)()
		end)

		if success then
			UpdateBar(1)
			textLoader.Text = "Script loaded successfully"
			LoaderGui:Destroy()
		else
			warn("Failed to load script for the game:", result)
			textLoader.Text = "Error loading script"
			wait(1)
			LoaderGui:Destroy()
		end
	else
		warn("Game not supported")
		textLoader.Text = "Game not supported"
		wait(1)
		LoaderGui:Destroy()
	end
end

LoadGame(game.PlaceId)
