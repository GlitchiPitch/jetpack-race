---@class FlyingEntity
---@field isActive boolean
---@field speedMultiplier number
---@field chargeLevel number
---@field sprintActivated boolean
---@field maxCharge number
local FlyingEntity = {}
FlyingEntity.__index = FlyingEntity

---@return FlyingEntity
function FlyingEntity.new()
	local self = setmetatable({}, FlyingEntity)
	self.isActive = false
	self.speedMultiplier = 1.0
	self.chargeLevel = 100
	self.sprintActivated = false
	self.maxCharge = 100
	return self
end

---@return boolean
function FlyingEntity:CanFly(): boolean
	return self.isActive and self.chargeLevel > 0
end

---@return boolean
function FlyingEntity:CanSprint(): boolean
	return self:CanFly() and self.chargeLevel > 5
end

---@param baseSpeed number
---@param sprintMultiplier number
---@return number
function FlyingEntity:CalculateSpeed(baseSpeed: number, sprintMultiplier: number): number
	local multiplier = self.sprintActivated and sprintMultiplier or 1
	return baseSpeed * multiplier
end

---@param amount number
---@return boolean
function FlyingEntity:ConsumeCharge(amount: number): boolean
	if self.chargeLevel >= amount then
		self:UpdateCharge(-amount)
		return true
	end
	return false
end

---@param value number
function FlyingEntity:UpdateCharge(value)
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

return FlyingEntity
