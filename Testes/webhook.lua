local HttpService = game:GetService("HttpService")

function webhook()
    while getgenv().webhook == true do
        local discordWebhookUrl = urlwebhook
        local resultUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Results")

        local numberAndAfter = {}
        local statsString = {}
        local mapConfigString = {}
        
        if resultUI and resultUI.Enabled == true then
            local name = game:GetService("Players").LocalPlayer.Name
            local formattedName = "||" .. name .. "||"

            local player = game:GetService("Players").LocalPlayer
            local levelPlayer = player.PlayerGui.Main.Frame.BottomLeft.Menu:FindFirstChild("TextLabel")
            
            if levelPlayer then
                table.insert(numberAndAfter, levelPlayer.Text)
            end

            local grade = game:GetService("Players").LocalPlayer.ReplicatedData:FindFirstChild("grade")
            local cash = game:GetService("Players").LocalPlayer.ReplicatedData:FindFirstChild("cash")

            if grade and cash then
                table.insert(statsString, grade.Value .. "\n" .. "Cash: $" .. cash.Value)
            end

            local frame = game:GetService("Players").LocalPlayer.PlayerGui.Results.Frame:FindFirstChild("Stats")

            if frame then
                local deaths = frame:FindFirstChild("Deaths") and frame.Deaths.Value or 0
                local kills = frame:FindFirstChild("Kills") and frame.Kills.Value or 0
                local playerCount = frame:FindFirstChild("PlayerCount") and frame.PlayerCount.Value or 0
                local score = frame:FindFirstChild("Score") and frame.Score.Value or 0
                local timeSpent = frame:FindFirstChild("TimeSpent") and frame.TimeSpent.Value or 0

                local output = string.format(
                    "\nDeaths: %s\nKills: %s\nPlayerCount: %s\nScore: %s\nTimeSpent: %s",
                    tostring(deaths.Text), tostring(kills.Text), tostring(playerCount.Text), tostring(score.Text), tostring(timeSpent.Text)
                )
                table.insert(mapConfigString, output)
            end

            local payload = {
                content = pingContent,
                embeds = {
                    {
                        description = string.format(
                            "User: %s\nLevel: %s\n\nPlayer Stats:\n%s\n\nMatch Result%s", 
                            formattedName, 
                            table.concat(numberAndAfter, ", "),
                            table.concat(statsString, "\n"),
                            table.concat(mapConfigString, "\n")
                        ),
                        color = color,
                        fields = {
                            {
                                name = "Discord",
                                value = "https://discord.gg/ey83AwMvAn"
                            }
                        },
                        author = {
                            name = "Jujutsu Infinite"
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
