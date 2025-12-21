---@class RaceSystemServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return RaceSystemServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:debug("RaceSystemPlayerService", "Initializing PlayerService...")

	---@type RaceSystemEntities
	local entities = self.diContainer:resolve("Entities")
	logger:debug("RaceSystemPlayerService", "Resolved entities from DI container")

	---@type RaceSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	logger:debug("RaceSystemPlayerService", "Resolved PlayerRepository from DI container")

	self.PlayerEntity = entities.Player
	self.playerRepository = playerRepository

	logger:debug("RaceSystemPlayerService", "PlayerService initialization completed")
end

function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("RaceSystemPlayerService", "Player added to rewards system:", player.Name, "(ID:", player.UserId, ")")

	---@type RaceSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	logger:debug("RaceSystemPlayerService", "Creating/getting player entity for:", player.Name)

	local playerEntity = playerRepository:getPlayerEntity(player)
	logger:debug("RaceSystemPlayerService", "Player entity created/retrieved successfully for:", player.Name)

	-- Log initial player data
	local playerData = playerEntity:getData()
	logger:debug("RaceSystemPlayerService", "Initial player data for", player.Name, ":", playerData)
end

function PlayerService:onPlayerRemoving(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("RaceSystemPlayerService", "Player removing from rewards system:", player.Name, "(ID:", player.UserId, ")")

	---@type RaceSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	logger:debug("RaceSystemPlayerService", "Removing player entity for:", player.Name)

	playerRepository:removePlayerEntity(player)
	logger:debug("RaceSystemPlayerService", "Player entity removed successfully for:", player.Name)
end

function PlayerService:updatePlayer(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:debug("RaceSystemPlayerService", "Updating player data for:", player.Name)

	---@type RaceSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	local playerEntity = playerRepository:getPlayerEntity(player)

	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type RaceSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	local playerData = playerEntity:getData()
	logger:debug("RaceSystemPlayerService", "Sending player update to client for:", player.Name, "with data:", playerData)

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerData,
	})

	logger:debug("RaceSystemPlayerService", "Player update sent successfully for:", player.Name)
end

return PlayerService
