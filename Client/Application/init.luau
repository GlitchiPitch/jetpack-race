local Services = require(script.Services)

---@class ClientApplication
---@field services ClientApplicationServices
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return ClientApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
    self.services = Services.new(self.diContainer)
	self:_register()
	return self
end

function Application:_register() end

function Application:init()
	
end

return Application
