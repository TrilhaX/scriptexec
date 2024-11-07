local Games = {
    ["ALS"] = {12886143095, 18583778121},
}

local function LoadGame(GameId)
    local GameName
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TrilhaX/scriptexec/main/Games/"..GameName..".lua"))()
    else
        warn("Game not supported")
    end
end

LoadGame(game.GameId)