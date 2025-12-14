local Items = require(script.Items)
local Gamepasses = require(script.Gamepasses)
---@class ShopList
local ShopList = {}
ShopList.ITEMS = Items
ShopList.GAMEPASSES = Gamepasses

function ShopList.getItem(itemName)
	local item = ShopList.ITEMS.getItem(itemName) or ShopList.GAMEPASSES.getGamepass(itemName)
	return item
end

return ShopList
