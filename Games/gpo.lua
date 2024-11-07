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
    Title = 'Tempest Hub | Grand Piece Online',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Grand Piece Online Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait(1)
warn('[TEMPEST HUB] Loading Toggles')
wait(1)
warn('[TEMPEST HUB] Last Checking')
wait(1)

local TweenService = game:GetService("TweenService")
local speed = 50

-- Function to tween a model to a target CFrame
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

-- Function to get a CFrame based on different types of input
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

    -- Apply height and angle adjustments
    if height then
        cframe = cframe + Vector3.new(0, height, 0)
    end
    if angle then
        cframe = cframe * CFrame.Angles(0, math.rad(angle), 0)
    end
    
    return cframe
end

-- Function to automate farming
function autofarmcolar()
    while getgenv().autofarmcolar == true do
        local npcquest = workspace.NPCs:FindFirstChild("Sarah") and workspace.NPCs.Sarah:FindFirstChild("HumanoidRootPart")
        local quest = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Quest") and game:GetService("Players").LocalPlayer.PlayerGui.Quest.Main
        
        if quest and quest.Visible then
            local Colar = game.workspace.Effects:FindFirstChild("Part")
            if Colar then
                local itemframe = GetCFrame(Colar)
                local tween = tweenModel(game.Players.LocalPlayer.Character, itemframe)
                if tween then
                    tween.Completed:Wait()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    local npccframe = GetCFrame(npcquest)
                    local tween = tweenModel(game.Players.LocalPlayer.Character, npccframe)
                    tween.Completed:Wait()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.T, false, game)
                else
                    print("Failed to create tween")
                end
            else
                print("Colar Não Encontrado")
            end
        else
            if npcquest then
                local npccframe = GetCFrame(npcquest)
                local tween = tweenModel(game.Players.LocalPlayer.Character, npccframe)
                if tween then
                    tween.Completed:Wait()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.T, false, game)
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local npcChat = player.PlayerGui:FindFirstChild("NPCCHAT")
                    
                        while npcChat do
                            local frame = npcChat:FindFirstChild("Frame")
                            if frame then
                                local button = frame:FindFirstChild("go")
                                if button then
                                    for _, connection in pairs(getconnections(button.MouseButton1Click)) do
                                        if type(connection.Function) == "function" then
                                            connection.Function()
                                        end
                                    end
                                end
                            end
                            npcChat = player.PlayerGui:FindFirstChild("NPCCHAT") -- Atualiza o npcChat para verificar se ainda existe
                            wait(0.1) -- Adiciona um pequeno atraso para evitar sobrecarga do loop
                        end
                    end)
                else
                    print("Failed to create tween")
                end
            else
                print("Npc Não Encontrado")
            end
        end
        wait() -- Add a delay to prevent high CPU usage
    end
end

function autoenterimpelodown()
    while getgenv().autoenterimpelodown == true do
        local ImpelDown = workspace.Islands:FindFirstChild("Impel Base")
        local DoorImpel
                
        if ImpelDown and ImpelDown:FindFirstChild("ImpelBase") and ImpelDown.ImpelBase:FindFirstChild("castle") and ImpelDown.ImpelBase.castle:FindFirstChild("Bookshelf") and ImpelDown.ImpelBase.castle.Bookshelf:FindFirstChild("Book") and ImpelDown.ImpelBase.castle.Bookshelf.Book:FindFirstChild("Model") then
            DoorImpel = ImpelDown.ImpelBase.castle.Bookshelf.Book.Model
        end
                
        if DoorImpel then
            local dgenter = workspace.Effects.Entrance
                    
            if dgenter then
                local TpFrame = GetCFrame(dgenter) -- Pass the correct CFrame or Instance
                local tween2 = tweenModel(game.Players.LocalPlayer.Character, TpFrame)
            else
                print("Tp Error")
            end
        else
            local TpFrame2 = CFrame.new(5933.44434, 7.6820488, -10171.3477, 0.642763317, 0, 0.766064942, 0, 1, 0, -0.766064942, 0, 0.642763317)
            local tween = tweenModel(game.Players.LocalPlayer.Character, TpFrame2)
        end
        wait()
    end
end

function autoimpelodown()
    while getgenv().autoimpelodown == true do

        wait()
    end
end

local players = game:GetService("Players")
local runService = game:GetService("RunService")

local function createESP(player)
    if not player.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.5
    highlight.Adornee = player.Character
    highlight.Parent = player.Character

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = player.Character:FindFirstChild("Head")
    billboardGui.Size = UDim2.new(2, 0, 1, 0)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = player.Name
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = billboardGui

    billboardGui.Parent = player.Character:FindFirstChild("Head")

    player.CharacterAdded:Connect(function(character)
        highlight.Adornee = character
        highlight.Parent = character

        local newBillboardGui = billboardGui:Clone()
        newBillboardGui.Adornee = character:FindFirstChild("Head")
        newBillboardGui.Parent = character:FindFirstChild("Head")
    end)
end

local function onPlayerAdded(player)
    if player.Character then
        createESP(player)
    end
    player.CharacterAdded:Connect(function(character)
        createESP(player)
    end)
end

players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(players:GetPlayers()) do
    onPlayerAdded(player)
end

runService.RenderStepped:Connect(function()
    for _, player in ipairs(players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Highlight") then
            player.Character.Highlight.Enabled = true
        end
    end
end)

function arma()
    while getgenv().arma == true do
    local localPlayer = game.Players.LocalPlayer
    local shooting = true
    local shootpos = CFrame.new(0, 0, 0)
    local cf = getrenv()._G.MouseCF
    getrenv()._G.MouseCF = nil

    -- Define KeyCode and UserInputState for shooting action
    local input = {
        KeyCode = Enum.KeyCode.Unknown,
        UserInputState = Enum.UserInputState.Begin,
        UserInputType = Enum.UserInputType.MouseButton1
    }
    
    wait() -- Place wait() here to introduce a delay in the loop.

    -- Aim Assist
    setmetatable(
        getrenv()._G,
        {
            __index = function(a, b)
                if b == 'MouseCF' then
                    return shooting and (GetNearestPlayer() or cf) or cf
                end
                return rawget(a, b)
            end,
            __newindex = function(a, b, c)
                if b == 'MouseCF' then
                    cf = c
                end
                return rawset(a, b, c)
            end
        }
    )
end
end

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Farm')

LeftGroupBox:AddToggle('AutoFarmColar', {
    Text = 'Auto Farm Colar',
    Default = false,
    Callback = function(Value)
        getgenv().autofarmcolar = Value
        autofarmcolar()
    end
})

LeftGroupBox:AddToggle('AutoFarmColar', {
    Text = 'Auto Gun',
    Default = false,
    Callback = function(Value)
        getgenv().arma = Value
        arma()
    end
})

LeftGroupBox:AddToggle('AutoFarmColar', {
    Text = 'Auto Enter Impel Down',
    Default = false,
    Callback = function(Value)
        getgenv().autoenterimpelodown = Value
        autoenterimpelodown()
    end
})


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
SaveManager:SetFolder('Tempest Hub/_GPO_')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_GPO_'
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