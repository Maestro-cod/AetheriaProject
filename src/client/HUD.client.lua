-- AETHERIA Client HUD
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait for character and data
player.CharacterAdded:Wait()
local leaderstats = player:WaitForChild("leaderstats")
local credits = leaderstats:WaitForChild("Credits")

-- Create the HUD
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AetheriaHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Credit display (top center)
local creditFrame = Instance.new("Frame")
creditFrame.Name = "CreditDisplay"
creditFrame.Size = UDim2.new(0, 220, 0, 50)
creditFrame.Position = UDim2.new(0.5, -110, 0, 10)
creditFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
creditFrame.BackgroundTransparency = 0.2
creditFrame.BorderSizePixel = 0
creditFrame.Parent = screenGui

local creditCorner = Instance.new("UICorner")
creditCorner.CornerRadius = UDim.new(0, 12)
creditCorner.Parent = creditFrame

local creditStroke = Instance.new("UIStroke")
creditStroke.Color = Color3.fromRGB(255, 215, 0)
creditStroke.Thickness = 1.5
creditStroke.Parent = creditFrame

local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "Amount"
creditLabel.Size = UDim2.new(1, 0, 1, 0)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = credits.Value .. " Credits"
creditLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
creditLabel.TextSize = 22
creditLabel.Font = Enum.Font.GothamBold
creditLabel.Parent = creditFrame

-- Update credits in real time
credits.Changed:Connect(function(newValue)
    creditLabel.Text = newValue .. " Credits"
end)

-- Age display (below credits)
local ageFrame = Instance.new("Frame")
ageFrame.Name = "AgeDisplay"
ageFrame.Size = UDim2.new(0, 160, 0, 30)
ageFrame.Position = UDim2.new(0.5, -80, 0, 65)
ageFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
ageFrame.BackgroundTransparency = 0.3
ageFrame.BorderSizePixel = 0
ageFrame.Parent = screenGui

local ageCorner = Instance.new("UICorner")
ageCorner.CornerRadius = UDim.new(0, 10)
ageCorner.Parent = ageFrame

local ageStroke = Instance.new("UIStroke")
ageStroke.Color = Color3.fromRGB(0, 255, 255)
ageStroke.Thickness = 1
ageStroke.Parent = ageFrame

local ageLabel = Instance.new("TextLabel")
ageLabel.Name = "Stage"
ageLabel.Size = UDim2.new(1, 0, 1, 0)
ageLabel.BackgroundTransparency = 1
ageLabel.Text = "Age: Child"
ageLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
ageLabel.TextSize = 16
ageLabel.Font = Enum.Font.GothamMedium
ageLabel.Parent = ageFrame

-- Property counter (top left)
local propFrame = Instance.new("Frame")
propFrame.Name = "PropertyDisplay"
propFrame.Size = UDim2.new(0, 200, 0, 80)
propFrame.Position = UDim2.new(0, 10, 0, 10)
propFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
propFrame.BackgroundTransparency = 0.2
propFrame.BorderSizePixel = 0
propFrame.Parent = screenGui

local propCorner = Instance.new("UICorner")
propCorner.CornerRadius = UDim.new(0, 12)
propCorner.Parent = propFrame

local propStroke = Instance.new("UIStroke")
propStroke.Color = Color3.fromRGB(150, 150, 160)
propStroke.Thickness = 1
propStroke.Parent = propFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "AETHERIA"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = propFrame

local landLabel = Instance.new("TextLabel")
landLabel.Name = "LandCount"
landLabel.Size = UDim2.new(1, -10, 0, 20)
landLabel.Position = UDim2.new(0, 10, 0, 30)
landLabel.BackgroundTransparency = 1
landLabel.Text = "Land Owned: 0"
landLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
landLabel.TextSize = 14
landLabel.Font = Enum.Font.Gotham
landLabel.TextXAlignment = Enum.TextXAlignment.Left
landLabel.Parent = propFrame

local shopLabel = Instance.new("TextLabel")
shopLabel.Name = "ShopCount"
shopLabel.Size = UDim2.new(1, -10, 0, 20)
shopLabel.Position = UDim2.new(0, 10, 0, 52)
shopLabel.BackgroundTransparency = 1
shopLabel.Text = "Shops Rented: 0"
shopLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
shopLabel.TextSize = 14
shopLabel.Font = Enum.Font.Gotham
shopLabel.TextXAlignment = Enum.TextXAlignment.Left
shopLabel.Parent = propFrame

print("[HUD] AETHERIA HUD loaded")
