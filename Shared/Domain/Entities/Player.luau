---@class PlayerEntity
---@field player Player
---@field money number
---@field equippedJetpack string
---@field _jetpack JetpackEntity | nil
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param data table<string, any>
---@return PlayerEntity
function PlayerEntity.new(player, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self.money = data.money or 100
	self.equippedJetpack = data.equippedJetpack or ""
	self._jetpack = nil
	self._state = "Idle"
	return self
end

function PlayerEntity:getData()
	return self.data
end

---@param jetpack JetpackEntity
function PlayerEntity:equipJetpack(jetpack)
	self._jetpack = jetpack
	self._jetpack:equipToPlayer(self)
end

function PlayerEntity:unequipJetpack()
	if self._jetpack then
		self._jetpack:destroy()
	end
end

return PlayerEntity
