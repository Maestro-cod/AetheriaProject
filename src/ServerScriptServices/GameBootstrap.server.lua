-- AETHERIA: Main Server Bootstrap v2.0
print("==================================================")
print("  AETHERIA - Sovereign City Engine v2.0")
print("==================================================")

local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Services = ServerStorage:WaitForChild("Services")
local DataService = require(Services:WaitForChild("DataService"))
local EconomyService = require(Services:WaitForChild("EconomyService"))
local PlotService = require(Services:WaitForChild("PlotService"))
local WorldSetup = require(Services:WaitForChild("WorldSetup"))
local OutfitService = require(Services:WaitForChild("OutfitService"))
local WorldService = require(Services:WaitForChild("WorldService"))
local JobService = require(Services:WaitForChild("JobService"))
local AgingService = require(Services:WaitForChild("AgingService"))
local FurnitureService = require(Services:WaitForChild("FurnitureService"))

DataService.Init()
EconomyService.Init()
PlotService.Init()
OutfitService.Init()
WorldService.Init()
JobService.Init()
AgingService.Init()local FamilyService = require(Services:WaitForChild("FamilyService"))local MarketService = require(Services:WaitForChild("MarketService"))
FurnitureService.Init()FamilyService.Init()
FamilyService.SetupPlayerInteraction()MarketService.Init()
print("[BOOTSTRAP] All services initialized")


WorldSetup.Build()
PlotService.SetupPlots()
JobService.SetupJobStations()

WorldService.StartDayNightCycle()
AgingService.StartAgeLoop()

Players.PlayerAdded:Connect(function(player)
    local profile = DataService.WaitForProfile(player, 15)
    if not profile then return end

    local data = DataService.GetData(player)
    AgingService.UpdatePlayer(player)

    print("[BOOTSTRAP] " .. player.Name .. " | Credits: " .. data.Credits .. " | Age: " .. data.AgeStage)

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local credits = Instance.new("IntValue")
    credits.Name = "Credits"
    credits.Value = data.Credits
    credits.Parent = leaderstats

    OutfitService.SetupPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    JobService.OnPlayerLeaving(player)
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