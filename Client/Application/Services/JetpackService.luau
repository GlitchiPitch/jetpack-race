local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
---@class ClientJetpackService
---@field diContainer DIContainer
---@field _updateTime number
---@field _deltaTime number
---@field _inputBeganConnect RBXScriptConnection
---@field _inputEndedConnect RBXScriptConnection
---@field _renderConnect RBXScriptConnection
local JetpackService = {}
JetpackService.__index = JetpackService

---@param diContainer DIContainer
---@return ClientJetpackService
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

	playerService:toggleDefaultControl(false)
	self:_moveUp()
	self:_listenInput()

	local function onRender(deltaTime: number)
		self._deltaTime += deltaTime
		if self._deltaTime >= self._updateTime then
			self._deltaTime = 0
			local a = cameraService:getUnitVector()
			playerJetpack:setMovers({
				isActive = true,
				vectorVelocity = a * playerJetpack.speed,
				orientationCFrame = cameraService:getCFrame(),
			})

			playerJetpack:updateNitro()
		end
	end

	self._renderConnect = RunService.RenderStepped:Connect(onRender)
end

function JetpackService:finishFly()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local playerService = application.services.playerService
	playerService:toggleDefaultControl(true)

	if self._inputBeganConnect then
		self._inputBeganConnect:Disconnect()
	end
	if self._inputEndedConnect then
		self._inputEndedConnect:Disconnect()
	end
	if self._renderConnect then
		self._renderConnect:Disconnect()
	end
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

function JetpackService:_listenInput()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local playerService = application.services.playerService
	local playerJetpack = playerService:getPlayerJetpack()

	---@param input InputObject
	---@param gameProcessed boolean
	local function inputBegan(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			playerJetpack:toggleNitro(true)
		end
	end

	local function inputEnded(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			playerJetpack:toggleNitro(false)
		end
	end

	self._inputBeganConnect = UserInputService.InputBegan:Connect(inputBegan)
	self._inputEndedConnect = UserInputService.InputEnded:Connect(inputEnded)
end

return JetpackService
