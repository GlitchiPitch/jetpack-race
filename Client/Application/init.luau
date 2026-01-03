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

function Application:_register()
	self.diContainer:singleton("Application", function()
		return self
	end)
end

function Application:init() end

function Application:_connectToEvents()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.PLAYER_UPDATED
	)
end

return Application
