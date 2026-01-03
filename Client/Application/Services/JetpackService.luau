local RunService = game:GetService("RunService")
---@class ClientJetpackService
---@field diContainer DIContainer
---@field _updateTime number
---@field _deltaTime number
local JetpackService = {}
JetpackService.__index = JetpackService

---@param diContainer DIContainer
function JetpackService.new(diContainer)
	local self = setmetatable({}, JetpackService)
	self.diContainer = diContainer
	self._updateTime = 0.3
	self._deltaTime = 0
	return self
end

---@param jetpackData jetpackData
function JetpackService:updateJetpack(jetpackData)
	---@type ClientInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	local jetpack = shared.Domain.Entities.Jetpack.new(jetpackData)
	infrastructure.repositories.playerRepository:updateJetpack(jetpack)
end

function JetpackService:startFly()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local cameraService = application.services.cameraService
	local playerService = application.services.playerService
	local playerJetpack = playerService:getPlayerJetpack()

	playerService:disableDefaultControl()
	self:_moveUp()

	local function onRender(deltaTime: number)
		self._deltaTime += deltaTime
		if self._deltaTime >= self._updateTime then
			self._deltaTime = 0
			local a = cameraService:getUnitVector()
			playerJetpack:setMovers({
				isActive = true,
				vectorVelocity = a * 50,
				orientationCFrame = cameraService:getCFrame(),
			})
		end
	end

	RunService.RenderStepped:Connect(onRender)
end

function JetpackService:_moveUp()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local playerService = application.services.playerService
	local cameraService = application.services.cameraService
	local playerJetpack = playerService:getPlayerJetpack()

	playerJetpack:setMovers({
		isActive = true,
		vectorVelocity = Vector3.yAxis * 10,
		orientationCFrame = cameraService:getCFrame(),
	})

	task.wait(3)
end

return JetpackService
