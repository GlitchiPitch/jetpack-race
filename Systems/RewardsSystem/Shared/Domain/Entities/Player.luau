---@class PetSystemPlayerEntity
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param _playerData table<string, any>
---@param data table<string, any>
---@return PlayerEntity
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

function PlayerEntity:getPlayerData()
	return self._playerData
end



return PlayerEntity