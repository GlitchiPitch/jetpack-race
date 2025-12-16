local UserInputService = game:GetService("UserInputService")
local JetpackUI = require(script.Jetpack)

---@class FlyingSystemUI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return FlyingSystemUI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer
	self.isActive = false
	self._connections = {}
	self.jetpackUI = JetpackUI.new(self.diContainer)
	return self
end

function UI:init()
	self.remoteEventService = self.diContainer:resolve("RemoteEventService")
	self.inputService = self.diContainer:resolve("InputService")
	self.constants = self.diContainer:resolve("Shared.Constants")

	---@type FlyingSystemClientRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()

	flyingEntity.isActive.Changed:Connect(function(value)
		self.jetpackUI:set(value)
		if value then
			self:Activate()
		else
			self:Deactivate()
		end
	end)

	-- Check initial state
	if flyingEntity.isActive then
		self:Activate()
	end
	flyingEntity.speedMultiplier.Changed:Connect(function(value)
		self.jetpackUI:setSpeedMultiplier(value)
	end)
	flyingEntity.sprintActivated.Changed:Connect(function(value)
		self.jetpackUI:setSprintActivated(value)
	end)
end

function UI:Activate()
	if self.isActive then
		return
	end
	self.isActive = true

	warn("FlyingSystem UI: Activating flying controls")

	-- Отслеживание изменений камеры через RunService
	local RunService = game:GetService("RunService")
	self._connections.cameraChanged = RunService.RenderStepped:Connect(function()
		self:OnCameraChanged()
	end)

	self._connections.inputBegan = UserInputService.InputBegan:Connect(function(input, processed)
		if not processed then
			self:OnInputBegan(input)
		end
	end)

	self._connections.inputEnded = UserInputService.InputEnded:Connect(function(input, processed)
		if not processed then
			self:OnInputEnded(input)
		end
	end)
end

function UI:Deactivate()
	self.isActive = false

	for _, connection in self._connections do
		connection:Disconnect()
	end
	self._connections = {}
end

function UI:OnCameraChanged()
	if not self.isActive then
		return
	end

	-- Проверить, экипирован ли джетпак (наличие BodyPosition и BodyGyro)
	local player = game.Players.LocalPlayer
	local character = player.Character
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	local hasBodyPosition = humanoidRootPart:FindFirstChild("BodyPosition") ~= nil
	local hasBodyGyro = humanoidRootPart:FindFirstChild("BodyGyro") ~= nil

	if not (hasBodyPosition and hasBodyGyro) then
		-- Джетпак не экипирован, не отправлять обновления
		return
	end

	local cameraCFrame = self.inputService:GetCameraCFrame()
	warn("FlyingSystem UI: Sending flying update with camera position:", cameraCFrame.Position)
	self.remoteEventService:fireServer("flying", cameraCFrame)
end

function UI:OnInputBegan(input)
	if input.KeyCode == self.constants.INPUT_KEYS.SPRINT then
		self.remoteEventService:fireServer("sprint", true)
	end
end

function UI:OnInputEnded(input)
	if input.KeyCode == self.constants.INPUT_KEYS.SPRINT then
		self.remoteEventService:fireServer("sprint", false)
	end
end

return UI
