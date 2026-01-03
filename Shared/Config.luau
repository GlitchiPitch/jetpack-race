---@class cameraSettings
local cameraSettings = {
	normalMouseSensitivity = 0.3,
	normalCameraOffset = Vector3.new(-3, 1, 15),
	normalFov = 80,
	normalRotationSmoothness = 0.15,

	aimMouseSensitivity = 0.2,
	aimCameraOffset = Vector3.new(1.5, 1.8, 6.0),
	aimFov = 50,
	aimRotationSmoothness = 0.8,

	nitroMouseSensitivity = 0.2,
	nitroCameraOffset = Vector3.new(-3, 1, 25),
	nitroFov = 100,
	nitroRotationSmoothness = 0.8,

	minPitch = -80,
	maxPitch = 80,

	cameraCollisionBuffer = 0.2,
	smoothTransitionSpeed = 10,
}

---@class SharedConfig
local Config = {
	cameraSettings = cameraSettings,
}

return Config
