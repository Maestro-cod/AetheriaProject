local DataService = {}

local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Load ProfileStore from Packages
local ProfileStore = require(ServerStorage.Packages.ProfileStore)

-- Load shared modules
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

-- Create the store
local PlayerStore = ProfileStore.New("AetheriaPlayerData", Types.DEFAULT_PROFILE)

-- Use mock store in Studio for safe testing
if RunService:IsStudio() then
    PlayerStore = PlayerStore.Mock
end

-- Active sessions: { [Player] = Profile }
local Profiles = {}

function DataService.Init()
    print("[DATA] DataService initializing...")

    Players.PlayerAdded:Connect(function(player)
        DataService._loadProfile(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        DataService._releaseProfile(player)
    end)

    -- Handle server shutdown
    game:BindToClose(function()
        for _, player in Players:GetPlayers() do
            DataService._releaseProfile(player)
        end
    end)

    print("[DATA] DataService ready")
end

function DataService._loadProfile(player: Player)
    local profile = PlayerStore:StartSessionAsync("Player_" .. player.UserId, {
        Cancel = function()
            return player.Parent ~= Players
        end,
    })

    if profile == nil then
        warn("[DATA] Failed to load profile for " .. player.Name)
        player:Kick("Unable to load your data. Please rejoin.")
        return
    end

    profile:AddUserId(player.UserId)

    profile.OnSessionEnd:Connect(function()
        Profiles[player] = nil
        if player.Parent == Players then
            player:Kick("Your data session ended. Please rejoin.")
        end
    end)

    if player.Parent ~= Players then
        profile:EndSession()
        return
    end

    -- Set birth timestamp for new players
    if profile.Data.BirthTimestamp == 0 then
        profile.Data.BirthTimestamp = os.time()
    end

    Profiles[player] = profile
    print("[DATA] Profile loaded for " .. player.Name)
end

function DataService._releaseProfile(player: Player)
    local profile = Profiles[player]
    if profile then
        profile:EndSession()
        Profiles[player] = nil
        print("[DATA] Profile released for " .. player.Name)
    end
end

-- Public API: Get a player's profile data
function DataService.GetProfile(player: Player)
    return Profiles[player]
end

-- Public API: Get profile data table directly
function DataService.GetData(player: Player)
    local profile = Profiles[player]
    if profile then
        return profile.Data
    end
    return nil
end

-- Public API: Check if profile is loaded
function DataService.IsLoaded(player: Player): boolean
    return Profiles[player] ~= nil
end

-- Public API: Wait for profile to load
function DataService.WaitForProfile(player: Player, timeout: number?)
    local maxWait = timeout or 10
    local elapsed = 0
    while not Profiles[player] and elapsed < maxWait do
        task.wait(0.1)
        elapsed += 0.1
    end
    return Profiles[player]
end

return DataService
