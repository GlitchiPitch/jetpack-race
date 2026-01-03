---@class PlayerRepository : IPlayerRepository
---@field diContainer DIContainer
local PlayerRepository = {}
PlayerRepository.__index = PlayerRepository

---@param diContainer DIContainer
---@return PlayerRepository
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
