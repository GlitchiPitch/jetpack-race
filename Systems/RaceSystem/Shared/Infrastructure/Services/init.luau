local AssetsSpawnService = require(script.AssetsSpawnService)
local RingsService = require(script.RingsService)
---@class RaceSystemSharedInfrastructureServices
---@field diContainer DIContainer
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return RaceSystemSharedInfrastructureServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self:_register()
	return self
end

function Services:_register()
	
	self.diContainer:singleton("AssetsSpawnService", function()
		return AssetsSpawnService.new()
	end)

	self.diContainer:singleton("RingsService", function()
		return RingsService.new()
	end)
end

return Services
