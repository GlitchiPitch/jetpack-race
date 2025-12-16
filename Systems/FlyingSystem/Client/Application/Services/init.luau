local InputService = require(script.InputService)
local FlyingService = require(script.FlyingService)

---@class FlyingSystemApplicationServices
---@field diContainer DIContainer
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return FlyingSystemApplicationServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self:_register()
	return self
end

function Services:_register()
	self.diContainer:singleton("InputService", function(c)
		return InputService.new(c)
	end)
	self.diContainer:singleton("FlyingService", function(c)
		return FlyingService.new(c)
	end)
end

return Services
