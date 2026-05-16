---!strict
-- ShopService: Manages the ownership and rental of luxury plots in AETHERIA.

local ShopService = {}

-- COST OF LUXURY
local SETTINGS = {
 RENTAL_PRICE = 1000, -- How many credits it costs to rent a plot
 SovereignTax = 0.05, -- 5% tax for the city (you)
}

-- THIS FUNCTION HANDLES THE PURCHASE
function ShopService.AttemptRent(player: Player, plot: BasePart)
 local ServerStorage = game:GetService("ServerStorage")
 
 -- We call the EconomyService we built earlier to check the money
 local Economy = require(ServerStorage.Services.EconomyService)
 local balance = Economy.GetBalance(player)
 
 if balance >= SETTINGS.RENTAL_PRICE then
  print("💰 [SHOP] " .. player.Name .. " has just invested in city real estate!")
  
  -- 1. Change the plot color to "Owned" (Pure White)
  plot.BrickColor = BrickColor.new("Institutional white")
  plot.Material = Enum.Material.Neon
  
  -- 2. Create the "Owner Sign" (Billboard)
  local billboard = Instance.new("BillboardGui", plot)
  billboard.Size = UDim2.new(0, 200, 0, 50)
  billboard.StudsOffset = Vector3.new(0, 5, 0)
  billboard.AlwaysOnTop = true
  
  local label = Instance.new("TextLabel", billboard)
  label.Size = UDim2.new(1, 0, 1, 0)
  label.Text = "👑 OWNED BY: " .. player.Name
  label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  label.TextColor3 = Color3.fromRGB(255, 255, 0) -- Gold Text
  label.TextScaled = true
  label.Font = Enum.Font.GothamBold
  
  return true
 else
  warn("❌ [SHOP] Resident " .. player.Name .. " does not have enough credits for this luxury.")
  return false
 end
end

return ShopService

