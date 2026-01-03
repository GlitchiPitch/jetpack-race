---@class ClientApplicationRaceService
---@field diContainer DIContainer
local RaceService = {}
RaceService.__index = RaceService

---@param diContainer DIContainer
---@return ClientApplicationRaceService
function RaceService.new(diContainer)
	local self = setmetatable({}, RaceService)
	self.diContainer = diContainer
	return self
end

function RaceService:activateTrigger()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	shared.Infrastructure.services.remoteEventService:fireServer(shared.Constants.REMOTE_EVENTS.RACE_TRIGGER_ACTIVATED)
end

function RaceService:start()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")

	application.services.jetpackService:startFly()
	application.services.cameraService:activateFlyingCamera()
	application.services.animationService:activateFlyingIdle()
end

return RaceService
