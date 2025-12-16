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

return InputService
