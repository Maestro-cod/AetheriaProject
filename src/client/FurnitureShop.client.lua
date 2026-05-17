-- AETHERIA Furniture Shop + Placement
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local ItemDatabase = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ItemDatabase"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local BuyFurniture = Remotes:WaitForChild("BuyFurniture")
local PlaceFurniture = Remotes:WaitForChild("PlaceFurniture")

local playerGui = player:WaitForChild("PlayerGui")
local shopOpen = false
local placingItem = nil
local ghostPart = nil
local currentRotation = 0

local shopGui = Instance.new("ScreenGui")
shopGui.Name = "FurnitureShop"
shopGui.ResetOnSpawn = false
shopGui.Parent = playerGui

local shopBtn = Instance.new("TextButton")
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
Instance.new("UIStroke", shopBtn).Color = Color3.fromRGB(255, 215, 0)

local shopPanel = Instance.new("Frame")
shopPanel.Size = UDim2.new(0, 340, 0, 420)
shopPanel.Position = UDim2.new(1, -355, 0.5, -210)
shopPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
shopPanel.BackgroundTransparency = 0.05
shopPanel.BorderSizePixel = 0
shopPanel.Visible = false
shopPanel.Parent = shopGui
Instance.new("UICorner", shopPanel).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", shopPanel).Color = Color3.fromRGB(255, 215, 0)

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

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = shopPanel

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.BorderSizePixel = 0
scrollFrame.Parent = shopPanel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame

local hintLabel = Instance.new("TextLabel")
hintLabel.Size = UDim2.new(0, 400, 0, 40)
hintLabel.Position = UDim2.new(0.5, -200, 1, -130)
hintLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
hintLabel.BackgroundTransparency = 0.2
hintLabel.Text = ""
hintLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hintLabel.TextSize = 16
hintLabel.Font = Enum.Font.GothamBold
hintLabel.Visible = false
hintLabel.BorderSizePixel = 0
hintLabel.Parent = shopGui
Instance.new("UICorner", hintLabel).CornerRadius = UDim.new(0, 10)

for _, item in ItemDatabase.Furniture do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 55)
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    row.BorderSizePixel = 0
    row.Parent = scrollFrame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 35, 0, 35)
    preview.Position = UDim2.new(0, 6, 0.5, -17)
    preview.BackgroundColor3 = item.color
    preview.BorderSizePixel = 0
    preview.Parent = row
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 85, 0, 20)
    nameLabel.Position = UDim2.new(0, 48, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = item.name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row

    local catLabel = Instance.new("TextLabel")
    catLabel.Size = UDim2.new(0, 85, 0, 15)
    catLabel.Position = UDim2.new(0, 48, 0, 27)
    catLabel.BackgroundTransparency = 1
    catLabel.Text = item.category
    catLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
    catLabel.TextSize = 10
    catLabel.Font = Enum.Font.Gotham
    catLabel.TextXAlignment = Enum.TextXAlignment.Left
    catLabel.Parent = row

    local buyBtn = Instance.new("TextButton")
    buyBtn.Size = UDim2.new(0, 50, 0, 26)
    buyBtn.Position = UDim2.new(1, -115, 0.5, -13)
    buyBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    buyBtn.Text = item.price .. "C"
    buyBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
    buyBtn.TextSize = 11
    buyBtn.Font = Enum.Font.GothamBold
    buyBtn.BorderSizePixel = 0
    buyBtn.Parent = row
    Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 6)

    local placeBtn = Instance.new("TextButton")
    placeBtn.Size = UDim2.new(0, 50, 0, 26)
    placeBtn.Position = UDim2.new(1, -58, 0.5, -13)
    placeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    placeBtn.Text = "Place"
    placeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    placeBtn.TextSize = 11
    placeBtn.Font = Enum.Font.GothamBold
    placeBtn.BorderSizePixel = 0
    placeBtn.Parent = row
    Instance.new("UICorner", placeBtn).CornerRadius = UDim.new(0, 6)

    buyBtn.MouseButton1Click:Connect(function()
        BuyFurniture:FireServer(item.id)
        buyBtn.Text = "OK!"
        buyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(0.8)
        buyBtn.Text = item.price .. "C"
        buyBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end)

    placeBtn.MouseButton1Click:Connect(function()
        shopPanel.Visible = false
        shopOpen = false
        placingItem = item
        if ghostPart then ghostPart:Destroy() end
        ghostPart = Instance.new("Part")
        ghostPart.Name = "GhostPreview"
        ghostPart.Size = item.size
        ghostPart.Anchored = true
        ghostPart.CanCollide = false
        ghostPart.Material = Enum.Material.ForceField
        ghostPart.Color = item.color
        ghostPart.Transparency = 0.5
        ghostPart.Parent = workspace
        currentRotation = 0
        hintLabel.Text = "Click to place | R to rotate | Q to cancel"
        hintLabel.Visible = true
    end)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)

local function toggleShop()
    shopOpen = not shopOpen
    shopPanel.Visible = shopOpen
end

shopBtn.MouseButton1Click:Connect(toggleShop)
closeBtn.MouseButton1Click:Connect(toggleShop)

RunService.RenderStepped:Connect(function()
    if not placingItem or not ghostPart then return end
    local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
    local rayResult = workspace:Raycast(ray.Origin, ray.Direction * 500)
    if rayResult then
        local pos = rayResult.Position
        local sx = math.round(pos.X / 2) * 2
        local sz = math.round(pos.Z / 2) * 2
        local sy = pos.Y + (placingItem.size.Y / 2)
        ghostPart.CFrame = CFrame.new(sx, sy, sz) * CFrame.Angles(0, math.rad(currentRotation), 0)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if not placingItem then return end
    if input.KeyCode == Enum.KeyCode.R then
        currentRotation = currentRotation + 45
    end
    if input.KeyCode == Enum.KeyCode.Q then
        if ghostPart then ghostPart:Destroy() end
        ghostPart = nil
        placingItem = nil
        hintLabel.Visible = false
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if ghostPart then
            PlaceFurniture:FireServer(placingItem.id, ghostPart.Position, currentRotation)
            ghostPart:Destroy()
            ghostPart = nil
            placingItem = nil
            hintLabel.Visible = false
        end
    end
end)

print("[SHOP] Furniture shop + placement loaded")