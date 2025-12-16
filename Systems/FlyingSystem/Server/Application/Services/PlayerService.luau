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

---@param player Player
function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("FlyingSystemPlayerService", "Player added to flying system:", player.Name, "(ID:", player.UserId, ")")

	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity(player)

	-- Инициализировать flying entity (но не активировать полет до экипировки джетпака)
	flyingEntity:setFlyingActive(false)
end

function PlayerService:onPlayerRemoving(player)
	local logger = self.diContainer:resolve("Logger")
	logger:info("FlyingSystemPlayerService", "Player removing from flying system:", player.Name)

	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity(player)

	-- Деактивировать полет при выходе игрока
	flyingEntity:deactivateFlying()

	---@type FlyingSystemServerMovementService
	local movementService = self.diContainer:resolve("Server.Application.Services").movementService
	movementService:stopFlyingMovement(player)
end

function PlayerService:updatePlayer(player)
	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	---@type FlyingEntity
	local flyingEntity = flyingRepository:getFlyingEntity(player)
	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type FlyingSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = flyingEntity:getData(),
	})
end

function PlayerService:onSprintActivated(player)
	local logger = self.diContainer:resolve("Logger")
	logger:info("FlyingSystemPlayerService", "Sprint activated for player:", player.Name)

	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	---@type FlyingEntity
	local flyingEntity = flyingRepository:getFlyingEntity(player)

	-- Активировать спринт в сущности игрока
	flyingEntity:setSprintActivated(true)
end

function PlayerService:onSprintDeactivated(player)
	local logger = self.diContainer:resolve("Logger")
	logger:info("FlyingSystemPlayerService", "Sprint deactivated for player:", player.Name)

	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	---@type FlyingEntity
	local flyingPlayerEntity = flyingRepository:getPlayerEntity(player)

	-- Деактивировать спринт в сущности игрока
	flyingPlayerEntity:setSprintActivated(false)
end

return PlayerService
