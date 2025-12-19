---@class ShopSystemSharedData
local Data = {}

-- Shop item catalog
Data.ShopItems = {
	-- Jetpacks
	{
		id = "jetpack_basic",
		name = "Basic Jetpack",
		type = "jetpack",
		category = "Jetpacks",
		description = "Standard jetpack for racing",
		icon = "rbxassetid://1234567890",
		price = {coins = 0, gems = 0}, -- Free default
		rarity = "common",
		previewModel = "rbxassetid://1234567891",
		effectData = {
			speedMultiplier = 1.0,
			boostPower = 1.0,
			fuelCapacity = 100
		}
	},
	{
		id = "jetpack_speedster",
		name = "Speedster Jetpack",
		type = "jetpack",
		category = "Jetpacks",
		description = "Faster jetpack with speed boost",
		icon = "rbxassetid://1234567892",
		price = {coins = 500, gems = 0},
		rarity = "rare",
		previewModel = "rbxassetid://1234567893",
		effectData = {
			speedMultiplier = 1.2,
			boostPower = 1.1,
			fuelCapacity = 120
		}
	},
	{
		id = "jetpack_legendary",
		name = "Legendary Jetpack",
		type = "jetpack",
		category = "Jetpacks",
		description = "Ultimate jetpack with maximum performance",
		icon = "rbxassetid://1234567894",
		price = {coins = 2000, gems = 50},
		rarity = "legendary",
		previewModel = "rbxassetid://1234567895",
		effectData = {
			speedMultiplier = 1.5,
			boostPower = 1.3,
			fuelCapacity = 150
		}
	},

	-- Trails
	{
		id = "trail_fire",
		name = "Fire Trail",
		type = "trail",
		category = "Trails",
		description = "Burning trail effect",
		icon = "rbxassetid://1234567896",
		price = {coins = 200, gems = 0},
		rarity = "common",
		previewModel = "",
		effectData = {
			color = Color3.fromRGB(255, 100, 50),
			particleId = "rbxassetid://1234567897",
			lifetime = 2.0
		}
	},
	{
		id = "trail_rainbow",
		name = "Rainbow Trail",
		type = "trail",
		category = "Trails",
		description = "Colorful rainbow trail",
		icon = "rbxassetid://1234567898",
		price = {coins = 800, gems = 10},
		rarity = "epic",
		previewModel = "",
		effectData = {
			color = Color3.fromRGB(255, 255, 255), -- Dynamic colors
			particleId = "rbxassetid://1234567899",
			lifetime = 3.0
		}
	},

	-- Effects
	{
		id = "effect_sparkle",
		name = "Sparkle Effect",
		type = "effect",
		category = "Effects",
		description = "Magical sparkle particles",
		icon = "rbxassetid://1234567900",
		price = {coins = 300, gems = 0},
		rarity = "common",
		previewModel = "",
		effectData = {
			particleId = "rbxassetid://1234567901",
			emissionRate = 50,
			size = Vector3.new(2, 2, 2)
		}
	},
	{
		id = "effect_golden",
		name = "Golden Glow",
		type = "effect",
		category = "Effects",
		description = "Premium golden glow effect",
		icon = "rbxassetid://1234567902",
		price = {coins = 1500, gems = 25},
		rarity = "epic",
		previewModel = "",
		effectData = {
			particleId = "rbxassetid://1234567903",
			emissionRate = 100,
			size = Vector3.new(3, 3, 3),
			glowIntensity = 2.0
		}
	}
}

-- Currency definitions
Data.Currencies = {
	COINS = "coins",
	GEMS = "gems"
}

-- Rarity colors
Data.RarityColors = {
	common = Color3.fromRGB(150, 150, 150),
	rare = Color3.fromRGB(50, 150, 255),
	epic = Color3.fromRGB(150, 50, 255),
	legendary = Color3.fromRGB(255, 150, 50)
}

return Data
