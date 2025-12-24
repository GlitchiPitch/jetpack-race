---@class PurchaseDialog
local PurchaseDialog = {}
PurchaseDialog.__index = PurchaseDialog

---@param diContainer DIContainer
---@param parentFrame Frame
---@param existingFrame? Frame - Optional existing frame from model
---@return PurchaseDialog
function PurchaseDialog.new(diContainer, parentFrame, existingFrame)
	local self = setmetatable({}, PurchaseDialog)
	self.diContainer = diContainer
	self.parentFrame = parentFrame
	self.isVisible = false
	self.currentItem = nil

	if existingFrame then
		self:_setupFromExistingFrame(existingFrame)
	else
		self:_setupUI()
	end

	return self
end

function PurchaseDialog:_setupFromExistingFrame(existingFrame)
	local logger = self.diContainer:resolve("Logger")
	logger:info("PurchaseDialog", "Setting up from existing frame")

	-- Use the existing frame from the model
	self.dialogFrame = existingFrame
	self.dialogFrame.Visible = false

	-- Find buttons from the model
	local buttonsFrame = existingFrame:FindFirstChild("Buttons")
	if buttonsFrame then
		self.confirmButton = buttonsFrame:FindFirstChild("ConfirmButton")
		self.cancelButton = buttonsFrame:FindFirstChild("CancelButton")

		if self.confirmButton then
			self.confirmButton.MouseButton1Click:Connect(function()
				self:_onConfirmPurchase()
			end)
		end

		if self.cancelButton then
			self.cancelButton.MouseButton1Click:Connect(function()
				self:hide()
			end)
		end
	end

	-- Find info elements from the model
	local infoFrame = existingFrame:FindFirstChild("Info")
	if infoFrame then
		self.itemNameLabel = infoFrame:FindFirstChild("ItemName")
		self.priceLabel = infoFrame:FindFirstChild("Price")

		-- Find description label (unnamed TextLabel in Info frame)
		for _, child in ipairs(infoFrame:GetChildren()) do
			if child:IsA("TextLabel") and child ~= self.itemNameLabel and child ~= self.priceLabel then
				self.itemDescriptionLabel = child
				break
			end
		end
	end

	-- Find title label (unnamed TextLabel)
	local titleLabel = existingFrame:FindFirstChildOfClass("TextLabel")
	if titleLabel then
		self.titleLabel = titleLabel
	end

	logger:info("PurchaseDialog", "Setup from existing frame completed")
end

function PurchaseDialog:_setupUI()
	-- Main dialog frame
	self.dialogFrame = Instance.new("Frame")
	self.dialogFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
	self.dialogFrame.Position = UDim2.new(0.3, 0, 0.35, 0)
	self.dialogFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	self.dialogFrame.BackgroundTransparency = 0.1
	self.dialogFrame.Visible = false
	self.dialogFrame.Parent = self.parentFrame

	-- Add border
	local border = Instance.new("UIStroke")
	border.Color = Color3.fromRGB(100, 100, 100)
	border.Thickness = 2
	border.Parent = self.dialogFrame

	-- Background overlay (semi-transparent)
	self.overlay = Instance.new("Frame")
	self.overlay.Size = UDim2.new(1, 0, 1, 0)
	self.overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	self.overlay.BackgroundTransparency = 0.7
	self.overlay.Visible = false
	self.overlay.Parent = self.parentFrame

	-- Title
	self.titleLabel = Instance.new("TextLabel")
	self.titleLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
	self.titleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
	self.titleLabel.BackgroundTransparency = 1
	self.titleLabel.Text = "Confirm Purchase"
	self.titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.titleLabel.TextScaled = true
	self.titleLabel.Font = Enum.Font.SourceSansBold
	self.titleLabel.Parent = self.dialogFrame

	-- Item info
	self.itemInfoFrame = Instance.new("Frame")
	self.itemInfoFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
	self.itemInfoFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
	self.itemInfoFrame.BackgroundTransparency = 1
	self.itemInfoFrame.Parent = self.dialogFrame

	-- Item name
	self.itemNameLabel = Instance.new("TextLabel")
	self.itemNameLabel.Size = UDim2.new(1, 0, 0.3, 0)
	self.itemNameLabel.Position = UDim2.new(0, 0, 0, 0)
	self.itemNameLabel.BackgroundTransparency = 1
	self.itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.itemNameLabel.TextScaled = true
	self.itemNameLabel.Font = Enum.Font.SourceSansBold
	self.itemNameLabel.Parent = self.itemInfoFrame

	-- Item description
	self.itemDescriptionLabel = Instance.new("TextLabel")
	self.itemDescriptionLabel.Size = UDim2.new(1, 0, 0.4, 0)
	self.itemDescriptionLabel.Position = UDim2.new(0, 0, 0.3, 0)
	self.itemDescriptionLabel.BackgroundTransparency = 1
	self.itemDescriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	self.itemDescriptionLabel.TextScaled = true
	self.itemDescriptionLabel.Font = Enum.Font.SourceSans
	self.itemDescriptionLabel.TextWrapped = true
	self.itemDescriptionLabel.Parent = self.itemInfoFrame

	-- Price display
	self.priceLabel = Instance.new("TextLabel")
	self.priceLabel.Size = UDim2.new(1, 0, 0.3, 0)
	self.priceLabel.Position = UDim2.new(0, 0, 0.7, 0)
	self.priceLabel.BackgroundTransparency = 1
	self.priceLabel.TextScaled = true
	self.priceLabel.Font = Enum.Font.SourceSansBold
	self.priceLabel.Parent = self.itemInfoFrame

	-- Buttons frame
	self.buttonsFrame = Instance.new("Frame")
	self.buttonsFrame.Size = UDim2.new(0.9, 0, 0.2, 0)
	self.buttonsFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
	self.buttonsFrame.BackgroundTransparency = 1
	self.buttonsFrame.Parent = self.dialogFrame

	-- Confirm button
	self.confirmButton = Instance.new("TextButton")
	self.confirmButton.Size = UDim2.new(0.45, 0, 1, 0)
	self.confirmButton.Position = UDim2.new(0, 0, 0, 0)
	self.confirmButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	self.confirmButton.Text = "Confirm"
	self.confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.confirmButton.TextScaled = true
	self.confirmButton.Font = Enum.Font.SourceSansBold
	self.confirmButton.Parent = self.buttonsFrame

	local confirmBorder = Instance.new("UIStroke")
	confirmBorder.Color = Color3.fromRGB(100, 100, 100)
	confirmBorder.Parent = self.confirmButton

	-- Cancel button
	self.cancelButton = Instance.new("TextButton")
	self.cancelButton.Size = UDim2.new(0.45, 0, 1, 0)
	self.cancelButton.Position = UDim2.new(0.55, 0, 0, 0)
	self.cancelButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	self.cancelButton.Text = "Cancel"
	self.cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.cancelButton.TextScaled = true
	self.cancelButton.Font = Enum.Font.SourceSansBold
	self.cancelButton.Parent = self.buttonsFrame

	local cancelBorder = Instance.new("UIStroke")
	cancelBorder.Color = Color3.fromRGB(100, 100, 100)
	cancelBorder.Parent = self.cancelButton

	-- Connect button events
	self.confirmButton.MouseButton1Click:Connect(function()
		self:_onConfirm()
	end)

	self.cancelButton.MouseButton1Click:Connect(function()
		self:hide()
	end)

	-- Close on overlay click
	self.overlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:hide()
		end
	end)
end

---@param itemData table
function PurchaseDialog:showPurchaseDialog(itemData)
	self.currentItem = itemData
	self.isVisible = true

	-- Update dialog content
	self.itemNameLabel.Text = itemData.name
	self.itemDescriptionLabel.Text = itemData.description or "No description available"

	-- Update price display
	local priceText = ""
	if itemData.price.coins and itemData.price.coins > 0 then
		priceText = priceText .. "🪙 " .. tostring(itemData.price.coins) .. " "
	end
	if itemData.price.gems and itemData.price.gems > 0 then
		priceText = priceText .. "💎 " .. tostring(itemData.price.gems)
	end
	self.priceLabel.Text = "Price: " .. priceText

	-- Set price color based on currency type
	if itemData.price.gems and itemData.price.gems > 0 then
		self.priceLabel.TextColor3 = Color3.fromRGB(0, 191, 255) -- Blue for gems
	else
		self.priceLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold for coins
	end

	-- Show dialog
	self.overlay.Visible = true
	self.dialogFrame.Visible = true

	local logger = self.diContainer:resolve("Logger")
	logger:info("PurchaseDialog", "Showing purchase dialog for:", itemData.id)
end

function PurchaseDialog:_onConfirm()
	if not self.currentItem then return end

	local logger = self.diContainer:resolve("Logger")
	logger:info("PurchaseDialog", "Purchase confirmed for:", self.currentItem.id)

	-- Send purchase request to server
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireServer(constants.REMOTE_EVENTS.SHOP_PURCHASE_REQUEST, {
		itemId = self.currentItem.id,
		player = game.Players.LocalPlayer
	})

	-- Hide dialog
	self:hide()
end

function PurchaseDialog:showErrorDialog(errorMessage)
	self.titleLabel.Text = "Purchase Failed"
	self.itemNameLabel.Text = "Error"
	self.itemDescriptionLabel.Text = errorMessage
	self.priceLabel.Text = ""

	-- Change confirm button to "OK"
	self.confirmButton.Text = "OK"
	self.confirmButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	self.cancelButton.Visible = false
	self.confirmButton.Size = UDim2.new(1, 0, 1, 0)
	self.confirmButton.Position = UDim2.new(0, 0, 0, 0)

	-- Connect OK button to just hide
	local originalConfirm = self.confirmButton.MouseButton1Click
	self.confirmButton.MouseButton1Click:Connect(function()
		self:hide()
		-- Reset dialog state
		self:_resetDialog()
	end)

	-- Show dialog
	self.overlay.Visible = true
	self.dialogFrame.Visible = true

	local logger = self.diContainer:resolve("Logger")
	logger:info("PurchaseDialog", "Showing error dialog:", errorMessage)
end

function PurchaseDialog:_resetDialog()
	self.titleLabel.Text = "Confirm Purchase"
	self.confirmButton.Text = "Confirm"
	self.confirmButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	self.cancelButton.Visible = true
	self.confirmButton.Size = UDim2.new(0.45, 0, 1, 0)
	self.confirmButton.Position = UDim2.new(0, 0, 0, 0)

	-- Reconnect original confirm handler
	self.confirmButton.MouseButton1Click:Connect(function()
		self:_onConfirm()
	end)
end

function PurchaseDialog:hide()
	self.isVisible = false
	self.overlay.Visible = false
	self.dialogFrame.Visible = false
	self.currentItem = nil
end

function PurchaseDialog:destroy()
	if self.dialogFrame then
		self.dialogFrame:Destroy()
	end
	if self.overlay then
		self.overlay:Destroy()
	end
end

return PurchaseDialog
