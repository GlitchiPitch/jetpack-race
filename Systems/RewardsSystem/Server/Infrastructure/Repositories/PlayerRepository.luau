---@class RewardsSystemServerPlayerRepository
local PlayerRepository = {}
PlayerRepository.__index = PlayerRepository

---@param entities table
---@return RewardsSystemServerPlayerRepository
function PlayerRepository.new(entities)
	local self = setmetatable({}, PlayerRepository)
	self.playerEntities = {}
	self.PlayerEntity = entities.Player
	return self
end

---@param player Player
---@return RewardsSystemPlayerEntity
function PlayerRepository:getPlayerEntity(player)
	if not self.playerEntities[player] then
		print("[RewardsSystemPlayerRepository] Creating new player entity for:", player.Name, "(ID:", player.UserId, ")")
		self.playerEntities[player] = self.PlayerEntity.new(player, {}, {})
	else
		print("[RewardsSystemPlayerRepository] Returning existing player entity for:", player.Name, "(ID:", player.UserId, ")")
	end

	return self.playerEntities[player]
end

---@param player Player
function PlayerRepository:removePlayerEntity(player)
	print("[RewardsSystemPlayerRepository] Removing player entity for:", player.Name, "(ID:", player.UserId, ")")
	local entityCountBefore = 0
	for _ in pairs(self.playerEntities) do
		entityCountBefore = entityCountBefore + 1
	end

	self.playerEntities[player] = nil

	local entityCountAfter = 0
	for _ in pairs(self.playerEntities) do
		entityCountAfter = entityCountAfter + 1
	end

	print("[RewardsSystemPlayerRepository] Player entity removed. Entities before:", entityCountBefore, "after:", entityCountAfter)
end

return PlayerRepository
