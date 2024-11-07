local players = game:GetService("Players")
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local env = workspace:WaitForChild("Env")
local camera = game.Workspace.CurrentCamera

local chests = {}
for _, child in ipairs(env:GetChildren()) do
    if child.Name == "Chest" then
        table.insert(chests, child)
    end
end

local function createESP(object, name, color)
    if not object:IsA("Model") then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.5
    highlight.Adornee = object
    highlight.Parent = object

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = object:FindFirstChild("Head") or object:FindFirstChild("PrimaryPart") or object:FindFirstChildWhichIsA("BasePart")
    billboardGui.Size = UDim2.new(2, 0, 1, 0)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.Size = UDim2.new(1, 0, 0.8, 0)  -- Reduzido o tamanho para dar espaço para o distanceLabel
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboardGui

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Text = ""
    distanceLabel.Size = UDim2.new(1, 0, 0.2, 0)  -- Tamanho menor para o distanceLabel
    distanceLabel.Position = UDim2.new(0, 0, 1, 0)
    distanceLabel.AnchorPoint = Vector2.new(0, 1)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Parent = billboardGui

    billboardGui.Parent = object:FindFirstChild("Head") or object:FindFirstChild("PrimaryPart") or object:FindFirstChildWhichIsA("BasePart")

    local function updateDistance()
        local objectPosition = object:FindFirstChild("Head") or object:FindFirstChild("PrimaryPart") or object:FindFirstChildWhichIsA("BasePart").Position
        local playerPosition = camera.CFrame.Position
        local distance = (objectPosition - playerPosition).magnitude
        distanceLabel.Text = string.format("%.1f studs", distance)
    end

    runService.RenderStepped:Connect(function()
        if object.Parent then
            updateDistance()
        end
    end)
end

local function activateESPForPlayers()
    local function onPlayerAdded(player)
        local function setupCharacter(character)
            createESP(character, player.Name, Color3.fromRGB(255, 0, 0))
        end
        
        if player.Character then
            setupCharacter(player.Character)
        end
        player.CharacterAdded:Connect(setupCharacter)
    end

    players.PlayerAdded:Connect(onPlayerAdded)
    for _, player in ipairs(players:GetPlayers()) do
        onPlayerAdded(player)
    end
end

local function activateESPForChests()
    local function onChestAdded(chest)
        createESP(chest, chest.Name, Color3.fromRGB(255, 0, 0))
    end

    for _, chest in ipairs(chests) do
        onChestAdded(chest)
    end

    env.ChildAdded:Connect(function(child)
        if child.Name == "Chest" then
            onChestAdded(child)
        end
    end)
end

local function activateESP()
    activateESPForPlayers()
    activateESPForChests()
end

repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:findFirstChild("Head") and game.Players.LocalPlayer.Character:findFirstChild("Humanoid")

local mouse = game.Players.LocalPlayer:GetMouse()
repeat wait() until mouse

local plr = game.Players.LocalPlayer
local torso = plr.Character.Head
local flying = false
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local maxspeed = 60
local speed = 60

function Fly()
    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = torso.CFrame
    
    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    repeat wait()
        plr.Character.Humanoid.PlatformStand = true
        
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = speed + 0.5 + (speed / maxspeed)
            if speed > maxspeed then
                speed = maxspeed
            end
        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
            speed = speed - 1
            if speed < 0 then
                speed = 0
            end
        end
        
        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CFrame.lookVector * (ctrl.f + ctrl.b)) + 
                ((game.Workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - 
                game.Workspace.CurrentCamera.CFrame.p)) * speed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CFrame.lookVector * (lastctrl.f + lastctrl.b)) + 
                ((game.Workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - 
                game.Workspace.CurrentCamera.CFrame.p)) * speed
        else
            bv.velocity = Vector3.new(0, 0.1, 0)
        end
        
        bg.cframe = game.Workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
    until not flying
    
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    speed = 0
    bg:Destroy()
    bv:Destroy()
    plr.Character.Humanoid.PlatformStand = false
end

mouse.KeyDown:connect(function(key)
    if key:lower() == "f" then
        if flying then
            flying = false
        else
            flying = true
            Fly()
        end
    elseif key:lower() == "w" then
        ctrl.f = 1
    elseif key:lower() == "s" then
        ctrl.b = -1
    elseif key:lower() == "a" then
        ctrl.l = -1
    elseif key:lower() == "d" then
        ctrl.r = 1
    end
end)

mouse.KeyUp:connect(function(key)
    if key:lower() == "w" then
        ctrl.f = 0
    elseif key:lower() == "s" then
        ctrl.b = 0
    elseif key:lower() == "a" then
        ctrl.l = 0
    elseif key:lower() == "d" then
        ctrl.r = 0
    end
end)

Fly()
activateESP()