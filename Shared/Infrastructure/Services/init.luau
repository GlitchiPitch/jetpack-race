local RemoteEventService = require(script.RemoteEventService)
local FeatureFlagService = require(script.FeatureFlagService)
local LoggerService = require(script.LoggerService)

---@class SharedInfrastructureServices
---@field remoteEvent RemoteEvent
---@field diContainer DIContainer
---@field remoteEventService RemoteEventService
---@field featureFlagService FeatureFlagService
---@field logger LoggerService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return SharedInfrastructureServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.remoteEvent = script.RemoteEvent
	self:_register()
	return self
end

function Services:_register()
	-- Регистрируем LoggerService
	self.diContainer:singleton("Logger", function()
		return LoggerService.new(LoggerService.LEVELS.INFO)
	end)

	self.diContainer:singleton("RemoteEventService", function(container)
		local logger = container:resolve("Logger")
		return RemoteEventService.new(self.remoteEvent, logger)
	end)

	-- Регистрируем FeatureFlagService с зависимостью от констант
	self.diContainer:singleton("FeatureFlagService", function()
		local constants = self.diContainer:resolve("Constants")
		return FeatureFlagService.new(constants.FeatureFlags)
	end)
end

return Services
