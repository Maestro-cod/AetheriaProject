local FamilyService = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DataService

-- Pending proposals: { [targetUserId] = { fromPlayer, type } }
local PendingProposals = {}

function FamilyService.Init()
    DataService = require(ServerStorage.Services.DataService)

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then
        remotes = Instance.new("Folder")
        remotes.Name = "Remotes"
        remotes.Parent = ReplicatedStorage
    end

    local proposeEvent = Instance.new("RemoteEvent")
    proposeEvent.Name = "ProposeRelationship"
    proposeEvent.Parent = remotes

    local respondEvent = Instance.new("RemoteEvent")
    respondEvent.Name = "RespondProposal"
    respondEvent.Parent = remotes

    local getFamily = Instance.new("RemoteFunction")
    getFamily.Name = "GetFamilyData"
    getFamily.Parent = remotes

    proposeEvent.OnServerEvent:Connect(function(player, targetPlayer, relationType)
        FamilyService.Propose(player, targetPlayer, relationType)
    end)

    respondEvent.OnServerEvent:Connect(function(player, accept)
        FamilyService.RespondToProposal(player, accept)
    end)

    getFamily.OnServerInvoke = function(player)
        return FamilyService.GetFamilyInfo(player)
    end

    print("[FAMILY] FamilyService ready")
end

function FamilyService.Propose(fromPlayer, targetPlayer, relationType)
    if not targetPlayer or not targetPlayer:IsA("Player") then return end
    if fromPlayer == targetPlayer then return end

    local validTypes = {Marriage = true, Friend = true, Sibling = true}
    if not validTypes[relationType] then return end

    -- Check not already related
    local fromData = DataService.GetData(fromPlayer)
    if not fromData then return end

    local key = tostring(targetPlayer.UserId)
    if fromData.Relationships[key] then
        warn("[FAMILY] Already in a relationship with " .. targetPlayer.Name)
        return
    end

    PendingProposals[targetPlayer.UserId] = {
        fromPlayer = fromPlayer,
        relationType = relationType,
    }

    -- Notify target player
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local notify = remotes:FindFirstChild("NotifyProposal")
        if not notify then
            notify = Instance.new("RemoteEvent")
            notify.Name = "NotifyProposal"
            notify.Parent = remotes
        end
        notify:FireClient(targetPlayer, fromPlayer.Name, relationType)
    end

    print("[FAMILY] " .. fromPlayer.Name .. " proposed " .. relationType .. " to " .. targetPlayer.Name)
end

function FamilyService.RespondToProposal(targetPlayer, accept)
    local proposal = PendingProposals[targetPlayer.UserId]
    if not proposal then return end

    local fromPlayer = proposal.fromPlayer
    local relationType = proposal.relationType
    PendingProposals[targetPlayer.UserId] = nil

    if not accept then
        print("[FAMILY] " .. targetPlayer.Name .. " declined " .. fromPlayer.Name .. "'s proposal")
        return
    end

    if not fromPlayer.Parent then return end

    local fromData = DataService.GetData(fromPlayer)
    local targetData = DataService.GetData(targetPlayer)
    if not fromData or not targetData then return end

    local timestamp = os.time()

    fromData.Relationships[tostring(targetPlayer.UserId)] = {
        relationType = relationType,
        otherUserId = targetPlayer.UserId,
        timestamp = timestamp,
    }

    targetData.Relationships[tostring(fromPlayer.UserId)] = {
        relationType = relationType,
        otherUserId = fromPlayer.UserId,
        timestamp = timestamp,
    }

    -- Add to family IDs
    fromData.FamilyIds[tostring(targetPlayer.UserId)] = relationType
    targetData.FamilyIds[tostring(fromPlayer.UserId)] = relationType

    print("[FAMILY] " .. fromPlayer.Name .. " and " .. targetPlayer.Name .. " are now " .. relationType)
end

function FamilyService.GetFamilyInfo(player)
    local data = DataService.GetData(player)
    if not data then return {} end

    local family = {}
    for userId, rel in data.Relationships do
        local targetPlayer = Players:GetPlayerByUserId(tonumber(userId))
        local name = targetPlayer and targetPlayer.Name or "Offline#" .. userId
        table.insert(family, {
            name = name,
            relationType = rel.relationType,
            userId = rel.otherUserId,
        })
    end
    return family
end

-- Setup proximity interaction between players
function FamilyService.SetupPlayerInteraction()
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRoot then return end

            local prompt = Instance.new("ProximityPrompt")
            prompt.ObjectText = player.Name
            prompt.ActionText = "Interact"
            prompt.HoldDuration = 0.5
            prompt.MaxActivationDistance = 10
            prompt.RequiresLineOfSight = false
            prompt.Parent = humanoidRoot

            prompt.Triggered:Connect(function(triggerPlayer)
                if triggerPlayer == player then return end
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes then
                    local showMenu = remotes:FindFirstChild("ShowInteractMenu")
                    if not showMenu then
                        showMenu = Instance.new("RemoteEvent")
                        showMenu.Name = "ShowInteractMenu"
                        showMenu.Parent = remotes
                    end
                    showMenu:FireClient(triggerPlayer, player.Name, player)
                end
            end)
        end)
    end)
end

return FamilyService