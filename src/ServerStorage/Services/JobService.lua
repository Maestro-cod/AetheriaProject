local JobService = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Constants)

local DataService
local EconomyService

-- Track who is working: { [Player] = { jobName, startTime, station } }
local ActiveShifts = {}

function JobService.Init()
    DataService = require(ServerStorage.Services.DataService)
    EconomyService = require(ServerStorage.Services.EconomyService)
    print("[JOBS] JobService ready")
end

function JobService.StartShift(player, jobName, station)
    if ActiveShifts[player] then
        warn("[JOBS] " .. player.Name .. " is already working")
        return false
    end

    local jobInfo = Constants.JOBS[jobName]
    if not jobInfo then
        warn("[JOBS] Unknown job: " .. jobName)
        return false
    end

    ActiveShifts[player] = {
        jobName = jobName,
        startTime = os.clock(),
        station = station,
    }

    print("[JOBS] " .. player.Name .. " started " .. jobName .. " shift")

    -- Run the shift timer
    task.spawn(function()
        local elapsed = 0
        while elapsed < jobInfo.shiftDuration do
            task.wait(1)
            elapsed += 1

            -- Check if player left
            if not ActiveShifts[player] then return end
        end

        -- Shift complete - pay the worker
        if ActiveShifts[player] then
            EconomyService.AddFunds(player, jobInfo.wage)
            EconomyService.UpdateLeaderstat(player)
            print("[JOBS] " .. player.Name .. " completed " .. jobName .. " | Earned: " .. jobInfo.wage)
            ActiveShifts[player] = nil
        end
    end)

    return true
end

function JobService.QuitShift(player)
    if ActiveShifts[player] then
        print("[JOBS] " .. player.Name .. " quit their shift early")
        ActiveShifts[player] = nil
    end
end

function JobService.IsWorking(player)
    return ActiveShifts[player] ~= nil
end

function JobService.GetShiftInfo(player)
    return ActiveShifts[player]
end

-- Create job stations in the mall
function JobService.SetupJobStations()
    local workspace = game:GetService("Workspace")
    local mall = workspace:FindFirstChild("Mall")
    if not mall then return end

    local stations = {
        {name = "Cashier_Station", job = "Cashier", pos = Vector3.new(0, 1, 45), color = Color3.fromRGB(0, 200, 0)},
        {name = "Security_Station", job = "Security", pos = Vector3.new(0, 1, -45), color = Color3.fromRGB(200, 0, 0)},
        {name = "DJ_Station", job = "DJ", pos = Vector3.new(0, 1, 0), color = Color3.fromRGB(200, 0, 200)},
    }

    for _, s in stations do
        local station = Instance.new("Part")
        station.Name = s.name
        station.Size = Vector3.new(6, 4, 6)
        station.Position = s.pos
        station.Anchored = true
        station.Material = Enum.Material.SmoothPlastic
        station.Color = s.color
        station.Parent = mall

        -- Job sign
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 200, 0, 80)
        billboard.StudsOffset = Vector3.new(0, 5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = station

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = s.job .. " Station"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = billboard

        local wageLabel = Instance.new("TextLabel")
        wageLabel.Size = UDim2.new(1, 0, 0.5, 0)
        wageLabel.Position = UDim2.new(0, 0, 0.5, 0)
        wageLabel.BackgroundTransparency = 1
        wageLabel.Text = "Wage: " .. Constants.JOBS[s.job].wage .. " Credits"
        wageLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        wageLabel.TextScaled = true
        wageLabel.Font = Enum.Font.Gotham
        wageLabel.Parent = billboard

        -- Proximity prompt to start working
        local prompt = Instance.new("ProximityPrompt")
        prompt.ObjectText = s.job
        prompt.ActionText = "Start " .. s.job .. " Shift"
        prompt.HoldDuration = 1
        prompt.MaxActivationDistance = 12
        prompt.Parent = station

        prompt.Triggered:Connect(function(player)
            local success = JobService.StartShift(player, s.job, station)
            if success then
                prompt.ActionText = "Working..."
                prompt.Enabled = false

                -- Re-enable after shift ends
                task.spawn(function()
                    local jobInfo = Constants.JOBS[s.job]
                    task.wait(jobInfo.shiftDuration)
                    prompt.ActionText = "Start " .. s.job .. " Shift"
                    prompt.Enabled = true
                end)
            end
        end)
    end

    print("[JOBS] Job stations created")
end

-- Clean up when player leaves
function JobService.OnPlayerLeaving(player)
    ActiveShifts[player] = nil
end

return JobService
