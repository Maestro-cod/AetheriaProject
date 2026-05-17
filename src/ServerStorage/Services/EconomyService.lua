local EconomyService = {}

local ServerStorage = game:GetService("ServerStorage")
local DataService

function EconomyService.Init()
    DataService = require(ServerStorage.Services.DataService)
    print("[ECONOMY] EconomyService ready")
end

function EconomyService.GetBalance(player)
    local data = DataService.GetData(player)
    if data then
        return data.Credits
    end
    return 0
end

function EconomyService.Spend(player, amount)
    local data = DataService.GetData(player)
    if data and data.Credits >= amount then
        data.Credits -= amount
        print("[ECONOMY] " .. player.Name .. " spent " .. amount .. " | Balance: " .. data.Credits)
        return true
    end
    warn("[ECONOMY] " .. player.Name .. " cannot afford " .. amount)
    return false
end

function EconomyService.AddFunds(player, amount)
    local data = DataService.GetData(player)
    if data then
        data.Credits += amount
        print("[ECONOMY] " .. player.Name .. " earned " .. amount .. " | Balance: " .. data.Credits)
    end
end

function EconomyService.UpdateLeaderstat(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local credits = leaderstats:FindFirstChild("Credits")
        if credits then
            credits.Value = EconomyService.GetBalance(player)
        end
    end
end

return EconomyService
