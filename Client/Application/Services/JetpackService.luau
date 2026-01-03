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

function JetpackService:startFly()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local playerJetpack = application.services.playerService:getPlayerJetpack()
	local cameraService = application.services.cameraService
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
	script.Parent.AlignOrientation.Enabled = true
	script.Parent.LinearVelocity.Enabled = true
	script.Parent.LinearVelocity.VectorVelocity = Vector3.yAxis * 10
end

return JetpackService
