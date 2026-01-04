local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
---@class CameraService
---@field diContainer DIContainer
---@field renderConnection RBXScriptConnection
---@field cameraSettings cameraSettings
---@field camera Camera
local CameraService = {}
CameraService.__index = CameraService

-- Helper function for linear interpolation (Lerp) for numbers
local function lerp(a, b, t)
	return a + (b - a) * t
end

-- Frame-rate independent Lerp alpha calculation
local function getLerpAlpha(speed, deltaTime)
	deltaTime = math.min(deltaTime, 0.1) -- Prevent large jumps in interpolation if deltaTime is very big
	return 1 - math.exp(-speed * deltaTime) -- Exponential approach to target value
end

---@param diContainer DIContainer
---@return CameraService
function CameraService.new(diContainer)
	local self = setmetatable({}, CameraService)
	self.diContainer = diContainer

	self.camera = workspace.CurrentCamera
	self.currentYaw = 0
	self.currentPitch = 0
	self.isAiming = false
	self.shoulderSide = 1
	self.isCameraActive = true
	self.isNitro = false
	self:_setup()
	return self
end

function CameraService:_setup()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	self.cameraSettings = shared.Config.cameraSettings
end

---@return Vector3
function CameraService:getUnitVector()
	return self.camera.CFrame.LookVector.Unit
end

---@return CFrame
function CameraService:getCFrame()
	return self.camera.CFrame
end

function CameraService:activateFlyingCamera()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local character = application.services.playerService:getPlayerCharacter()

	local function updateCamera(deltaTime)
		self:_updateCamera(deltaTime)
	end

	local function handleAimInput(input, gameProcessed)
		self:_handleAimInput(input, gameProcessed)
	end
	local function handleShoulderSwapInput(input, gameProcessed)
		self:_handleShoulderSwapInput(input, gameProcessed)
	end

	self.effectiveOffset = Vector3.new(
		self.cameraSettings.normalCameraOffset.X * self.shoulderSide,
		self.cameraSettings.normalCameraOffset.Y,
		self.cameraSettings.normalCameraOffset.Z
	)

	self.effectiveFov = self.cameraSettings.normalFov
	self.camera.CameraType = Enum.CameraType.Scriptable -- Sets the camera's control mode to "Scriptable".  This means that the
	self.raycastParams = RaycastParams.new() -- Creates a new RaycastParams object.  This object is used to configure
	self.raycastParams.FilterType = Enum.RaycastFilterType.Exclude -- Sets the filter type to "Exclude".  This means that the raycast
	self.raycastParams.FilterDescendantsInstances = { character } -- Sets the filter list to include the player's character.  This
	self.raycastParams.IgnoreWater = true

	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter -- Locks the mouse cursor to the center of the screen.  This is
	UserInputService.MouseIconEnabled = false -- Hides the default mouse cursor.  This is often done when the mouse
	UserInputService.InputBegan:Connect(handleAimInput) -- Connects the handleAimInput function to the InputBegan event,
	UserInputService.InputEnded:Connect(handleAimInput) -- Connects handleAimInput to the InputEnded event, which fires
	UserInputService.InputBegan:Connect(handleShoulderSwapInput)

	self.renderConnection = RunService.RenderStepped:Connect(updateCamera) -- Connects updateCamera to RenderStepped.

	-- Clean up when character is removed
	character.Destroying:Connect(function() -- Connects a function to the character's Destroying event.
		self:deactivateFlyingCamera()
	end)
end

function CameraService:deactivateFlyingCamera()
	if self.renderConnection then -- If the renderConnection exists...
		self.renderConnection:Disconnect() -- ...disconnect it.  This stops the updateCamera function from being called.
	end
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default -- Resets the mouse behavior to the default.
	UserInputService.MouseIconEnabled = true -- Re-enables the mouse icon.
	self.camera.CameraType = Enum.CameraType.Custom
end

-- Main update function connected to RenderStepped
function CameraService:_updateCamera(deltaTime)
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local playerService = application.services.playerService
	local character = playerService:getPlayerCharacter()
	self.rootPart = character:FindFirstChild("HumanoidRootPart")
	if not self.isCameraActive or not self.rootPart then
		return
	end -- If the camera is not active or the root part doesn't exist, exit.

	local targetBaseOffset, targetFov
	local sensitivity, rotSmoothness -- Use target values directly for responsiveness
	if self.isAiming then
		targetBaseOffset = self.cameraSettings.aimCameraOffset
		targetFov = self.cameraSettings.aimFov
		sensitivity = self.cameraSettings.aimMouseSensitivity
		rotSmoothness = self.cameraSettings.aimRotationSmoothness
	elseif self.isNitro then
		local function getRandomValue()
			return math.random(10, 300) / 100
		end
		local bobbleOffset = Vector3.new(getRandomValue(), getRandomValue(), getRandomValue())

		targetBaseOffset = self.cameraSettings.nitroCameraOffset + bobbleOffset
		targetFov = self.cameraSettings.nitroFov
		sensitivity = self.cameraSettings.nitroMouseSensitivity
		rotSmoothness = self.cameraSettings.nitroRotationSmoothness
	else
		targetBaseOffset = self.cameraSettings.normalCameraOffset
		targetFov = self.cameraSettings.normalFov
		sensitivity = self.cameraSettings.normalMouseSensitivity
		rotSmoothness = self.cameraSettings.normalRotationSmoothness
	end

	-- === Calculate FULL Target Offset (including shoulder side) === -- NEW STEP
	-- This is the actual position offset the camera should smoothly move towards
	local fullTargetOffset = Vector3.new(targetBaseOffset.X * self.shoulderSide, targetBaseOffset.Y, targetBaseOffset.Z)

	-- === Smoothly update EFFECTIVE values towards TARGET values ===
	local alpha = getLerpAlpha(self.cameraSettings.smoothTransitionSpeed, deltaTime)

	-- Interpolate the full offset (which now includes shoulder side) towards the target
	self.effectiveOffset = self.effectiveOffset:Lerp(fullTargetOffset, alpha)
	-- Interpolate the Field of View
	self.effectiveFov = lerp(self.effectiveFov, targetFov, alpha)

	-- === Camera Rotation ===
	local mouseDelta = UserInputService:GetMouseDelta() -- Gets the change in mouse position since the last frame.
	self.currentYaw = self.currentYaw - mouseDelta.X * sensitivity -- Updates the horizontal camera angle (yaw) based on mouse movement
	self.currentPitch = math.clamp(
		self.currentPitch - mouseDelta.Y * sensitivity,
		self.cameraSettings.minPitch,
		self.cameraSettings.maxPitch
	) -- Updates the vertical camera
	-- angle (pitch) and clamps it to the defined limits.

	local yawRad = math.rad(self.currentYaw) -- Converts the yaw angle from degrees to radians.  Roblox uses radians
	-- for trigonometric functions.
	local pitchRad = math.rad(self.currentPitch) -- Converts the pitch angle from degrees to radians.

	-- === Camera Positioning and CFrame Calculation ===
	local cameraRotation = CFrame.Angles(0, yawRad, 0) * CFrame.Angles(pitchRad, 0, 0) -- Creates a CFrame (Coordinate Frame)
	-- that represents the camera's rotation.  CFrames are used to store
	-- position and orientation information.  This combines the yaw and
	-- pitch rotations.
	local anchorPosition = self.rootPart.Position -- Gets the position of the character's HumanoidRootPart.  This is the
	-- point around which the camera will rotate.

	-- Calculate the IDEAL CFrame and Position WITHOUT collision first
	-- Use the FULLY SMOOTHED effective offset (already includes shoulder side effects)
	local idealShoulderOffsetCFrame = CFrame.new(self.effectiveOffset.X, self.effectiveOffset.Y, self.effectiveOffset.Z)
	local idealCameraCFrame = CFrame.new(anchorPosition) * cameraRotation * idealShoulderOffsetCFrame
	local idealPosition = idealCameraCFrame.Position

	-- === Collision Detection ===
	local finalOffsetVector = self.effectiveOffset -- Start collision scaling from the current SMOOTHED offset
	local rayOrigin = anchorPosition
	local rayDirection = idealPosition - rayOrigin
	local idealDistance = rayDirection.Magnitude

	if idealDistance > 0.01 then -- added a check to prevent a bug where the camera would go inside the player.
		local raycastResult = workspace:Raycast(rayOrigin, rayDirection.Unit * idealDistance, self.raycastParams) -- Performs the raycast.
		if raycastResult then -- If the raycast hit something...
			local hitDistance = raycastResult.Distance -- Gets the distance from the origin to the hit point.
			if hitDistance < idealDistance then
				-- Scale the current effectiveOffset based on collision distance
				local scaleFactor =
					math.clamp((hitDistance - self.cameraSettings.cameraCollisionBuffer) / idealDistance, 0, 1)
				finalOffsetVector = self.effectiveOffset * scaleFactor
			end
		end
	end

	-- === Calculate Final CFrame using potentially adjusted offset ===
	-- The finalOffsetVector now already includes smoothing and shoulder side effects
	local finalAppliedOffsetCFrame = CFrame.new(finalOffsetVector.X, finalOffsetVector.Y, finalOffsetVector.Z)
	local finalCameraCFrame = CFrame.new(anchorPosition) * cameraRotation * finalAppliedOffsetCFrame

	-- === Set Camera CFrame and FOV ===
	self.camera.CFrame = finalCameraCFrame -- Sets the camera's position and orientation.
	self.camera.Focus = CFrame.new(anchorPosition) -- Sets the point that the camera is focused on.  In this case, it's the
	-- character's root part.  This can help with some camera behaviors.
	self.camera.FieldOfView = self.effectiveFov -- Sets the camera's field of view.

	-- === Character Rotation ===
	local targetRootCFrame = CFrame.new(self.rootPart.Position) * CFrame.Angles(0, yawRad, 0) -- Creates a CFrame that represents
	-- the target orientation for the character's root part.  This rotates
	-- the character horizontally to face the direction the camera is pointing.
	self.rootPart.CFrame = self.rootPart.CFrame:Lerp(targetRootCFrame, rotSmoothness) -- Smoothly rotates the character's root part
	-- towards the target orientation.  The `rotSmoothness` value controls
	-- how quickly the rotation occurs.
end

-- Handle Aim Input
function CameraService:_handleAimInput(input, gameProcessed)
	if gameProcessed or not self.isCameraActive then
		return
	end -- If the input was already handled by the game or the camera is inactive, exit.
	if input.UserInputType == Enum.UserInputType.MouseButton2 then -- If the input is from the right mouse button...
		if input.UserInputState == Enum.UserInputState.Begin then -- ...and the button was just pressed down...
			self.isAiming = true -- ...set the aiming flag to true.
		elseif input.UserInputState == Enum.UserInputState.End then -- ...or the button was just released...
			self.isAiming = false -- ...set the aiming flag to false.
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		if input.UserInputState == Enum.UserInputState.Begin then -- ...and the button was just pressed down...
			self.isNitro = true -- ...set the aiming flag to true.
		elseif input.UserInputState == Enum.UserInputState.End then -- ...or the button was just released...
			self.isNitro = false -- ...set the aiming flag to false.
		end
	end
end

-- Handle Shoulder Swap Input
function CameraService:_handleShoulderSwapInput(input, gameProcessed)
	if gameProcessed or not self.isCameraActive then
		return
	end
	if input.KeyCode == Enum.KeyCode.Q and input.UserInputState == Enum.UserInputState.Begin then
		self.shoulderSide = self.shoulderSide * -1
	end
end

return CameraService
