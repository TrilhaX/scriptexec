local player = game.Players.LocalPlayer
function EquipTool(Name)
local Tool = player.Backpack:FindFirstChild(Name)
if Tool then
player.Character.Humanoid:EquipTool(Tool)
end
end

EquipTool('Magu-Magu')

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

local npcs = workspace:FindFirstChild("NPCs")

if npcs then
    for _, child in ipairs(npcs:GetChildren()) do
        local targetCFrame = GetCFrame(child, 10)
        local tween = tweenModel(game.Players.LocalPlayer.Character, targetCFrame)
        tween.Completed:Wait()
        local args = {
            [1] = "Magma Hound"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Skill"):InvokeServer(unpack(args))
        function getNil(name,class) for _,v in next, getnilinstances()do if v.ClassName==class and v.Name==name then return v;end end end

        local args = {
            [1] = CFrame.new(targetCFrame.Position)
        }

        getNil(player .. "|ServerScriptService.Skills.Skills.SkillContainer.Magu-Magu.Magma Hound", "RemoteFunction"):InvokeServer(unpack(args))
        
    end
else
    print("Pasta NPCs não encontrada em workspace.")
end