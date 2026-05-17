local ItemDatabase = {}

ItemDatabase.Furniture = {
    {
        id = "wall_basic",
        name = "Basic Wall",
        price = 100,
        size = Vector3.new(12, 8, 1),
        color = Color3.fromRGB(200, 200, 200),
        material = "Concrete",
        category = "Structure",
    },
    {
        id = "wall_glass",
        name = "Glass Wall",
        price = 250,
        size = Vector3.new(12, 8, 1),
        color = Color3.fromRGB(180, 220, 240),
        material = "Glass",
        category = "Structure",
        transparency = 0.3,
    },
    {
        id = "floor_wood",
        name = "Wood Floor",
        price = 150,
        size = Vector3.new(12, 0.5, 12),
        color = Color3.fromRGB(150, 100, 50),
        material = "Wood",
        category = "Structure",
    },
    {
        id = "table_office",
        name = "Office Desk",
        price = 200,
        size = Vector3.new(5, 3, 2.5),
        color = Color3.fromRGB(60, 40, 25),
        material = "Wood",
        category = "Furniture",
    },
    {
        id = "chair_modern",
        name = "Modern Chair",
        price = 120,
        size = Vector3.new(2, 3, 2),
        color = Color3.fromRGB(30, 30, 35),
        material = "SmoothPlastic",
        category = "Furniture",
    },
    {
        id = "couch_luxury",
        name = "Luxury Couch",
        price = 500,
        size = Vector3.new(6, 3, 3),
        color = Color3.fromRGB(40, 40, 50),
        material = "Fabric",
        category = "Furniture",
    },
    {
        id = "lamp_neon",
        name = "Neon Lamp",
        price = 180,
        size = Vector3.new(1, 6, 1),
        color = Color3.fromRGB(0, 255, 255),
        material = "Neon",
        category = "Decor",
        light = { range = 20, brightness = 1 },
    },
    {
        id = "sign_custom",
        name = "Shop Sign",
        price = 300,
        size = Vector3.new(8, 3, 0.5),
        color = Color3.fromRGB(0, 200, 255),
        material = "Neon",
        category = "Decor",
    },
    {
        id = "counter_shop",
        name = "Shop Counter",
        price = 350,
        size = Vector3.new(6, 3.5, 2),
        color = Color3.fromRGB(200, 200, 210),
        material = "Marble",
        category = "Furniture",
    },
    {
        id = "plant_pot",
        name = "Potted Plant",
        price = 80,
        size = Vector3.new(2, 4, 2),
        color = Color3.fromRGB(50, 130, 50),
        material = "Grass",
        category = "Decor",
    },
}

function ItemDatabase.GetItem(itemId)
    for _, item in ItemDatabase.Furniture do
        if item.id == itemId then
            return item
        end
    end
    return nil
end

function ItemDatabase.GetByCategory(category)
    local results = {}
    for _, item in ItemDatabase.Furniture do
        if item.category == category then
            table.insert(results, item)
        end
    end
    return results
end

return ItemDatabase