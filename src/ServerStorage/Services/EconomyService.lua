local EconomyService = {}

local ServerStorage = game:GetService("ServerStorage")

local DataService -- loaded in Init to avoid circular require

function EconomyService.Init()
    DataService = require(ServerStorage.Services.DataService)
    print("[ECONOMY] EconomyService ready")
end

function EconomyService.GetBalance(player: Player): number
    local data = DataService.GetData(player)
    if data then
        return data.Credits
    end
    return 0
end

function EconomyService.Spend(player: Player, amount: number): boolean
    local data = DataService.GetData(player)
    if data and data.Credits >= amount then
        data.Credits -= amount
        print("[ECONOMY] " .. player.Name .. " spent " .. amount .. " | Balance: " .. data.Credits)
        return true
    end
    warn("[ECONOMY] " .. player.Name .. " cannot afford " .. amount)
    return false
end

function EconomyService.AddFunds(player: Player, amount: number)
    local data = DataService.GetData(player)
    if data then
        data.Credits += amount
        print("[ECONOMY] " .. player.Name .. " earned " .. amount .. " | Balance: " .. data.Credits)
    end
end

-- Update the leaderboard display
function EconomyService.UpdateLeaderstat(player: Player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local credits = leaderstats:FindFirstChild("Credits")
        if credits then
            credits.Value = EconomyService.GetBalance(player
type src\ServerStorage\Services\EconomyService.lua | Select-Object -Last 5
Set-Content -Path "src\ServerScriptServices\GameBootstrap.lua" -Value @"
-- AETHERIA: Main Server Bootstrap
-- Loads all services in the correct order

print("==================================================")
print("  AETHERIA - Sovereign City Engine v2.0")
print("==================================================")

local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- Load services in dependency order
local Services = ServerStorage:WaitForChild("Services")
local DataService = require(Services:WaitForChild("DataService"))
local EconomyService = require(Services:WaitForChild("EconomyService"))
local ShopService = require(Services:WaitForChild("ShopService"))

-- Initialize services (order matters)
DataService.Init()
EconomyService.Init()
print("[BOOTSTRAP] All services initialized")

-- Handle new residents
Players.PlayerAdded:Connect(function(player)
    -- Wait for profile to load
    local profile = DataService.WaitForProfile(player, 15)
    if not profile then return end

    local data = DataService.GetData(player)
    print("[BOOTSTRAP] " .. player.Name .. " arrived | Credits: " .. data.Credits .. " | Age: " .. data.AgeStage)

    -- Create leaderboard
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local credits = Instance.new("IntValue")
    credits.Name = "Credits"
    credits.Value = data.Credits
    credits.Parent = leaderstats
end)

-- Update leaderboard every 10 seconds
task.spawn(function()
    while true do
        task.wait(10)
        for _, player in Players:GetPlayers() do
            EconomyService.UpdateLeaderstat(player)
        end
    end
end)

print("==================================================")
print("  AETHERIA is ONLINE - Land is money.")
print("==================================================")
