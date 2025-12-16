local Services = require(script.Services)

---@class FlyingSystemApplication
---@field services FlyingSystemApplicationServices
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return FlyingSystemApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
    self.services = Services.new(self.diContainer)
	self:_register()
	return self
end

function Application:_register() end

function Application:init()
	---@type FlyingSystemClientFlyingService
	local flyingService = self.diContainer:resolve("FlyingService")
	flyingService:init()
    
end

return Application
