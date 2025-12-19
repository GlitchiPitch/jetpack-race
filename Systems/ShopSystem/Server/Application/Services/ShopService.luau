---@class ShopSystemServerShopService
local ShopService = {}
ShopService.__index = ShopService

---@param diContainer DIContainer
---@return ShopSystemServerShopService
function ShopService.new(diContainer)
	local self = setmetatable({}, ShopService)
	self.diContainer = diContainer
	return self
end

function ShopService:init()
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopSystemServerShopService", "Initializing ShopService...")

	-- Setup shop prompt
	local shopPrompt = workspace:FindFirstChild("ShopPrompt")
	if shopPrompt then
		self:setupShopPrompt(shopPrompt)
	else
		logger:warn("ShopSystemServerShopService", "ShopPrompt not found in workspace")
	end

	-- Setup remote event handlers
	self:setupRemoteEventHandlers()
end

function ShopService:setupShopPrompt(shopPrompt)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	local proximityPrompt = shopPrompt:FindFirstChild("ProximityPrompt")
	if not proximityPrompt then
		logger:warn("ShopSystemServerShopService", "ProximityPrompt not found in ShopPrompt")
		return
	end

	proximityPrompt.ActionText = "Open Shop"
	proximityPrompt.Triggered:Connect(function(player)
		self:openShopForPlayer(player)
	end)

	logger:info("ShopSystemServerShopService", "ShopPrompt setup completed")
end

---@param player Player
function ShopService:openShopForPlayer(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopSystemServerShopService", "Opening shop for player:", player.Name)

	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type ShopSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Fire remote event to client to open shop UI
	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_OPENED, {
		playerName = player.Name,
		timestamp = tick()
	})
end

function ShopService:setupRemoteEventHandlers()
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Handle purchase requests
	remoteEventService:listenToServer(constants.REMOTE_EVENTS.SHOP_PURCHASE_REQUEST, function(player, data)
		if data.itemId then
			self:handlePurchaseRequest(player, data.itemId)
		end
	end)

	-- Handle equip requests
	remoteEventService:listenToServer(constants.REMOTE_EVENTS.SHOP_EQUIP_REQUEST, function(player, data)
		if data.itemId then
			self:handleEquipRequest(player, data.itemId)
		end
	end)

	-- Handle unequip requests
	remoteEventService:listenToServer(constants.REMOTE_EVENTS.SHOP_UNEQUIP_REQUEST, function(player, data)
		if data.itemId then
			self:handleUnequipRequest(player, data.itemId)
		end
	end)

	-- Handle developer product requests
	remoteEventService:listenToServer(constants.REMOTE_EVENTS.SHOP_DEV_PRODUCT_REQUEST, function(player, data)
		if data.productId then
			self:handleDevProductRequest(player, data.productId)
		end
	end)
end

function ShopService:handlePurchaseRequest(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")
	local marketplaceService = self.diContainer:resolve("Shared.Services").marketplaceService

	logger:info("ShopService", "Processing purchase request:", player.Name, itemId)

	-- Attempt purchase
	local success, errorMessage, transactionData = marketplaceService:purchaseItem(player, itemId)

	if success then
		-- Fire success event to client
		remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_PURCHASE_SUCCESS, {
			itemId = itemId,
			transactionData = transactionData
		})

		logger:info("ShopService", "Purchase successful:", player.Name, itemId)
	else
		-- Fire failure event to client
		remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_PURCHASE_FAILED, {
			itemId = itemId,
			error = errorMessage
		})

		logger:warn("ShopService", "Purchase failed:", player.Name, itemId, errorMessage)
	end
end

function ShopService:handleEquipRequest(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")
	local marketplaceService = self.diContainer:resolve("Shared.Services").marketplaceService

	logger:info("ShopService", "Processing equip request:", player.Name, itemId)

	local success, errorMessage = marketplaceService:equipItem(player, itemId)

	if success then
		logger:info("ShopService", "Item equipped successfully:", player.Name, itemId)
		-- Could fire an equip success event if needed
	else
		logger:warn("ShopService", "Equip failed:", player.Name, itemId, errorMessage)
		-- Could fire an equip failure event if needed
	end
end

function ShopService:handleUnequipRequest(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")
	local marketplaceService = self.diContainer:resolve("Shared.Services").marketplaceService

	logger:info("ShopService", "Processing unequip request:", player.Name, itemId)

	local success, errorMessage = marketplaceService:unequipItem(player, itemId)

	if success then
		logger:info("ShopService", "Item unequipped successfully:", player.Name, itemId)
		-- Could fire an unequip success event if needed
	else
		logger:warn("ShopService", "Unequip failed:", player.Name, itemId, errorMessage)
		-- Could fire an unequip failure event if needed
	end
end

function ShopService:handleDevProductRequest(player, productId)
	local logger = self.diContainer:resolve("Logger")
	local developerProductsService = self.diContainer:resolve("DeveloperProductsService")

	logger:info("ShopService", "Processing developer product request:", player.Name, productId)

	local success, errorMessage = developerProductsService:promptPurchase(player, productId)

	if not success then
		logger:warn("ShopService", "Developer product request failed:", player.Name, productId, errorMessage)

		-- Fire failure event to client
		local remoteEventService = self.diContainer:resolve("RemoteEventService")
		local constants = self.diContainer:resolve("Shared.Constants")

		remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_PURCHASE_FAILED, {
			productId = productId,
			error = errorMessage,
			isDeveloperProduct = true
		})
	else
		logger:info("ShopService", "Developer product prompt successful:", player.Name, productId)
	end
end

return ShopService
