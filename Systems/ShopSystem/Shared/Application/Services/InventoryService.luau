---@class InventoryService
---@field diContainer DIContainer
local InventoryService = {}
InventoryService.__index = InventoryService

---@param diContainer DIContainer
---@return InventoryService
function InventoryService.new(diContainer)
	local self = setmetatable({}, InventoryService)
	self.diContainer = diContainer
	return self
end

---@param playerEntity PlayerEntity
---@param itemId string
---@return boolean
function InventoryService:addItem(playerEntity, itemId)
	local logger = self.diContainer:resolve("Logger")

	if not playerEntity then
		logger:warn("InventoryService", "Player entity is nil")
		return false
	end

	-- Add item to inventory (we'll store this in player data)
	if not playerEntity.inventory then
		playerEntity.inventory = {}
	end

	playerEntity.inventory[itemId] = true

	logger:info("InventoryService", "Item added to inventory:", playerEntity:getPlayer().Name, itemId)
	return true
end

---@param playerEntity PlayerEntity
---@return table -- {itemId = true, ...}
function InventoryService:getOwnedItems(playerEntity)
	if not playerEntity or not playerEntity.inventory then
		return {}
	end

	return playerEntity.inventory
end

---@param playerEntity PlayerEntity
---@param itemId string
---@return boolean
function InventoryService:hasItem(playerEntity, itemId)
	local ownedItems = self:getOwnedItems(playerEntity)
	return ownedItems[itemId] or false
end

---@param playerEntity PlayerEntity
---@param itemId string
---@return boolean
function InventoryService:removeItem(playerEntity, itemId)
	local logger = self.diContainer:resolve("Logger")

	if not playerEntity or not playerEntity.inventory then
		return false
	end

	if playerEntity.inventory[itemId] then
		playerEntity.inventory[itemId] = nil
		logger:info("InventoryService", "Item removed from inventory:", playerEntity:getPlayer().Name, itemId)
		return true
	end

	return false
end

---@param playerEntity PlayerEntity
---@return table -- Array of item IDs
function InventoryService:getEquippedItems(playerEntity)
	if not playerEntity then
		return {}
	end

	local equippedItems = {}

	-- Add equipped jetpack
	if playerEntity:getJetpack() ~= "Default Jetpack" then
		table.insert(equippedItems, playerEntity:getJetpack())
	end

	-- Add equipped accessories
	for _, accessory in ipairs(playerEntity:getAccessories()) do
		table.insert(equippedItems, accessory.id)
	end

	return equippedItems
end

return InventoryService
