---@class DeveloperProductsService
---@field diContainer DIContainer
local DeveloperProductsService = {}
DeveloperProductsService.__index = DeveloperProductsService

---@param diContainer DIContainer
---@return DeveloperProductsService
function DeveloperProductsService.new(diContainer)
	local self = setmetatable({}, DeveloperProductsService)
	self.diContainer = diContainer

	-- Developer Product IDs and their rewards
	self.products = {
		-- Coin packages
		[123456789] = { -- Replace with actual Developer Product IDs
			name = "Coin Pack Small",
			reward = {coins = 500, gems = 0},
			price = 4.99
		},
		[123456790] = {
			name = "Coin Pack Medium",
			reward = {coins = 1200, gems = 10},
			price = 9.99
		},
		[123456791] = {
			name = "Coin Pack Large",
			reward = {coins = 2500, gems = 25},
			price = 19.99
		},

		-- Gem packages
		[123456792] = {
			name = "Gem Pack Small",
			reward = {coins = 0, gems = 50},
			price = 4.99
		},
		[123456793] = {
			name = "Gem Pack Large",
			reward = {coins = 1000, gems = 100},
			price = 14.99
		}
	}

	return self
end

function DeveloperProductsService:init()
	local logger = self.diContainer:resolve("Logger")
	logger:info("DeveloperProductsService", "Initializing Developer Products...")

	-- Connect to MarketplaceService.PromptPurchaseFinished
	local MarketplaceService = game:GetService("MarketplaceService")

	MarketplaceService.PromptPurchaseFinished:Connect(function(player, productId, wasPurchased)
		self:_onPurchaseFinished(player, productId, wasPurchased)
	end)

	MarketplaceService.ProcessReceipt = function(receiptInfo)
		return self:_processReceipt(receiptInfo)
	end

	logger:info("DeveloperProductsService", "Developer Products initialized successfully")
end

---@param player Player
---@param productId number
function DeveloperProductsService:promptPurchase(player, productId)
	local logger = self.diContainer:resolve("Logger")

	if not self.products[productId] then
		logger:warn("DeveloperProductsService", "Unknown product ID:", productId)
		return false, "Unknown product"
	end

	local MarketplaceService = game:GetService("MarketplaceService")

	local success, errorMessage = pcall(function()
		MarketplaceService:PromptPurchase(player, productId)
	end)

	if not success then
		logger:error("DeveloperProductsService", "Failed to prompt purchase:", errorMessage)
		return false, errorMessage
	end

	logger:info("DeveloperProductsService", "Prompted purchase for player:", player.Name, "product:", productId)
	return true, ""
end

---@param player Player
---@param productId number
---@param wasPurchased boolean
function DeveloperProductsService:_onPurchaseFinished(player, productId, wasPurchased)
	local logger = self.diContainer:resolve("Logger")

	logger:info("DeveloperProductsService", "Purchase finished for player:", player.Name, "product:", productId, "purchased:", wasPurchased)

	-- Note: Actual reward granting happens in ProcessReceipt
	-- This event is mainly for UI feedback
end

---@param receiptInfo table
---@return Enum.ProductPurchaseDecision
function DeveloperProductsService:_processReceipt(receiptInfo)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")

	logger:info("DeveloperProductsService", "Processing receipt for product:", receiptInfo.ProductId)

	local player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		logger:warn("DeveloperProductsService", "Player not found for receipt:", receiptInfo.PlayerId)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local productData = self.products[receiptInfo.ProductId]
	if not productData then
		logger:error("DeveloperProductsService", "Unknown product in receipt:", receiptInfo.ProductId)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Get player entity
	local playerEntity = playerService:getPlayerEntity(player)
	if not playerEntity then
		logger:warn("DeveloperProductsService", "Player entity not found:", player.Name)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Grant rewards
	local rewards = productData.reward
	if rewards.coins and rewards.coins > 0 then
		playerEntity:addCurrency("coins", rewards.coins)
		logger:info("DeveloperProductsService", "Granted", rewards.coins, "coins to", player.Name)
	end

	if rewards.gems and rewards.gems > 0 then
		playerEntity:addCurrency("gems", rewards.gems)
		logger:info("DeveloperProductsService", "Granted", rewards.gems, "gems to", player.Name)
	end

	-- Save player data
	playerService:savePlayerData(player)

	-- Fire client event to update UI
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.SHOP_PURCHASE_SUCCESS, {
		productId = receiptInfo.ProductId,
		rewards = rewards,
		isDeveloperProduct = true
	})

	logger:info("DeveloperProductsService", "Successfully processed receipt for:", player.Name, "product:", receiptInfo.ProductId)

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

---@return table -- Array of product data
function DeveloperProductsService:getAvailableProducts()
	local productsArray = {}

	for productId, productData in pairs(self.products) do
		table.insert(productsArray, {
			id = productId,
			name = productData.name,
			reward = productData.reward,
			price = productData.price
		})
	end

	return productsArray
end

---@param productId number
---@return table|nil -- Product data or nil if not found
function DeveloperProductsService:getProductData(productId)
	return self.products[productId]
end

return DeveloperProductsService
