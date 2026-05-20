-- AETHERIA Thrift Marketplace
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ListItemForSale = Remotes:WaitForChild("ListItemForSale")
local BuyListing = Remotes:WaitForChild("BuyListing")
local GetListings = Remotes:WaitForChild("GetListings")

local marketOpen = false

local gui = Instance.new("ScreenGui")
gui.Name = "MarketplaceUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Market button (bottom, left of S button)
local marketBtn = Instance.new("TextButton")
marketBtn.Size = UDim2.new(0, 50, 0, 50)
marketBtn.Position = UDim2.new(1, -125, 1, -75)
marketBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
marketBtn.Text = "T"
marketBtn.TextColor3 = Color3.fromRGB(255, 100, 50)
marketBtn.TextSize = 24
marketBtn.Font = Enum.Font.GothamBold
marketBtn.BorderSizePixel = 0
marketBtn.Parent = gui
Instance.new("UICorner", marketBtn).CornerRadius = UDim.new(0.5, 0)
local mStroke = Instance.new("UIStroke", marketBtn)
mStroke.Color = Color3.fromRGB(255, 100, 50)
mStroke.Thickness = 2

-- Market panel
local panel = Instance.new("Frame")
panel.Name = "MarketPanel"
panel.Size = UDim2.new(0, 380, 0, 440)
panel.Position = UDim2.new(0.5, -190, 0.5, -220)
panel.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)
local pStroke = Instance.new("UIStroke", panel)
pStroke.Color = Color3.fromRGB(255, 100, 50)
pStroke.Thickness = 2

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
header.BackgroundTransparency = 0.85
header.Text = "  THRIFT MARKET"
header.TextColor3 = Color3.fromRGB(255, 100, 50)
header.TextSize = 18
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.BorderSizePixel = 0
header.Parent = panel
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = panel

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 20)
subtitle.Position = UDim2.new(0, 10, 0, 42)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Buy and sell items with other residents"
subtitle.TextColor3 = Color3.fromRGB(120, 120, 130)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = panel

-- Listing scroll
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 65)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.BorderSizePixel = 0
scroll.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = scroll

-- Empty state
local emptyLabel = Instance.new("TextLabel")
emptyLabel.Name = "EmptyState"
emptyLabel.Size = UDim2.new(1, 0, 0, 60)
emptyLabel.BackgroundTransparency = 1
emptyLabel.Text = "No items for sale yet.\nBuy furniture and list it here!"
emptyLabel.TextColor3 = Color3.fromRGB(80, 80, 90)
emptyLabel.TextSize = 14
emptyLabel.Font = Enum.Font.Gotham
emptyLabel.Parent = scroll

-- Refresh button
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(1, -20, 0, 35)
refreshBtn.Position = UDim2.new(0, 10, 1, -45)
refreshBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
refreshBtn.BackgroundTransparency = 0.1
refreshBtn.Text = "Refresh Listings"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.TextSize = 14
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = panel
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)

local function clearListings()
    for _, child in scroll:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

local function loadListings()
    clearListings()
    local listings = GetListings:InvokeServer()

    if not listings or #listings == 0 then
        emptyLabel.Visible = true
        scroll.CanvasSize = UDim2.new(0, 0, 0, 60)
        return
    end

    emptyLabel.Visible = false

    for _, listing in listings do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 55)
        row.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        row.BorderSizePixel = 0
        row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

        local preview = Instance.new("Frame")
        preview.Size = UDim2.new(0, 35, 0, 35)
        preview.Position = UDim2.new(0, 6, 0.5, -17)
        preview.BackgroundColor3 = listing.color
        preview.BorderSizePixel = 0
        preview.Parent = row
        Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 120, 0, 20)
        nameLabel.Position = UDim2.new(0, 48, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = listing.itemName
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = row

        local sellerLabel = Instance.new("TextLabel")
        sellerLabel.Size = UDim2.new(0, 120, 0, 15)
        sellerLabel.Position = UDim2.new(0, 48, 0, 27)
        sellerLabel.BackgroundTransparency = 1
        sellerLabel.Text = "by " .. listing.sellerName
        sellerLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
        sellerLabel.TextSize = 10
        sellerLabel.Font = Enum.Font.Gotham
        sellerLabel.TextXAlignment = Enum.TextXAlignment.Left
        sellerLabel.Parent = row

        local buyBtn = Instance.new("TextButton")
        buyBtn.Size = UDim2.new(0, 70, 0, 28)
        buyBtn.Position = UDim2.new(1, -80, 0.5, -14)
        buyBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
        buyBtn.Text = listing.price .. " C"
        buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        buyBtn.TextSize = 12
        buyBtn.Font = Enum.Font.GothamBold
        buyBtn.BorderSizePixel = 0
        buyBtn.Parent = row
        Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 6)

        buyBtn.MouseButton1Click:Connect(function()
            BuyListing:FireServer(listing.id)
            buyBtn.Text = "Bought!"
            buyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            task.wait(1)
            loadListings()
        end)
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

local function toggleMarket()
    marketOpen = not marketOpen
    panel.Visible = marketOpen
    if marketOpen then
        loadListings()
    end
end

marketBtn.MouseButton1Click:Connect(toggleMarket)
closeBtn.MouseButton1Click:Connect(toggleMarket)

print("[MARKET UI] Thrift marketplace loaded")