local WorldSetup = {}

function WorldSetup.Build()
    local workspace = game:GetService("Workspace")
    print("[WORLD] Building AETHERIA city...")

    local ground = Instance.new("Part")
    ground.Name = "CityGround"
    ground.Size = Vector3.new(600, 1, 600)
    ground.Position = Vector3.new(0, -0.5, 0)
    ground.Anchored = true
    ground.Material = Enum.Material.Asphalt
    ground.Color = Color3.fromRGB(45, 45, 50)
    ground.Parent = workspace

    local plaza = Instance.new("Folder")
    plaza.Name = "CentralPlaza"
    plaza.Parent = workspace

    local plazaFloor = Instance.new("Part")
    plazaFloor.Name = "PlazaFloor"
    plazaFloor.Size = Vector3.new(80, 0.5, 80)
    plazaFloor.Position = Vector3.new(0, 0.25, 0)
    plazaFloor.Anchored = true
    plazaFloor.Material = Enum.Material.Marble
    plazaFloor.Color = Color3.fromRGB(230, 230, 235)
    plazaFloor.Parent = plaza

    local fountain = Instance.new("Part")
    fountain.Name = "Fountain"
    fountain.Shape = Enum.PartType.Cylinder
    fountain.Size = Vector3.new(4, 16, 16)
    fountain.CFrame = CFrame.new(0, 2, 0) * CFrame.Angles(0, 0, math.rad(90))
    fountain.Anchored = true
    fountain.Material = Enum.Material.Marble
    fountain.Color = Color3.fromRGB(200, 200, 210)
    fountain.Parent = plaza

    local mall = Instance.new("Folder")
    mall.Name = "Mall"
    mall.Parent = workspace

    local mallFloor = Instance.new("Part")
    mallFloor.Name = "MallFloor"
    mallFloor.Size = Vector3.new(120, 1, 120)
    mallFloor.Position = Vector3.new(100, 0.5, 0)
    mallFloor.Anchored = true
    mallFloor.Material = Enum.Material.Marble
    mallFloor.Color = Color3.fromRGB(240, 240, 245)
    mallFloor.Parent = mall

    local mallWalls = {
        {pos=Vector3.new(100, 15, 60), size=Vector3.new(120, 30, 2)},
        {pos=Vector3.new(100, 15, -60), size=Vector3.new(120, 30, 2)},
        {pos=Vector3.new(160, 15, 0), size=Vector3.new(2, 30, 120)},
        {pos=Vector3.new(42, 15, 30), size=Vector3.new(2, 30, 58)},
        {pos=Vector3.new(42, 15, -30), size=Vector3.new(2, 30, 58)},
    }
    for i, w in mallWalls do
        local wall = Instance.new("Part")
        wall.Name = "MallWall_" .. i
        wall.Size = w.size
        wall.Position = w.pos
        wall.Anchored = true
        wall.Material = Enum.Material.Glass
        wall.Color = Color3.fromRGB(180, 200, 220)
        wall.Transparency = 0.3
        wall.Parent = mall
    end

    local signPart = Instance.new("Part")
    signPart.Name = "MallSign"
    signPart.Size = Vector3.new(20, 5, 1)
    signPart.Position = Vector3.new(42, 28, 0)
    signPart.Anchored = true
    signPart.Material = Enum.Material.Neon
    signPart.Color = Color3.fromRGB(0, 200, 255)
    signPart.Parent = mall
    local signGui = Instance.new("SurfaceGui")
    signGui.Face = Enum.NormalId.Front
    signGui.Parent = signPart
    local signLabel = Instance.new("TextLabel")
    signLabel.Size = UDim2.new(1, 0, 1, 0)
    signLabel.BackgroundTransparency = 1
    signLabel.Text = "AETHERIA MALL"
    signLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    signLabel.TextScaled = true
    signLabel.Font = Enum.Font.GothamBold
    signLabel.Parent = signGui

    local shopPositions = {
        {name="Shop_A1", pos=Vector3.new(70, 1, 40), price=1000},
        {name="Shop_A2", pos=Vector3.new(70, 1, 15), price=1000},
        {name="Shop_A3", pos=Vector3.new(70, 1, -15), price=1500},
        {name="Shop_A4", pos=Vector3.new(70, 1, -40), price=1000},
        {name="Shop_B1", pos=Vector3.new(140, 1, 40), price=1000},
        {name="Shop_B2", pos=Vector3.new(140, 1, 15), price=1000},
        {name="Shop_B3", pos=Vector3.new(140, 1, -15), price=1500},
        {name="Shop_B4", pos=Vector3.new(140, 1, -40), price=1000},
    }
    for _, s in shopPositions do
        local plot = Instance.new("Part")
        plot.Name = s.name
        plot.Size = Vector3.new(18, 0.3, 18)
        plot.Position = s.pos
        plot.Anchored = true
        plot.Material = Enum.Material.Neon
        plot.Color = Color3.fromRGB(0, 255, 255)
        plot:SetAttribute("IsPlot", true)
        plot:SetAttribute("PlotType", "shop")
        plot:SetAttribute("Price", s.price)
        plot.Parent = mall
    end

    local residential = Instance.new("Folder")
    residential.Name = "ResidentialDistrict"
    residential.Parent = workspace

    local landPositions = {
        {name="Land_01", pos=Vector3.new(-100, 1, 80), price=2500},
        {name="Land_02", pos=Vector3.new(-100, 1, 40), price=2500},
        {name="Land_03", pos=Vector3.new(-100, 1, 0), price=3000},
        {name="Land_04", pos=Vector3.new(-100, 1, -40), price=2500},
        {name="Land_05", pos=Vector3.new(-100, 1, -80), price=2500},
        {name="Land_06", pos=Vector3.new(-140, 1, 80), price=3500},
        {name="Land_07", pos=Vector3.new(-140, 1, 40), price=3500},
        {name="Land_08", pos=Vector3.new(-140, 1, 0), price=5000},
        {name="Land_09", pos=Vector3.new(-140, 1, -40), price=3500},
        {name="Land_10", pos=Vector3.new(-140, 1, -80), price=3500},
    }
    for _, l in landPositions do
        local plot = Instance.new("Part")
        plot.Name = l.name
        plot.Size = Vector3.new(32, 0.3, 32)
        plot.Position = l.pos
        plot.Anchored = true
        plot.Material = Enum.Material.Neon
        plot.Color = Color3.fromRGB(255, 215, 0)
        plot:SetAttribute("IsPlot", true)
        plot:SetAttribute("PlotType", "land")
        plot:SetAttribute("Price", l.price)
        plot.Parent = residential
    end

    local lights = Instance.new("Folder")
    lights.Name = "StreetLights"
    lights.Parent = workspace
    local lightPositions = {
        Vector3.new(12, 0, 50), Vector3.new(12, 0, 100),
        Vector3.new(-12, 0, 50), Vector3.new(-12, 0, 100),
        Vector3.new(12, 0, -50), Vector3.new(-12, 0, -50),
        Vector3.new(50, 0, 12), Vector3.new(-50, 0, 12),
    }
    for i, pos in lightPositions do
        local pole = Instance.new("Part")
        pole.Name = "LightPole_" .. i
        pole.Size = Vector3.new(0.5, 12, 0.5)
        pole.Position = pos + Vector3.new(0, 6, 0)
        pole.Anchored = true
        pole.Material = Enum.Material.Metal
        pole.Color = Color3.fromRGB(60, 60, 65)
        pole.Parent = lights
        local head = Instance.new("Part")
        head.Name = "LightHead_" .. i
        head.Size = Vector3.new(2, 1, 2)
        head.Position = pos + Vector3.new(0, 12.5, 0)
        head.Anchored = true
        head.Material = Enum.Material.Neon
        head.Color = Color3.fromRGB(255, 230, 180)
        head.Parent = lights
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 1
        pointLight.Range = 30
        pointLight.Color = Color3.fromRGB(255, 230, 180)
        pointLight.Parent = head
    end

    local park = Instance.new("Folder")
    park.Name = "CityPark"
    park.Parent = workspace
    local grass = Instance.new("Part")
    grass.Name = "ParkGrass"
    grass.Size = Vector3.new(80, 0.5, 80)
    grass.Position = Vector3.new(0, 0.25, -120)
    grass.Anchored = true
    grass.Material = Enum.Material.Grass
    grass.Color = Color3.fromRGB(60, 140, 60)
    grass.Parent = park

    print("[WORLD] City built: Mall + Residential + Plaza + Park + Streets")
end

return WorldSetup