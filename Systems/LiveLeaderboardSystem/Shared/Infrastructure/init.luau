local DIContainer = require(script.DIContainer)
local Services = require(script.Services)

---@class LiveLeaderboardSystemSharedInfrastructure
---@field DIContainer DIContainer
---@field Services SharedInfrastructureServices
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@return LiveLeaderboardSystemSharedInfrastructure
function Infrastructure.new()
	local self = setmetatable({}, Infrastructure)
	self.DIContainer = DIContainer.new()
	self.Services = Services.new(self.DIContainer)
	return self
end

return Infrastructure
