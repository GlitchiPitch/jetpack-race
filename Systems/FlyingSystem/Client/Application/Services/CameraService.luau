--Services--
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

---@class FlyingSystemClientCameraService
---@field diContainer DIContainer
---@field cameraConstants table
---@field currentCamera Camera
---@field localPlayer Player
---@field currentCharacter Model
---@field cameraInitialized boolean
---@field cameraOrientation Vector2
---@field xOffset number
---@field isActive boolean
local CameraService = {}
CameraService.__index = CameraService

---@param diContainer DIContainer
---@return FlyingSystemClientCameraService
function CameraService.new(diContainer)
	local self = setmetatable({}, CameraService)
	self.diContainer = diContainer
	self.currentCamera = workspace.CurrentCamera
	self.localPlayer = Players.LocalPlayer
	self.cameraInitialized = false
	self.cameraOrientation = Vector2.new(0, 0)
	self.isActive = false

	-- Get camera constants from shared constants
	local sharedConstants = diContainer:resolve("Shared.Constants")
	self.cameraConstants = {
		offset = sharedConstants.CAMERA_OFFSET,
		settings = sharedConstants.CAMERA_SETTINGS,
		inputKeys = {
			switchShoulder = sharedConstants.INPUT_KEYS.SWITCH_SHOULDER,
		},
	}
	self.xOffset = self.cameraConstants.offset.X

	return self
end

function CameraService:init()
	-- Handle existing character
	if self.localPlayer.Character then
		self.currentCharacter = self.localPlayer.Character
	else
		self.currentCharacter = self.localPlayer.CharacterAdded:Wait()
	end

	-- Ensure camera follows player by default
	self.currentCamera.CameraType = Enum.CameraType.Custom

	self.localPlayer.CharacterAdded:Connect(function(newCharacter)
		self.currentCharacter = newCharacter
		if self.isActive then
			self:disableAutoRotate()
		end
	end)
end

---@param active boolean
function CameraService:setActive(active)
	if active and not self.isActive then
		self:activateCamera()
	elseif not active and self.isActive then
		self:deactivateCamera()
	end
end

function CameraService:activateCamera()
	if self.isActive then
		return
	end

	self.isActive = true
	self.cameraInitialized = false
	self.cameraOrientation = Vector2.new(0, 0)
	self:disableAutoRotate()

	-- Bind input actions
	ContextActionService:BindAction("MoveMouse", function(actionName, inputState)
		self:onMouseMovement()
	end, false, Enum.UserInputType.MouseMovement)

	ContextActionService:BindAction("SwitchShoulder", function(actionName, inputState)
		if inputState == Enum.UserInputState.Begin then
			self:onSwitchShoulder()
		end
	end, false, self.cameraConstants.inputKeys.switchShoulder)

	-- Connect update loops
	self.renderSteppedConnection = RunService.RenderStepped:Connect(function()
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		self:updateCamera()
	end)

	self.steppedConnection = RunService.Stepped:Connect(function()
		self:updateNeckTransform()
	end)
end

function CameraService:deactivateCamera()
	if not self.isActive then
		return
	end

	self.isActive = false

	-- Unbind actions
	ContextActionService:UnbindAction("MoveMouse")
	ContextActionService:UnbindAction("SwitchShoulder")

	-- Disconnect update loops
	if self.renderSteppedConnection then
		self.renderSteppedConnection:Disconnect()
		self.renderSteppedConnection = nil
	end

	if self.steppedConnection then
		self.steppedConnection:Disconnect()
		self.steppedConnection = nil
	end

	-- Reset camera
	self.currentCamera.CameraType = Enum.CameraType.Custom
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default

	-- Re-enable auto rotate
	self:enableAutoRotate()
end

-- Character Handling
function CameraService:disableAutoRotate()
	local humanoid = self.currentCharacter:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.AutoRotate = false
	else
		task.delay(self.cameraConstants.settings.AUTO_ROTATE_DELAY, function()
			self:disableAutoRotate()
		end)
	end
end

function CameraService:enableAutoRotate()
	local humanoid = self.currentCharacter:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.AutoRotate = true
	end
end

function CameraService:updateNeckTransform()
	local head = self.currentCharacter:FindFirstChild("Head")
	local neck = head and head:FindFirstChildOfClass("Motor6D")
	if not neck then
		return
	end

	local deltaCframe = CFrame.Angles(math.rad(-self.cameraOrientation.Y), 0, 0)
	neck.Transform = neck.Transform * deltaCframe
end

-- Camera Manipulation
function CameraService:updateCamera()
	self.currentCamera.CameraType = Enum.CameraType.Scriptable

	local deltaCframe = CFrame.Angles(math.rad(-self.cameraOrientation.Y), 0, 0)
	local primaryPart = self.currentCharacter.PrimaryPart
	if primaryPart then
		self.currentCamera.CFrame = primaryPart.CFrame:ToWorldSpace(
			CFrame.new(self.xOffset, self.cameraConstants.offset.Y, self.cameraConstants.offset.Z)
		) * deltaCframe
	end
end

function CameraService:onMouseMovement()
	local mouseDelta = UserInputService:GetMouseDelta()
	local xDelta = mouseDelta.X * self.cameraConstants.settings.SPEED_MULTIPLIER
	local yDelta = mouseDelta.Y * self.cameraConstants.settings.SPEED_MULTIPLIER

	self.cameraOrientation = Vector2.new(
		self.cameraOrientation.X + xDelta,
		math.clamp(
			self.cameraOrientation.Y + yDelta,
			-self.cameraConstants.settings.Y_EXTREME,
			self.cameraConstants.settings.Y_EXTREME
		)
	)

	local deltaXCframe = CFrame.Angles(0, math.rad(-xDelta), 0)
	local rootPart = self.currentCharacter.PrimaryPart
	if rootPart then
		rootPart.CFrame = rootPart.CFrame * deltaXCframe
	end
end

function CameraService:onSwitchShoulder()
	self.xOffset = -self.xOffset
end

return CameraService
