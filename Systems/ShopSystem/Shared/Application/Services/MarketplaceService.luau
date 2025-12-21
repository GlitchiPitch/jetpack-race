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

	logger:info("MarketplaceService", "Validating purchase for player:", player.Name, "item:", itemId)

	-- Get player entity
	local playerEntity = playerService:getPlayerEntity(player)
	if not playerEntity then
		logger:warn("MarketplaceService", "Player entity not found for:", player.Name, "(ID:", player.UserId, ")")
		return false, "Player data not loaded"
	end

	logger:info("MarketplaceService", "Player entity found for", player.Name)

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
		logger:warn("MarketplaceService", "Shop item not found:", itemId, "- Available items:", #shopData.ShopItems)
		return false, "Item not found"
	end

	logger:info(
		"MarketplaceService",
		"Found shop item:",
		itemId,
		"Type:",
		shopItem.type,
		"Price:",
		shopItem:getPrice("coins"),
		"coins,",
		shopItem:getPrice("gems"),
		"gems"
	)

	-- Check if item is in stock
	if not shopItem.isInStock() then
		logger:info("MarketplaceService", "Item", itemId, "is out of stock for", player.Name)
		return false, "Item out of stock"
	end

	logger:info("MarketplaceService", "Item", itemId, "is in stock")

	-- Check currency requirements
	local playerCurrency = playerEntity:getCurrencyData()
	logger:info(
		"MarketplaceService",
		"Player",
		player.Name,
		"has",
		playerCurrency.coins,
		"coins and",
		playerCurrency.gems,
		"gems"
	)

	if shopItem:requiresCoins() and not playerEntity:hasEnoughCurrency("coins", shopItem:getPrice("coins")) then
		local required = shopItem:getPrice("coins")
		local has = playerCurrency.coins
		logger:warn("MarketplaceService", "Insufficient coins for", player.Name, "- Required:", required, "Has:", has)
		return false, "Insufficient coins"
	end

	if shopItem:requiresGems() and not playerEntity:hasEnoughCurrency("gems", shopItem:getPrice("gems")) then
		local required = shopItem:getPrice("gems")
		local has = playerCurrency.gems
		logger:warn("MarketplaceService", "Insufficient gems for", player.Name, "- Required:", required, "Has:", has)
		return false, "Insufficient gems"
	end

	logger:info("MarketplaceService", "Purchase validation passed for", player.Name, "item", itemId)
	return true, ""
end

---@param player Player
---@param itemId string
---@return boolean, string, table -- success, errorMessage, transactionData
function MarketplaceService:purchaseItem(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")

	---@type ShopSystemSharedServices
	local services = self.diContainer:resolve("Shared.Application.Services")
	local inventoryService = services.inventoryService

	logger:info(
		"MarketplaceService",
		"Starting purchase transaction for player:",
		player.Name,
		"item:",
		itemId,
		"UserID:",
		player.UserId
	)

	-- Validate purchase
	logger:info("MarketplaceService", "Validating purchase requirements...")
	local canPurchase, errorMessage = self:canPurchase(player, itemId)
	if not canPurchase then
		logger:warn(
			"MarketplaceService",
			"Purchase validation failed for",
			player.Name,
			itemId,
			"- Reason:",
			errorMessage
		)
		return false, errorMessage, nil
	end

	logger:info("MarketplaceService", "Purchase validation passed, proceeding with transaction")

	-- Get player entity
	local playerEntity = playerService:getPlayerEntity(player)
	local originalCurrency = playerEntity:getCurrencyData()
	logger:info(
		"MarketplaceService",
		"Player",
		player.Name,
		"original currency - Coins:",
		originalCurrency.coins,
		"Gems:",
		originalCurrency.gems
	)

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
		totalValue = (shopItem:getPrice("coins") * 1) + (shopItem:getPrice("gems") * 10), -- Gems worth 10x coins
		playerName = player.Name,
	}

	logger:info(
		"MarketplaceService",
		"Transaction data prepared - Item:",
		itemId,
		"Coins to deduct:",
		transactionData.coinsSpent,
		"Gems to deduct:",
		transactionData.gemsSpent
	)

	-- Deduct currency
	if shopItem:requiresCoins() then
		logger:info("MarketplaceService", "Deducting", shopItem:getPrice("coins"), "coins from", player.Name)
		playerEntity:subtractCurrency("coins", shopItem:getPrice("coins"))
	end
	if shopItem:requiresGems() then
		logger:info("MarketplaceService", "Deducting", shopItem:getPrice("gems"), "gems from", player.Name)
		playerEntity:subtractCurrency("gems", shopItem:getPrice("gems"))
	end

	local newCurrency = playerEntity:getCurrencyData()
	logger:info("MarketplaceService", "Currency after deduction - Coins:", newCurrency.coins, "Gems:", newCurrency.gems)

	-- Add item to inventory
	logger:info("MarketplaceService", "Adding item", itemId, "to inventory for", player.Name)
	local success = inventoryService:addItem(playerEntity, itemId)
	if not success then
		logger:error(
			"MarketplaceService",
			"Failed to add item",
			itemId,
			"to inventory for",
			player.Name,
			"- Refunding currency"
		)

		-- Refund currency if inventory addition failed
		if shopItem:requiresCoins() then
			playerEntity:addCurrency("coins", shopItem:getPrice("coins"))
			logger:info("MarketplaceService", "Refunded", shopItem:getPrice("coins"), "coins to", player.Name)
		end
		if shopItem:requiresGems() then
			playerEntity:addCurrency("gems", shopItem:getPrice("gems"))
			logger:info("MarketplaceService", "Refunded", shopItem:getPrice("gems"), "gems to", player.Name)
		end

		return false, "Failed to add item to inventory", nil
	end

	logger:info("MarketplaceService", "Successfully added item", itemId, "to inventory for", player.Name)

	-- Update stock if limited
	if shopItem.stock > 0 then
		local oldStock = shopItem.stock
		shopItem.stock = shopItem.stock - 1
		logger:info("MarketplaceService", "Updated stock for item", itemId, "- Old:", oldStock, "New:", shopItem.stock)
	end

	-- Save player data
	logger:info("MarketplaceService", "Saving player data for", player.Name)
	playerService:savePlayerData(player)

	logger:info(
		"MarketplaceService",
		"Purchase completed successfully - Player:",
		player.Name,
		"Item:",
		itemId,
		"Total value:",
		transactionData.totalValue
	)

	return true, "", transactionData
end

---@param playerEntity PlayerEntity
---@return table -- {itemId = true, ...}
function MarketplaceService:getOwnedItems(playerEntity)
	---@type ShopSystemSharedServices
	local services = self.diContainer:resolve("Shared.Application.Services")
	local inventoryService = services.inventoryService
	return inventoryService:getOwnedItems(playerEntity)
end

---@param playerEntity PlayerEntity
---@param itemId string
---@return boolean
function MarketplaceService:ownsItem(playerEntity, itemId)
	local ownedItems = self:getOwnedItems(playerEntity)
	return ownedItems[itemId] or false
end

---@param player Player
---@param itemId string
---@return boolean, string -- success, errorMessage
function MarketplaceService:equipItem(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")
	local playerEntity = playerService:getPlayerEntity(player)

	logger:info(
		"MarketplaceService",
		"Processing equip request - Player:",
		player.Name,
		"Item:",
		itemId,
		"UserID:",
		player.UserId
	)

	-- Check if player owns the item
	logger:info("MarketplaceService", "Checking if", player.Name, "owns item", itemId)
	if not self:ownsItem(playerEntity, itemId) then
		logger:warn("MarketplaceService", "Equip failed -", player.Name, "does not own item", itemId)
		return false, "Item not owned"
	end

	logger:info("MarketplaceService", player.Name, "owns item", itemId, "- proceeding with equip")

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
		logger:warn("MarketplaceService", "Equip failed - item data not found for", itemId)
		return false, "Item not found"
	end

	logger:info("MarketplaceService", "Found item data - Type:", shopItem.type, "ID:", itemId)

	-- Get current equipment
	local currentJetpack = playerEntity:getJetpack()
	local currentAccessories = playerEntity:getAccessories()

	logger:info(
		"MarketplaceService",
		"Current equipment - Jetpack:",
		currentJetpack,
		"Accessories:",
		#currentAccessories
	)

	-- Equip based on item type
	if shopItem.type == "jetpack" then
		logger:info("MarketplaceService", "Equipping jetpack", itemId, "for", player.Name, "(was:", currentJetpack, ")")
		playerEntity:setJetpack(itemId)
	elseif shopItem.type == "trail" or shopItem.type == "effect" then
		logger:info("MarketplaceService", "Equipping accessory", itemId, "of type", shopItem.type, "for", player.Name)

		-- Remove existing accessories of same type
		local removedCount = 0
		for _, accessory in ipairs(currentAccessories) do
			if accessory.type == shopItem.type then
				logger:info(
					"MarketplaceService",
					"Removing existing accessory",
					accessory.id,
					"of type",
					accessory.type
				)
				removedCount = removedCount + 1
			end
		end

		-- Add to equipped accessories
		playerEntity:addAccessory(shopItem.type, itemId)
		logger:info(
			"MarketplaceService",
			"Added accessory",
			itemId,
			"of type",
			shopItem.type,
			"- Removed",
			removedCount,
			"existing accessories"
		)
	else
		logger:warn("MarketplaceService", "Unknown item type:", shopItem.type, "for item", itemId)
	end

	-- Save player data
	logger:info("MarketplaceService", "Saving player data after equip for", player.Name)
	playerService:savePlayerData(player)

	logger:info("MarketplaceService", "Item equipped successfully:", player.Name, itemId, "Type:", shopItem.type)

	return true, ""
end

---@param player Player
---@param itemId string
---@return boolean, string -- success, errorMessage
function MarketplaceService:unequipItem(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")
	local playerEntity = playerService:getPlayerEntity(player)

	logger:info(
		"MarketplaceService",
		"Processing unequip request - Player:",
		player.Name,
		"Item:",
		itemId,
		"UserID:",
		player.UserId
	)

	-- Get current equipment
	local currentJetpack = playerEntity:getJetpack()
	local currentAccessories = playerEntity:getAccessories()

	logger:info(
		"MarketplaceService",
		"Current equipment before unequip - Jetpack:",
		currentJetpack,
		"Accessories:",
		#currentAccessories
	)

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
		logger:warn("MarketplaceService", "Unequip failed - item data not found for", itemId)
		return false, "Item not found"
	end

	logger:info("MarketplaceService", "Found item data - Type:", shopItem.type, "ID:", itemId)

	-- Unequip based on item type
	if shopItem.type == "jetpack" then
		logger:info("MarketplaceService", "Unequipping jetpack", itemId, "for", player.Name, "- resetting to default")
		playerEntity:setJetpack("jetpack_basic")
	elseif shopItem.type == "trail" or shopItem.type == "effect" then
		logger:info("MarketplaceService", "Unequipping accessory", itemId, "of type", shopItem.type, "for", player.Name)

		-- Remove from accessories
		local originalCount = #currentAccessories
		local newAccessories = {}
		local removed = false

		for _, accessory in ipairs(currentAccessories) do
			if accessory.type == shopItem.type and accessory.id == itemId then
				logger:info("MarketplaceService", "Removing accessory", accessory.id, "of type", accessory.type)
				removed = true
			else
				table.insert(newAccessories, accessory)
			end
		end

		playerEntity.accessories = newAccessories
		local newCount = #newAccessories

		if removed then
			logger:info(
				"MarketplaceService",
				"Successfully removed accessory - Accessories count:",
				originalCount,
				"->",
				newCount
			)
		else
			logger:warn("MarketplaceService", "Accessory", itemId, "was not found in equipped accessories")
		end
	else
		logger:warn("MarketplaceService", "Unknown item type:", shopItem.type, "for item", itemId)
	end

	-- Save player data
	logger:info("MarketplaceService", "Saving player data after unequip for", player.Name)
	playerService:savePlayerData(player)

	logger:info("MarketplaceService", "Item unequipped successfully:", player.Name, itemId, "Type:", shopItem.type)

	return true, ""
end

return MarketplaceService
