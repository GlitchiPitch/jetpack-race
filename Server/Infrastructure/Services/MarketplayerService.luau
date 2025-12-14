local MarketPlayerService = game:GetService("MarketPlayerService")

---@class _MarketPlayerService
local _MarketPlayerService = {}
_MarketPlayerService.__index = _MarketPlayerService

---@param diContainer DIContainer
---@return _MarketPlayerService
function _MarketPlayerService.new(diContainer)
	local self = setmetatable({}, _MarketPlayerService)
	self.diContainer = diContainer
	return self
end



return MarketPlayerService
