--- ServerRaceService - Server-side race orchestration and coordination
---
--- This service coordinates the overall race lifecycle on the server,
--- managing race initialization, player preparation, and race completion.
--- It acts as the central coordinator for all race-related services.
---
--- Key Features:
--- - Race initialization and setup coordination
--- - Player jetpack equipment on race trigger activation
--- - Integration with FlyingService for flight tracking
--- - Checkpoint and boost generation orchestration
---
--- Race Flow:
--- - **Trigger Activation**: Equips player with jetpack and enables flight
--- - **Race Start**: Generates checkpoints and boosts for the course
--- - **Race End**: Cleans up race entities and resets player state
---
--- @class ServerRaceService
--- @field diContainer DIContainer Dependency injection container for resolving other services
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
