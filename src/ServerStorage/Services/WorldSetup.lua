local WorldSetup = {}

function WorldSetup.Build()
    local workspace = game:GetService("Workspace")
    print("[WORLD] Building AETHERIA city...")

    -- Create Mall Building shell
    local mallFolder = Instance.new("Folder")
    mallFolder.Name = "Mall"
    mallFolder.Parent = workspace

    -- Mall walls
    local wallData = {
        {name="WallNorth", pos=Vector3.new(0,15,60), size=Vector3.new(120,30,2)},
        {name="WallSouth", pos=Vector3.new(0,15,-60), size=Vector3.new(120,30,2)},
        {name="WallEast", pos=Vector3.new(60,15,0), size=Vector3.new(2,30,120)},
        {name="WallWest", pos=Vector3.new(-60,15,0), size=Vector3.new(2,30,120)},
    }

    for _, w in wallData do
        local wall = Instance.new("Part")
        wall.Name = w.name
        wall.Size = w.size
        wall.Position = w.pos
        wall.Anchored = true
        wall.Material = Enum.Material.Concrete
        wall.Color = Color3.fromRGB(200, 200, 210)
        wall.Parent = mallFolder
    end

    -- Mall Floor (interior)
    local mallFloor = Instance.new("Part")
    mallFloor.Name = "MallInterior"
    mallFloor.Size = Vector3.new(118, 1, 118)
    mallFloor.Position = Vector3.new(0, 0.5, 0)
    mallFloor.Anchored = true
    mallFloor.Material = Enum.Material.Marble
    mallFloor.Color = Color3.fromRGB(240, 240, 245)
    mallFloor.Parent = mallFolder

    -- SHOP PLOTS (rentable)
    local shopPositions = {
        {name="Shop_A1", pos=Vector3.new(-40, 1, 40), price=1000},
        {name="Shop_A2", pos=Vector3.new(-40, 1, 20), price=1000},
        {name="Shop_A3", pos=Vector3.new(-40, 1, 0),  price=1500},
        {name="Shop_A4", pos=Vector3.new(-40, 1, -20), price=1000},
        {name="Shop_B1", pos=Vector3.new(40, 1, 40),  price=1000},
        {name="Shop_B2", pos=Vector3.new(40, 1, 20),  price=1000},
        {name="Shop_B3", pos=Vector3.new(40, 1, 0),   price=1500},
        {name="Shop_B4", pos=Vector3.new(40, 1, -20),  price=1000},
    }

    for _, s in shopPositions do
        local plot = Instance.new("Part")
        plot.Name = s.name
        plot.Size = Vector3.new(16, 0.5, 16)
        plot.Position = s.pos
        plot.Anchored = true
        plot.Material = Enum.Material.Neon
        plot.Color = Color3.fromRGB(0, 255, 255)
        plot:SetAttribute("IsPlot", true)
        plot:SetAttribute("PlotType", "shop")
        plot:SetAttribute("Price", s.price)
        plot.Parent = mallFolder
    end

    -- LAND PLOTS (outside mall, buyable permanently)
    local landFolder = Instance.new("Folder")
    landFolder.Name = "LandPlots"
    landFolder.Parent = workspace

    local landPositions = {
        {name="Land_01", pos=Vector3.new(-100, 1, 100), price=2500},
        {name="Land_02", pos=Vector3.new(-100, 1, 50),  price=2500},
        {name="Land_03", pos=Vector3.new(-100, 1, 0),   price=3000},
        {name="Land_04", pos=Vector3.new(-100, 1, -50),  price=2500},
        {name="Land_05", pos=Vector3.new(100, 1, 100),  price=2500},
        {name="Land_06", pos=Vector3.new(100, 1, 50),   price=2500},
        {name="Land_07", pos=Vector3.new(100, 1, 0),    price=3500},
        {name="Land_08", pos=Vector3.new(100, 1, -50),   price=2500},
    }

    for _, l in landPositions do
        local plot = Instance.new("Part")
        plot.Name = l.name
        plot.Size = Vector3.new(30, 0.5, 30)
        plot.Position = l.pos
        plot.Anchored = true
        plot.Material = Enum.Material.Neon
        plot.Color = Color3.fromRGB(255, 215, 0)
        plot:SetAttribute("IsPlot", true)
        plot:SetAttribute("PlotType", "land")
        plot:SetAttribute("Price", l.price)
        plot.Parent = landFolder
    end

    print("[WORLD] City built: 8 shops + 8 land plots")
end

return WorldSetup
