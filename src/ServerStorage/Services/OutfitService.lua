local OutfitService = {}

local Players = game:GetService("Players")

function OutfitService.Init()
    print("[OUTFIT] OutfitService ready")
end

function OutfitService.ApplyStarterOutfit(player)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Wait for appearance to fully load


    -- Apply shirt
    local shirt = character:FindFirstChildOfClass("Shirt")
    if not shirt then
        shirt = Instance.new("Shirt")
        shirt.Parent = character
    end
    shirt.ShirtTemplate = "rbxassetid://6536004768"

    -- Apply pants
    local pants = character:FindFirstChildOfClass("Pants")
    if not pants then
        pants = Instance.new("Pants")
        pants.Parent = character
    end
    pants.PantsTemplate = "rbxassetid://6536009595"

    -- Dark shoes via body colors
    local bodyColors = character:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        bodyColors.LeftFootColor3 = Color3.fromRGB(30, 30, 30)
        bodyColors.RightFootColor3 = Color3.fromRGB(30, 30, 30)
    end

    print("[OUTFIT] Applied look to " .. player.Name)
end

function OutfitService.SetupPlayer(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1)
        OutfitService.ApplyStarterOutfit(player)
    end)

    if player.Character then
        task.wait(1)
        OutfitService.ApplyStarterOutfit(player)
    end
end

return OutfitService