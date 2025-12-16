---@class FlyingSystemCameraService
---@field constants FlyingSystemConstants
---@field config FlyingSystemSharedConfig
local CameraService = {}
CameraService.__index = CameraService

---@param diContainer DIContainer
---@param config FlyingSystemSharedConfig
---@return FlyingSystemCameraService
function CameraService.new(diContainer, config)
	local self = setmetatable({}, CameraService)
	self.diContainer = diContainer
	self.config = config

	return self
end

---@return table
function CameraService:getCameraConstants()
	local constants = self.diContainer:resolve("Shared.Constants")
	return {
		offset = constants.CAMERA_OFFSET,
		settings = constants.CAMERA_SETTINGS,
		inputKeys = {
			switchShoulder = constants.INPUT_KEYS.SWITCH_SHOULDER,
		},
	}
end

return CameraService
