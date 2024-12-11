warn('[TEMPEST HUB] Loading Ui')
wait()
local repo = 'https://raw.githubusercontent.com/TrilhaX/tempestHubUI/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
Library:Notify('Welcome to Tempest Hub', 5)

local Window = Library:CreateWindow({ 
    Title = 'Tempest Hub | Anime Shadow',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Anime Shadow Script', 5)
warn('[TEMPEST HUB] Loading Function')
wait()
warn('[TEMPEST HUB] Loading Toggles')
wait()
warn('[TEMPEST HUB] Last Checking')
wait()

function hideUIExec()
    if getgenv().hideUIExec then
        local windowFrame = game:GetService("CoreGui").LinoriaGui.windowFrame
        windowFrame.Visible = false
        wait()
    end
end

function aeuat()
    if getgenv().aeuat == true then
        local teleportQueued = false
        game.Players.LocalPlayer.OnTeleport:Connect(function(State)
            if (State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress) and not teleportQueued then
                teleportQueued = true
                
                queue_on_teleport([[ 
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

function autoJoin()
    while getgenv().autoJoin == true do
            local args = {
                [1] = {
                    ["data"] = buffer(buffer: 0xe66ce2b83d3ffbe2)
                    ["references"] = {}
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("NetserEvent"):FireServer(unpack(args))      
            local args = {
                [1] = {
                    ["data"] = buffer(buffer: 0xdf29dabc5c0faefa)
                    ["references"] = {}
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("NetserEvent"):FireServer(unpack(args))
            wait(.5)
            local VirtualInputManager = game:GetService("VirtualInputManager")
            local GuiService = game:GetService("GuiService")

            local player = game:GetService("Players").LocalPlayer
            local mapas = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MapSelector.Content.ScrollingFrame

            for i,v in pairs(mapas:GetChildren())do
                if v.MapImage.Frame.TextLabel.Text == selectedMapFarm then
                    local button = v.MapImage

                    if button and button:IsA("TextButton") then
                        GuiService.SelectedObject = button
                        
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    else
                        warn("O botão não foi encontrado ou não é um TextButton.")
                    end     
                else
                    print("Fudeu")
                end 
            end
        wait()
    end
end


local mapas = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MapSelector.Content.ScrollingFrame
local ValuesMapas

for i,v in pairs(mapas:GetChildren())do
    if v.Name ~= "UIGridLayout" then
        table.insert(ValuesMapas, v.MapImage.Frame.TextLabel.Text)
    end
end

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("SLA PORRA")

LeftGroupBox:AddDropdown('dropdownSelectMap', {
    Values = ValuesMapas,
    Default = "None",
    Multi = false,

    Text = 'Select Map',

    Callback = function(Value)
        selectedMapFarm = Value
    end
})

LeftGroupBox:AddToggle("AJS", {
	Text = "Auto Join",
	Default = false,
	Callback = function(Value)
		getgenv().autoJoin = Value
		autoJoin()
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

    Library:SetWatermark(('Tempest Hub | %s fps | %s ms | %s'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()),
        FormatTime(activeTime)
    ))
end

WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(UpdateWatermark)

local TabsUI = {
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local function Unload()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end

local MenuGroup = TabsUI['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddToggle('huwe', {
    Text = 'Hide UI When Execute',
    Default = false,
    Callback = function(Value)
        getgenv().hideUIExec = Value
		hideUIExec()
    end
})

MenuGroup:AddToggle('aeuat', {
    Text = 'Auto Execute',
    Default = false,
    Callback = function(Value)
        getgenv().aeuat = Value
		aeuat()
    end
})


MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('Tempest Hub')
SaveManager:SetFolder('Tempest Hub/_ALS_')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_ALS_'
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

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
warn('[TEMPEST HUB] Loaded')