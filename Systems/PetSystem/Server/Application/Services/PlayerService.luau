---@class PetSystemServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return PetSystemServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:init()
	---@type PetSystemEntities
	local entities = self.diContainer:resolve("Entities")
	---@type PetSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	self.PlayerEntity = entities.Player
	self.playerRepository = playerRepository
end

function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("PetSystemPlayerService", "Player added to pet system:", player.Name, "(ID:", player.UserId, ")")

	---@type PetSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	playerRepository:getPlayerEntity(player)
end

function PlayerService:onPlayerRemoving(player)
	---@type PetSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	playerRepository:removePlayerEntity(player)
end

function PlayerService:updatePlayer(player)
	---@type PetSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type PetSystemPlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)
	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type PetSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerEntity:getData(),
	})
end

return PlayerService
