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
	return self
end

function UI:init()
	self.remoteEventService = self.diContainer:resolve("RemoteEventService")
	self.constants = self.diContainer:resolve("Shared.Constants")
end


return UI
