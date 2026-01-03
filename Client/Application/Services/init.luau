local RaceService = require(script.RaceService)

---@class ClientApplicationServices
---@field diContainer DIContainer
---@field raceService ClientApplicationRaceService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return ClientApplicationServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.raceService = RaceService.new(diContainer)
	return self
end

return Services