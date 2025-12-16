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
	---@type FlyingSystemServerServices
	local services = self.diContainer:resolve("Server.Application.Services")
	---@type FlyingSystemServerJetpackService
	local jetpackService = services.jetpackService
	logger:info("FlyingSystemPlayerService", "Player added to flying system:", player.Name, "(ID:", player.UserId, ")")

	---@type PlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	local playerEntity = playerRepository:getPlayerEntity(player)
	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	---@type FlyingEntity
	local flyingEntity = flyingRepository:getFlyingEntity(player)
	warn(flyingEntity)
	jetpackService:setupStarterJetpack(playerEntity)
end

function PlayerService:onPlayerRemoving(player) end

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
