---@class MarketplaceService
---@field diContainer DIContainer
local MarketplaceService = {}
MarketplaceService.__index = MarketplaceService

---@param diContainer DIContainer
---@return MarketplaceService
function MarketplaceService.new(diContainer)
	local self = setmetatable({}, MarketplaceService)
	self.diContainer = diContainer
	return self
end

---@param player Player
---@param itemId string
---@return boolean, string -- success, errorMessage
function MarketplaceService:canPurchase(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")

	-- Get player entity
	local playerEntity = playerService:getPlayerEntity(player)
	if not playerEntity then
		logger:warn("MarketplaceService", "Player entity not found for:", player.Name)
		return false, "Player data not loaded"
	end

	-- Get shop data
	local shopData = self.diContainer:resolve("Shared.Data")
	local shopItem = nil

	for _, item in ipairs(shopData.ShopItems) do
		if item.id == itemId then
			shopItem = item
			break
		end
	end

	if not shopItem then
		logger:warn("MarketplaceService", "Shop item not found:", itemId)
		return false, "Item not found"
	end

	-- Check if item is in stock
	if not shopItem.isInStock() then
		return false, "Item out of stock"
	end

	-- Check currency requirements
	if shopItem:requiresCoins() and not playerEntity:hasEnoughCurrency("coins", shopItem:getPrice("coins")) then
		return false, "Insufficient coins"
	end

	if shopItem:requiresGems() and not playerEntity:hasEnoughCurrency("gems", shopItem:getPrice("gems")) then
		return false, "Insufficient gems"
	end

	return true, ""
end

---@param player Player
---@param itemId string
---@return boolean, string, table -- success, errorMessage, transactionData
function MarketplaceService:purchaseItem(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")
	local inventoryService = self.diContainer:resolve("InventoryService")

	-- Validate purchase
	local canPurchase, errorMessage = self:canPurchase(player, itemId)
	if not canPurchase then
		return false, errorMessage, nil
	end

	-- Get player entity
	local playerEntity = playerService:getPlayerEntity(player)

	-- Get shop item data
	local shopData = self.diContainer:resolve("Shared.Data")
	local shopItem = nil
	for _, item in ipairs(shopData.ShopItems) do
		if item.id == itemId then
			shopItem = item
			break
		end
	end

	-- Process transaction
	local transactionData = {
		playerId = player.UserId,
		itemId = itemId,
		timestamp = tick(),
		coinsSpent = shopItem:getPrice("coins"),
		gemsSpent = shopItem:getPrice("gems"),
		totalValue = (shopItem:getPrice("coins") * 1) + (shopItem:getPrice("gems") * 10) -- Gems worth 10x coins
	}

	-- Deduct currency
	if shopItem:requiresCoins() then
		playerEntity:subtractCurrency("coins", shopItem:getPrice("coins"))
	end
	if shopItem:requiresGems() then
		playerEntity:subtractCurrency("gems", shopItem:getPrice("gems"))
	end

	-- Add item to inventory
	local success = inventoryService:addItem(player, itemId)
	if not success then
		-- Refund currency if inventory addition failed
		if shopItem:requiresCoins() then
			playerEntity:addCurrency("coins", shopItem:getPrice("coins"))
		end
		if shopItem:requiresGems() then
			playerEntity:addCurrency("gems", shopItem:getPrice("gems"))
		end
		logger:error("MarketplaceService", "Failed to add item to inventory:", itemId)
		return false, "Failed to add item to inventory", nil
	end

	-- Update stock if limited
	if shopItem.stock > 0 then
		shopItem.stock = shopItem.stock - 1
	end

	-- Save player data
	playerService:savePlayerData(player)

	logger:info("MarketplaceService", "Purchase completed:", player.Name, itemId, transactionData.totalValue)

	return true, "", transactionData
end

---@param player Player
---@return table -- {itemId = true, ...}
function MarketplaceService:getOwnedItems(player)
	local inventoryService = self.diContainer:resolve("InventoryService")
	return inventoryService:getOwnedItems(player)
end

---@param player Player
---@param itemId string
---@return boolean
function MarketplaceService:ownsItem(player, itemId)
	local ownedItems = self:getOwnedItems(player)
	return ownedItems[itemId] or false
end

---@param player Player
---@param itemId string
---@return boolean, string -- success, errorMessage
function MarketplaceService:equipItem(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")
	local inventoryService = self.diContainer:resolve("InventoryService")

	-- Check if player owns the item
	if not self:ownsItem(player, itemId) then
		return false, "Item not owned"
	end

	-- Get item data
	local shopData = self.diContainer:resolve("Shared.Data")
	local shopItem = nil
	for _, item in ipairs(shopData.ShopItems) do
		if item.id == itemId then
			shopItem = item
			break
		end
	end

	if not shopItem then
		return false, "Item not found"
	end

	-- Get player entity
	local playerEntity = playerService:getPlayerEntity(player)

	-- Equip based on item type
	if shopItem.type == "jetpack" then
		playerEntity:setJetpack(itemId)
	elseif shopItem.type == "trail" or shopItem.type == "effect" then
		-- Add to equipped accessories (remove existing of same type first)
		local newAccessories = {}
		for _, accessory in ipairs(playerEntity:getAccessories()) do
			if accessory.type ~= shopItem.type then
				table.insert(newAccessories, accessory)
			end
		end
		playerEntity:addAccessory(shopItem.type, itemId)
	end

	-- Save player data
	playerService:savePlayerData(player)

	logger:info("MarketplaceService", "Item equipped:", player.Name, itemId)

	return true, ""
end

---@param player Player
---@param itemId string
---@return boolean, string -- success, errorMessage
function MarketplaceService:unequipItem(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")

	-- Get player entity
	local playerEntity = playerService:getPlayerEntity(player)

	-- Get item data to determine type
	local shopData = self.diContainer:resolve("Shared.Data")
	local shopItem = nil
	for _, item in ipairs(shopData.ShopItems) do
		if item.id == itemId then
			shopItem = item
			break
		end
	end

	if not shopItem then
		return false, "Item not found"
	end

	-- Unequip based on item type
	if shopItem.type == "jetpack" then
		-- Reset to default jetpack
		playerEntity:setJetpack("jetpack_basic")
	elseif shopItem.type == "trail" or shopItem.type == "effect" then
		-- Remove from accessories
		local newAccessories = {}
		for _, accessory in ipairs(playerEntity:getAccessories()) do
			if not (accessory.type == shopItem.type and accessory.id == itemId) then
				table.insert(newAccessories, accessory)
			end
		end
		playerEntity.accessories = newAccessories
	end

	-- Save player data
	playerService:savePlayerData(player)

	logger:info("MarketplaceService", "Item unequipped:", player.Name, itemId)

	return true, ""
end

return MarketplaceService
