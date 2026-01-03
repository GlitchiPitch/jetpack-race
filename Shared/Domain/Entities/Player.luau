---@class PlayerEntity
---@field player Player
---@field money number
---@field equippedJetpack string
---@field jetpack JetpackEntity | nil
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param data table<string, any>
---@return PlayerEntity
function PlayerEntity.new(player, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self.money = data.money or 100
	self.equippedJetpack = data.equippedJetpack or "Default"
	self.jetpack = nil
	self._state = "Idle"
	return self
end

function PlayerEntity:getData()
	warn(self)
	return {
		money = self.money,
		equippedJetpack = self.equippedJetpack,
		jetpack = self.jetpack and self.jetpack:getData(),
	}
end

---@param jetpack JetpackEntity
function PlayerEntity:equipJetpack(jetpack)
	self.jetpack = jetpack
	self.jetpack:equipToPlayer(self)
end

function PlayerEntity:unequipJetpack()
	if self.jetpack then
		self.jetpack:destroy()
	end
end

function PlayerEntity:disableDefaultControl()
	local PlayerModule = require(self.player.PlayerScripts:FindFirstChild("PlayerModule"))
	local Control = PlayerModule:GetControls()
	Control:Disable()
end

return PlayerEntity
