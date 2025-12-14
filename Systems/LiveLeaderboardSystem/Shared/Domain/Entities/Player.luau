---@class LiveLeaderboardSystemPlayerEntity
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param data table<string, any>
---@return LiveLeaderboardSystemPlayerEntity
function PlayerEntity.new(player, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self.data = data
	return self
end

function PlayerEntity:getData()
	return self.data
end

return PlayerEntity