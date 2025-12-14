local ShopConstants = require(script.Parent.Parent.ShopConstants)

---@class Items
local Items = {
	[ShopConstants.ITEMS.ITEM_NAME_1.name] = {
		name = ShopConstants.ITEMS.ITEM_NAME_1.displayName,
		price = 100,
		productId = "1234567890",
		giftProductId = "1234567890",
		type = ShopConstants.PURCHASE_TYPES.PRODUCT,
		image = "rbxassetid://113833840486362",
	},
    [ShopConstants.ITEMS.ITEM_NAME_2.name] = {
		name = ShopConstants.ITEMS.ITEM_NAME_2.displayName,
		price = 100,
		productId = "1234567890",
		giftProductId = "1234567890",
		type = ShopConstants.PURCHASE_TYPES.PRODUCT,
		image = "rbxassetid://113833840486362",
	},
}

function Items.getItem(itemName)
	local item = Items[itemName]
	return item
end

return Items