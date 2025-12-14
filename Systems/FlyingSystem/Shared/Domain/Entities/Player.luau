---@class FlyingSystemPlayerEntity
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param data table<string, any>
---@param _playerData table<string, any>
---@return FlyingSystemPlayerEntity
function PlayerEntity.new(player, _playerData, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self._playerData = _playerData
	self.data = data
	return self
end

function PlayerEntity:getData()
	return self.data
end

return PlayerEntity