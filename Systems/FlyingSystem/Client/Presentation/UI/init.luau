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
	self.jetpackService = self.diContainer:resolve("JetpackService")
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

	-- Camera changes are now handled by the client-side MovementService
	-- No need to send camera CFrame to server anymore
	-- Position updates are sent automatically by MovementService
end

function UI:OnInputBegan(input)
	if input.KeyCode == self.constants.INPUT_KEYS.SPRINT then
		self.remoteEventService:fireServer("sprint", true)
	elseif input.KeyCode == Enum.KeyCode.Space then
		self.jetpackService:startFlying()
	end
end

function UI:OnInputEnded(input)
	if input.KeyCode == self.constants.INPUT_KEYS.SPRINT then
		self.remoteEventService:fireServer("sprint", false)
	elseif input.KeyCode == Enum.KeyCode.Space then
		self.jetpackService:stopFlying()
	end
end

return UI
