local Types = {}

-- What gets saved to DataStore for every player
export type PlayerProfile = {
    Credits: number,
    BirthTimestamp: number,
    AgeStage: string,

    -- Real Estate Empire
    OwnedPlots: { [string]: PlotData },
    RentedShops: { [string]: ShopData },

    -- Inventory
    Inventory: { [string]: number },
    Outfit: { [string]: string },

    -- Social
    FamilyIds: { [string]: string },
    Relationships: { [string]: RelationshipData },

    -- Monetization
    GrantedReceipts: { [string]: boolean },
}

export type PlotData = {
    plotId: string,
    purchaseTime: number,
    furniture: { FurnitureItem },
    plotValue: number,
}

export type ShopData = {
    shopId: string,
    rentStart: number,
    rentExpiry: number,
    shopName: string,
    earnings: number,
}

export type RelationshipData = {
    relationType: string,
    otherUserId: number,
    timestamp: number,
}

export type FurnitureItem = {
    itemId: string,
    x: number,
    y: number,
    z: number,
    rotation: number,
}

-- Default profile for new players
Types.DEFAULT_PROFILE = {
    Credits = 5000,
    BirthTimestamp = 0,
    AgeStage = "Child",

    OwnedPlots = {},
    RentedShops = {},

    Inventory = {},
    Outfit = {},

    FamilyIds = {},
    Relationships = {},

    GrantedReceipts = {},
}

return Types
