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

---@return Model?
function PlayerEntity:getCharacter()
	return self.player.Character
end

---@return Humanoid
function PlayerEntity:getHumanoid()
	local character = self:getCharacter()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	return humanoid
end

---@return Animator
function PlayerEntity:getAnimator()
	local humanoid = self:getHumanoid()
	local animator = humanoid:FindFirstChildOfClass("Animator")
	return animator
end

function PlayerEntity:disableDefaultControl()
	local PlayerModule = require(self.player.PlayerScripts:FindFirstChild("PlayerModule"))
	local character = self:getCharacter()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local Control = PlayerModule:GetControls()
	Control:Disable()
	humanoid.PlatformStand = true
end

return PlayerEntity
