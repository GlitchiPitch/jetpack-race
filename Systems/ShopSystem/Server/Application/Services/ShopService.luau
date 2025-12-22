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
	logger:info("ShopSystemServerShopService", "=== STARTING ShopService initialization ===")
	local shopPrompt = workspace.JetpackRace.ShopPrompt
	shopPrompt.ProximityPrompt.ActionText = "Open Shop"
	self:setupShopPrompt(shopPrompt)
	-- Setup remote event handlers
	self:setupRemoteEventHandlers()
end

function ShopService:setupShopPrompt(shopPrompt)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("ShopSystemServerShopService", "Setting up shop prompt...")

	local proximityPrompt = shopPrompt:FindFirstChild("ProximityPrompt")
	if not proximityPrompt then
		logger:warn("ShopSystemServerShopService", "ProximityPrompt not found in ShopPrompt")
		-- Log all children of ShopPrompt to debug
		logger:info("ShopSystemServerShopService", "ShopPrompt children:")
		for _, child in ipairs(shopPrompt:GetChildren()) do
			logger:info("ShopSystemServerShopService", "  -", child.Name, "(", child.ClassName, ")")
		end
		return
	end

	logger:info("ShopSystemServerShopService", "Found ProximityPrompt, configuring...")
	logger:info(
		"ShopSystemServerShopService",
		"ProximityPrompt properties - Enabled:",
		proximityPrompt.Enabled,
		"MaxActivationDistance:",
		proximityPrompt.MaxActivationDistance,
		"RequiresLineOfSight:",
		proximityPrompt.RequiresLineOfSight
	)

	proximityPrompt.ActionText = "Open Shop"
	proximityPrompt.Enabled = true
	proximityPrompt.MaxActivationDistance = 10 -- Make sure it's reasonable
	logger:info(
		"ShopSystemServerShopService",
		"ProximityPrompt configured - ActionText: '",
		proximityPrompt.ActionText,
		"', Enabled:",
		proximityPrompt.Enabled,
		"MaxActivationDistance:",
		proximityPrompt.MaxActivationDistance
	)

	proximityPrompt.Triggered:Connect(function(player)
		
		self:openShopForPlayer(player)
	end)

	logger:info("ShopSystemServerShopService", "ShopPrompt setup completed - proximity prompt event connected")

	-- Add a command for testing shop opening
	logger:info("ShopSystemServerShopService", "Setting up test command for manual shop opening")
	-- Note: You can test by running: game.Players:GetPlayers()[1].Chatted:Connect(function(msg) if msg == "/openshop" then shopService:openShopForPlayer(game.Players:GetPlayers()[1]) end end)
end

---@param player Player
function ShopService:openShopForPlayer(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopSystemServerShopService", "Opening shop for player:", player.Name, "(ID:", player.UserId, ")")

	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type ShopSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")
	---@type ShopSystemServerPlayerService
	local playerService = self.diContainer:resolve("PlayerService")

	local eventData = {
		playerName = player.Name,
		playerId = player.UserId,
		timestamp = tick(),
	}

	logger:info("ShopSystemServerShopService", "Firing SHOP_OPENED event to client with data:", eventData)
	logger:info("ShopSystemServerShopService", "Event name:", constants.REMOTE_EVENTS.SHOP_OPENED)

	-- Fire remote event to client to open shop UI
	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_OPENED, eventData)

	-- Send current player data to client
	logger:info("ShopSystemServerShopService", "Sending current player data to client for shop")
	playerService:updatePlayer(player)
end

function ShopService:setupRemoteEventHandlers()
	local logger = self.diContainer:resolve("Logger")
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	logger:info("ShopSystemServerShopService", "Setting up remote event handlers...")

	-- Handle purchase requests
	logger:info("ShopSystemServerShopService", "Setting up SHOP_PURCHASE_REQUEST handler")
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.SHOP_PURCHASE_REQUEST, function(player, data)
		logger:info(
			"ShopSystemServerShopService",
			"Received SHOP_PURCHASE_REQUEST from",
			player.Name,
			"with data:",
			data
		)
		if data.itemId then
			self:handlePurchaseRequest(player, data.itemId)
		else
			logger:warn("ShopSystemServerShopService", "SHOP_PURCHASE_REQUEST missing itemId from", player.Name)
		end
	end)

	-- Handle equip requests
	logger:info("ShopSystemServerShopService", "Setting up SHOP_EQUIP_REQUEST handler")
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.SHOP_EQUIP_REQUEST, function(player, data)
		logger:info("ShopSystemServerShopService", "Received SHOP_EQUIP_REQUEST from", player.Name, "with data:", data)
		if data.itemId then
			self:handleEquipRequest(player, data.itemId)
		else
			logger:warn("ShopSystemServerShopService", "SHOP_EQUIP_REQUEST missing itemId from", player.Name)
		end
	end)

	-- Handle unequip requests
	logger:info("ShopSystemServerShopService", "Setting up SHOP_UNEQUIP_REQUEST handler")
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.SHOP_UNEQUIP_REQUEST, function(player, data)
		logger:info(
			"ShopSystemServerShopService",
			"Received SHOP_UNEQUIP_REQUEST from",
			player.Name,
			"with data:",
			data
		)
		if data.itemId then
			self:handleUnequipRequest(player, data.itemId)
		else
			logger:warn("ShopSystemServerShopService", "SHOP_UNEQUIP_REQUEST missing itemId from", player.Name)
		end
	end)

	-- Handle developer product requests
	logger:info("ShopSystemServerShopService", "Setting up SHOP_DEV_PRODUCT_REQUEST handler")
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.SHOP_DEV_PRODUCT_REQUEST, function(player, data)
		logger:info(
			"ShopSystemServerShopService",
			"Received SHOP_DEV_PRODUCT_REQUEST from",
			player.Name,
			"with data:",
			data
		)
		if data.productId then
			self:handleDevProductRequest(player, data.productId)
		else
			logger:warn("ShopSystemServerShopService", "SHOP_DEV_PRODUCT_REQUEST missing productId from", player.Name)
		end
	end)

	logger:info("ShopSystemServerShopService", "All remote event handlers setup completed")
end

function ShopService:handlePurchaseRequest(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")
	local marketplaceService = self.diContainer:resolve("Shared.Application.Services").marketplaceService

	logger:info(
		"ShopService",
		"Processing purchase request - Player:",
		player.Name,
		"ItemID:",
		itemId,
		"UserID:",
		player.UserId
	)

	-- Attempt purchase
	logger:info("ShopService", "Calling marketplaceService:purchaseItem for", player.Name, itemId)
	local success, errorMessage, transactionData = marketplaceService:purchaseItem(player, itemId)

	if success then
		logger:info("ShopService", "Purchase successful - firing success event to client")
		logger:info(
			"ShopService",
			"Transaction data - Item:",
			itemId,
			"Coins spent:",
			transactionData.coinsSpent,
			"Gems spent:",
			transactionData.gemsSpent,
			"Total value:",
			transactionData.totalValue
		)

		-- Fire success event to client
		local successData = {
			itemId = itemId,
			transactionData = transactionData,
			timestamp = tick(),
		}
		local fireSuccess =
			remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_PURCHASE_SUCCESS, successData)

		if fireSuccess then
			logger:info("ShopService", "Successfully fired SHOP_PURCHASE_SUCCESS event for", player.Name, itemId)
		else
			logger:warn("ShopService", "Failed to fire SHOP_PURCHASE_SUCCESS event for", player.Name, itemId)
		end

		-- Send updated player data to client
		local playerService = self.diContainer:resolve("PlayerService")
		playerService:updatePlayer(player)
	else
		logger:warn("ShopService", "Purchase failed for", player.Name, itemId, "- Error:", errorMessage)

		-- Fire failure event to client
		local failureData = {
			itemId = itemId,
			error = errorMessage,
			timestamp = tick(),
		}
		local fireFailure =
			remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_PURCHASE_FAILED, failureData)

		if fireFailure then
			logger:info("ShopService", "Successfully fired SHOP_PURCHASE_FAILED event for", player.Name, itemId)
		else
			logger:warn("ShopService", "Failed to fire SHOP_PURCHASE_FAILED event for", player.Name, itemId)
		end
	end
end

function ShopService:handleEquipRequest(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")
	local marketplaceService = self.diContainer:resolve("Shared.Application.Services").marketplaceService

	logger:info(
		"ShopService",
		"Processing equip request - Player:",
		player.Name,
		"ItemID:",
		itemId,
		"UserID:",
		player.UserId
	)

	logger:info("ShopService", "Calling marketplaceService:equipItem for", player.Name, itemId)
	local success, errorMessage = marketplaceService:equipItem(player, itemId)

	if success then
		logger:info("ShopService", "Item equipped successfully:", player.Name, itemId)

		-- Fire equip success event to client
		local equipData = {
			itemId = itemId,
			action = "equipped",
			timestamp = tick(),
		}
		local fireSuccess =
			remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_EQUIP_REQUEST .. "_SUCCESS", equipData)

		if fireSuccess then
			logger:info("ShopService", "Successfully fired equip success event for", player.Name, itemId)
		else
			logger:warn("ShopService", "Failed to fire equip success event for", player.Name, itemId)
		end
	else
		logger:warn("ShopService", "Equip failed:", player.Name, itemId, "- Error:", errorMessage)

		-- Fire equip failure event to client
		local failureData = {
			itemId = itemId,
			error = errorMessage,
			timestamp = tick(),
		}
		local fireFailure =
			remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_EQUIP_REQUEST .. "_FAILED", failureData)

		if fireFailure then
			logger:info("ShopService", "Successfully fired equip failure event for", player.Name, itemId)
		else
			logger:warn("ShopService", "Failed to fire equip failure event for", player.Name, itemId)
		end
	end
end

function ShopService:handleUnequipRequest(player, itemId)
	local logger = self.diContainer:resolve("Logger")
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")
	local marketplaceService = self.diContainer:resolve("Shared.Application.Services").marketplaceService

	logger:info(
		"ShopService",
		"Processing unequip request - Player:",
		player.Name,
		"ItemID:",
		itemId,
		"UserID:",
		player.UserId
	)

	logger:info("ShopService", "Calling marketplaceService:unequipItem for", player.Name, itemId)
	local success, errorMessage = marketplaceService:unequipItem(player, itemId)

	if success then
		logger:info("ShopService", "Item unequipped successfully:", player.Name, itemId)

		-- Fire unequip success event to client
		local unequipData = {
			itemId = itemId,
			action = "unequipped",
			timestamp = tick(),
		}
		local fireSuccess = remoteEventService:fireClient(
			player,
			constants.REMOTE_EVENTS.SHOP_UNEQUIP_REQUEST .. "_SUCCESS",
			unequipData
		)

		if fireSuccess then
			logger:info("ShopService", "Successfully fired unequip success event for", player.Name, itemId)
		else
			logger:warn("ShopService", "Failed to fire unequip success event for", player.Name, itemId)
		end
	else
		logger:warn("ShopService", "Unequip failed:", player.Name, itemId, "- Error:", errorMessage)

		-- Fire unequip failure event to client
		local failureData = {
			itemId = itemId,
			error = errorMessage,
			timestamp = tick(),
		}
		local fireFailure = remoteEventService:fireClient(
			player,
			constants.REMOTE_EVENTS.SHOP_UNEQUIP_REQUEST .. "_FAILED",
			failureData
		)

		if fireFailure then
			logger:info("ShopService", "Successfully fired unequip failure event for", player.Name, itemId)
		else
			logger:warn("ShopService", "Failed to fire unequip failure event for", player.Name, itemId)
		end
	end
end

function ShopService:handleDevProductRequest(player, productId)
	local logger = self.diContainer:resolve("Logger")
	local developerProductsService = self.diContainer:resolve("DeveloperProductsService")

	logger:info(
		"ShopService",
		"Processing developer product request - Player:",
		player.Name,
		"ProductID:",
		productId,
		"UserID:",
		player.UserId
	)

	logger:info("ShopService", "Calling developerProductsService:promptPurchase for", player.Name, productId)
	local success, errorMessage = developerProductsService:promptPurchase(player, productId)

	if not success then
		logger:warn(
			"ShopService",
			"Developer product request failed:",
			player.Name,
			productId,
			"- Error:",
			errorMessage
		)

		-- Fire failure event to client
		local remoteEventService = self.diContainer:resolve("RemoteEventService")
		local constants = self.diContainer:resolve("Shared.Constants")

		local failureData = {
			productId = productId,
			error = errorMessage,
			isDeveloperProduct = true,
			timestamp = tick(),
		}
		local fireFailure =
			remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_PURCHASE_FAILED, failureData)

		if fireFailure then
			logger:info("ShopService", "Successfully fired developer product failure event for", player.Name, productId)
		else
			logger:warn("ShopService", "Failed to fire developer product failure event for", player.Name, productId)
		end
	else
		logger:info(
			"ShopService",
			"Developer product prompt successful - Roblox purchase prompt shown to",
			player.Name,
			"for product",
			productId
		)
	end
end

return ShopService
