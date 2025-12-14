---@class LiveLeaderboardSystemSharedInfrastructureServices
---@field remoteEvent RemoteEvent
---@field diContainer DIContainer
---@field remoteEventService RemoteEventService
---@field featureFlagService FeatureFlagService
---@field logger LoggerService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return LiveLeaderboardSystemSharedInfrastructureServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self:_register()
	return self
end

function Services:_register()
end

return Services
