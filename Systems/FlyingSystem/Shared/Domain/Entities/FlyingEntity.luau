---@class FlyingEntity
---@field playerEntity PlayerEntity
---@field isActive BoolValue
---@field speedMultiplier NumberValue
---@field sprintActivated BoolValue
---@field jetpackState StringValue
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
	self.jetpackState = flyingData.JetpackState
	self.flyingData = flyingData

	-- Set initial state
	self.jetpackState.Value = "Inactive"

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
		jetpackState = self.jetpackState.Value,
	}
end

function FlyingEntity:setSprintActivated(active)
	self.sprintActivated.Value = active
end

function FlyingEntity:isSprintActivated()
	return self.sprintActivated.Value
end

---@return string
function FlyingEntity:getJetpackState()
	return self.jetpackState.Value
end

---@param state string
function FlyingEntity:setJetpackState(state)
	self.jetpackState.Value = state
end

function FlyingEntity:startActivating()
	self:setJetpackState("Activating")
	self.isActive.Value = true
	self:activateFlying()
end

function FlyingEntity:startIdle()
	self:setJetpackState("Idle")
	self.isActive.Value = true
end

function FlyingEntity:startFlying()
	self:setJetpackState("Flying")
	self.isActive.Value = true
end

function FlyingEntity:startDeactivating()
	self:setJetpackState("Deactivating")
	self.isActive.Value = true
end

function FlyingEntity:deactivate()
	self:setJetpackState("Inactive")
	self.isActive.Value = false
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
			local originalPlatformStand = humanoid.PlatformStand
			humanoid.PlatformStand = true
			humanoid.Sit = false
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

			if originalPlatformStand and humanoid.PlatformStand then
				warn("FlyingEntity: PlatformStand was not disabled - still true after setting to false")
			end
		else
			warn("FlyingEntity: Humanoid not found in character")
		end
	else
		warn("FlyingEntity: Character not found for player", self.playerEntity.player.Name)
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
