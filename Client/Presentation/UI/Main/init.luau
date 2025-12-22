local Players = game:GetService("Players")
---@class MainUI
local MainUI = {}
MainUI.__index = MainUI

---@param diContainer DIContainer
---@return MainUI
function MainUI.new(diContainer)
	local self = setmetatable({}, MainUI)
	self.diContainer = diContainer
	self.ui = script.MainUI:Clone()
	self.player = Players.LocalPlayer
	self:init()
	return self
end

function MainUI:init()
	self.ui.Parent = self.player.PlayerGui
	self:_setupCurrencyDisplay()
	self:_setupRemoteEventListeners()
end

function MainUI:_setupCurrencyDisplay()
	local statsFrame = self.ui:FindFirstChild("StatsFrame")
	if not statsFrame then
		warn("MainUI: StatsFrame not found")
		return
	end

	local template = statsFrame:FindFirstChild("Template")
	if not template then
		warn("MainUI: Template not found in StatsFrame")
		return
	end

	-- Hide template
	template.Visible = false

	-- Create currency displays
	self:_createCurrencyDisplay("Coins", "rbxassetid://76908661", Color3.fromRGB(255, 215, 0))
	self:_createCurrencyDisplay("Gems", "rbxassetid://32578003", Color3.fromRGB(0, 191, 255))
end

function MainUI:_createCurrencyDisplay(currencyName, icon, color)
	local statsFrame = self.ui.StatsFrame
	local template = statsFrame.Template

	-- Clone template
	local currencyFrame = template:Clone()
	currencyFrame.Name = currencyName .. "Frame"
	currencyFrame.Visible = true
	currencyFrame.Parent = statsFrame

	-- Setup amount label
	local amountLabel = currencyFrame:FindFirstChild("AmountLabel")
	if amountLabel then
		amountLabel.Text = "0"
		amountLabel.TextColor3 = color
	end

	-- Setup icon
	local imageLabel = currencyFrame:FindFirstChild("ImageLabel")
	if imageLabel then
		imageLabel.Image = icon
		warn(imageLabel.Image)
	end
end

function MainUI:_setupRemoteEventListeners()
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Listen for player data updates
	local playerUpdatedConnection = remoteEventService:connectToEvent(
		constants.REMOTE_EVENTS.PLAYER_UPDATED,
		function(data)
			if data.playerData and data.playerData.currency then
				self:updateCurrencyDisplay(data.playerData.currency)
			end
		end
	)

	-- Store connection for cleanup
	self.remoteConnections = {
		playerUpdatedConnection,
	}
end

function MainUI:updateCurrencyDisplay(currency)
	local statsFrame = self.ui:FindFirstChild("StatsFrame")
	if not statsFrame then
		return
	end

	-- Update coins
	local coinsFrame = statsFrame:FindFirstChild("CoinsFrame")
	if coinsFrame then
		local amountLabel = coinsFrame:FindFirstChild("AmountLabel")
		if amountLabel then
			amountLabel.Text = tostring(currency.coins or 0)
		end
	end

	-- Update gems
	local gemsFrame = statsFrame:FindFirstChild("GemsFrame")
	if gemsFrame then
		local amountLabel = gemsFrame:FindFirstChild("AmountLabel")
		if amountLabel then
			amountLabel.Text = tostring(currency.gems or 0)
		end
	end
end

function MainUI:destroy()
	if self.remoteConnections then
		for _, connection in ipairs(self.remoteConnections) do
			if connection then
				connection:Disconnect()
			end
		end
	end

	if self.ui then
		self.ui:Destroy()
	end
end

return MainUI
