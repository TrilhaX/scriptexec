local Games = {
    ["ALS"] = {12886143095, 18583778121, 12900046592},
}

local function LoadGame(GameId)
    local GameName = nil

    for name, ids in pairs(Games) do
        for _, id in ipairs(ids) do
            if id == GameId then
                GameName = name
                break
            end
        end
        if GameName then break end
    end

    if GameName then
        local success, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/scriptexec/main/Games/"..GameName..".lua"))()
        end)
        
        if not success then
            warn("Failed to load script for the game:", result)
        end
    else
        warn("Game not supported")
    end
end

LoadGame(game.PlaceId)
