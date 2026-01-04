---@class ServerRaceService
---@field diContainer DIContainer
local RaceService = {}
RaceService.__index = RaceService

---@param diContainer DIContainer
---@return ServerRaceService
function RaceService.new(diContainer)
	local self = setmetatable({}, RaceService)
	self.diContainer = diContainer

	self:_setup()
	return self
end

function RaceService:_setup() end

---@param playerEntity PlayerEntity
function RaceService:triggerActivated(playerEntity)
	---@type ServerApplication
	local application = self.diContainer:resolve("Application")
	application.services.jetpackService:equipJetpack(playerEntity)
	application.services.flyingService:connectPlayerFly(playerEntity)
end

function RaceService:start()
	---@type ServerApplication
	local application = self.diContainer:resolve("Application")
	application.services.checkpointService:generate()
	application.services.boostsService:generate()
end

function RaceService:finish() 
	---@type ServerApplication
	local application = self.diContainer:resolve("Application")
	application.services.boostsService:clear()
end

return RaceService
