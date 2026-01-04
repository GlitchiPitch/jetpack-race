local Services = require(script.Services)

---@class ClientApplication
---@field services ClientApplicationServices
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return ClientApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
	self.services = Services.new(self.diContainer)
	self:_register()
	return self
end

function Application:_register()
	self.diContainer:singleton("Application", function()
		return self
	end)
end

function Application:init()
	self:_connectToEvents()

	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	local remoteEventService = shared.Infrastructure.services.remoteEventService
	remoteEventService:fireServer(shared.Constants.REMOTE_EVENTS.PLAYER_UPDATED)
end

function Application:_connectToEvents()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.PLAYER_UPDATED,
		function(args)
			self.services.playerService:updatePlayerData(args.playerData)
		end
	)

	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.FLYING_ACTIVATED,
		function(args)
			self.services.jetpackService:updateJetpack(args.jetpack)
			self.services.cameraService:activateFlyingCamera()
			self.services.jetpackService:startFly()
			self.services.animationService:activateFlyingIdle()
		end
	)

	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.RACE_START,
		function(args)
			self.services.checkpointService:trackCheckpoints(args)
			self.services.raceService:start()
		end
	)

	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.FINISH_RACE,
		function(_)
			self.services.raceService:finish()
		end
	)

	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.FLYING_DEACTIVATED,
		function(_)
			self.services.jetpackService:finishFly()
			self.services.animationService:deactivateFlyingIdle()
			self.services.cameraService:deactivateFlyingCamera()
		end
	)
end

return Application
