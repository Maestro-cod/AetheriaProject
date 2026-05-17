-- AETHERIA Furniture Shop Client
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local ItemDatabase = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ItemDatabase"))

-- Wait for remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local BuyFurniture = Remotes:WaitForChild("BuyFurniture")
local PlaceFurniture = Remotes:WaitForChild("PlaceFurniture")

local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- FURNITURE SHOP UI
-- ==========================================
local shopGui = Instance.new("ScreenGui")
shopGui.Name = "FurnitureShop"
shopGui.ResetOnSpawn = false
shopGui.Parent = playerGui

-- Shop button (bottom right)
local shopBtn = Instance.new("TextButton")
shopBtn.Name = "ShopButton"
shopBtn.Size = UDim2.new(0, 50, 0, 50)
shopBtn.Position = UDim2.new(1, -65, 1, -75)
shopBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
shopBtn.Text = "S"
shopBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
shopBtn.TextSize = 24
shopBtn.Font = Enum.Font.GothamBold
shopBtn.BorderSizePixel = 0
shopBtn.Parent = shopGui

Instance.new("UICorner", shopBtn).CornerRadius = UDim.new(0.5, 0)
local shopBtnStroke = Instance.new("UIStroke", shopBtn)
shopBtnStroke.Color = Color3.fromRGB(255, 215, 0)
shopBtnStroke.Thickness = 2

-- Shop panel
local shopOpen = false
local shopPanel = Instance.new("Frame")
shopPanel.Name = "ShopPanel"
shopPanel.Size = UDim2.new(0, 340, 0, 420)
shopPanel.Position = UDim2.new(1, -355, 0.5, -210)
shopPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
shopPanel.BackgroundTransparency = 0.05
shopPanel.BorderSizePixel = 0
shopPanel.Visible = false
shopPanel.Parent = shopGui

Instance.new("UICorner", shopPanel).CornerRadius = UDim.new(0, 16)
local panelStroke = Instance.new("UIStroke", shopPanel)
panelStroke.Color = Color3.fromRGB(255, 215, 0)
panelStroke.Thickness = 2

-- Header
local shopHeader = Instance.new("TextLabel")
shopHeader.Size = UDim2.new(1, 0, 0, 40)
shopHeader.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
shopHeader.BackgroundTransparency = 0.85
shopHeader.Text = "  FURNITURE SHOP"
shopHeader.TextColor3 = Color3.fromRGB(255, 215, 0)
shopHeader.TextSize = 18
shopHeader.Font = Enum.Font.GothamBold
shopHeader.TextXAlignment = Enum.TextXAlignment.Left
shopHeader.BorderSizePixel = 0
shopHeader.Parent = shopPanel
Instance.new("UICorner", shopHeader).CornerRadius = UDim.new(0, 16)

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = shopPanel

-- Scrolling item list
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
scrollFrame.BorderSizePixel = 0
scrollFrame.Parent = shopPanel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame

-- Placement mode state
local placingItem = nil
local ghostPart = nil

-- Populate items
for _, item in ItemDatabase.Furniture do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 55)
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    row.BorderSizePixel = 0
    row.Parent = scrollFrame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    -- Color preview
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 40, 0, 40)
    preview.Position = UDim2.new(0, 8, 0.5, -20)
    preview.BackgroundColor3 = item.color
    preview.BorderSizePixel = 0
    preview.Parent = row
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)

    -- Item name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 140, 0, 20)
    nameLabel.Position = UDim2.new(0, 55, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = item.name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row

    -- Category
    local catLabel = Instance.new("TextLabel")
    catLabel.Size = UDim2.new(0, 140, 0, 15)
    catLabel.Position = UDim2.new(0, 55, 0, 27)
    catLabel.BackgroundTransparency = 1
    catLabel.Text = item.category
    catLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
    catLabel.TextSize = 11
    catLabel.Font = Enum.Font.Gotham
    catLabel.TextXAlignment = Enum.TextXAlignment.Left
    catLabel.Parent = row

    -- Buy button
    local buyBtn = Instance.new("TextButton")
    buyBtn.Size = UDim2.new(0, 80, 0, 32)
    buyBtn.Position = UDim2.new(1, -90, 0.5, -16)
    buyBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    buyBtn.BackgroundTransparency = 0.1
    buyBtn.Text = item.price .. " C"
    buyBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
    buyBtn.TextSize = 13
    buyBtn.Font = Enum.Font.GothamBold
    buyBtn.BorderSizePixel = 0
    buyBtn.Parent = row
    Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 8)

    buyBtn.MouseButton1Click:Connect(function()
        BuyFurniture:FireServer(item.id)
        buyBtn.Text = "Bought!"
        buyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(1)
        buyBtn.Text = item.price .. " C"
        buyBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end)
end

-- Auto-size the scroll
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- Toggle shop
local function toggleShop()
    shopOpen = not shopOpen
    shopPanel.Visible = shopOpen
end

shopBtn.MouseButton1Click:Connect(toggleShop)
closeBtn.MouseButton1Click:Connect(toggleShop)

print("[SHOP UI] Furniture shop loaded")