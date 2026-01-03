---@class ServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return ServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

---@param player Player
function PlayerService:onPlayerAdded(player)
	self.playerRepository:getPlayerEntity(player)
end

---@param player Player
function PlayerService:onPlayerRemoving(player)
	self.playerRepository:removePlayerEntity(player)
end

---@param player Player
---@return PlayerEntity
function PlayerService:getPlayerEntity(player)
	---@type ServerInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type PlayerEntity
	local playerEntity = infrastructure.Repositories.PlayerRepository:getPlayerEntity(player)

	return playerEntity
end

---@param player Player
function PlayerService:updatePlayer(player)
	---@type ServerInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type Shared
	local shared = self.diContainer:resolve("Shared")

	---@type PlayerEntity
	local playerEntity = infrastructure.Repositories.PlayerRepository:getPlayerEntity(player)
	---@type RemoteEventService
	local remoteEventService = shared.Infrastructure.services.remoteEventService
	---@type SharedConstants
	local constants = shared.Constants

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerEntity:getData(),
	})
end

---@param playerEntity PlayerEntity
function PlayerService:kickPlayer(playerEntity)
	playerEntity.player:Kick("Bibibibib")
end

return PlayerService
