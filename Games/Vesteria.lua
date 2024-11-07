warn('[TEMPEST HUB] Loading Bypass')
wait(1)
warn('[TEMPEST HUB] Loading Ui')
wait(1)
local repo = 'https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
Library:Notify('Welcome to Tempest Hub', 5)

local Window = Library:CreateWindow({
    Title = 'Tempest Hub | Vesteria',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Vesteria Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

local TweenService = game:GetService("TweenService")
local speed = 10000

-- Function to tween a model to a target CFrame
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

-- Function to get a CFrame based on different types of input
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

    -- Apply height and angle adjustments
    if height then
        cframe = cframe + Vector3.new(0, height, 0)
    end
    if angle then
        cframe = cframe * CFrame.Angles(0, math.rad(angle), 0)
    end
    
    return cframe
end

local Player = game.Players.LocalPlayer





















local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection

-- Create a function to update FPS and ping information
local function UpdateWatermark()
    FrameCounter = FrameCounter + 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    Library:SetWatermark(('Tempest Hub | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end

-- Connect the function to the RenderStepped event
WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(UpdateWatermark)

-- Create tabs for UI settings
local TabsUI = {
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Unload function
local function Unload()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end

-- UI Settings
local MenuGroup = TabsUI['UI Settings']:AddLeftGroupbox('Menu')

-- Add an unload button
MenuGroup:AddButton('Unload', Unload)

-- Add a label and key picker for the menu keybind
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

-- Define the ToggleKeybind variable
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('Tempest Hub')
SaveManager:SetFolder('Tempest Hub/_Vesteria')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_Vesteria'
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

-- Disable player idling
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
warn('[TEMPEST HUB] Loaded')