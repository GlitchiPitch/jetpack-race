local RaceService = require(script.RaceService)

---@class RaceSystemClientApplicationServices
---@field diContainer DIContainer
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return RaceSystemClientApplicationServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self:_register()
	return self
end

function Services:_register()
	self.diContainer:singleton("RaceService", function(c)
		return RaceService.new(c)
	end)
end

return Services
