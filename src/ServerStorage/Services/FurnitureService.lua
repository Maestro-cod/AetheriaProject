local FurnitureService = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemDatabase = require(ReplicatedStorage.Shared.ItemDatabase)

local DataService
local EconomyService

function FurnitureService.Init()
    DataService = require(ServerStorage.Services.DataService)
    EconomyService = require(ServerStorage.Services.EconomyService)

    -- Create remote events for client communication
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then
        remotes = Instance.new("Folder")
        remotes.Name = "Remotes"
        remotes.Parent = ReplicatedStorage
    end

    local buyFurniture = Instance.new("RemoteEvent")
    buyFurniture.Name = "BuyFurniture"
    buyFurniture.Parent = remotes

    local placeFurniture = Instance.new("RemoteEvent")
    placeFurniture.Name = "PlaceFurniture"
    placeFurniture.Parent = remotes

    buyFurniture.OnServerEvent:Connect(function(player, itemId)
        FurnitureService.BuyItem(player, itemId)
    end)

    placeFurniture.OnServerEvent:Connect(function(player, itemId, position, rotation)
        FurnitureService.PlaceItem(player, itemId, position, rotation)
    end)

    print("[FURNITURE] FurnitureService ready")
end

function FurnitureService.BuyItem(player, itemId)
    local item = ItemDatabase.GetItem(itemId)
    if not item then
        warn("[FURNITURE] Unknown item: " .. tostring(itemId))
        return false
    end

    local data = DataService.GetData(player)
    if not data then return false end

    if not EconomyService.Spend(player, item.price) then
        return false
    end

    -- Add to inventory
    if not data.Inventory[itemId] then
        data.Inventory[itemId] = 0
    end
    data.Inventory[itemId] += 1

    EconomyService.UpdateLeaderstat(player)
    print("[FURNITURE] " .. player.Name .. " bought " .. item.name)
    return true
end

function FurnitureService.PlaceItem(player, itemId, position, rotation)
    local item = ItemDatabase.GetItem(itemId)
    if not item then return false end

    local data = DataService.GetData(player)
    if not data then return false end

    -- Check player owns the item
    if not data.Inventory[itemId] or data.Inventory[itemId] <= 0 then
        warn("[FURNITURE] " .. player.Name .. " doesn't own " .. itemId)
        return false
    end

    -- Check player owns a plot near this position
    local ownsNearbyPlot = false
    for plotId, plotData in data.OwnedPlots do
        ownsNearbyPlot = true
        break
    end
    for shopId, shopData in data.RentedShops do
        ownsNearbyPlot = true
        break
    end

    if not ownsNearbyPlot then
        warn("[FURNITURE] " .. player.Name .. " has no property to place items on")
        return false
    end

    -- Remove from inventory
    data.Inventory[itemId] -= 1
    if data.Inventory[itemId] <= 0 then
        data.Inventory[itemId] = nil
    end

    -- Create the furniture in the world
    local part = Instance.new("Part")
    part.Name = "Placed_" .. itemId
    part.Size = item.size
    part.Position = position
    part.Anchored = true
    part.Material = Enum.Material[item.material] or Enum.Material.SmoothPlastic
    part.Color = item.color
    part.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(rotation or 0), 0)

    if item.transparency then
        part.Transparency = item.transparency
    end

    -- Add light if applicable
    if item.light then
        local pointLight = Instance.new("PointLight")
        pointLight.Range = item.light.range
        pointLight.Brightness = item.light.brightness
        pointLight.Color = item.color
        pointLight.Parent = part
    end

    part:SetAttribute("Owner", player.UserId)
    part:SetAttribute("ItemId", itemId)
    part.Parent = workspace

    print("[FURNITURE] " .. player.Name .. " placed " .. item.name)
    return true
end

return FurnitureService