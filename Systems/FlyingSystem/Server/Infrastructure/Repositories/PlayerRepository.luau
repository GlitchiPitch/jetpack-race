---@class FlyingSystemServerPlayerRepository
local PlayerRepository = {}
PlayerRepository.__index = PlayerRepository

---@param PlayerEntity FlyingSystemPlayerEntity
---@return FlyingSystemServerPlayerRepository
function PlayerRepository.new(PlayerEntity)
	local self = setmetatable({}, PlayerRepository)
	self.playerEntities = {}
	self.PlayerEntity = PlayerEntity
	return self
end

---@param player Player
---@return FlyingSystemPlayerEntity
function PlayerRepository:getPlayerEntity(player)
	if not self.playerEntities[player] then
		self.playerEntities[player] = self.PlayerEntity.new(player)
	end

	return self.playerEntities[player]
end

---@param player Player
function PlayerRepository:removePlayerEntity(player)
	self.playerEntities[player] = nil
end

return PlayerRepository
