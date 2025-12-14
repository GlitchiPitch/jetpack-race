---@class LiveLeaderboardSystemSharedServices
---@field config SharedConfig
---@field diContainer DIContainer
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@param config SharedConfig
---@return LiveLeaderboardSystemSharedServices
function Services.new(diContainer, config)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.config = config
	return self
end

function Services:init()
end

return Services
