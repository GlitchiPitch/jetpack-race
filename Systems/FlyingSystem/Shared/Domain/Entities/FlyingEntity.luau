---@class FlyingEntity
---@field playerEntity PlayerEntity
---@field isActive BoolValue
---@field speedMultiplier NumberValue
---@field sprintActivated BoolValue
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
	self.sprintActivated = flyingData.SprintActivated
	self.flyingData = flyingData

	self.flyingData.Parent = self.playerEntity.player
	return self
end

---@return boolean
function FlyingEntity:canFly(): boolean
	return self.isActive
end

---@return boolean
function FlyingEntity:canSprint(): boolean
	return self:canFly()
end

---@param baseSpeed number
---@param sprintMultiplier number
---@return number
function FlyingEntity:calculateSpeed(baseSpeed: number, sprintMultiplier: number): number
	local multiplier = self.sprintActivated and sprintMultiplier or 1
	return baseSpeed * multiplier
end

---@param jetpack any
function FlyingEntity:setJetpack(jetpack)
	self.jetpack = jetpack
end

---@return table
function FlyingEntity:GetState()
	return {
		isActive = self.isActive.Value,
		speedMultiplier = self.speedMultiplier.Value,
		sprintActivated = self.sprintActivated.Value,
	}
end

function FlyingEntity:setSprintActivated(active)
	self.sprintActivated.Value = active
end

function FlyingEntity:isSprintActivated()
	return self.sprintActivated.Value
end

---@param active boolean
function FlyingEntity:setFlyingActive(active)
	self.isActive.Value = active
end

function FlyingEntity:activateFlying()
	warn("FlyingEntity: Activated flying")
	self.isActive.Value = true
	self.sprintActivated.Value = false

	-- Set humanoid stand to false when flying
	local character = self.playerEntity.player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
			humanoid.Sit = false
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		end
	end

	warn("FlyingEntity: Activated flying - Active:", self.isActive.Value)
end

function FlyingEntity:deactivateFlying()
	self.isActive.Value = false
	self.sprintActivated.Value = false

	-- Reset humanoid state when stopping flying
	local character = self.playerEntity.player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		end
	end
end

return FlyingEntity
