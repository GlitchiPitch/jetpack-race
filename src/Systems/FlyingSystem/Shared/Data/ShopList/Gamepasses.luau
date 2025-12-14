local ShopConstants = require(script.Parent.Parent.ShopConstants)

---@class Gamepasses
local Gamepasses = {
	[ShopConstants.GAMEPASSES.GAMEPASS_NAME_1.name] = {
		name = ShopConstants.GAMEPASSES.GAMEPASS_NAME_1.displayName,
		price = 100,
		productId = "1234567890",
		giftProductId = "1234567890",
		type = ShopConstants.PURCHASE_TYPES.GAMEPASS,
		image = "rbxassetid://113833840486362",
	},
	[ShopConstants.GAMEPASSES.GAMEPASS_NAME_2.name] = {
		name = ShopConstants.GAMEPASSES.GAMEPASS_NAME_2.displayName,
		price = 100,
		productId = "1234567890",
		giftProductId = "1234567890",
		type = ShopConstants.PURCHASE_TYPES.GAMEPASS,
		image = "rbxassetid://113833840486362",
	},
}


function Gamepasses.getGamepass(gamepassName)
	local gamepass = Gamepasses[gamepassName]
	return gamepass
end

return Gamepasses