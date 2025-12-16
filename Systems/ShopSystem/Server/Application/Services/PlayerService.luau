---@class ShopSystemServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return ShopSystemServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopSystemPlayerService", "Player added to flying system:", player.Name, "(ID:", player.UserId, ")")

	---@type ShopSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	playerRepository:getPlayerEntity(player)
end

function PlayerService:onPlayerRemoving(player)
	self.playerRepository:removePlayerEntity(player)
end

function PlayerService:updatePlayer(player)
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type ShopSystemPlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)
	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type ShopSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerEntity:getData(),
	})
end

return PlayerService
