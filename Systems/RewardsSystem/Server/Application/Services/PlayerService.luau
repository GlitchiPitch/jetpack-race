---@class RewardsSystemServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return RewardsSystemServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:debug("RewardsSystemPlayerService", "Initializing PlayerService...")

	---@type RewardsSystemEntities
	local entities = self.diContainer:resolve("Entities")
	logger:debug("RewardsSystemPlayerService", "Resolved entities from DI container")

	---@type RewardsSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	logger:debug("RewardsSystemPlayerService", "Resolved PlayerRepository from DI container")

	self.PlayerEntity = entities.Player
	self.playerRepository = playerRepository

	logger:debug("RewardsSystemPlayerService", "PlayerService initialization completed")
end

function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("RewardsSystemPlayerService", "Player added to rewards system:", player.Name, "(ID:", player.UserId, ")")

	---@type RewardsSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	logger:debug("RewardsSystemPlayerService", "Creating/getting player entity for:", player.Name)

	local playerEntity = playerRepository:getPlayerEntity(player)
	logger:debug("RewardsSystemPlayerService", "Player entity created/retrieved successfully for:", player.Name)

	-- Log initial player data
	local playerData = playerEntity:getData()
	logger:debug("RewardsSystemPlayerService", "Initial player data for", player.Name, ":", playerData)
end

function PlayerService:onPlayerRemoving(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("RewardsSystemPlayerService", "Player removing from rewards system:", player.Name, "(ID:", player.UserId, ")")

	---@type RewardsSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	logger:debug("RewardsSystemPlayerService", "Removing player entity for:", player.Name)

	playerRepository:removePlayerEntity(player)
	logger:debug("RewardsSystemPlayerService", "Player entity removed successfully for:", player.Name)
end

function PlayerService:updatePlayer(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:debug("RewardsSystemPlayerService", "Updating player data for:", player.Name)

	---@type RewardsSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type RewardsSystemPlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)

	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type RewardsSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	local playerData = playerEntity:getData()
	logger:debug("RewardsSystemPlayerService", "Sending player update to client for:", player.Name, "with data:", playerData)

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerData,
	})

	logger:debug("RewardsSystemPlayerService", "Player update sent successfully for:", player.Name)
end

return PlayerService
