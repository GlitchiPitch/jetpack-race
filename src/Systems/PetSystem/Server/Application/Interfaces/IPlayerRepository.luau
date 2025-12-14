---@class IPlayerRepository
local IPlayerRepository = {}

---@return IPlayerRepository
function IPlayerRepository.new()
	error("Not implemented")
end

---@param player Player
---@return PlayerEntity
function IPlayerRepository:getPlayerEntity(player)
	error("Not implemented")
end

---@param player Player
function IPlayerRepository:removePlayerEntity(player)
	error("Not implemented")
end

return IPlayerRepository
