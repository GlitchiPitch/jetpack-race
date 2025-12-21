---@class PlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@param remoteEventService RemoteEventService
---@return PlayerService
function PlayerService.new(diContainer, remoteEventService)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	self.remoteEventService = remoteEventService
	return self
end

function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("PlayerService", "Player added:", player.Name, "(ID:", player.UserId, ")")

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
	---@type IPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type PlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)
	---@type SharedConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	self.remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerEntity:getData(),
	})
end

return PlayerService
