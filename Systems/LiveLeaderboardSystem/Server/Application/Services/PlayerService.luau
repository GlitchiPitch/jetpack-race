---@class LiveLeaderboardSystemServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return LiveLeaderboardSystemServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("LiveLeaderboardPlayerService", "Player added to live leaderboard system:", player.Name, "(ID:", player.UserId, ")")

	---@type LiveLeaderboardSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	playerRepository:getPlayerEntity(player)
end

function PlayerService:onPlayerRemoving(player)
	---@type LiveLeaderboardSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	playerRepository:removePlayerEntity(player)
end

function PlayerService:updatePlayer(player)
	---@type LiveLeaderboardSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type LeaderboardPlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)
	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type LiveLeaderboardSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
		playerData = playerEntity:getData(),
	})
end

return PlayerService
