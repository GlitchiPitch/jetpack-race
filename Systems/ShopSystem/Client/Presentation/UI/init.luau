local ShopFrame = require(script.ShopFrame)
---@class ShopSystemUI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return ShopSystemUI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer
	self.isActive = false
	self._connections = {}

	-- Create shop frame
	self.shopFrame = ShopFrame.new(diContainer)

	return self
end

function UI:init()
	self.remoteEventService = self.diContainer:resolve("RemoteEventService")
	self.constants = self.diContainer:resolve("Shared.Constants")

	self.shopFrame:init()
	-- Listen for shop open events
	self:_setupRemoteEventListeners()
end

function UI:_setupRemoteEventListeners()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	-- Listen for shop opened event
	local shopOpenedConnection = self.remoteEventService:listenToClient(self.constants.REMOTE_EVENTS.SHOP_OPENED, function(data)
		logger:info("ShopSystemUI", "Shop opened for player:", data.playerName)
		self:openShop()
	end)

	table.insert(self._connections, shopOpenedConnection)
end

function UI:openShop()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	if self.isActive then
		logger:warn("ShopSystemUI", "Shop is already open")
		return
	end

	logger:info("ShopSystemUI", "Opening shop UI")

	self.isActive = true
	self.shopFrame:open()
end

function UI:closeShop()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	if not self.isActive then
		logger:warn("ShopSystemUI", "Shop is already closed")
		return
	end

	logger:info("ShopSystemUI", "Closing shop UI")

	self.isActive = false
	self.shopFrame:close()
end

function UI:destroy()
	-- Disconnect all connections
	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end
	self._connections = {}

	self:closeShop()

	-- Destroy shop frame
	if self.shopFrame then
		self.shopFrame:destroy()
	end
end


return UI
