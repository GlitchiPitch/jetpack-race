---@class RewardsSystemSharedServices
---@field config SharedConfig
---@field diContainer DIContainer
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@param config SharedConfig
---@return RewardsSystemSharedServices
function Services.new(diContainer, config)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.config = config
	return self
end

function Services:init()
end

return Services
