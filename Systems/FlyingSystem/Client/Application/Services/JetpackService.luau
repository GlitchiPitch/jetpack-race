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

	-- Найти Handle часть в модели джетпака
	local handle = jetpack:FindFirstChild("Handle")
	if not handle then
		warn("JetpackService: Handle part not found in jetpack model")
		return
	end

	-- Найти аттачменты LeftVFX и RightVFX
	local leftVFX = handle:FindFirstChild("LeftVFX")
	local rightVFX = handle:FindFirstChild("RightVFX")

	if leftVFX then
		self:_enableParticleEmitters(leftVFX)
	else
		warn("JetpackService: LeftVFX attachment not found")
	end

	if rightVFX then
		self:_enableParticleEmitters(rightVFX)
	else
		warn("JetpackService: RightVFX attachment not found")
	end

	-- Отключить стандартный контроллер игрока
	self:_disableDefaultController()

	-- Переместить на правильную высоту Y
	self:_moveToFlyingHeight()

	-- Начать процесс активации джетпака
	flyingEntity:startActivating()
end

---@param jetpack any
function JetpackService:unequipJetpack(jetpack)
	local flyingEntity = self.flyingRepository:getFlyingEntity()
	flyingEntity:startDeactivating()
end

function JetpackService:startFlying()
	local flyingEntity = self.flyingRepository:getFlyingEntity()
	local currentState = flyingEntity:getJetpackState()
	local constants = self.diContainer:resolve("Shared.Constants")

	if currentState == constants.JETPACK_STATES.IDLE then
		flyingEntity:startFlying()
	end
end

function JetpackService:stopFlying()
	local flyingEntity = self.flyingRepository:getFlyingEntity()
	local currentState = flyingEntity:getJetpackState()
	local constants = self.diContainer:resolve("Shared.Constants")

	if currentState == constants.JETPACK_STATES.FLYING then
		flyingEntity:startIdle()
	end
end

---@param attachment Attachment
function JetpackService:_enableParticleEmitters(attachment)
	for _, descendant in ipairs(attachment:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") then
			descendant.Enabled = true
		end
	end
end

function JetpackService:_disableDefaultController()
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer

	-- Дождаться загрузки PlayerScripts
	local playerScripts = player:WaitForChild("PlayerScripts")

	-- Дождаться загрузки PlayerModule
	local playerModule = playerScripts:WaitForChild("PlayerModule")

	-- Загрузить PlayerModule
	local playerModuleScript = require(playerModule)

	-- Получить контроллеры и отключить их
	local controls = playerModuleScript:GetControls()
	if controls then
		controls:Disable()
		warn("JetpackService: Default player controls disabled")
	else
		warn("JetpackService: Could not get controls from PlayerModule")
	end
end

function JetpackService:_moveToFlyingHeight()
	local player = game.Players.LocalPlayer
	local character = player.Character
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	local bodyPosition = humanoidRootPart:FindFirstChild("BodyPosition")
	if not bodyPosition then
		warn("JetpackService: BodyPosition not found - BodyMovers may not be set up")
		return
	end

	-- Установить позицию на высоте полета (Y=50)
	local flyingHeight = 50
	local currentPosition = humanoidRootPart.Position
	local targetPosition = Vector3.new(currentPosition.X, flyingHeight, currentPosition.Z)

	bodyPosition.Position = targetPosition
	bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
	bodyPosition.D = 100

	-- Также настроить BodyGyro для ориентации
	local bodyGyro = humanoidRootPart:FindFirstChild("BodyGyro")
	if bodyGyro then
		local camera = workspace.CurrentCamera
		bodyGyro.CFrame = camera.CFrame
		bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
		bodyGyro.D = 100
	end
end

return JetpackService
