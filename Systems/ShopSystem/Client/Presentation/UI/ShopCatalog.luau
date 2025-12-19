---@class ShopCatalog
local ShopCatalog = {}
ShopCatalog.__index = ShopCatalog

---@param diContainer DIContainer
---@param parentFrame Frame
---@return ShopCatalog
function ShopCatalog.new(diContainer, parentFrame)
	local self = setmetatable({}, ShopCatalog)
	self.diContainer = diContainer
	self.parentFrame = parentFrame
	self.items = {}
	self.itemButtons = {}

	self:_setupUI()
	self:_loadShopItems()

	return self
end

function ShopCatalog:_setupUI()
	-- Create main scrolling frame
	self.scrollingFrame = Instance.new("ScrollingFrame")
	self.scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	self.scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
	self.scrollingFrame.BackgroundTransparency = 1
	self.scrollingFrame.BorderSizePixel = 0
	self.scrollingFrame.ScrollBarThickness = 8
	self.scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be set dynamically
	self.scrollingFrame.Parent = self.parentFrame

	-- Create grid layout
	self.gridLayout = Instance.new("UIGridLayout")
	self.gridLayout.CellSize = UDim2.new(0, 150, 0, 180)
	self.gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	self.gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	self.gridLayout.Parent = self.scrollingFrame

	-- Create category filter buttons
	self:_createCategoryFilters()
end

function ShopCatalog:_createCategoryFilters()
	local categories = {"All", "Jetpacks", "Trails", "Effects"}
	local yOffset = 0

	for i, category in ipairs(categories) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0, 100, 0, 30)
		button.Position = UDim2.new(0, (i-1) * 110, 0, yOffset)
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		button.Text = category
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextScaled = true
		button.Parent = self.parentFrame

		-- Add border
		local border = Instance.new("UIStroke")
		border.Color = Color3.fromRGB(100, 100, 100)
		border.Parent = button

		button.MouseButton1Click:Connect(function()
			self:_filterItems(category)
			self:_updateCategoryButtonStyles(category)
		end)
	end

	-- Adjust parent frame to account for filter buttons
	self.scrollingFrame.Position = UDim2.new(0, 0, 0, 40)
	self.scrollingFrame.Size = UDim2.new(1, 0, 1, -40)
end

function ShopCatalog:_updateCategoryButtonStyles(selectedCategory)
	-- Update all category buttons
	for _, child in ipairs(self.parentFrame:GetChildren()) do
		if child:IsA("TextButton") and child ~= self.scrollingFrame then
			if child.Text == selectedCategory then
				child.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			else
				child.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			end
		end
	end
end

function ShopCatalog:_loadShopItems()
	local shopData = self.diContainer:resolve("Shared.Data")

	-- Clear existing items
	for _, button in ipairs(self.itemButtons) do
		button:Destroy()
	end
	self.itemButtons = {}

	-- Create item buttons
	for i, itemData in ipairs(shopData.ShopItems) do
		local itemButton = self:_createItemButton(itemData)
		itemButton.LayoutOrder = i
		itemButton.Parent = self.scrollingFrame
		table.insert(self.itemButtons, itemButton)
	end

	-- Update canvas size
	self:_updateCanvasSize()

	-- Set default filter to "All"
	self:_filterItems("All")
	self:_updateCategoryButtonStyles("All")
end

function ShopCatalog:_createItemButton(itemData)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 150, 0, 180)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.Text = ""
	button.AutoButtonColor = false

	-- Add border
	local border = Instance.new("UIStroke")
	border.Color = self:_getRarityColor(itemData.rarity)
	border.Thickness = 2
	border.Parent = button

	-- Item icon
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0.8, 0, 0.6, 0)
	icon.Position = UDim2.new(0.1, 0, 0.05, 0)
	icon.BackgroundTransparency = 1
	icon.Image = itemData.icon
	icon.Parent = button

	-- Item name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
	nameLabel.Position = UDim2.new(0.05, 0, 0.68, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = itemData.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.Parent = button

	-- Price display
	local priceFrame = Instance.new("Frame")
	priceFrame.Size = UDim2.new(0.9, 0, 0.12, 0)
	priceFrame.Position = UDim2.new(0.05, 0, 0.85, 0)
	priceFrame.BackgroundTransparency = 1
	priceFrame.Parent = button

	-- Coins price
	if itemData.price.coins and itemData.price.coins > 0 then
		local coinLabel = Instance.new("TextLabel")
		coinLabel.Size = UDim2.new(0.45, 0, 1, 0)
		coinLabel.Position = UDim2.new(0, 0, 0, 0)
		coinLabel.BackgroundTransparency = 1
		coinLabel.Text = "🪙 " .. tostring(itemData.price.coins)
		coinLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		coinLabel.TextScaled = true
		coinLabel.Font = Enum.Font.SourceSans
		coinLabel.Parent = priceFrame
	end

	-- Gems price
	if itemData.price.gems and itemData.price.gems > 0 then
		local gemLabel = Instance.new("TextLabel")
		gemLabel.Size = UDim2.new(0.45, 0, 1, 0)
		gemLabel.Position = UDim2.new(0.55, 0, 0, 0)
		gemLabel.BackgroundTransparency = 1
		gemLabel.Text = "💎 " .. tostring(itemData.price.gems)
		gemLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
		gemLabel.TextScaled = true
		gemLabel.Font = Enum.Font.SourceSans
		gemLabel.Parent = priceFrame
	end

	-- Rarity indicator
	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
	rarityLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.Text = string.upper(itemData.rarity)
	rarityLabel.TextColor3 = self:_getRarityColor(itemData.rarity)
	rarityLabel.TextScaled = true
	rarityLabel.Font = Enum.Font.SourceSansBold
	rarityLabel.Parent = button

	-- Store item data for later use
	button:SetAttribute("ItemId", itemData.id)
	button:SetAttribute("Category", itemData.category)

	-- Connect click event
	button.MouseButton1Click:Connect(function()
		self:_onItemClicked(itemData)
	end)

	return button
end

function ShopCatalog:_getRarityColor(rarity)
	local shopData = self.diContainer:resolve("Shared.Data")
	return shopData.RarityColors[rarity] or Color3.fromRGB(150, 150, 150)
end

function ShopCatalog:_filterItems(category)
	for _, button in ipairs(self.itemButtons) do
		if category == "All" then
			button.Visible = true
		else
			button.Visible = button:GetAttribute("Category") == category
		end
	end

	self:_updateCanvasSize()
end

function ShopCatalog:_updateCanvasSize()
	local visibleCount = 0
	for _, button in ipairs(self.itemButtons) do
		if button.Visible then
			visibleCount = visibleCount + 1
		end
	end

	local columns = math.floor(self.scrollingFrame.AbsoluteSize.X / 160) -- 150 + 10 padding
	local rows = math.ceil(visibleCount / columns)

	self.scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, rows * 190) -- 180 + 10 padding
end

function ShopCatalog:_onItemClicked(itemData)
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopCatalog", "Item clicked:", itemData.id)

	-- Fire event to show item details/preview
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireServer(constants.REMOTE_EVENTS.SHOP_ITEM_SELECTED, {
		itemId = itemData.id,
		player = game.Players.LocalPlayer
	})
end

function ShopCatalog:updateOwnedIndicators()
	local player = game.Players.LocalPlayer
	local marketplaceService = self.diContainer:resolve("Shared.Services").marketplaceService
	local ownedItems = marketplaceService:getOwnedItems(player)

	for _, button in ipairs(self.itemButtons) do
		local itemId = button:GetAttribute("ItemId")
		local isOwned = ownedItems[itemId] or false

		-- Update button appearance for owned items
		if isOwned then
			button.BackgroundColor3 = Color3.fromRGB(70, 100, 70) -- Green tint for owned

			-- Add "OWNED" label
			local ownedLabel = button:FindFirstChild("OwnedLabel")
			if not ownedLabel then
				ownedLabel = Instance.new("TextLabel")
				ownedLabel.Name = "OwnedLabel"
				ownedLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
				ownedLabel.Position = UDim2.new(0.1, 0, 0.02, 0)
				ownedLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
				ownedLabel.Text = "OWNED"
				ownedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				ownedLabel.TextScaled = true
				ownedLabel.Font = Enum.Font.SourceSansBold
				ownedLabel.Parent = button
			end
		else
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

			-- Remove owned label if it exists
			local ownedLabel = button:FindFirstChild("OwnedLabel")
			if ownedLabel then
				ownedLabel:Destroy()
			end
		end
	end
end

function ShopCatalog:destroy()
	if self.scrollingFrame then
		self.scrollingFrame:Destroy()
	end
end

return ShopCatalog
