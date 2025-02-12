local HttpService = game:GetService("HttpService")
local urlwebhook = ""

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local resultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Results")

        local numberAndAfter = {}
        local statsString = {}
        local mapConfigString = {}
        
            local ValuesRewards = {}
            local ValuesStatPlayer = {}        
            local name = game:GetService("Players").LocalPlayer.Name
            local formattedName = "||" .. name .. "||"

            local levelText = game:GetService("Players").LocalPlayer.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text
            local numberAndAfter = levelText:sub(7)

            local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
            local upvalues = debug.getupvalues(Loader.init)

            local Modules = {
                ["CORE_CLASS"] = upvalues[6],
                ["CORE_SERVICE"] = upvalues[7],
                ["SERVER_CLASS"] = upvalues[8],
                ["SERVER_SERVICE"] = upvalues[9],
                ["CLIENT_CLASS"] = upvalues[10],
                ["CLIENT_SERVICE"] = upvalues[11],
            }

            local gems = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data.gem_amount 
            local gold = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data.gold_amount 
            local holiday = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceHolidayStars").Value
            local candie = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceCandies").Value

            local ValuesRewards = {}
            local player = game:GetService("Players").LocalPlayer
            local scrollingFrame = player.PlayerGui.ResultsUI.Holder.LevelRewards.ScrollingFrame
            local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
            local upvalues = debug.getupvalues(Loader.init)
            local Modules = {
                ["CORE_CLASS"] = upvalues[6],
                ["CORE_SERVICE"] = upvalues[7],
                ["SERVER_CLASS"] = upvalues[8],
                ["SERVER_SERVICE"] = upvalues[9],
                ["CLIENT_CLASS"] = upvalues[10],
                ["CLIENT_SERVICE"] = upvalues[11],
            }
            local inventory = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.inventory.inventory_profile_data.normal_items

            for _, frame in pairs(scrollingFrame:GetChildren()) do
                if (frame.Name == "GemReward" or frame.Name == "GoldReward" or frame.Name == "TrophyReward" or frame.Name == "XPReward") and frame.Visible then
                    local amountLabel = frame:FindFirstChild("Main") and frame.Main:FindFirstChild("Amount")
                    if amountLabel then
                        local rewardType = frame.Name:gsub("Reward", "")
                        local gainedAmount = amountLabel.Text
                        local totalAmount = inventory[rewardType:lower()]
            
                        if totalAmount then
                            table.insert(ValuesRewards, gainedAmount .. "[" .. totalAmount .. "]\n")
                        else
                            table.insert(ValuesRewards, gainedAmount .. " " ..  frame.Name .. "\n")
                        end
                    end
                end
            end

            local rewardsString = table.concat(ValuesRewards, "\n")

            function formatNumber(num)
                if num >= 1000 then
                    local suffix = "k"
                    local formatted = num / 1000
                    if formatted % 1 == 0 then
                        return formatted .. suffix
                    else
                        return string.format("%.1fk", formatted)
                    end
                else
                    return tostring(num)
                end
            end
            
            local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
            local upvalues = debug.getupvalues(Loader.init)
            
            local Modules = {
                ["CORE_CLASS"] = upvalues[6],
                ["CORE_SERVICE"] = upvalues[7],
                ["SERVER_CLASS"] = upvalues[8],
                ["SERVER_SERVICE"] = upvalues[9],
                ["CLIENT_CLASS"] = upvalues[10],
                ["CLIENT_SERVICE"] = upvalues[11],
            }
            
            local clientService = Modules["CLIENT_SERVICE"]
            local ValuesUnitInfo = {}
            
            if clientService and clientService["StatsServiceClient"] then
                local statsServiceClient = clientService["StatsServiceClient"].module
                local collectionData = statsServiceClient.session.collection.collection_profile_data
            
                if collectionData and collectionData.owned_units then
                    local ownedUnits = collectionData.owned_units
                    local equippedUnits = collectionData.unit_ingame_levels
                    for _, unit in pairs(ownedUnits) do
                        if type(unit) == "table" then
                            local unitId = unit.unit_id
                            local totalKills = unit.total_kills
                            local worthness = unit.stat_luck
                            if worthness == nil then
                                worthness = 0
                                totalKills = 0
                            end
                            if equippedUnits[unitId] then
                                local formattedUnitInfo = unitId .. " = " .. formatNumber(totalKills) .. ":crossed_swords: [" .. formatNumber(worthness) .. "% W]\n"
                                table.insert(ValuesUnitInfo, formattedUnitInfo)
                            end
                        end
                    end
                else
                    warn("Nenhum dado encontrado em 'owned_units'.")
                end
            else
                warn("CLIENT_SERVICE ou StatsServiceClient não encontrado.")
            end            
            
            local unitInfo = table.concat(ValuesUnitInfo)                   
            
            local ResultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
            local act = ResultUI.Holder.LevelName.Text

            local ValuesMapConfig = {}
            
            local result = ResultUI.Holder.Title.Text
            local elapsedTimeText = ResultUI.Holder.Middle.Timer.Text
            local timeParts = string.split(elapsedTimeText, ":")
            local totalSeconds = 0
            
            if #timeParts == 3 then
                local hours = tonumber(timeParts[1]) or 0
                local minutes = tonumber(timeParts[2]) or 0
                local seconds = tonumber(timeParts[3]) or 0
                totalSeconds = (hours * 3600) + (minutes * 60) + seconds
            elseif #timeParts == 2 then
                local minutes = tonumber(timeParts[1]) or 0
                local seconds = tonumber(timeParts[2]) or 0
                totalSeconds = (minutes * 60) + seconds
            elseif #timeParts == 1 then
                totalSeconds = tonumber(timeParts[1]) or 0
            end
            
            local hours = math.floor(totalSeconds / 3600)
            local minutes = math.floor((totalSeconds % 3600) / 60)
            local seconds = totalSeconds % 60
            
            local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
            
            local levelDataRemote = workspace._MAP_CONFIG:WaitForChild("GetLevelData")
            local levelData = levelDataRemote:InvokeServer()
            
            if type(levelData) == "table" then
                local difficulty = levelData["_difficulty"]
                local locationName = levelData["_location_name"]
                local name = levelData["name"]
            

                if difficulty and name and locationName then
                    local FormattedFinal = formattedTime .. " - " .. result .. "\n" .. locationName .. " - " .. name .. " [" .. difficulty .. "] "
                    table.insert(ValuesMapConfig, FormattedFinal)
                end
            end            

            local mapConfigString = table.concat(ValuesMapConfig, "\n")

            local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("GameLevelInfo")
            local cardsEffect = {}
            
            if gui and gui.Enabled then
                local list = gui:FindFirstChild("List_rg")
                if list and list.Visible then
                    local buffs = list:FindFirstChild("Buffs")
                    if buffs then 
                        for _, v in pairs(buffs:GetChildren()) do
                            if v:IsA("TextLabel") then
                                table.insert(cardsEffect, v.Text)
                            end
                        end
                    end
                end
            end
            
            if #cardsEffect == 0 then
                cardsEffect = {"No card"}
            end
            
            local cards = table.concat(cardsEffect, "\n")
            
            local color = 7995647
            if result == "DEFEAT" then
                color = 16711680
            elseif result == "VICTORY" then
                color = 65280
            end

            local pingContent = ""
            if getgenv().pingUser and getgenv().pingUserId then
                pingContent = "<@" .. getgenv().pingUserId .. ">"
            elseif getgenv().pingUser then
                pingContent = "@"
            end

            local payload = {
                content = pingcontent,
                embeds = {
                    {
                        description = "User: " .. formattedName .. "\nLevel: " .. numberAndAfter .. " || [1111/1123] ||",
                        color = color,
                        fields = {
                            {
                                name = "Player Stats",
                                value = string.format("<:gemsAA:1322365177320177705> %s\n <:goldAA:1322369598015668315> %s\n<:holidayEventAA:1322369599517491241> %s\n<:candieAA:1322369601182629929> %s\n", gems, gold, holiday, candie),
                                inline = true
                            },
                            {
                                name = "Rewards",
                                value = string.format("%s",  rewardsString),
                                inline = true
                            },
                            {
                                name = "Units",
                                value = string.format("%s", unitInfo)
                            },
                            {
                                name = "Card Effects",
                                value = string.format("%s", cards)
                            },
                            {
                                name = "Match Result",
                                value = string.format("%s", mapConfigString)
                            }
                        },
                        author = {
                            name = "Anime Adventures"
                        },
                        footer = {
                            text = "https://discord.gg/MfvHUDp5XF - Tempest Hub"
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                        thumbnail = {
                            url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png"
                        }
                    }
                },
                attachments = {}
            }

            local payloadJson = HttpService:JSONEncode(payload)

            if syn and syn.request then
                local response = syn.request({
                    Url = discordWebhookUrl,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = payloadJson
                })

                if response.Success then
                    print("Webhook sent successfully")
                    break
                else
                    warn("Error sending message to Discord with syn.request:", response.StatusCode, response.Body)
                end
            elseif http_request then
                local response = http_request({
                    Url = discordWebhookUrl,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = payloadJson
                })

                if response.Success then
                    print("Webhook sent successfully")
                    break
                else
                    warn("Error sending message to Discord with http_request:", response.StatusCode, response.Body)
                end
            else
                print("Synchronization not supported on this device.")
            end
        end
        wait(1)
end

getgenv().webhook = true
webhook()