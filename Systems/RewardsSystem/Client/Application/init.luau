local Services = require(script.Services)

---@class RewardsSystemClientApplication
---@field services RewardsSystemClientApplicationServices
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return RewardsSystemClientApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer

    self.services = Services.new(self.diContainer)

	return self
end

function Application:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RewardsSystemClientApplication", "Creating client application...")
	logger:debug("RewardsSystemClientApplication", "Client application services created")

	logger:debug("RewardsSystemClientApplication", "Initializing client application...")

	if self.services.init then
		self.services:init()
		logger:debug("RewardsSystemClientApplication", "Client application services initialized")
	end

	logger:debug("RewardsSystemClientApplication", "Client application initialization completed")
end

return Application
