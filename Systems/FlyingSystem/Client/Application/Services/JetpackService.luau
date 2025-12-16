---@class ClientJetpackService
---@field diContainer DIContainer
---@field flyingRepository FlyingSystemClientRepository
local JetpackService = {}
JetpackService.__index = JetpackService

---@param diContainer DIContainer
---@return ClientJetpackService
function JetpackService.new(diContainer)
	local self = setmetatable({}, JetpackService)
	self.diContainer = diContainer
	return self
end

function JetpackService:init()
	self.cameraService = self.diContainer:resolve("CameraService")
	self.flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = self.flyingRepository:getFlyingEntity()

	-- Listen for flying activation/deactivation to control camera
	flyingEntity.isActive.Changed:Connect(function(isActive)
		self.cameraService:setActive(isActive)
	end)

end

---@param jetpack any
function JetpackService:equipJetpack(jetpack)
	local flyingEntity = self.flyingRepository:getFlyingEntity()
	flyingEntity:setJetpack(jetpack)
	flyingEntity:activateFlying()
end

---@param jetpack any
function JetpackService:unequipJetpack(jetpack)
	local flyingEntity = self.flyingRepository:getFlyingEntity()
	flyingEntity:deactivateFlying()
end

return JetpackService
