--Services--
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

---@class FlyingSystemClientCameraService
---@field currentCamera Camera
---@field localPlayer Player
---@field currentCharacter Model
---@field isActive boolean
---@field cameraOrientation Vector2
---@field xOffset number
---@field renderConnection RBXScriptConnection?
---@field steppedConnection RBXScriptConnection?
local CameraService = {}
CameraService.__index = CameraService

---@return FlyingSystemClientCameraService
function CameraService.new(diContainer)
	local self = setmetatable({}, CameraService)
	self.diContainer = diContainer
	-- Initialize properties
	self.currentCamera = workspace.CurrentCamera
	self.localPlayer = Players.LocalPlayer
	self.currentCharacter = self.localPlayer.Character or self.localPlayer.CharacterAdded:Wait()
	self.isActive = false
	self.cameraOrientation = Vector2.new(0, 0)

	local sharedConstants = self.diContainer:resolve("Shared.Constants")
	self.xOffset = sharedConstants.CAMERA_OFFSET.X
	self.renderConnection = nil
	self.steppedConnection = nil

	warn("CameraService: Created new instance for player:", self.localPlayer.Name)

	-- Set up character handling
	if self.localPlayer.Character then
		warn("CameraService: Character already exists, setting up for player:", self.localPlayer.Name)
		self:_onCharacterAdded(self.localPlayer.Character)
	end
	self.localPlayer.CharacterAdded:Connect(function(character)
		self:_onCharacterAdded(character)
	end)

	return self
end

-- Private methods
---@param newCharacter Model
function CameraService:_onCharacterAdded(newCharacter)
	warn("CameraService: Character added/changed for player:", self.localPlayer.Name)
	self.currentCharacter = newCharacter
	if self.isActive then
		self:_disableAutoRotate()
	end
end

function CameraService:_disableAutoRotate()
	local humanoid = self.currentCharacter:FindFirstChildOfClass("Humanoid")
	local sharedConstants = self.diContainer:resolve("Shared.Constants")
	if humanoid then
		print("disabling auto rotate")
		humanoid.AutoRotate = false
	else
		task.delay(sharedConstants.CAMERA_SETTINGS.AUTO_ROTATE_DELAY, function()
			self:_disableAutoRotate()
		end)
	end
end

function CameraService:_enableAutoRotate()
	local humanoid = self.currentCharacter:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.AutoRotate = true
	end
end

function CameraService:_updateNeckTransform()
	local head: Instance = self.currentCharacter:FindFirstChild("Head")
	local neckMotor: Motor6D? = head:FindFirstChildOfClass("Motor6D")
	if not neckMotor then
		return
	end

	local delta_cframe: CFrame = CFrame.Angles(math.rad(-self.cameraOrientation.Y), 0, 0)
	neckMotor.Transform = neckMotor.Transform * delta_cframe
end

-- Private camera manipulation methods
function CameraService:_updateCamera()
	self.currentCamera.CameraType = Enum.CameraType.Scriptable

	local sharedConstants = self.diContainer:resolve("Shared.Constants")
	local delta_cframe: CFrame = CFrame.Angles(math.rad(-self.cameraOrientation.Y), 0, 0)
	self.currentCamera.CFrame = (self.currentCharacter.PrimaryPart :: BasePart).CFrame:ToWorldSpace(
		CFrame.new(self.xOffset, sharedConstants.CAMERA_OFFSET.Y, sharedConstants.CAMERA_OFFSET.Z)
	) * delta_cframe
end

function CameraService:_onMouseMovement()
	local sharedConstants = self.diContainer:resolve("Shared.Constants")
	local mouse_delta: Vector2 = UserInputService:GetMouseDelta()
	local x_delta: number = mouse_delta.X * sharedConstants.CAMERA_SETTINGS.SPEED_MULTIPLIER
	local y_delta: number = mouse_delta.Y * sharedConstants.CAMERA_SETTINGS.SPEED_MULTIPLIER

	self.cameraOrientation = Vector2.new(
		math.clamp(
			self.cameraOrientation.X + x_delta,
			-sharedConstants.CAMERA_SETTINGS.X_EXTREME,
			sharedConstants.CAMERA_SETTINGS.X_EXTREME
		),
		math.clamp(
			self.cameraOrientation.Y + y_delta,
			-sharedConstants.CAMERA_SETTINGS.Y_EXTREME,
			sharedConstants.CAMERA_SETTINGS.Y_EXTREME
		)
	)

	local delta_x_cframe: CFrame = CFrame.Angles(0, math.rad(-x_delta), 0)
	local root_part: BasePart? = self.currentCharacter.PrimaryPart
	local root_part_cframe = root_part :: BasePart
	root_part_cframe.CFrame *= delta_x_cframe
end

function CameraService:_onSwitchShoulder(_, input_state)
	if input_state == Enum.UserInputState.Begin then
		self.xOffset = -self.xOffset
		warn("CameraService: Switched to " .. (self.xOffset > 0 and "right" or "left") .. " shoulder")
	end
end

-- Public API
function CameraService:activate()
	if self.isActive then
		warn("CameraService: Already active, skipping activation")
		return
	end

	warn("CameraService: Activating camera for player:", self.localPlayer.Name)

	self.isActive = true
	local sharedConstants = self.diContainer:resolve("Shared.Constants")
	self.xOffset = sharedConstants.CAMERA_OFFSET.X -- reset to right shoulder
	self.cameraOrientation = Vector2.new(0, 0)

	self:_disableAutoRotate()

	-- Bind input actions
	local function onMouseMovementHandler(...)
		self:_onMouseMovement(...)
	end
	local function onSwitchShoulderHandler(...)
		self:_onSwitchShoulder(...)
	end

	ContextActionService:BindAction("MoveMouse", onMouseMovementHandler, false, Enum.UserInputType.MouseMovement)
	ContextActionService:BindAction(
		"SwitchShoulder",
		onSwitchShoulderHandler,
		false,
		sharedConstants.INPUT_KEYS.SWITCH_SHOULDER
	)

	-- Connect update loops
	self.renderConnection = RunService.RenderStepped:Connect(function()
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		self:_updateCamera()
	end)

	self.steppedConnection = RunService.Stepped:Connect(function()
		self:_updateNeckTransform()
	end)
end

function CameraService:deactivate()
	if not self.isActive then
		warn("CameraService: Already inactive, skipping deactivation")
		return
	end

	warn("CameraService: Deactivating camera for player:", self.localPlayer.Name)

	self.isActive = false

	-- Unbind actions
	ContextActionService:UnbindAction("MoveMouse")
	ContextActionService:UnbindAction("SwitchShoulder")

	-- Disconnect update loops
	if self.renderConnection then
		self.renderConnection:Disconnect()
		self.renderConnection = nil
	end

	if self.steppedConnection then
		self.steppedConnection:Disconnect()
		self.steppedConnection = nil
	end

	-- Reset camera
	self.currentCamera.CameraType = Enum.CameraType.Custom
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default

	-- Re-enable auto rotate
	self:_enableAutoRotate()
end


return CameraService
