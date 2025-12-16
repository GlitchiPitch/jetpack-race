---@class FlyingEntity
---@field playerEntity PlayerEntity
---@field isActive BoolValue
---@field speedMultiplier NumberValue
---@field chargeLevel NumberValue
---@field sprintActivated BoolValue
---@field maxCharge NumberValue
local FlyingEntity = {}
FlyingEntity.__index = FlyingEntity

---@param playerEntity PlayerEntity
---@param flyingData Configuration
---@return FlyingEntity
function FlyingEntity.new(playerEntity, flyingData)
	local self = setmetatable({}, FlyingEntity)
	self.playerEntity = playerEntity
	self.isActive = flyingData.IsActive
	self.speedMultiplier = flyingData.SpeedMultiplier
	self.chargeLevel = flyingData.ChargeLevel
	self.sprintActivated = flyingData.SprintActivated
	self.maxCharge = flyingData.MaxCharge
	self.flyingData = flyingData

	self.flyingData.Parent = self.playerEntity.player
	return self
end

---@return boolean
function FlyingEntity:canFly(): boolean
	return self.isActive and self.chargeLevel > 0
end

---@return boolean
function FlyingEntity:canSprint(): boolean
	return self:canFly() and self.chargeLevel > 5
end

---@param baseSpeed number
---@param sprintMultiplier number
---@return number
function FlyingEntity:calculateSpeed(baseSpeed: number, sprintMultiplier: number): number
	local multiplier = self.sprintActivated and sprintMultiplier or 1
	return baseSpeed * multiplier
end

---@param amount number
---@return boolean
function FlyingEntity:consumeCharge(amount: number): boolean
	if self.chargeLevel >= amount then
		self:updateCharge(-amount)
		return true
	end
	return false
end

---@param value number
function FlyingEntity:updateCharge(value)
	self.chargeLevel += value
end

---@return table
function FlyingEntity:GetState()
	return {
		isActive = self.isActive,
		speedMultiplier = self.speedMultiplier,
		chargeLevel = self.chargeLevel,
		sprintActivated = self.sprintActivated,
		maxCharge = self.maxCharge,
	}
end

function FlyingEntity:setSprintActivated(active)
	self.sprintActivated = active
end

function FlyingEntity:isSprintActivated()
	return self.sprintActivated
end

return FlyingEntity
