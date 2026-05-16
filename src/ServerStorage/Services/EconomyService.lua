local EconomyService = {}

local DataStoreService = game:GetService("DataStoreService")
local CurrencyStore = DataStoreService:GetDataStore("AetheriaCurrency")

local DEFAULT_BALANCE = 5000

function EconomyService.GetBalance(player: Player): number
    local success, balance = pcall(function()
        return CurrencyStore:GetAsync("balance_" .. player.UserId)
    end)
    if success and balance then
        return balance
    end
    return DEFAULT_BALANCE
end

function EconomyService.Spend(player: Player, amount: number): boolean
    local balance = EconomyService.GetBalance(player)
    if balance >= amount then
        local newBalance = balance - amount
        pcall(function()
            CurrencyStore:SetAsync("balance_" .. player.UserId, newBalance)
        end)
        return true
    end
    return false
end

function EconomyService.AddFunds(player: Player, amount: number)
    local balance = EconomyService.GetBalance(player)
    pcall(function()
        CurrencyStore:SetAsync("balance_" .. player.UserId, balance + amount)
    end)
end

return EconomyService
