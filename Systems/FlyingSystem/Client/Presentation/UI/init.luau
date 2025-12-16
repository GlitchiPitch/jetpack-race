local UserInputService = game:GetService("UserInputService")

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
	return self
end

function UI:init()
	self.remoteEventService = self.diContainer:resolve("RemoteEventService")
	self.inputService = self.diContainer:resolve("InputService")
	self.constants = self.diContainer:resolve("Shared.Constants")
end

function UI:Activate()
	if self.isActive then
		return
	end
	self.isActive = true

	self._connections.inputChanged = UserInputService.InputChanged:Connect(function()
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

	local cameraCFrame = self.inputService:GetCameraCFrame()
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
