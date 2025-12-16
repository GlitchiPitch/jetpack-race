local Services = require(script.Services)

---@class RaceSystemClientApplication
---@field services RaceSystemClientApplicationServices
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return RaceSystemClientApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer

    self.services = Services.new(self.diContainer)

	return self
end

function Application:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RaceSystemClientApplication", "Creating client application...")
	logger:debug("RaceSystemClientApplication", "Client application services created")

	logger:debug("RaceSystemClientApplication", "Initializing client application...")

	if self.services.init then
		self.services:init()
		logger:debug("RaceSystemClientApplication", "Client application services initialized")
	end

	logger:debug("RaceSystemClientApplication", "Client application initialization completed")
end

return Application
