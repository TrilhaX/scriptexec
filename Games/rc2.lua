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
    Title = 'Tempest Hub | Refinary Caves 2',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Refinary Caves 2 Script', 5)
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

local player = game.Players.LocalPlayer

local function EquipTool(selectedTool)
    while getgenv().EquipToo == true do
        local Tool = player.Backpack:FindFirstChild(selectedTool)
        if Tool then
            player.Character.Humanoid:EquipTool(Tool)
        end
        wait(2)  -- Wait before checking again
    end
end

function autobuy()
    while getgenv().autobuy == true do
        local grab = workspace:FindFirstChild("Grab")
        local Character = player.Character
        
        if grab then
            local children = grab:GetChildren()
            local seenNames = {}
            
            for _, child in ipairs(children) do
                if not seenNames[child.Name] then
                    seenNames[child.Name] = true
                    local parts = child:GetChildren()
                    local foundPart = false
                    
                    for _, part in ipairs(parts) do
                        if part:IsA("Part") then
                            -- Check if selectedItemToBuy matches child's name
                            if selectedItemToBuy == child.Name then
                                Character.HumanoidRootPart.CFrame = CFrame.new(1940.10779, 3.28117442, -177.802002, -0.61974299, 2.7837654e-08, -0.784804821, 9.27394481e-08, 1, -3.77634919e-08, 0.784804821, -9.6186028e-08, -0.61974299)
                                part.CFrame = CFrame.new(1940.36426, 3.00488424, -169.990311, -0.0175484549, 0.409162462, 0.912292838, 0.999815881, 9.37731311e-05, 0.0191899519, 0.0077662603, 0.912461519, -0.409088761)
                                local args = {
                                    [1] = workspace:WaitForChild("Grab"):WaitForChild(selectedItemToBuy):WaitForChild("Part"),
                                    [2] = "Grab"
                                }
                                
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("GrabHandler"):InvokeServer(unpack(args))
                                
                                workspace:WaitForChild("Map"):WaitForChild("Structures"):WaitForChild("UCS"):WaitForChild("Registers"):WaitForChild("Counter"):WaitForChild("TalkPart"):WaitForChild("Interact"):FireServer()
                                local args = {
                                    [1] = "Yes",
                                    [2] = 1
                                }
                                
                                workspace:WaitForChild("Map"):WaitForChild("Structures"):WaitForChild("UCS"):WaitForChild("Registers"):WaitForChild("Counter"):WaitForChild("TalkPart"):WaitForChild("Interact"):FireServer(unpack(args))
                                foundPart = true
                            end
                        end
                    end
                    
                    if not foundPart then
                        wait()
                    end
                end
            end
        else
            print("Grab não encontrado no workspace")
        end
        wait(2)
    end
end

function autofish()
    while getgenv().autofish == true do
        local targetCFrame = CFrame.new(4434.49072, -703.024475, 2466.45947, -0.648476779, 4.07732266e-08, -0.761234462, 9.79536381e-08, 1, -2.9882294e-08, 0.761234462, -9.39436546e-08, -0.648476779)
        local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
        tween.Completed:Wait()
        
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if character then
            local currentTool = character:FindFirstChildOfClass("Tool")
            
            if currentTool then
                local Bobber = currentTool:FindFirstChild("_Bobber")
                if Bobber then
                    local fish = player.PlayerGui.UserGui.CatchFrame.Fish
                        local fishrotation = fish.Rotation
                        
                        if fishrotation == 180 then
                            local args = {"Right"}
                            game:GetService("ReplicatedStorage").Events.FishPull:FireServer(unpack(args))
                        elseif fishrotation == 0 then
                            local args = {"Left"}
                            game:GetService("ReplicatedStorage").Events.FishPull:FireServer(unpack(args))
                        else
                            print("Não Tem Pexie")  -- If fish rotation is neither 180 nor 0
                        end
                else
                    local args1 = {
                        [1] = {
                            ["Action"] = "Charge",
                            ["Position"] = Vector3.new(4451.72021484375, -708.7493896484375, 2469.5947265625)
                        }
                    }
                    game.Players.LocalPlayer.Character:FindFirstChild(selectedTool).Replicator:FireServer(unpack(args1))
                    
                    local args2 = {
                        [1] = {
                            ["Action"] = "Attack",
                            ["Data"] = {
                                ["Alpha"] = 1,
                                ["ResponseTime"] = 1
                            }
                        }
                    }
                    game.Players.LocalPlayer.Character:FindFirstChild(selectedTool).Replicator:FireServer(unpack(args2))
                end
            else
                print("O jogador não está usando nenhuma ferramenta.")
            end
        else
            print("O jogador não possui um personagem.")
        end
        wait(.1)
    end
end

function auto100ROCK()
    while getgenv().auto100ROCK == true do
        local oresFolder = workspace.WorldSpawn.Ores
        local names = {}

        for _, child in ipairs(oresFolder:GetChildren()) do
            local name = child.Name
            if not names[name] then
                names[name] = true
                            local args = {
                                [1] = {
                                    ["Action"] = "Attack",
                                    ["Data"] = {
                                        ["Alpha"] = 1,
                                        ["ResponseTime"] = 1
                                    }
                                }
                            }
                            
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild(selectedTool).Replicator:FireServer(unpack(args))
                            wait(1)
                        else
                            local args = {
                                [1] = {
                                    ["Action"] = "Attack",
                                    ["Data"] = {
                                        ["Alpha"] = 1,
                                        ["ResponseTime"] = 1
                                    }
                                }
                            }
                            
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild(selectedTool).Replicator:FireServer(unpack(args))
                            wait(1)
                        end
                    end        
        wait() -- Wait before looping again
    end
end


function teleporttoore()
    while getgenv().teleporttoore == true do
        local oresFolder = workspace.WorldSpawn.Ores
        local names = {}
        
        -- Iterar sobre cada filho dentro de Ores
        for _, child in ipairs(oresFolder:GetChildren()) do
            local name = child.Name
            if not names[name] then
                names[name] = true
                if selectedOre == name then
                    if child:FindFirstChild("Hittable") then
                        local hitPart = child.Hittable:FindFirstChild("Part")
                        if hitPart then
                            local targetCFrame = GetCFrame(hitPart, 5)
                            local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
                            tween.Completed:Wait()
                            local args = {
                                [1] = {
                                    ["Target"] = workspace:WaitForChild("WorldSpawn"):WaitForChild("Ores"):WaitForChild(selectedOre):WaitForChild("Hittable"):WaitForChild("Part"),
                                    ["ParticleDirection"] = CFrame.new(),
                                    ["Action"] = "Charge",
                                    ["Position"] = Vector3.new(hitPart.Position)
                                }
                            }
                            
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild(selectedTool).Replicator:FireServer(unpack(args))                            
                        end
                    else
                        wait()
                    end
                else
                    wait()
                end
            end
        end
        wait(5)
    end
end

function teleporttoNPC()
    while getgenv().teleporttoNPC == true do
        local npcsFolder = workspace.Npcs
        local ValuesNamesNPC = {}
        local seenNames = {}
        
        for _, child in ipairs(npcsFolder:GetChildren()) do
            local npcName = child.Name
            if not seenNames[npcName] then
                seenNames[npcName] = true
                
                if selectedOre == npcName then
                    local targetCFrame = GetCFrame(child.HumanoidRootPart)
                    local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
                    tween.Completed:Wait()
                else
                    -- Caso o NPC não corresponda ao selecionado, apenas esperar
                    wait()
                end
            end
        end
        wait()
    end
end

local function drawESP(playerCharacter, camera)
    local humanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local screenPosition, onScreen = camera:WorldToScreenPoint(humanoidRootPart.Position)
        if onScreen then
            local gui = Instance.new("BillboardGui")
            gui.AlwaysOnTop = true
            gui.Size = UDim2.new(4, 0, 4, 0)
            gui.StudsOffset = Vector3.new(0, 2, 0)
            gui.Parent = game.CoreGui

            local espLabel = Instance.new("TextLabel")
            espLabel.BackgroundTransparency = 1
            espLabel.Size = UDim2.new(1, 0, 1, 0)
            espLabel.Text = playerCharacter.Name
            espLabel.Font = Enum.Font.SourceSansBold
            espLabel.TextSize = 18
            espLabel.TextColor3 = Color3.new(1, 1, 1)
            espLabel.Parent = gui

            -- Função para atualizar a posição da GUI
            local function updateESP()
                local screenPosition, onScreen = camera:WorldToScreenPoint(humanoidRootPart.Position)
                if onScreen then
                    gui.Enabled = true
                    gui.Adornee = humanoidRootPart
                    gui.StudsOffset = Vector3.new(0, 2, 0)
                    gui.AlwaysOnTop = true
                    gui.Size = UDim2.new(4, 0, 4, 0)
                else
                    gui.Enabled = false
                end
            end

            -- Conectar ao evento RenderStepped para atualizar continuamente
            game:GetService("RunService").RenderStepped:Connect(updateESP)
            
            -- Chamar updateESP uma vez para inicializar corretamente
            updateESP()
        end
    end
end

-- Função principal para ESP de jogadores
function espplayer()
    while getgenv().espplayer == true do
    local player = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    
    -- Desenhar ESP para jogadores existentes
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            drawESP(player.Character, camera)
        end
    end
    
    -- Conectar ao evento PlayerAdded para desenhar ESP quando novos jogadores entram
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            drawESP(character, camera)
        end)
        if player.Character then
            drawESP(player.Character, camera)
        end
    end)
    wait()
    end
end

function autobuyplot()
    while getgenv().autobuyplot == true do
        local workspace = game:GetService("Workspace")
        local plots = workspace.Plots

        local children = plots:GetChildren()

        for _, child in ipairs(children) do
            local owner = child.Owner
            if owner and owner.Value ~= nil then
                local originalName = owner.Parent.Name
                if originalName == selectedPlotNumber then
                    local plotIndex = tonumber(originalName:match("%d+"))
                    if plotIndex then
                        local args = {
                            [1] = {
                                ["Rotation"] = 0,
                                ["PlotIndex"] = plotIndex
                            },
                            [2] = "LandAgency"
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SelectPlot"):FireServer(unpack(args))                        
                    else
                        warn("O nome do pai não contém um número válido.")
                    end
                else
                    wait()
                end
            end
        end        
        wait()
    end
end

local ValuesToolsName = {}
local Tools = game:GetService("ReplicatedStorage").Content.Tools
local children = Tools:GetChildren()

for _, child in ipairs(children) do
   table.insert(ValuesToolsName, child.Name)
end


local ValuesItensBuy = {}
local grab = workspace:FindFirstChild("Grab")
        
if grab then
    local children2 = grab:GetChildren()
    local seenNames = {}
            
    for _, child2 in ipairs(children2) do
        if not seenNames[child2.Name] then
            table.insert(ValuesItensBuy, child2.Name)
            seenNames[child2.Name] = true
        else
            wait()
        end
    end
end

local oresFolder = workspace.WorldSpawn.Ores
local names = {}
local ValuesNamesOre = {}

-- Iterating over each child within Ores
for _, child3 in ipairs(oresFolder:GetChildren()) do
    local name = child3.Name
    if not names[name] then
        table.insert(ValuesNamesOre, name)  -- Use 'name' directly instead of 'name.Name'
        names[name] = true
    end
end


local npcsFolder = workspace.Npcs
local ValuesNamesNPC = {}
local seenNames = {}

-- Iterating over each child within npcsFolder
for _, child in ipairs(npcsFolder:GetChildren()) do
    local npcName = child.Name
    if not seenNames[npcName] then
        table.insert(ValuesNamesNPC, npcName)
        seenNames[npcName] = true
    end
end


local ValuesPlotNumber = {}
local workspace = game:GetService("Workspace")
local plots = workspace.Plots
local children = plots:GetChildren()

-- Iterando sobre os filhos
for _, child in ipairs(children) do
    local owner = child.Owner
    if owner and owner.Value ~= nil then
        -- Nome original do pai
        local originalName = owner.Parent.Name
        table.insert(ValuesPlotNumber, originalName)
    end
end

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Player')

LeftGroupBox:AddDropdown('CDTJ', {
    Values = ValuesToolsName,
    Default = "None",
    Multi = false,
    Text = 'Choose Tool To Equip',
    Callback = function(value)
        selectedTool = value
    end
})

LeftGroupBox:AddToggle('AEP', {
    Text = 'Auto Equip',
    Default = false,
    Callback = function(Value)
        if Value then
            getgenv().EquipToo = Value
            EquipTool(selectedTool)
        end
    end
})

LeftGroupBox:AddToggle('AUTO100ROCK', {
    Text = 'Auto 100 Rock',
    Default = false,
    Callback = function(Value)
        getgenv().auto100ROCK = Value
        auto100ROCK()
    end
})

LeftGroupBox:AddToggle('AutoFish', {
    Text = 'Auto Fish',
    Default = false,
    Callback = function(Value)
        getgenv().autofish = Value
        autofish()
    end
})

LeftGroupBox:AddDropdown('CDTJ', {
    Values = ValuesItensBuy,
    Default = "None",
    Multi = false,
    Text = 'Choose Item To Buy',
    Callback = function(value)
        selectedItemToBuy = value
    end
})

LeftGroupBox:AddToggle('AEP', {
    Text = 'Auto Buy',
    Default = false,
    Callback = function(Value)
        getgenv().autobuy = Value
        autobuy()
    end
})

LeftGroupBox:AddDropdown('CDTJ', {
    Values = ValuesNamesOre,
    Default = "None",
    Multi = false,
    Text = 'Choose Ore To TP',
    Callback = function(value)
        selectedOre = value
    end
})

LeftGroupBox:AddToggle('AEP', {
    Text = 'Auto Tp to Ore',
    Default = false,
    Callback = function(Value)
        getgenv().teleporttoore = Value
        teleporttoore()
    end
})

LeftGroupBox:AddDropdown('CDTJ', {
    Values = ValuesNamesNPC,
    Default = "None",
    Multi = false,
    Text = 'Choose NPC To TP',
    Callback = function(value)
        selectedOre = value
    end
})

LeftGroupBox:AddToggle('AEP', {
    Text = 'Auto Tp to NPC',
    Default = false,
    Callback = function(Value)
        getgenv().teleporttoNPC = Value
        teleporttoNPC()
    end
})

LeftGroupBox:AddDropdown('CDTJ', {
    Values = ValuesPlotNumber,
    Default = "None",
    Multi = false,
    Text = 'Choose Plot To Buy',
    Callback = function(value)
        selectedPlotNumber = value
    end
})

LeftGroupBox:AddToggle('AEP', {
    Text = 'Auto Buy Plot',
    Default = false,
    Callback = function(Value)
        getgenv().autobuyplot = Value
        autobuyplot()
    end
})


LeftGroupBox:AddToggle('AEP', {
    Text = 'Esp Player',
    Default = false,
    Callback = function(Value)
        getgenv().espplayer = Value
        espplayer()
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
SaveManager:SetFolder('Tempest Hub/_U_T_D')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_U_T_D'
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