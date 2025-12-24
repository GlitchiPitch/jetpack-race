---@class ItemPreview
local ItemPreview = {}
ItemPreview.__index = ItemPreview

---@param diContainer DIContainer
---@param parentFrame Frame
---@param purchaseDialog PurchaseDialog
---@param existingFrame? Frame - Optional existing frame from model
---@return ItemPreview
function ItemPreview.new(diContainer, parentFrame, purchaseDialog, existingFrame)
	local self = setmetatable({}, ItemPreview)
	self.diContainer = diContainer
	self.parentFrame = parentFrame
	self.purchaseDialog = purchaseDialog
	self.currentItem = nil
	self.isVisible = false

	if existingFrame then
		self:_setupFromExistingFrame(existingFrame)
	else
		self:_setupUI()
	end

	return self
end

function ItemPreview:_setupFromExistingFrame(existingFrame)
	local logger = self.diContainer:resolve("Logger")
	logger:info("ItemPreview", "Setting up from existing frame")

	-- Use the existing frame from the model
	self.previewFrame = existingFrame
	self.previewFrame.Visible = false

	-- Find elements from the model
	self.iconImage = existingFrame:FindFirstChild("Icon")
	self.titleLabel = existingFrame:FindFirstChild("ItemName") -- ItemName serves as title
	self.itemNameLabel = existingFrame:FindFirstChild("ItemName")
	self.itemDescriptionLabel = existingFrame:FindFirstChild("ItemDescription")
	self.descriptionLabel = existingFrame:FindFirstChild("ItemDescription") -- Alias for compatibility
	self.subLabel = existingFrame:FindFirstChild("Sub")
	self.rarityLabel = existingFrame:FindFirstChild("Sub") -- Sub label can serve as rarity indicator

	-- Find action buttons (unnamed frames)
	local actionFrames = {}
	for _, child in ipairs(existingFrame:GetChildren()) do
		if child:IsA("Frame") and not child.Name:match("Icon|ItemName|ItemDescription|Sub") then
			table.insert(actionFrames, child)
		end
	end

	-- Assume first unnamed frame contains action buttons
	if #actionFrames >= 1 then
		local actionFrame = actionFrames[1]
		self.actionFrame = actionFrame -- Store reference to action frame
		self.buyButton = actionFrame:FindFirstChild("BuyButton")
		self.equipButton = actionFrame:FindFirstChild("EquipButton")
		self.unequipButton = actionFrame:FindFirstChild("UnequipButton")

		-- Connect button events
		if self.buyButton then
			self.buyButton.MouseButton1Click:Connect(function()
				if self.purchaseDialog and self.currentItem then
					self.purchaseDialog:showPurchaseDialog(self.currentItem)
				end
			end)
		end

		if self.equipButton then
			self.equipButton.MouseButton1Click:Connect(function()
				if self.currentItem then
					self:_equipItem(self.currentItem.id)
				end
			end)
		end

		if self.unequipButton then
			self.unequipButton.MouseButton1Click:Connect(function()
				if self.currentItem then
					self:_unequipItem(self.currentItem.id)
				end
			end)
		end
	end

	-- Create missing elements that are needed for functionality
	self:_createMissingElements(existingFrame)

	logger:info("ItemPreview", "Setup from existing frame completed")
end

function ItemPreview:_createMissingElements(existingFrame)
	-- Create price frame if it doesn't exist
	if not existingFrame:FindFirstChild("PriceFrame") then
		self.priceFrame = Instance.new("Frame")
		self.priceFrame.Name = "PriceFrame"
		self.priceFrame.Size = UDim2.new(0.9, 0, 0.08, 0)
		self.priceFrame.Position = UDim2.new(0.05, 0, 0.78, 0)
		self.priceFrame.BackgroundTransparency = 1
		self.priceFrame.Parent = existingFrame
	end

	-- Create 3D preview viewport if it doesn't exist
	if not existingFrame:FindFirstChild("PreviewViewport") then
		self.previewViewport = Instance.new("ViewportFrame")
		self.previewViewport.Name = "PreviewViewport"
		self.previewViewport.Size = UDim2.new(0.9, 0, 0.4, 0)
		self.previewViewport.Position = UDim2.new(0.05, 0, 0.17, 0)
		self.previewViewport.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		self.previewViewport.BackgroundTransparency = 0.2
		self.previewViewport.Parent = existingFrame

		-- Configure viewport
		local viewportBorder = Instance.new("UIStroke")
		viewportBorder.Color = Color3.fromRGB(80, 80, 80)
		viewportBorder.Parent = self.previewViewport

		self.previewViewport.CurrentCamera = Instance.new("Camera")
		self.previewViewport.CurrentCamera.CFrame = CFrame.new(0, 0, 5)
		self.previewViewport.CurrentCamera.Parent = self.previewViewport
	end

	-- Create close button if it doesn't exist
	if not existingFrame:FindFirstChild("CloseButton") then
		local closeButton = Instance.new("TextButton")
		closeButton.Name = "CloseButton"
		closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
		closeButton.Position = UDim2.new(0.9, 0, 0.01, 0)
		closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		closeButton.Text = "X"
		closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		closeButton.TextScaled = true
		closeButton.Font = Enum.Font.SourceSansBold
		closeButton.Parent = existingFrame

		closeButton.MouseButton1Click:Connect(function()
			self:hide()
		end)
	end
end

function ItemPreview:_setupUI()
	-- Main preview frame
	self.previewFrame = Instance.new("Frame")
	self.previewFrame.Size = UDim2.new(0.4, 0, 0.8, 0)
	self.previewFrame.Position = UDim2.new(0.55, 0, 0.1, 0)
	self.previewFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	self.previewFrame.BackgroundTransparency = 0.1
	self.previewFrame.Visible = false
	self.previewFrame.Parent = self.parentFrame

	-- Add border
	local border = Instance.new("UIStroke")
	border.Color = Color3.fromRGB(100, 100, 100)
	border.Thickness = 2
	border.Parent = self.previewFrame

	-- Title
	self.titleLabel = Instance.new("TextLabel")
	self.titleLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
	self.titleLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
	self.titleLabel.BackgroundTransparency = 1
	self.titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.titleLabel.TextScaled = true
	self.titleLabel.Font = Enum.Font.SourceSansBold
	self.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.titleLabel.Parent = self.previewFrame

	-- Rarity indicator
	self.rarityLabel = Instance.new("TextLabel")
	self.rarityLabel.Size = UDim2.new(0.9, 0, 0.05, 0)
	self.rarityLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
	self.rarityLabel.BackgroundTransparency = 1
	self.rarityLabel.TextScaled = true
	self.rarityLabel.Font = Enum.Font.SourceSansBold
	self.rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.rarityLabel.Parent = self.previewFrame

	-- 3D Preview area
	self.previewViewport = Instance.new("ViewportFrame")
	self.previewViewport.Size = UDim2.new(0.9, 0, 0.4, 0)
	self.previewViewport.Position = UDim2.new(0.05, 0, 0.17, 0)
	self.previewViewport.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	self.previewViewport.BackgroundTransparency = 0.2
	self.previewViewport.Parent = self.previewFrame

	-- Configure viewport
	local viewportBorder = Instance.new("UIStroke")
	viewportBorder.Color = Color3.fromRGB(80, 80, 80)
	viewportBorder.Parent = self.previewViewport

	self.previewViewport.CurrentCamera = Instance.new("Camera")
	self.previewViewport.CurrentCamera.CFrame = CFrame.new(0, 0, 5)
	self.previewViewport.CurrentCamera.Parent = self.previewViewport

	-- Description
	self.descriptionLabel = Instance.new("TextLabel")
	self.descriptionLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
	self.descriptionLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
	self.descriptionLabel.BackgroundTransparency = 1
	self.descriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	self.descriptionLabel.TextScaled = true
	self.descriptionLabel.Font = Enum.Font.SourceSans
	self.descriptionLabel.TextWrapped = true
	self.descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
	self.descriptionLabel.Parent = self.previewFrame

	-- Price display
	self.priceFrame = Instance.new("Frame")
	self.priceFrame.Size = UDim2.new(0.9, 0, 0.08, 0)
	self.priceFrame.Position = UDim2.new(0.05, 0, 0.78, 0)
	self.priceFrame.BackgroundTransparency = 1
	self.priceFrame.Parent = self.previewFrame

	-- Action buttons frame
	self.actionFrame = Instance.new("Frame")
	self.actionFrame.Size = UDim2.new(0.9, 0, 0.08, 0)
	self.actionFrame.Position = UDim2.new(0.05, 0, 0.88, 0)
	self.actionFrame.BackgroundTransparency = 1
	self.actionFrame.Parent = self.previewFrame

	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
	closeButton.Position = UDim2.new(0.9, 0, 0.01, 0)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextScaled = true
	closeButton.Font = Enum.Font.SourceSansBold
	closeButton.Parent = self.previewFrame

	closeButton.MouseButton1Click:Connect(function()
		self:hide()
	end)
end

---@param itemData table
function ItemPreview:showItem(itemData, playerData)
	self.currentItem = itemData
	self.isVisible = true
	self.previewFrame.Visible = true

	-- Update title
	self.titleLabel.Text = itemData.name

	-- Update rarity
	self.rarityLabel.Text = string.upper(itemData.rarity)
	local shopData = self.diContainer:resolve("Shared.Data")
	self.rarityLabel.TextColor3 = shopData.RarityColors[itemData.rarity] or Color3.fromRGB(150, 150, 150)

	-- Update description
	self.descriptionLabel.Text = itemData.description

	-- Update price display
	self:_updatePriceDisplay(itemData)

	-- Setup 3D preview
	self:_setup3DPreview(itemData)

	-- Update action buttons
	self:_updateActionButtons(itemData, playerData)

	local logger = self.diContainer:resolve("Logger")
	logger:info("ItemPreview", "Showing preview for item:", itemData.id)
end

function ItemPreview:_updatePriceDisplay(itemData)
	-- Clear existing price labels
	for _, child in ipairs(self.priceFrame:GetChildren()) do
		child:Destroy()
	end

	local xOffset = 0

	-- Coins price
	if itemData.price.coins and itemData.price.coins > 0 then
		local coinLabel = Instance.new("TextLabel")
		coinLabel.Size = UDim2.new(0.45, 0, 1, 0)
		coinLabel.Position = UDim2.new(xOffset, 0, 0, 0)
		coinLabel.BackgroundTransparency = 1
		coinLabel.Text = "🪙 " .. tostring(itemData.price.coins)
		coinLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		coinLabel.TextScaled = true
		coinLabel.Font = Enum.Font.SourceSansBold
		coinLabel.Parent = self.priceFrame
		xOffset = xOffset + 0.5
	end

	-- Gems price
	if itemData.price.gems and itemData.price.gems > 0 then
		local gemLabel = Instance.new("TextLabel")
		gemLabel.Size = UDim2.new(0.45, 0, 1, 0)
		gemLabel.Position = UDim2.new(xOffset, 0, 0, 0)
		gemLabel.BackgroundTransparency = 1
		gemLabel.Text = "💎 " .. tostring(itemData.price.gems)
		gemLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
		gemLabel.TextScaled = true
		gemLabel.Font = Enum.Font.SourceSansBold
		gemLabel.Parent = self.priceFrame
	end
end

function ItemPreview:_setup3DPreview(itemData)
	-- Clear existing preview objects
	for _, child in ipairs(self.previewViewport:GetChildren()) do
		if child:IsA("Model") or child:IsA("BasePart") or child:IsA("ParticleEmitter") then
			child:Destroy()
		end
	end

	if itemData.type == "jetpack" then
		self:_createJetpackPreview(itemData)
	elseif itemData.type == "trail" then
		self:_createTrailPreview(itemData)
	elseif itemData.type == "effect" then
		self:_createEffectPreview(itemData)
	end
end

function ItemPreview:_createJetpackPreview(itemData)
	-- Create a simple jetpack model for preview
	local jetpackModel = Instance.new("Model")
	jetpackModel.Name = "JetpackPreview"

	-- Main body
	local body = Instance.new("Part")
	body.Size = Vector3.new(2, 1, 1)
	body.Position = Vector3.new(0, 0, 0)
	body.Anchored = true
	body.CanCollide = false
	body.BrickColor = BrickColor.new("Really black")
	body.Parent = jetpackModel

	-- Thrusters
	local leftThruster = Instance.new("Part")
	leftThruster.Size = Vector3.new(0.5, 0.5, 0.5)
	leftThruster.Position = Vector3.new(-0.8, -0.5, 0)
	leftThruster.Anchored = true
	leftThruster.CanCollide = false
	leftThruster.BrickColor = BrickColor.new("Bright blue")
	leftThruster.Parent = jetpackModel

	local rightThruster = Instance.new("Part")
	rightThruster.Size = Vector3.new(0.5, 0.5, 0.5)
	rightThruster.Position = Vector3.new(0.8, -0.5, 0)
	rightThruster.Anchored = true
	rightThruster.CanCollide = false
	rightThruster.BrickColor = BrickColor.new("Bright blue")
	rightThruster.Parent = jetpackModel

	-- Add particle effects to thrusters
	local leftParticles = Instance.new("ParticleEmitter")
	leftParticles.Rate = 50
	leftParticles.Lifetime = NumberRange.new(0.5, 1)
	leftParticles.Speed = NumberRange.new(5, 10)
	leftParticles.Size = NumberSequence.new(0.2, 0.1)
	leftParticles.Color = ColorSequence.new(Color3.fromRGB(0, 150, 255))
	leftParticles.Parent = leftThruster

	local rightParticles = Instance.new("ParticleEmitter")
	rightParticles.Rate = 50
	rightParticles.Lifetime = NumberRange.new(0.5, 1)
	rightParticles.Speed = NumberRange.new(5, 10)
	rightParticles.Size = NumberSequence.new(0.2, 0.1)
	rightParticles.Color = ColorSequence.new(Color3.fromRGB(0, 150, 255))
	rightParticles.Parent = rightThruster

	jetpackModel.Parent = self.previewViewport

	-- Position camera to look at the jetpack
	self.previewViewport.CurrentCamera.CFrame = CFrame.new(Vector3.new(3, 1, 5), Vector3.new(0, 0, 0))
end

function ItemPreview:_createTrailPreview(itemData)
	-- Create a simple trail preview with moving object
	local trailModel = Instance.new("Model")
	trailModel.Name = "TrailPreview"

	-- Moving part that leaves trail
	local movingPart = Instance.new("Part")
	movingPart.Size = Vector3.new(0.5, 0.5, 0.5)
	movingPart.Position = Vector3.new(0, 0, 0)
	movingPart.Anchored = true
	movingPart.CanCollide = false
	movingPart.BrickColor = BrickColor.new("Bright red")
	movingPart.Parent = trailModel

	-- Add trail effect
	local trail = Instance.new("Trail")
	trail.Attachment0 = Instance.new("Attachment", movingPart)
	trail.Attachment1 = Instance.new("Attachment", movingPart)
	trail.Color = ColorSequence.new(itemData.effectData.color or Color3.fromRGB(255, 0, 0))
	trail.Lifetime = itemData.effectData.lifetime or 2
	trail.Parent = movingPart

	trailModel.Parent = self.previewViewport

	-- Animate the part to show trail
	task.spawn(function()
		while trailModel.Parent do
			for i = -2, 2, 0.1 do
				if not movingPart.Parent then
					break
				end
				movingPart.Position = Vector3.new(i, 0, 0)
				task.wait(0.05)
			end
			for i = 2, -2, -0.1 do
				if not movingPart.Parent then
					break
				end
				movingPart.Position = Vector3.new(i, 0, 0)
				task.wait(0.05)
			end
		end
	end)

	self.previewViewport.CurrentCamera.CFrame = CFrame.new(Vector3.new(0, 2, 5), Vector3.new(0, 0, 0))
end

function ItemPreview:_createEffectPreview(itemData)
	-- Create effect preview with particle system
	local effectModel = Instance.new("Model")
	effectModel.Name = "EffectPreview"

	local effectPart = Instance.new("Part")
	effectPart.Size = Vector3.new(1, 1, 1)
	effectPart.Position = Vector3.new(0, 0, 0)
	effectPart.Anchored = true
	effectPart.CanCollide = false
	effectPart.Transparency = 1 -- Invisible part for particles
	effectPart.Parent = effectModel

	-- Add particle effect
	local particles = Instance.new("ParticleEmitter")
	particles.Rate = itemData.effectData.emissionRate or 50
	particles.Lifetime = NumberRange.new(1, 2)
	particles.Speed = NumberRange.new(2, 5)
	particles.Size = NumberSequence.new(itemData.effectData.size.X or 0.5)
	particles.Color = ColorSequence.new(Color3.fromRGB(255, 200, 100))
	particles.Parent = effectPart

	effectModel.Parent = self.previewViewport
	self.previewViewport.CurrentCamera.CFrame = CFrame.new(Vector3.new(2, 2, 3), Vector3.new(0, 0, 0))
end

function ItemPreview:_updateActionButtons(itemData, playerData)
	-- Clear existing buttons
	for _, child in ipairs(self.actionFrame:GetChildren()) do
		child:Destroy()
	end

	local player = game.Players.LocalPlayer
	local PlayerEntity = self.diContainer:resolve("Entities").Player
	local playerEntity = PlayerEntity.new(player, playerData)
	local marketplaceService = self.diContainer:resolve("Shared.Application.Services").marketplaceService

	local isOwned = marketplaceService:ownsItem(playerEntity, itemData.id)
	local canPurchase, errorMessage = marketplaceService:canPurchase(player, itemData.id)

	if isOwned then
		-- Show equip/unequip buttons
		local equippedItems = marketplaceService:getOwnedItems(playerEntity)
		local isEquipped = false

		if itemData.type == "jetpack" then
			isEquipped = playerEntity:getJetpack() == itemData.id
		else
			-- Check if equipped as accessory
			local accessories = playerEntity:getAccessories()
			for _, accessory in ipairs(accessories) do
				if accessory.id == itemData.id then
					isEquipped = true
					break
				end
			end
		end

		if isEquipped then
			local unequipButton = self:_createActionButton("Unequip", Color3.fromRGB(150, 150, 150))
			unequipButton.MouseButton1Click:Connect(function()
				self:_unequipItem(itemData.id)
			end)
		else
			local equipButton = self:_createActionButton("Equip", Color3.fromRGB(50, 150, 50))
			equipButton.MouseButton1Click:Connect(function()
				self:_equipItem(itemData.id)
			end)
		end
	else
		-- Show purchase button
		local purchaseButton = self:_createActionButton("Purchase", Color3.fromRGB(50, 100, 200))
		if canPurchase then
			purchaseButton.MouseButton1Click:Connect(function()
				self:_purchaseItem(itemData.id)
			end)
		else
			purchaseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			purchaseButton.Text = errorMessage or "Cannot Purchase"
		end
	end
end

function ItemPreview:_createActionButton(text, color)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.45, 0, 1, 0)
	button.Position = UDim2.new(0, 0, 0, 0)
	button.BackgroundColor3 = color
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextScaled = true
	button.Font = Enum.Font.SourceSansBold
	button.Parent = self.actionFrame

	local buttonBorder = Instance.new("UIStroke")
	buttonBorder.Color = Color3.fromRGB(150, 150, 150)
	buttonBorder.Parent = button

	return button
end

function ItemPreview:_purchaseItem(itemId)
	-- Show purchase confirmation dialog instead of direct purchase
	if self.purchaseDialog then
		local shopData = self.diContainer:resolve("Shared.Data")
		local itemData = nil

		for _, item in ipairs(shopData.ShopItems) do
			if item.id == itemId then
				itemData = item
				break
			end
		end

		if itemData then
			self.purchaseDialog:showPurchaseDialog(itemData)
		end
	end
end

function ItemPreview:_equipItem(itemId)
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireServer(constants.REMOTE_EVENTS.SHOP_EQUIP_REQUEST, {
		itemId = itemId,
		player = game.Players.LocalPlayer,
	})
end

function ItemPreview:_unequipItem(itemId)
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireServer(constants.REMOTE_EVENTS.SHOP_UNEQUIP_REQUEST, {
		itemId = itemId,
		player = game.Players.LocalPlayer,
	})
end

function ItemPreview:hide()
	self.isVisible = false
	self.previewFrame.Visible = false
	self.currentItem = nil
end

function ItemPreview:destroy()
	if self.previewFrame then
		self.previewFrame:Destroy()
	end
end

return ItemPreview
