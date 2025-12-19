---@class ShopItem
---@field id string
---@field name string
---@field type "jetpack"|"trail"|"effect"
---@field category string
---@field description string
---@field icon string
---@field price table<string, number> -- {coins = 100, gems = 10}
---@field rarity "common"|"rare"|"epic"|"legendary"
---@field previewModel string -- Asset ID for 3D preview
---@field effectData table -- Specific effect properties
---@field isLimited boolean
---@field stock number -- -1 for unlimited
local ShopItem = {}
ShopItem.__index = ShopItem

---@param itemData table
---@return ShopItem
function ShopItem.new(itemData)
	local self = setmetatable({}, ShopItem)
	self.id = itemData.id or ""
	self.name = itemData.name or ""
	self.type = itemData.type or "effect"
	self.category = itemData.category or ""
	self.description = itemData.description or ""
	self.icon = itemData.icon or ""
	self.price = itemData.price or {coins = 0, gems = 0}
	self.rarity = itemData.rarity or "common"
	self.previewModel = itemData.previewModel or ""
	self.effectData = itemData.effectData or {}
	self.isLimited = itemData.isLimited or false
	self.stock = itemData.stock or -1 -- -1 = unlimited

	return self
end

---@return table
function ShopItem:getData()
	return {
		id = self.id,
		name = self.name,
		type = self.type,
		category = self.category,
		description = self.description,
		icon = self.icon,
		price = self.price,
		rarity = self.rarity,
		previewModel = self.previewModel,
		effectData = self.effectData,
		isLimited = self.isLimited,
		stock = self.stock
	}
end

---@return boolean
function ShopItem:isInStock()
	if self.stock == -1 then return true end
	return self.stock > 0
end

---@param currencyType "coins"|"gems"
---@return number
function ShopItem:getPrice(currencyType)
	return self.price[currencyType] or 0
end

---@return boolean
function ShopItem:requiresGems()
	return self.price.gems and self.price.gems > 0
end

---@return boolean
function ShopItem:requiresCoins()
	return self.price.coins and self.price.coins > 0
end

return ShopItem
