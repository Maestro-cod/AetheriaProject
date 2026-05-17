local AgingService = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Constants)

local DataService

function AgingService.Init()
    DataService = require(ServerStorage.Services.DataService)
    print("[AGING] AgingService ready")
end

function AgingService.GetAgeStage(player)
    local data = DataService.GetData(player)
    if not data then return "Child" end

    local elapsed = os.time() - data.BirthTimestamp
    local total = 0

    for _, stage in Constants.AGE_STAGES do
        if stage.duration == -1 then
            return stage.name
        end
        total += stage.duration
        if elapsed < total then
            return stage.name
        end
    end

    return "Elder"
end

function AgingService.GetTimeUntilNextStage(player)
    local data = DataService.GetData(player)
    if not data then return 0 end

    local elapsed = os.time() - data.BirthTimestamp
    local total = 0

    for _, stage in Constants.AGE_STAGES do
        if stage.duration == -1 then return -1 end
        total += stage.duration
        if elapsed < total then
            return total - elapsed
        end
    end

    return -1
end

function AgingService.UpdatePlayer(player)
    local data = DataService.GetData(player)
    if not data then return end

    local newStage = AgingService.GetAgeStage(player)
    local oldStage = data.AgeStage

    if newStage ~= oldStage then
        data.AgeStage = newStage
        print("[AGING] " .. player.Name .. " aged: " .. oldStage .. " -> " .. newStage)
    end

    -- Apply avatar scaling
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local scales = Constants.AGE_SCALES[newStage]
    if scales then
        local desc = humanoid:GetAppliedDescription()
        desc.HeightScale = scales.Height
        desc.WidthScale = scales.Width
        desc.HeadScale = scales.Head
        humanoid:ApplyDescription(desc)
    end
end

-- Check all players every 5 minutes
function AgingService.StartAgeLoop()
    task.spawn(function()
        while true do
            task.wait(300)
            for _, player in game:GetService("Players"):GetPlayers() do
                AgingService.UpdatePlayer(player)
            end
        end
    end)
    print("[AGING] Age check loop started")
end

return AgingService
