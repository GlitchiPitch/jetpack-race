---@class FlyingSystemServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return FlyingSystemServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("FlyingSystemPlayerService", "Player added to flying system:", player.Name, "(ID:", player.UserId, ")")

	---@type FlyingSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	playerRepository:getPlayerEntity(player)
end

function PlayerService:onPlayerRemoving(player)
	self.playerRepository:removePlayerEntity(player)
end

function PlayerService:updatePlayer(player)
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type FlyingSystemPlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)
	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type FlyingSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerEntity:getData(),
	})
end

function PlayerService:onSprintActivated(player)
	local logger = self.diContainer:resolve("Logger")
	logger:info("FlyingSystemPlayerService", "Sprint activated for player:", player.Name)

	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type FlyingSystemPlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)

	-- Активировать спринт в сущности игрока
	playerEntity:setSprintActivated(true)
end

function PlayerService:onSprintDeactivated(player)
	local logger = self.diContainer:resolve("Logger")
	logger:info("FlyingSystemPlayerService", "Sprint deactivated for player:", player.Name)

	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type FlyingSystemPlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)

	-- Деактивировать спринт в сущности игрока
	playerEntity:setSprintActivated(false)
end

return PlayerService
