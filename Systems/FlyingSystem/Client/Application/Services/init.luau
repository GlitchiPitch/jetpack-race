local InputService = require(script.InputService)
local FlyingService = require(script.FlyingService)
local JetpackService = require(script.JetpackService)
local MovementService = require(script.MovementService)
local CameraService = require(script.CameraService)

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
	self.diContainer:singleton("JetpackService", function(c)
		return JetpackService.new(c)
	end)
	self.diContainer:singleton("MovementService", function(c)
		return MovementService.new(c)
	end)
	self.diContainer:singleton("CameraService", function(c)
		return CameraService.new(c)
	end)
end

return Services
