local CameraService = require(script.CameraService)

---@class FlyingSystemSharedServices
---@field config SharedConfig
---@field diContainer DIContainer
---@field cameraService FlyingSystemCameraService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@param config SharedConfig
---@return FlyingSystemSharedServices
function Services.new(diContainer, config)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.config = config
	self.cameraService = CameraService.new(diContainer, config)
	return self
end

function Services:init()
end

return Services
