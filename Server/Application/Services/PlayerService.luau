---@class PlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return PlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:onPlayerAdded(player)
	---@type IPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	return playerRepository:getPlayerEntity(player)
end

function PlayerService:onPlayerRemoving(player)
	---@type IPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	playerRepository:removePlayerEntity(player)
end

function PlayerService:updatePlayer(player)
	---@type PlayerEntity
	local playerEntity = self.playerRepository:getPlayerEntity(player)
	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type SharedConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerEntity:getData(),
	})
end

return PlayerService
