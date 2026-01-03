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

	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	self.remoteEventService = RemoteEventService.new(self.remoteEvent, LoggerService.new(LoggerService.LEVELS.INFO))
	self.featureFlagService = FeatureFlagService.new({})
	return self
end

return Services
