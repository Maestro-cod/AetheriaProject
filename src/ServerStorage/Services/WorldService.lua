local WorldService = {}

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Constants)

local CYCLE_MINUTES = Constants.DAY_CYCLE_MINUTES or 20
local SECONDS_PER_HOUR = (CYCLE_MINUTES * 60) / 24

local currentWeather = "Clear"

function WorldService.Init()
    -- Set initial lighting
    Lighting.ClockTime = 10
    Lighting.GlobalShadows = true

    -- Atmosphere
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmo then
        atmo.Density = 0.3
        atmo.Offset = 0.5
        atmo.Haze = 1
        atmo.Glare = 0
    end

    print("[WORLD] WorldService ready | Cycle: " .. CYCLE_MINUTES .. " min")
end

function WorldService.StartDayNightCycle()
    task.spawn(function()
        while true do
            -- Advance 1 in-game hour
            local current = Lighting.ClockTime
            local next = (current + 1) % 24

            -- Smooth tween
            local info = TweenInfo.new(SECONDS_PER_HOUR, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(Lighting, info, {ClockTime = next})
            tween:Play()
            tween.Completed:Wait()

            -- Adjust atmosphere for time of day
            WorldService._updateAtmosphere(next)
        end
    end)

    print("[WORLD] Day/night cycle started")
end

function WorldService._updateAtmosphere(hour)
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if not atmo then return end

    local info = TweenInfo.new(2, Enum.EasingStyle.Quad)

    if hour >= 6 and hour < 10 then
        -- Morning: warm golden light
        TweenService:Create(Lighting, info, {
            Ambient = Color3.fromRGB(80, 70, 50),
            OutdoorAmbient = Color3.fromRGB(100, 90, 70),
            Brightness = 2,
        }):Play()
        TweenService:Create(atmo, info, {Density = 0.25, Haze = 2}):Play()

    elseif hour >= 10 and hour < 17 then
        -- Midday: bright and clear
        TweenService:Create(Lighting, info, {
            Ambient = Color3.fromRGB(100, 100, 100),
            OutdoorAmbient = Color3.fromRGB(120, 120, 120),
            Brightness = 3,
        }):Play()
        TweenService:Create(atmo, info, {Density = 0.2, Haze = 0}):Play()

    elseif hour >= 17 and hour < 20 then
        -- Sunset: orange and purple
        TweenService:Create(Lighting, info, {
            Ambient = Color3.fromRGB(90, 50, 30),
            OutdoorAmbient = Color3.fromRGB(110, 60, 40),
            Brightness = 1.5,
        }):Play()
        TweenService:Create(atmo, info, {Density = 0.35, Haze = 3}):Play()

    else
        -- Night: dark blue
        TweenService:Create(Lighting, info, {
            Ambient = Color3.fromRGB(20, 20, 40),
            OutdoorAmbient = Color3.fromRGB(15, 15, 30),
            Brightness = 0.5,
        }):Play()
        TweenService:Create(atmo, info, {Density = 0.4, Haze = 1}):Play()
    end
end

function WorldService.GetTimeOfDay()
    local hour = Lighting.ClockTime
    if hour >= 6 and hour < 12 then return "Morning"
    elseif hour >= 12 and hour < 17 then return "Afternoon"
    elseif hour >= 17 and hour < 21 then return "Evening"
    else return "Night" end
end

return WorldService
