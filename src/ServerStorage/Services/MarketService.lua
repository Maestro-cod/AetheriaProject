local MarketService = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DataService
local EconomyService
local ItemDatabase

-- Active listings stored in memory (resets per server)
local Listings = {}
local nextListingId = 1

function MarketService.Init()
    DataService = require(ServerStorage.Services.DataService)
    EconomyService = require(ServerStorage.Services.EconomyService)
    ItemDatabase = require(ReplicatedStorage.Shared.ItemDatabase)

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then
        remotes = Instance.new("Folder")
        remotes.Name = "Remotes"
        remotes.Parent = ReplicatedStorage
    end

    local listItem = Instance.new("RemoteEvent")
    listItem.Name = "ListItemForSale"
    listItem.Parent = remotes

    local buyListing = Instance.new("RemoteEvent")
    buyListing.Name = "BuyListing"
    buyListing.Parent = remotes

    local getListings = Instance.new("RemoteFunction")
    getListings.Name = "GetListings"
    getListings.Parent = remotes

    listItem.OnServerEvent:Connect(function(player, itemId, price)
        MarketService.CreateListing(player, itemId, price)
    end)

    buyListing.OnServerEvent:Connect(function(player, listingId)
        MarketService.PurchaseListing(player, listingId)
    end)

    getListings.OnServerInvoke = function(player)
        return MarketService.GetActiveListings()
    end

    print("[MARKET] MarketService ready")
end

function MarketService.CreateListing(seller, itemId, price)
    local data = DataService.GetData(seller)
    if not data then return false end

    -- Check seller owns the item
    if not data.Inventory[itemId] or data.Inventory[itemId] <= 0 then
        warn("[MARKET] " .. seller.Name .. " doesn't own " .. itemId)
        return false
    end

    -- Validate price
    price = math.clamp(math.floor(price), 10, 50000)

    -- Remove from inventory
    data.Inventory[itemId] -= 1
    if data.Inventory[itemId] <= 0 then
        data.Inventory[itemId] = nil
    end

    -- Create listing
    local listingId = "L" .. nextListingId
    nextListingId += 1

    Listings[listingId] = {
        id = listingId,
        sellerId = seller.UserId,
        sellerName = seller.Name,
        itemId = itemId,
        price = price,
        timestamp = os.time(),
    }

    local item = ItemDatabase.GetItem(itemId)
    local itemName = item and item.name or itemId
    print("[MARKET] " .. seller.Name .. " listed " .. itemName .. " for " .. price .. " Credits")
    return true
end

function MarketService.PurchaseListing(buyer, listingId)
    local listing = Listings[listingId]
    if not listing then
        warn("[MARKET] Listing not found: " .. tostring(listingId))
        return false
    end

    -- Can't buy your own listing
    if listing.sellerId == buyer.UserId then
        warn("[MARKET] Can't buy your own listing")
        return false
    end

    local buyerData = DataService.GetData(buyer)
    if not buyerData then return false end

    -- Check buyer can afford
    if not EconomyService.Spend(buyer, listing.price) then
        return false
    end

    -- Give item to buyer
    if not buyerData.Inventory[listing.itemId] then
        buyerData.Inventory[listing.itemId] = 0
    end
    buyerData.Inventory[listing.itemId] += 1

    -- Pay seller (with 5% tax)
    local tax = math.floor(listing.price * 0.05)
    local sellerPayout = listing.price - tax

    local seller = Players:GetPlayerByUserId(listing.sellerId)
    if seller then
        EconomyService.AddFunds(seller, sellerPayout)
        EconomyService.UpdateLeaderstat(seller)
    end

    EconomyService.UpdateLeaderstat(buyer)

    local item = ItemDatabase.GetItem(listing.itemId)
    local itemName = item and item.name or listing.itemId
    print("[MARKET] " .. buyer.Name .. " bought " .. itemName .. " from " .. listing.sellerName .. " for " .. listing.price .. " (tax: " .. tax .. ")")

    -- Remove listing
    Listings[listingId] = nil
    return true
end

function MarketService.GetActiveListings()
    local result = {}
    for id, listing in Listings do
        local item = ItemDatabase.GetItem(listing.itemId)
        table.insert(result, {
            id = listing.id,
            sellerName = listing.sellerName,
            itemId = listing.itemId,
            itemName = item and item.name or listing.itemId,
            price = listing.price,
            category = item and item.category or "Unknown",
            color = item and item.color or Color3.fromRGB(200, 200, 200),
        })
    end
    return result
end

return MarketService