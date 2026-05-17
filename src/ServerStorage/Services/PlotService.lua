local PlotService = {}

local ServerStorage = game:GetService("ServerStorage")
local DataService
local EconomyService

function PlotService.Init()
    DataService = require(ServerStorage.Services.DataService)
    EconomyService = require(ServerStorage.Services.EconomyService)
    print("[PLOTS] PlotService ready")
end

-- Buy a land plot permanently
function PlotService.PurchasePlot(player, plotPart)
    local plotId = plotPart.Name
    local data = DataService.GetData(player)
    if not data then return false end

    -- Check if already owned by anyone
    if plotPart:GetAttribute("OwnerId") then
        warn("[PLOTS] " .. plotId .. " is already owned")
        return false
    end

    -- Check if player can afford it
    local price = plotPart:GetAttribute("Price") or 2500
    if not EconomyService.Spend(player, price) then
        return false
    end

    -- Record ownership
    data.OwnedPlots[plotId] = {
        plotId = plotId,
        purchaseTime = os.time(),
        furniture = {},
        plotValue = price,
    }

    -- Mark plot in world
    plotPart:SetAttribute("OwnerId", player.UserId)
    plotPart:SetAttribute("OwnerName", player.Name)

    -- Visual feedback
    plotPart.BrickColor = BrickColor.new("Institutional white")
    plotPart.Material = Enum.Material.Marble

    -- Owner billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "OwnerSign"
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = plotPart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "OWNED BY: " .. player.Name
    label.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    print("[PLOTS] " .. player.Name .. " purchased " .. plotId .. " for " .. price)
    return true
end

-- Rent a shop plot (temporary)
function PlotService.RentShop(player, plotPart)
    local plotId = plotPart.Name
    local data = DataService.GetData(player)
    if not data then return false end

    if plotPart:GetAttribute("OwnerId") then
        warn("[PLOTS] " .. plotId .. " is already rented")
        return false
    end

    local price = plotPart:GetAttribute("Price") or 1000
    if not EconomyService.Spend(player, price) then
        return false
    end

    local rentDuration = 7 * 24 * 3600
    data.RentedShops[plotId] = {
        shopId = plotId,
        rentStart = os.time(),
        rentExpiry = os.time() + rentDuration,
        shopName = player.Name .. "'s Shop",
        earnings = 0,
    }

    plotPart:SetAttribute("OwnerId", player.UserId)
    plotPart:SetAttribute("OwnerName", player.Name)
    plotPart.BrickColor = BrickColor.new("Institutional white")
    plotPart.Material = Enum.Material.Neon

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ShopSign"
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = plotPart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = player.Name .. "'s Shop"
    label.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    label.TextColor3 = Color3.fromRGB(0, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    print("[PLOTS] " .. player.Name .. " rented " .. plotId .. " for " .. price)
    return true
end

-- Get plot info
function PlotService.GetPlotInfo(plotPart)
    return {
        id = plotPart.Name,
        ownerId = plotPart:GetAttribute("OwnerId"),
        ownerName = plotPart:GetAttribute("OwnerName"),
        price = plotPart:GetAttribute("Price") or 2500,
        plotType = plotPart:GetAttribute("PlotType") or "land",
    }
end

-- Setup proximity prompts on all plots
function PlotService.SetupPlots()
    local workspace = game:GetService("Workspace")

    -- Find all plots in workspace
    for _, obj in workspace:GetDescendants() do
        if obj:IsA("BasePart") and obj:GetAttribute("IsPlot") then
            local plotType = obj:GetAttribute("PlotType") or "land"
            local price = obj:GetAttribute("Price") or 2500

            local prompt = Instance.new("ProximityPrompt")
            prompt.ObjectText = obj.Name
            prompt.HoldDuration = 1.5
            prompt.MaxActivationDistance = 15
            prompt.Parent = obj

            if plotType == "shop" then
                prompt.ActionText = "Rent Shop (" .. price .. " Credits)"
                prompt.Triggered:Connect(function(player)
                    local success = PlotService.RentShop(player, obj)
                    if success then
                        prompt:Destroy()
                    end
                end)
            else
                prompt.ActionText = "Buy Land (" .. price .. " Credits)"
                prompt.Triggered:Connect(function(player)
                    local success = PlotService.PurchasePlot(player, obj)
                    if success then
                        prompt:Destroy()
                    end
                end)
            end
        end
    end

    print("[PLOTS] All plots configured")
end

return PlotService
