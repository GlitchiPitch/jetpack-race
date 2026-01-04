local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
---@class ServerApplication
---@field application ServerApplicationServices
---@field diContainer DIContainer
---@field constants SharedConstants
---@field useCases ServerUseCases
---@field commands ServerCommands
---@field remoteEventService RemoteEventService
---@field services ServerApplicationServices
---@field _startLocation Part
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return ServerApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer

	self.commands = Commands.new()
	self.useCases = UseCases.new()
	self.services = Services.new(diContainer)

	self._startLocation = workspace.Workspace.StartLocation
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
	self.services.raceService:start()
end

function Application:_connectToEvents()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.RACE_TRIGGER_ACTIVATED,
		function(player, _)
			local playerEntity = self.services.playerService:getPlayerEntity(player)
			self.services.raceService:triggerActivated(playerEntity)

			shared.Infrastructure.services.remoteEventService:fireClient(
				playerEntity.player,
				shared.Constants.REMOTE_EVENTS.FLYING_ACTIVATED,
				playerEntity:getData()
			)

			shared.Infrastructure.services.remoteEventService:fireClient(
				playerEntity.player,
				shared.Constants.REMOTE_EVENTS.RACE_START,
				self.services.checkpointService:getCheckpoints()
			)

			self.services.flyingService:setUpdate(true)
		end
	)

	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.PLAYER_UPDATED,
		function(player, _)
			self.services.playerService:updatePlayer(player)
		end
	)

	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.CHECKPOINT_REACHED,
		function(player, args)
			local playerEntity = self.services.playerService:getPlayerEntity(player)
			self.services.checkpointService:checkpointReached(playerEntity, args)
		end
	)

	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.FINISH_RACE,
		function(player, _)
			local playerEntity = self.services.playerService:getPlayerEntity(player)
			self.services.raceService:finish()
			self.services.flyingService:disconnectPlayerFly(playerEntity)
			self.services.flyingService:setUpdate(false)
			self.services.jetpackService:unequipJetpack(playerEntity)

			shared.Infrastructure.services.remoteEventService:fireClient(
				playerEntity.player,
				shared.Constants.REMOTE_EVENTS.FLYING_DEACTIVATED
			)

			shared.Infrastructure.services.remoteEventService:fireClient(
				playerEntity.player,
				shared.Constants.REMOTE_EVENTS.FINISH_RACE
			)

			local character = playerEntity:getCharacter()
			character.PrimaryPart.Anchored = true
			character:PivotTo(self._startLocation.CFrame)
			character.PrimaryPart.Anchored = false
		end
	)
end

return Application
