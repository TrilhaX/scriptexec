local HttpService = game:GetService("HttpService")

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = "https://discord.com/api/webhooks/1303406324452687935/ou5GoCcOkvH-iRy9hhPoGJnJBs1B8edcin3QNq6UcU--wIhyDltFGmt7j7g-wg9wfE0E"
        local resultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")

        if resultUI and resultUI.Enabled == true then
            local ValuesRewards = {}
            local ValuesStatPlayer = {}        
            local name = game:GetService("Players").LocalPlayer.Name
            local formattedName = "||" .. name .. "||"

            local levelText = game:GetService("Players").LocalPlayer.PlayerGui.spawn_units.Lives.Main.Desc.Level.Text
            local numberAndAfter = levelText:sub(7)

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
                            table.insert(ValuesRewards, gainedAmount .. "\n")
                        end
                    end
                end
            end

            -- Collect the formatted result rewards into a string
            local rewardsString = table.concat(ValuesRewards, "\n")

            local levelDataRemote = workspace._MAP_CONFIG:WaitForChild("GetLevelData")
            local ResultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
            local act = ResultUI.Holder.LevelName.Text
            local levelData = levelDataRemote:InvokeServer()

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
            
            if type(levelData) == "table" then
                if levelData.world and levelData._gamemode and levelData._difficulty then
                    local formattedValue = levelData.world .. " " .. act .." - " .. levelData._gamemode .. " [" .. levelData._difficulty .. "]"
            
                    local FormattedFinal = "\n" .. formattedTime .. " - " .. result .. "\n" .. formattedValue
            
                    table.insert(ValuesMapConfig, FormattedFinal)
                else
                    print("Faltando informações necessárias no levelData.")
                end
            else
                print("O dado recebido não é uma tabela.")
            end      

            local playerData = Modules["CLIENT_SERVICE"]["StatsServiceClient"].module.session.profile_data
            local gemsEmoji = "<:gemsAA:1322365177320177705>"
            local goldEmoji = "<:goldAA:1322369598015668315>"
            local traitReroll = "<:traitRerollAA:1322370533106384987>"

            local keysToPrint = {
                ["gem_amount"] = gemsEmoji,
                ["gold_amount"] = goldEmoji,
                ["trait_reroll_tokens"] = traitReroll,
                ["trophies"] = "🏆",
                ["christmas2024_meter_value"] = "🎁"
            }
            
            local battlepassData = playerData.battlepass_data
            local silverChristmasXp = battlepassData.silver_christmas.xp
            
            local ValuesBattlepassXp = {}
            
            local holidayStars = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceHolidayStars")
            local Candies = game:GetService("Players").LocalPlayer._stats:FindFirstChild("_resourceCandies")
            
            if holidayStars and Candies then
                table.insert(ValuesBattlepassXp, holidayStars.Value)
                table.insert(ValuesBattlepassXp, Candies.Value)
            end
            
            table.insert(ValuesBattlepassXp, silverChristmasXp)
            table.insert(ValuesBattlepassXp, battlepassData)
            
            local message = ""
            
            for _, key in ipairs({"gem_amount", "gold_amount", "trait_reroll_tokens", "trophies", "christmas2024_meter_value"}) do
                if playerData[key] then
                    message = message .. keysToPrint[key] .. " " .. playerData[key] .. "\n"
                end
            end
            
            if holidayStars then
                local holidayEmoji = "<:holidayEventAA:1322369599517491241>"
                message = message .. holidayEmoji .. tostring(holidayStars.Value) .. "\n"
            end            
            if Candies then
                local candieEmoji = "<:candieAA:1322369601182629929>"
                message = message .. candieEmoji .. Candies.Value .. "\n"
            end
            
            table.insert(ValuesStatPlayer, message)            
            local statsString = table.concat(ValuesStatPlayer, "\n")
            local mapConfigString = table.concat(ValuesMapConfig, "\n")
            
            local color = 7995647
            if result == "DEFEAT" then
                color = 16711680
            elseif result == "VICTORY" then
                color = 65280
            end

            local payload = {
                content = pingContent,
                embeds = {
                    {
                        description = string.format("User: %s\nLevel: %s\n\nPlayer Stats:\n%s\nRewards:\n%s\nMatch Result:%s", formattedName, numberAndAfter, statsString, rewardsString, mapConfigString),
                        color = color,
                        fields = {
                            {
                                name = "Discord",
                                value = "https://discord.gg/ey83AwMvAn"
                            }
                        },
                        author = {
                            name = "Anime Adventures"
                        },
                        thumbnail = {
                            url = "https://cdn.discordapp.com/attachments/1060717519624732762/1307102212022861864/get_attachment_url.png?ex=673e5b4c&is=673d09cc&hm=1d58485280f1d6a376e1bee009b21caa0ae5cad9624832dd3d921f1e3b2217ce&"
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
end

getgenv().webhook = true
webhook()