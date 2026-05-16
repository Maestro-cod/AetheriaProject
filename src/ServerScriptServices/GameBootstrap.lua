--!strict
-- GameBootstrap: Main entry point for AETHERIA
print("--------------------------------------------------")
print("AETHERIA - Sovereign City Engine v1.0.0")
print("--------------------------------------------------")

local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- Load Services
local Services = ServerStorage:WaitForChild("Services")
local EconomyService = require(Services:WaitForChild("EconomyService"))
local ShopService = require(Services:WaitForChild("ShopService"))

print("[BOOTSTRAP] EconomyService loaded")
print("[BOOTSTRAP] ShopService loaded")

-- Handle new players joining
Players.PlayerAdded:Connect(function(player)
    print("[BOOTSTRAP] New resident arrived: " .. player.Name)

    -- Give starting balance
    local balance = EconomyService.GetBalance(player)
    print("[ECONOMY] " .. player.Name .. " balance: " .. tostring(balance))

    -- Create currency display
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local credits = Instance.new("IntValue")
    credits.Name = "Credits"
    credits.Value = balance
    credits.Parent = leaderstats
end)

print("--------------------------------------------------")
print("[BOOTSTRAP] AETHERIA is ONLINE")
print("--------------------------------------------------")
