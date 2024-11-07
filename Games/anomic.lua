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

function autochooseteam()
    while getgenv().autochooseteam == true do
        local a = require(game:GetService("ReplicatedStorage").Client.TeamList)

        for key, value in pairs(a) do
            local args = {
                [1] = selectedTeam
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("_CS.Events"):WaitForChild("TeamChanger"):FireServer(unpack(args))                       
        end        
        wait()
    end
end

function autospawn()
    while getgenv().autospawn == true do
        local args = {
            [1] = "SpawnChar",
            [2] = "Arway"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("_CS.Events"):WaitForChild("SpawnCharacter"):InvokeServer(unpack(args)) 
        wait()
    end
end

function bypass()
    repeat
        wait()
    until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.HumanoidRootPart and not game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored

    for i, v in next, getconnections(game:GetService("Players").LocalPlayer.Character.DescendantAdded) do
        v:Disable()
    end

    local s, err = pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local namecall = mt.__namecall

        mt.__namecall = function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if tostring(method) == 'FindPartOnRayWithWhitelist' and getcallingscript() == game.Players.LocalPlayer.PlayerGui['_L.Handler'].GunHandlerLocal then
                wait(9e9)
                return
            end

            if method == "Kick" then
                notify("Anomic V", "Server tried kicking you")
                return nil                    
            end        

            if tostring(method) == "FireServer" then
                if shotgunMod1 and tostring(self) == "AmmoRemover" then                        
                    return nil
                end                           
            end

            if tostring(method) == "Fire" then
                if Rmod and tostring(self) == "ShootAnim" then
                    return nil
                end                   
            end

            return namecall(self, ...)
        end
    end)

    if not s then
        warn("Error in bypass function:", err)
    end
end

local g = (number)
local lp = game:GetService("Players").LocalPlayer
    local hooks = {
        walkspeed = 23,
        jumppower = 50
    }
    local index
    local newindex

    index = hookmetamethod(game, "__index", function(self, property)
        if not checkcaller() and self:IsA("Humanoid") and self:IsDescendantOf(lp.Character) and hooks[property:lower()] then
            return hooks[property:lower()]
        end
        return index(self, property)
    end)

    newindex = hookmetamethod(game, "__newindex", function(self, property, value)
        if not checkcaller() and self:IsA("Humanoid") and self:IsDescendantOf(lp.Character) and hooks[property:lower()] then
            return value
        end
        return newindex(self, property, value)
    end)
 lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = g

print("Loading anti kick")
local protect = newcclosure or protect_function
hookfunction(game:GetService("Players").LocalPlayer.Kick,protect(function() 
    wait(9e9) 
end))

function noclip()
    while getgenv().noclip == true do
        local LPlayer = game.Players.LocalPlayer
        if LPlayer.Character then
            for _, child in pairs(LPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                end
            end
        end
        wait()
    end
end

-- Função para ESP de jogadores
function espplayer()
    while getgenv().espplayer == true do
        -- Captura dos jogadores e câmera
        local players = game:GetService("Players")
        local client = players.LocalPlayer
        local camera = workspace.CurrentCamera

        -- Declaração global de funções e serviços
        getgenv().global = getgenv()

        -- Função para declarar variáveis e serviços
        function global.declare(self, index, value, check)
            -- Implementação da função 'declare'
        end

        -- Declaração de serviços e funções relacionadas aos jogadores
        declare(global, "services", {})
        declare(declare(services, "loop", {}), "cache", {})
        
        -- Função para criar novas funções de loop
        get("loop").new = function(self, index, func, disabled)
            -- Implementação da função 'new' para loops
        end

        -- Função para criar novos desenhos
        get("new").drawing = function(class, properties)
            -- Implementação da função 'drawing' para desenhos
        end

        -- Funções para gerenciar jogadores
        declare(declare(services, "player", {}), "cache", {})
        
        -- Função para encontrar um jogador na cache
        get("player").find = function(self, player)
            -- Implementação da função 'find' para encontrar jogadores
        end

        -- Função para verificar se um jogador está disponível
        get("player").check = function(self, player)
            -- Implementação da função 'check' para verificar jogadores
        end

        -- Função para adicionar um novo jogador à cache
        get("player").new = function(self, player)
            -- Implementação da função 'new' para adicionar jogadores
        end

        -- Função para remover um jogador da cache
        get("player").remove = function(self, player)
            -- Implementação da função 'remove' para remover jogadores
        end

        -- Função para atualizar informações do jogador
        get("player").update = function(self, character, data)
            -- Implementação da função 'update' para atualizar informações do jogador
        end

        -- Loop principal para atualização dos jogadores na cache
        declare(get("player"), "loop", get("loop"):new(function()
            -- Implementação do loop principal para atualização dos jogadores
        end), true)

        -- Features e configurações visuais
        declare(global, "features", {})
        
        -- Função para alternar funcionalidades (features)
        features.toggle = function(self, feature, boolean)
            -- Implementação da função 'toggle' para alternar funcionalidades
        end

        -- Configurações visuais padrão
        declare(features, "visuals", {
            -- Configurações visuais padrão
        })

        -- Loop para adicionar jogadores existentes
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= client and not get("player"):find(player) then
                get("player"):new(player)
            end
        end

        -- Eventos para adição e remoção de jogadores
        declare(get("player"), "added", players.PlayerAdded:Connect(function(player)
            get("player"):new(player)
        end), true)

        declare(get("player"), "removing", players.PlayerRemoving:Connect(function(player)
            get("player"):remove(player)
        end), true)

        wait()
    end
end


function disableStam()
    while getgenv().disableStam == true do
    repeat wait() until LPlayer.Character.HumanoidRootPart.Anchored == false       
        for i,x in pairs(LPlayer.Character:GetChildren()) do
            if x:IsA("LocalScript") and x.Name ~= "KeyDrawer" and x.Name ~= "Animate" and x.Name ~= "AnimationHandler" then 
                if enabled then
                    x.Disabled = true
                else
                    x.Disabled = false
                end
            end 
        end 
    end
end

local ValuesTeamChoose = {}
local a = require(game:GetService("ReplicatedStorage").Client.TeamList)

for key, value in pairs(a) do
    table.insert(ValuesTeamChoose, key)
end  


local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Player')

LeftGroupBox:AddDropdown('CDTJ', {
    Values = ValuesTeamChoose,
    Default = "None",
    Multi = false,
    Text = 'Choose Plot To Buy',
    Callback = function(value)
        selectedTeam = value
    end
})

LeftGroupBox:AddToggle('AEP', {
    Text = 'Auto Team',
    Default = false,
    Callback = function(Value)
        getgenv().autochooseteam = Value
        autochooseteam()
    end
})

LeftGroupBox:AddToggle('AEP', {
    Text = 'No Clip',
    Default = false,
    Callback = function(Value)
        getgenv().noclip = Value
        noclip()
    end
})

LeftGroupBox:AddToggle('AEP', {
    Text = 'Inf Stamina',
    Default = false,
    Callback = function(Value)
        getgenv().disableStam = Value
        disableStam()
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