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

function RaceService:_setup()
end

---@param playerEntity PlayerEntity
function RaceService:triggerActivated(playerEntity)
	warn("TriggerZone")
	---@type ServerApplication
	local application = self.diContainer:resolve("Application")
	application.services.jetpackService:equipJetpack(playerEntity)
	application.services.flyingService:connectPlayerFly(playerEntity)

	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	shared.Infrastructure.services.remoteEventService:fireClient(
		playerEntity.player,
		shared.Constants.REMOTE_EVENTS.FLYING_ACTIVATED
	)
end

function RaceService:start()
	---@type ServerInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	infrastructure.services.trajectoryPathService:generateTrack()
end

function RaceService:finish() end

return RaceService
