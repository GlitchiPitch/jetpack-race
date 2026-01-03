---@class ServerRaceService
---@field diContainer DIContainer
local RaceService = {}
RaceService.__index = RaceService

---@param diContainer DIContainer
---@return ServerRaceService
function RaceService.new(diContainer)
	local self = setmetatable({}, RaceService)
	self.diContainer = diContainer
	return self
end

---@param playerEntity PlayerEntity
function RaceService:triggerActivated(playerEntity) 
	---@type ServerApplication
	local application = self.diContainer:resolve("Application")
	application.services.jetpackService:equipJetpack(playerEntity)
	application.services.flyingService:connectPlayerFly(playerEntity)
end

function RaceService:start()
	
end

function RaceService:finish()
	
end

return RaceService
