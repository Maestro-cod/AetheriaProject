local Constants = {}

-- Currency
Constants.STARTING_CREDITS = 5000
Constants.CURRENCY_NAME = "Credits"

-- Age System (in real-world seconds)
Constants.AGE_STAGES = {
    { name = "Child",  duration = 2 * 24 * 3600 },   -- 2 days
    { name = "Teen",   duration = 3 * 24 * 3600 },   -- 3 days
    { name = "Adult",  duration = 14 * 24 * 3600 },  -- 14 days
    { name = "Elder",  duration = -1 },               -- permanent
}

-- Avatar scaling per age stage
Constants.AGE_SCALES = {
    Child = { Height = 0.6, Width = 0.6, Head = 1.2 },
    Teen  = { Height = 0.85, Width = 0.85, Head = 1.05 },
    Adult = { Height = 1.0, Width = 1.0, Head = 1.0 },
    Elder = { Height = 0.95, Width = 1.0, Head = 1.0 },
}

-- Shop / Mall
Constants.SHOP_RENT_PRICE = 1000
Constants.SHOP_RENT_DURATION = 7 * 24 * 3600  -- 7 days
Constants.SOVEREIGN_TAX = 0.05               -- 5% city tax

-- Housing
Constants.PLOT_PRICE = 2500
Constants.MAX_FURNITURE_PER_PLOT = 50

-- Jobs
Constants.JOBS = {
    Cashier  = { wage = 50,  shiftDuration = 300 },  -- 5 min shift
    Security = { wage = 75,  shiftDuration = 300 },
    DJ       = { wage = 100, shiftDuration = 300 },
}

-- Day/Night Cycle
Constants.DAY_CYCLE_MINUTES = 20  -- full cycle in real minutes

return Constants
