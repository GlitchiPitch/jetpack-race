local UserInputService = game:GetService("UserInputService")

---@class InputService
local InputService = {}
InputService.__index = InputService

---@param diContainer DIContainer
---@return InputService
function InputService.new(diContainer)
	local self = setmetatable({}, InputService)
	self.diContainer = diContainer
	return self
end

---@return CFrame
function InputService:GetCameraCFrame()
	return workspace.CurrentCamera.CFrame
end

---@return boolean
function InputService:IsSprintInputActive()
	---@type FlyingSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")
	return UserInputService:IsKeyDown(constants.INPUT_KEYS.SPRINT)
end

---@return boolean
function InputService:IsMouseButtonDown()
	return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end

---@return boolean
function InputService:IsTouchActive()
	-- Check if any touch input is currently active
	local touchInputs = UserInputService:GetConnectedGamepads() -- This might not be the best way
	-- Actually, let's check if we're on a touch device and if there are active touches
	local isTouchDevice = UserInputService.TouchEnabled
	if not isTouchDevice then
		return false
	end

	-- For touch, we'll need to track touch events separately
	-- For now, return false as we'll handle touch in the UI system
	return false
end

---@return boolean
function InputService:IsSprintInputActiveExtended()
	-- Check keyboard sprint key
	if self:IsSprintInputActive() then
		return true
	end

	-- Check mouse left button (only if jetpack is equipped)
	if self:IsMouseButtonDown() and self:_hasJetpackEquipped() then
		return true
	end

	-- Touch input will be handled in UI system
	return false
end

---@return boolean
function InputService:IsFlyInputActive()
	return UserInputService:IsKeyDown(Enum.KeyCode.Space)
end

---@return boolean
function InputService:_hasJetpackEquipped()
	local player = game.Players.LocalPlayer
	local character = player.Character
	if not character then
		return false
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return false
	end

	-- Check for BodyVelocity which indicates jetpack is equipped
	return humanoidRootPart:FindFirstChild("BodyVelocity") ~= nil
end

---@return Vector3
function InputService:GetMovementInput()
	---@type FlyingSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	local moveVector = Vector3.new(0, 0, 0)

	if UserInputService:IsKeyDown(constants.INPUT_KEYS.MOVE_LEFT) then
		moveVector = Vector3.new(-1, 0, 0)
	end
	if UserInputService:IsKeyDown(constants.INPUT_KEYS.MOVE_RIGHT) then
		moveVector = Vector3.new(1, 0, 0)
	end

	-- Check if player has jetpack equipped (BodyPosition on HumanoidRootPart indicates jetpack)
	-- local hasJetpack = self:_hasJetpackEquipped()

	-- if not hasJetpack then
	-- 	-- Only process W/S keys if no jetpack equipped
	-- 	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
	-- 		moveVector = moveVector + Vector3.new(0, 0, -1) -- Negative Z for forward
	-- 	end
	-- 	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
	-- 		moveVector = moveVector + Vector3.new(0, 0, 1) -- Positive Z for backward
	-- 	end
	-- end

	return moveVector.Unit
end

return InputService
