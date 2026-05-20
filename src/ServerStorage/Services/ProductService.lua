local ProductService = {}

local MarketplaceService = game:GetService("MarketplaceService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DataService
local EconomyService

-- GAME PASS IDS (you'll set these from Creator Dashboard)
local PASSES = {
    VIP = { id = 0, name = "Aetheria VIP", price = 799, perks = "2x wages + VIP room" },
    FastTravel = { id = 0, name = "Fast Travel", price = 149, perks = "Teleport pads" },
    HousingPack = { id = 0, name = "Housing Themes", price = 399, perks = "20 exclusive furniture" },
    EraSkins = { id = 0, name = "Era Skins Pack", price = 299, perks = "Y2K + Cyber + Cottage outfits" },
    Penthouse = { id = 0, name = "Penthouse Plot", price = 999, perks = "Premium land plot" },
}

-- DEVELOPER PRODUCT IDS (repeatable purchases)
local PRODUCTS = {
    Credits1000 = { id = 0, name = "1,000 Credits", price = 75, credits = 1000 },
    Credits5500 = { id = 0, name = "5,500 Credits", price = 350, credits = 5500 },
    Credits12000 = { id = 0, name = "12,000 Credits", price = 700, credits = 12000 },
    WageBoost = { id = 0, name = "2x Wages (24hr)", price = 99, credits = 0 },
}

function ProductService.Init()
    DataService = require(ServerStorage.Services.DataService)
    EconomyService = require(ServerStorage.Services.EconomyService)

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then
        remotes = Instance.new("Folder")
        remotes.Name = "Remotes"
        remotes.Parent = ReplicatedStorage
    end

    local getPassInfo = Instance.new("RemoteFunction")
    getPassInfo.Name = "GetPassInfo"
    getPassInfo.Parent = remotes

    local promptPurchase = Instance.new("RemoteEvent")
    promptPurchase.Name = "PromptPurchase"
    promptPurchase.Parent = remotes

    getPassInfo.OnServerInvoke = function(player)
        return ProductService.GetAllPasses()
    end

    promptPurchase.OnServerEvent:Connect(function(player, passKey)
        ProductService.PromptPurchase(player, passKey)
    end)

    -- Handle developer product receipts
    MarketplaceService.ProcessReceipt = function(receiptInfo)
        return ProductService.HandleReceipt(receiptInfo)
    end

    print("[PRODUCTS] ProductService ready")
end

function ProductService.GetAllPasses()
    local result = { passes = {}, products = {} }
    for key, pass in PASSES do
        table.insert(result.passes, {
            key = key,
            name = pass.name,
            price = pass.price,
            perks = pass.perks,
        })
    end
    for key, product in PRODUCTS do
        table.insert(result.products, {
            key = key,
            name = product.name,
            price = product.price,
            credits = product.credits,
        })
    end
    return result
end

function ProductService.PromptPurchase(player, passKey)
    local pass = PASSES[passKey]
    if pass and pass.id > 0 then
        MarketplaceService:PromptGamePassPurchase(player, pass.id)
        return
    end

    local product = PRODUCTS[passKey]
    if product and product.id > 0 then
        MarketplaceService:PromptProductPurchase(player, product.id)
        return
    end

    warn("[PRODUCTS] Pass/product not configured: " .. tostring(passKey))
end

function ProductService.HasPass(player, passKey)
    local pass = PASSES[passKey]
    if not pass or pass.id == 0 then return false end

    local success, hasPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, pass.id)
    end)

    return success and hasPass
end

function ProductService.HandleReceipt(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

    local data = DataService.GetData(player)
    if not data then return Enum.ProductPurchaseDecision.NotProcessedYet end

    -- Check if already granted
    local receiptId = tostring(receiptInfo.PurchaseId)
    if data.GrantedReceipts[receiptId] then
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    -- Find which product was purchased
    for key, product in PRODUCTS do
        if product.id == receiptInfo.ProductId then
            if product.credits > 0 then
                EconomyService.AddFunds(player, product.credits)
                EconomyService.UpdateLeaderstat(player)
                print("[PRODUCTS] " .. player.Name .. " bought " .. product.name)
            end

            data.GrantedReceipts[receiptId] = true
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end

return ProductService