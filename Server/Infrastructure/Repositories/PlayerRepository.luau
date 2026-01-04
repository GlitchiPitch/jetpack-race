--- ServerPlayerRepository - Server-side player entity management and storage
---
--- This repository manages all player entities on the server, providing
--- centralized access to player data, creation, and cleanup operations.
--- It implements the IPlayerRepository interface and serves as the
--- authoritative source for player information.
---
--- Key Features:
--- - Multi-player entity management with UserId-based indexing
--- - Automatic player entity creation on first access
--- - Proper cleanup of player data on disconnection
--- - Integration with Shared domain entities
---
--- Entity Lifecycle:
--- - Player entities are created lazily when first requested
--- - Entities persist for the duration of the player's session
--- - Automatic cleanup prevents memory leaks on player leave
---
--- @class ServerPlayerRepository : IPlayerRepository
--- @field diContainer DIContainer Dependency injection container for resolving other services
--- @field playerEntities table<Player, PlayerEntity> Map of Player instances to their entity objects
local PlayerRepository = {}
PlayerRepository.__index = PlayerRepository

---@param diContainer DIContainer
---@return ServerPlayerRepository
function PlayerRepository.new(diContainer)
	local self = setmetatable({}, PlayerRepository)
	self.playerEntities = {}
	self.diContainer = diContainer
	return self
end

---@param player Player
---@return PlayerEntity
function PlayerRepository:getPlayerEntity(player)
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	if not self.playerEntities[player] then
		self.playerEntities[player] = shared.Domain.Entities.Player.new(player, {})
	end

	return self.playerEntities[player]
end

---@param player Player
function PlayerRepository:removePlayerEntity(player)
	self.playerEntities[player] = nil
end

return PlayerRepository
