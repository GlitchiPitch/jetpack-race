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

	
end

function ShopFrame:init()
	-- Create frame using BaseFrame component
	---@type Components
	local components = self.diContainer:resolve("UIComponents")

	self.frame = components.BaseFrame.new(self.diContainer, self.player.PlayerGui)
	-- Header section
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
	self.balanceFrame = Instance.new("Frame")
	self.balanceFrame.Size = UDim2.new(0.3, 0, 1, 0)
	self.balanceFrame.Position = UDim2.new(0.65, 0, 0, 0)
	self.balanceFrame.BackgroundTransparency = 1
	self.balanceFrame.Parent = headerFrame

	self:_updateBalanceDisplay()

	-- Add close button
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
		self:close()
	end)

	-- Content area
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, 0, 0.92, 0)
	contentFrame.Position = UDim2.new(0, 0, 0.08, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = self.frame

	-- Initialize ShopCatalog
	local ShopCatalog = require(script.Parent.ShopCatalog)
	self.shopCatalog = ShopCatalog.new(self.diContainer, contentFrame)

	-- Initialize PurchaseDialog
	local PurchaseDialog = require(script.Parent.PurchaseDialog)
	self.purchaseDialog = PurchaseDialog.new(self.diContainer, self.frame)

	-- Initialize ItemPreview
	local ItemPreview = require(script.Parent.ItemPreview)
	self.itemPreview = ItemPreview.new(self.diContainer, self.frame, self.purchaseDialog)

	-- Listen for item selection events
	self:_setupRemoteEventListeners()
end

function ShopFrame:_updateBalanceDisplay()
	if not self.balanceFrame then
		return
	end

	-- Clear existing balance display
	for _, child in ipairs(self.balanceFrame:GetChildren()) do
		child:Destroy()
	end

	-- Get player currency
	local playerService = self.diContainer:resolve("PlayerService")
	local playerEntity = playerService:getPlayerEntity(game.Players.LocalPlayer)

	if not playerEntity then
		return
	end

	local currency = playerEntity:getCurrencyData()

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
end

function ShopFrame:open()
	if self.isOpen then
		return
	end

	self.isOpen = true
	self.baseFrame:open()

	-- Update balance and owned items
	self:_updateBalanceDisplay()
	if self.shopCatalog then
		self.shopCatalog:updateOwnedIndicators()
	end

	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopFrame", "Shop frame opened")
end

function ShopFrame:close()
	if not self.isOpen then
		return
	end

	self.isOpen = false
	self.baseFrame:close()

	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopFrame", "Shop frame closed")
end

function ShopFrame:_setupRemoteEventListeners()
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Listen for item selection
	local itemSelectedConnection = remoteEventService:listenToClient(
		constants.REMOTE_EVENTS.SHOP_ITEM_SELECTED,
		function(data)
			if data.itemId then
				self:_showItemPreview(data.itemId)
			end
		end
	)

	-- Listen for purchase results
	local purchaseSuccessConnection = remoteEventService:listenToClient(
		constants.REMOTE_EVENTS.SHOP_PURCHASE_SUCCESS,
		function(data)
			if data.itemId then
				self:_onPurchaseSuccess(data.itemId)
			end
		end
	)

	local purchaseFailedConnection = remoteEventService:listenToClient(
		constants.REMOTE_EVENTS.SHOP_PURCHASE_FAILED,
		function(data)
			if data.error then
				self:_onPurchaseFailed(data.error, data.isDeveloperProduct)
			end
		end
	)

	-- Store connections for cleanup
	self.remoteConnections = {
		itemSelectedConnection,
		purchaseSuccessConnection,
		purchaseFailedConnection,
	}
end

function ShopFrame:_showItemPreview(itemId)
	-- Find item data
	local shopData = self.diContainer:resolve("Shared.Data")
	local itemData = nil

	for _, item in ipairs(shopData.ShopItems) do
		if item.id == itemId then
			itemData = item
			break
		end
	end

	if itemData and self.itemPreview then
		self.itemPreview:showItem(itemData)
	end
end

function ShopFrame:_onPurchaseSuccess(itemId)
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopFrame", "Purchase successful for item:", itemId)

	-- Update balance display
	self:_updateBalanceDisplay()

	-- Update owned items indicators
	if self.shopCatalog then
		self.shopCatalog:updateOwnedIndicators()
	end

	-- Update item preview if it's showing the purchased item
	if self.itemPreview and self.itemPreview.currentItem and self.itemPreview.currentItem.id == itemId then
		self.itemPreview:_updateActionButtons(self.itemPreview.currentItem)
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

	if self.frame then
		self.frame:Destroy()
	end
end

return ShopFrame
