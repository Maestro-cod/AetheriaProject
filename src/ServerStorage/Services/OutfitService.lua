local OutfitService = {}

local Players = game:GetService("Players")

-- Starter outfit: The Sovereign (Business look)
local STARTER_OUTFIT = {
    ShirtId = "rbxassetid://6536004768",
    PantsId = "rbxassetid://6536009595",
    HeadColor = Color3.fromRGB(234, 184, 146),
    TorsoColor = Color3.fromRGB(234, 184, 146),
}

function OutfitService.Init()
    print("[OUTFIT] OutfitService ready")
end

function OutfitService.ApplyStarterOutfit(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Apply shirt
    local existingShirt = character:FindFirstChildOfClass("Shirt")
    if not existingShirt then
        existingShirt = Instance.new("Shirt")
        existingShirt.Parent = character
    end
    existingShirt.ShirtTemplate = STARTER_OUTFIT.ShirtId

    -- Apply pants
    local existingPants = character:FindFirstChildOfClass("Pants")
    if not existingPants then
        existingPants = Instance.new("Pants")
        existingPants.Parent = character
    end
    existingPants.PantsTemplate = STARTER_OUTFIT.PantsId

    print("[OUTFIT] Applied Sovereign look to " .. player.Name)
end

-- Apply outfit every time character spawns
function OutfitService.SetupPlayer(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        OutfitService.ApplyStarterOutfit(player)
    end)

    if player.Character then
        OutfitService.ApplyStarterOutfit(player)
    end
end

return OutfitService
