local Services = require(script.Services)

---@class FlyingSystemApplication
---@field services FlyingSystemApplicationServices
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return FlyingSystemApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
    self.services = Services.new(self.diContainer)
	return self
end

function Application:init()
	---@type FlyingSystemClientFlyingService
	local flyingService = self.diContainer:resolve("FlyingService")
	flyingService:init()
	---@type ClientJetpackService
	local jetpackService = self.diContainer:resolve("JetpackService")
	jetpackService:init()

	---@type FlyingSystemClientCameraService
	local cameraService = self.diContainer:resolve("CameraService")
	cameraService:init()
end

return Application
