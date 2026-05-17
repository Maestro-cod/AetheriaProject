-- AETHERIA Client HUD + Phone Menu
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

player.CharacterAdded:Wait()
local leaderstats = player:WaitForChild("leaderstats")
local credits = leaderstats:WaitForChild("Credits")

-- ==========================================
-- MAIN HUD (always visible)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AetheriaHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Credit display
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

credits.Changed:Connect(function(newValue)
    creditLabel.Text = newValue .. " Credits"
end)

-- Age display
local ageFrame = Instance.new("Frame")
ageFrame.Size = UDim2.new(0, 160, 0, 30)
ageFrame.Position = UDim2.new(0.5, -80, 0, 65)
ageFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
ageFrame.BackgroundTransparency = 0.3
ageFrame.BorderSizePixel = 0
ageFrame.Parent = screenGui

Instance.new("UICorner", ageFrame).CornerRadius = UDim.new(0, 10)
local ageStroke = Instance.new("UIStroke", ageFrame)
ageStroke.Color = Color3.fromRGB(0, 255, 255)
ageStroke.Thickness = 1

local ageLabel = Instance.new("TextLabel")
ageLabel.Size = UDim2.new(1, 0, 1, 0)
ageLabel.BackgroundTransparency = 1
ageLabel.Text = "Age: Child"
ageLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
ageLabel.TextSize = 16
ageLabel.Font = Enum.Font.GothamMedium
ageLabel.Parent = ageFrame

-- ==========================================
-- PHONE BUTTON (bottom center)
-- ==========================================
local phoneBtn = Instance.new("TextButton")
phoneBtn.Name = "PhoneButton"
phoneBtn.Size = UDim2.new(0, 60, 0, 60)
phoneBtn.Position = UDim2.new(0.5, -30, 1, -75)
phoneBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
phoneBtn.Text = "M"
phoneBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
phoneBtn.TextSize = 28
phoneBtn.Font = Enum.Font.GothamBold
phoneBtn.BorderSizePixel = 0
phoneBtn.Parent = screenGui

Instance.new("UICorner", phoneBtn).CornerRadius = UDim.new(0.5, 0)
local phoneBtnStroke = Instance.new("UIStroke", phoneBtn)
phoneBtnStroke.Color = Color3.fromRGB(0, 255, 255)
phoneBtnStroke.Thickness = 2

-- ==========================================
-- PHONE MENU (toggle panel)
-- ==========================================
local phoneOpen = false

local phoneFrame = Instance.new("Frame")
phoneFrame.Name = "PhoneMenu"
phoneFrame.Size = UDim2.new(0, 320, 0, 420)
phoneFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
phoneFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
phoneFrame.BackgroundTransparency = 0.05
phoneFrame.BorderSizePixel = 0
phoneFrame.Visible = false
phoneFrame.Parent = screenGui

Instance.new("UICorner", phoneFrame).CornerRadius = UDim.new(0, 16)
local phoneStroke = Instance.new("UIStroke", phoneFrame)
phoneStroke.Color = Color3.fromRGB(0, 200, 255)
phoneStroke.Thickness = 2

-- Phone header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
header.BackgroundTransparency = 0.8
header.Text = "  AETHERIA"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextSize = 20
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.BorderSizePixel = 0
header.Parent = phoneFrame

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = phoneFrame

-- Content area
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -55)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.Parent = phoneFrame

-- Info rows
local function createRow(parent, yPos, label, value, color)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 35)
    row.Position = UDim2.new(0, 0, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(150, 150, 160)
    lbl.TextSize = 14
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local val = Instance.new("TextLabel")
    val.Name = "Value"
    val.Size = UDim2.new(0.5, -10, 1, 0)
    val.Position = UDim2.new(0.5, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = value
    val.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    val.TextSize = 14
    val.Font = Enum.Font.GothamBold
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.Parent = row

    return val
end

-- Section title
local function createSection(parent, yPos, title)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Position = UDim2.new(0, 0, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(0, 200, 255)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
end

-- Build phone content
createSection(content, 0, "PROFILE")
local creditsVal = createRow(content, 25, "Credits", tostring(credits.Value), Color3.fromRGB(255, 215, 0))
local ageVal = createRow(content, 65, "Life Stage", "Child", Color3.fromRGB(0, 255, 255))
createRow(content, 105, "Status", "Resident", Color3.fromRGB(100, 255, 100))

createSection(content, 155, "REAL ESTATE")
local landVal = createRow(content, 180, "Land Owned", "0", Color3.fromRGB(255, 215, 0))
local shopVal = createRow(content, 220, "Shops Rented", "0", Color3.fromRGB(0, 255, 255))
createRow(content, 260, "Total Value", "0 Credits", Color3.fromRGB(200, 200, 200))

createSection(content, 310, "EMPLOYMENT")
createRow(content, 335, "Current Job", "None", Color3.fromRGB(200, 200, 200))

-- Toggle phone
local function togglePhone()
    phoneOpen = not phoneOpen
    phoneFrame.Visible = phoneOpen

    if phoneOpen then
        creditsVal.Text = tostring(credits.Value)
    end
end

phoneBtn.MouseButton1Click:Connect(togglePhone)
closeBtn.MouseButton1Click:Connect(togglePhone)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.M then
        togglePhone()
    end
end)

-- Update HUD values
credits.Changed:Connect(function(newValue)
    creditLabel.Text = newValue .. " Credits"
    creditsVal.Text = tostring(newValue)
end)

print("[HUD] AETHERIA HUD + Phone loaded")