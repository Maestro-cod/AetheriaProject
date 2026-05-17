-- AETHERIA: Main Server Bootstrap v2.0
print("==================================================")
print("  AETHERIA - Sovereign City Engine v2.0")
print("==================================================")

local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Services = ServerStorage:WaitForChild("Services")
local DataService = require(Services:WaitForChild("DataService"))
local EconomyService = require(Services:WaitForChild("EconomyService"))

DataService.Init()
EconomyService.Init()
print("[BOOTSTRAP] All services initialized")

Players.PlayerAdded:Connect(function(player)
    local profile = DataService.WaitForProfile(player, 15)
    if not profile then return end

    local data = DataService.GetData(player)
    print("[BOOTSTRAP] " .. player.Name .. " arrived | Credits: " .. data.Credits .. " | Age: " .. data.AgeStage)

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local credits = Instance.new("IntValue")
    credits.Name = "Credits"
    credits.Value = data.Credits
    credits.Parent = leaderstats
end)

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