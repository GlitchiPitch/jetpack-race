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
function InputService:IsFlyInputActive()
	return UserInputService:IsKeyDown(Enum.KeyCode.Space)
end

---@return Vector3
function InputService:GetMovementInput()
	---@type FlyingSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	local moveVector = Vector3.new(0, 0, 0)

	if UserInputService:IsKeyDown(constants.INPUT_KEYS.MOVE_FORWARD) then
		moveVector = moveVector + Vector3.new(0, 0, -1)
	end
	if UserInputService:IsKeyDown(constants.INPUT_KEYS.MOVE_BACKWARD) then
		moveVector = moveVector + Vector3.new(0, 0, 1)
	end
	if UserInputService:IsKeyDown(constants.INPUT_KEYS.MOVE_LEFT) then
		moveVector = moveVector + Vector3.new(-1, 0, 0)
	end
	if UserInputService:IsKeyDown(constants.INPUT_KEYS.MOVE_RIGHT) then
		moveVector = moveVector + Vector3.new(1, 0, 0)
	end

	return moveVector.Unit
end

return InputService
