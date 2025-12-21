local Players = game:GetService("Players")
---@class ShopFrame
local ShopFrame = {}
ShopFrame.__index = ShopFrame

---@param diContainer DIContainer
---@return ShopFrame
function ShopFrame.new(diContainer)
	local self = setmetatable({}, ShopFrame)
	self.diContainer = diContainer
	self.isOpen = false
	self.player = Players.LocalPlayer
	self.playerData = nil -- Will be updated via RemoteEvent
	return self
end

function ShopFrame:init()
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopFrame", "Initializing shop frame for player:", self.player.Name, "(ID:", self.player.UserId, ")")

	-- Create frame using BaseFrame component
	---@type Components
	local components = self.diContainer:resolve("UIComponents")

	logger:info("ShopFrame", "Creating BaseFrame component")
	self.baseFrame = components.BaseFrame.new(self.diContainer, self.player.PlayerGui)
	self.frame = self.baseFrame.frame
	logger:info("ShopFrame", "BaseFrame created successfully")

	-- Header section
	logger:info("ShopFrame", "Setting up header section")
	local headerFrame = Instance.new("Frame")
	headerFrame.Size = UDim2.new(1, 0, 0.08, 0)
	headerFrame.Position = UDim2.new(0, 0, 0, 0)
	headerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	headerFrame.BackgroundTransparency = 0.1
	headerFrame.Parent = self.frame

	-- Add title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.6, 0, 1, 0)
	title.Position = UDim2.new(0.05, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Jetpack Shop"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.SourceSansBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = headerFrame

	-- Balance display
	logger:info("ShopFrame", "Setting up balance display frame")
	self.balanceFrame = Instance.new("Frame")
	self.balanceFrame.Size = UDim2.new(0.3, 0, 1, 0)
	self.balanceFrame.Position = UDim2.new(0.65, 0, 0, 0)
	self.balanceFrame.BackgroundTransparency = 1
	self.balanceFrame.Parent = headerFrame

	logger:info("ShopFrame", "Balance display frame created - will be updated when shop opens")

	-- Add close button
	logger:info("ShopFrame", "Setting up close button")
	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0.05, 0, 0.8, 0)
	closeButton.Position = UDim2.new(0.95, 0, 0.1, 0)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextScaled = true
	closeButton.Font = Enum.Font.SourceSansBold
	closeButton.Parent = headerFrame

	-- Connect close button
	closeButton.MouseButton1Click:Connect(function()
		logger:info("ShopFrame", "Close button clicked by player:", self.player.Name)
		self:close()
	end)

	-- Content area
	logger:info("ShopFrame", "Setting up content area")
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, 0, 0.92, 0)
	contentFrame.Position = UDim2.new(0, 0, 0.08, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = self.frame

	-- Initialize ShopCatalog
	logger:info("ShopFrame", "Initializing ShopCatalog component")
	local ShopCatalog = require(script.Parent.ShopCatalog)
	self.shopCatalog = ShopCatalog.new(self.diContainer, contentFrame)

	-- Initialize PurchaseDialog
	logger:info("ShopFrame", "Initializing PurchaseDialog component")
	local PurchaseDialog = require(script.Parent.PurchaseDialog)
	self.purchaseDialog = PurchaseDialog.new(self.diContainer, self.frame)

	-- Initialize ItemPreview
	logger:info("ShopFrame", "Initializing ItemPreview component")
	local ItemPreview = require(script.Parent.ItemPreview)
	self.itemPreview = ItemPreview.new(self.diContainer, self.frame, self.purchaseDialog)

	-- Listen for item selection events
	logger:info("ShopFrame", "Setting up remote event listeners")
	self:_setupRemoteEventListeners()

	logger:info("ShopFrame", "ShopFrame initialization completed successfully")
end

function ShopFrame:_updateBalanceDisplay()
	local logger = self.diContainer:resolve("Logger")

	if not self.balanceFrame then
		logger:warn("ShopFrame", "Balance frame not found, cannot update display")
		return
	end

	logger:info("ShopFrame", "Updating balance display for player:", self.player.Name)

	-- Clear existing balance display
	local childrenCount = #self.balanceFrame:GetChildren()
	for _, child in ipairs(self.balanceFrame:GetChildren()) do
		child:Destroy()
	end
	logger:info("ShopFrame", "Cleared", childrenCount, "existing balance display elements")

	-- Get player currency from local data
	if not self.playerData then
		logger:warn("ShopFrame", "Player data not available, cannot update balance display")
		return
	end

	local currency = self.playerData.currency
	logger:info("ShopFrame", "Retrieved currency data - Coins:", currency.coins, "Gems:", currency.gems)

	-- Coins display
	local coinLabel = Instance.new("TextLabel")
	coinLabel.Size = UDim2.new(0.45, 0, 1, 0)
	coinLabel.Position = UDim2.new(0, 0, 0, 0)
	coinLabel.BackgroundTransparency = 1
	coinLabel.Text = "🪙 " .. tostring(currency.coins)
	coinLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	coinLabel.TextScaled = true
	coinLabel.Font = Enum.Font.SourceSansBold
	coinLabel.Parent = self.balanceFrame
	logger:info("ShopFrame", "Created coin display label with text:", coinLabel.Text)

	-- Gems display
	local gemLabel = Instance.new("TextLabel")
	gemLabel.Size = UDim2.new(0.45, 0, 1, 0)
	gemLabel.Position = UDim2.new(0.55, 0, 0, 0)
	gemLabel.BackgroundTransparency = 1
	gemLabel.Text = "💎 " .. tostring(currency.gems)
	gemLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
	gemLabel.TextScaled = true
	gemLabel.Font = Enum.Font.SourceSansBold
	gemLabel.Parent = self.balanceFrame
	logger:info("ShopFrame", "Created gem display label with text:", gemLabel.Text)

	logger:info("ShopFrame", "Balance display updated successfully")
end

function ShopFrame:open()
	local logger = self.diContainer:resolve("Logger")

	if self.isOpen then
		logger:info("ShopFrame", "Shop frame already open, ignoring open request")
		return
	end

	logger:info("ShopFrame", "Opening shop frame for player:", self.player.Name)
	self.isOpen = true

	logger:info("ShopFrame", "Calling frame:open()")
	self.baseFrame:open()

	-- Update balance and owned items
	logger:info("ShopFrame", "Updating balance display")
	self:_updateBalanceDisplay()

	if self.shopCatalog then
		logger:info("ShopFrame", "Updating owned item indicators in catalog")
		self.shopCatalog:updateOwnedIndicators(self.playerData)
	else
		logger:warn("ShopFrame", "ShopCatalog not found, cannot update owned indicators")
	end

	logger:info("ShopFrame", "Shop frame opened successfully")
end

function ShopFrame:close()
	local logger = self.diContainer:resolve("Logger")

	if not self.isOpen then
		logger:info("ShopFrame", "Shop frame already closed, ignoring close request")
		return
	end

	logger:info("ShopFrame", "Closing shop frame for player:", self.player.Name)
	self.isOpen = false

	logger:info("ShopFrame", "Calling frame:close()")
	self.baseFrame:close()

	logger:info("ShopFrame", "Shop frame closed successfully")
end

function ShopFrame:_setupRemoteEventListeners()
	local logger = self.diContainer:resolve("Logger")
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	logger:info("ShopFrame", "Setting up remote event listeners")

	-- Listen for item selection
	logger:info("ShopFrame", "Setting up SHOP_ITEM_SELECTED listener")
	local itemSelectedConnection = remoteEventService:connectToEvent(
		constants.REMOTE_EVENTS.SHOP_ITEM_SELECTED,
		function(data)
			logger:info("ShopFrame", "Received SHOP_ITEM_SELECTED event with data:", data)
			if data.itemId then
				logger:info("ShopFrame", "Showing item preview for:", data.itemId)
				self:_showItemPreview(data.itemId)
			else
				logger:warn("ShopFrame", "SHOP_ITEM_SELECTED event missing itemId")
			end
		end
	)

	-- Listen for purchase results
	logger:info("ShopFrame", "Setting up SHOP_PURCHASE_SUCCESS listener")
	local purchaseSuccessConnection = remoteEventService:connectToEvent(
		constants.REMOTE_EVENTS.SHOP_PURCHASE_SUCCESS,
		function(data)
			logger:info("ShopFrame", "Received SHOP_PURCHASE_SUCCESS event with data:", data)
			if data.itemId then
				logger:info("ShopFrame", "Processing successful purchase for:", data.itemId)
				self:_onPurchaseSuccess(data.itemId)
			else
				logger:warn("ShopFrame", "SHOP_PURCHASE_SUCCESS event missing itemId")
			end
		end
	)

	logger:info("ShopFrame", "Setting up SHOP_PURCHASE_FAILED listener")
	local purchaseFailedConnection = remoteEventService:connectToEvent(
		constants.REMOTE_EVENTS.SHOP_PURCHASE_FAILED,
		function(data)
			logger:info("ShopFrame", "Received SHOP_PURCHASE_FAILED event with data:", data)
			if data.error then
				logger:info(
					"ShopFrame",
					"Processing purchase failure - Error:",
					data.error,
					"IsDevProduct:",
					data.isDeveloperProduct or false
				)
				self:_onPurchaseFailed(data.error, data.isDeveloperProduct)
			else
				logger:warn("ShopFrame", "SHOP_PURCHASE_FAILED event missing error data")
			end
		end
	)

	-- Listen for player data updates
	logger:info("ShopFrame", "Setting up PLAYER_UPDATED listener")
	local playerUpdatedConnection = remoteEventService:connectToEvent(
		constants.REMOTE_EVENTS.PLAYER_UPDATED,
		function(data)
			logger:info("ShopFrame", "Received PLAYER_UPDATED event")
			if data.playerData then
				self.playerData = data.playerData
				logger:info(
					"ShopFrame",
					"Player data updated - Currency: Coins=",
					data.playerData.currency.coins,
					"Gems=",
					data.playerData.currency.gems
				)
				-- Update balance display if shop is open
				if self.isOpen then
					self:_updateBalanceDisplay()
				end
			else
				logger:warn("ShopFrame", "PLAYER_UPDATED event missing playerData")
			end
		end
	)

	-- Store connections for cleanup
	self.remoteConnections = {
		itemSelectedConnection,
		purchaseSuccessConnection,
		purchaseFailedConnection,
		playerUpdatedConnection,
	}

	logger:info("ShopFrame", "Remote event listeners setup completed -", #self.remoteConnections, "connections created")
end

function ShopFrame:_showItemPreview(itemId)
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopFrame", "Showing item preview for itemId:", itemId)

	-- Find item data
	local shopData = self.diContainer:resolve("Shared.Data")
	local itemData = nil

	logger:info("ShopFrame", "Searching for item data among", #shopData.ShopItems, "items")
	for _, item in ipairs(shopData.ShopItems) do
		if item.id == itemId then
			itemData = item
			logger:info(
				"ShopFrame",
				"Found item data - Name:",
				itemData.name,
				"Type:",
				itemData.type,
				"Price:",
				itemData.price
			)
			break
		end
	end

	if itemData and self.itemPreview then
		logger:info("ShopFrame", "Calling itemPreview:showItem() for", itemId)
		self.itemPreview:showItem(itemData, self.playerData)
		logger:info("ShopFrame", "Item preview shown successfully for", itemId)
	elseif not itemData then
		logger:warn("ShopFrame", "Item data not found for itemId:", itemId)
	elseif not self.itemPreview then
		logger:warn("ShopFrame", "ItemPreview component not available for itemId:", itemId)
	end
end

function ShopFrame:_onPurchaseSuccess(itemId)
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopFrame", "Purchase successful for item:", itemId)

	-- Update balance display
	self:_updateBalanceDisplay()

	-- Update owned items indicators
	if self.shopCatalog then
		self.shopCatalog:updateOwnedIndicators(self.playerData)
	end

	-- Update item preview if it's showing the purchased item
	if self.itemPreview and self.itemPreview.currentItem and self.itemPreview.currentItem.id == itemId then
		self.itemPreview:_updateActionButtons(self.itemPreview.currentItem, self.playerData)
	end

	-- Show success message (could be improved with a proper notification system)
	warn("Purchase successful! Item added to inventory.")
end

function ShopFrame:_onPurchaseFailed(errorMessage, isDeveloperProduct)
	local logger = self.diContainer:resolve("Logger")
	logger:warn("ShopFrame", "Purchase failed:", errorMessage, "isDevProduct:", isDeveloperProduct or false)

	-- Show error dialog
	if self.purchaseDialog then
		local errorText = errorMessage
		if isDeveloperProduct then
			errorText = "Developer Product purchase failed: " .. errorMessage
		end
		self.purchaseDialog:showErrorDialog(errorText)
	else
		-- Fallback to warn
		warn("Purchase failed:", errorMessage)
	end
end

function ShopFrame:destroy()
	self:close()

	if self.shopCatalog then
		self.shopCatalog:destroy()
	end

	if self.purchaseDialog then
		self.purchaseDialog:destroy()
	end

	if self.itemPreview then
		self.itemPreview:destroy()
	end

	-- Disconnect remote event listeners
	if self.remoteConnections then
		for _, connection in ipairs(self.remoteConnections) do
			if connection then
				connection:Disconnect()
			end
		end
	end

	if self.baseFrame and self.baseFrame.frame then
		self.baseFrame.frame:Destroy()
	end
end

return ShopFrame
