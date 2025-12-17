---@class FlyingSystemClientMovementService
local MovementService = {}
MovementService.__index = MovementService

---@param diContainer DIContainer
---@return FlyingSystemClientMovementService
function MovementService.new(diContainer)
	local self = setmetatable({}, MovementService)
	self.diContainer = diContainer
	self.isActive = false
	self._connection = nil
	return self
end

function MovementService:init()
	self.inputService = self.diContainer:resolve("InputService")

	---@type FlyingSystemClientRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()

	-- Listen for flying state changes to start/stop movement updates
	flyingEntity.isActive.Changed:Connect(function(isActive)
		if isActive then
			self:startMovementUpdates()
		else
			self:stopMovementUpdates()
		end
	end)
end

function MovementService:startMovementUpdates()
	if self.isActive then
		return
	end
	self.isActive = true

	local RunService = game:GetService("RunService")

	-- Update movement every frame for smooth control
	self._connection = RunService.RenderStepped:Connect(function(deltaTime)
		self:_updateMovement(deltaTime)
	end)

	warn("ClientMovementService: Started movement updates")
end

function MovementService:stopMovementUpdates()
	self.isActive = false

	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end

	-- Disable body movers when stopping
	self:_disableBodyMovers()

	warn("ClientMovementService: Stopped movement updates")
end

---@param deltaTime number
function MovementService:_updateMovement(deltaTime)
	---@type FlyingSystemClientRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()

	if not flyingEntity:canFly() then
		return
	end

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
		-- Jetpack not equipped, skip movement
		return
	end

	-- Get movement direction from character orientation (character rotates with camera horizontally)
	local characterCFrame = character and character.PrimaryPart and character.PrimaryPart.CFrame or CFrame.new()

	-- Use character's orientation for movement (character rotates with horizontal camera movement)
	local characterForward = characterCFrame.LookVector
	local characterRight = characterCFrame.RightVector

	-- Get movement input from WASD keys
	local movementInput = self.inputService:GetMovementInput()

	-- Check if auto-forward movement is active
	local isAutoForward = flyingEntity:isAutoForwardMovement()

	-- If auto-forward is active, force forward movement regardless of input
	local finalMovementInput = movementInput
	if isAutoForward then
		-- Force forward movement (Z = -1 means forward)
		finalMovementInput = Vector3.new(movementInput.X, movementInput.Y, -1)
	end

	-- movementInput.Z is -1 for W (forward) and +1 for S (backward)
	-- We need to negate it so W moves forward and S moves backward
	local horizontalInput = characterRight * finalMovementInput.X + characterForward * -finalMovementInput.Z

	-- Only normalize if there's input, otherwise use zero vector
	local moveDirection = horizontalInput.Magnitude > 0 and horizontalInput.Unit or Vector3.new(0, 0, 0)

	-- Calculate flying speed
	local baseSpeed = 50 -- base flying speed
	local sprintMultiplier = 2 -- sprint multiplier
	local speed = flyingEntity:calculateSpeed(baseSpeed, sprintMultiplier)

	-- Apply body movers
	local camera = workspace.CurrentCamera
	self:_applyBodyPosition(humanoidRootPart, moveDirection, speed, deltaTime)
	self:_applyBodyGyro(humanoidRootPart, camera.CFrame)

	-- Send position update to server for validation (throttled)
	local constants = self.diContainer:resolve("Shared.Constants")
	local updateInterval = constants.POSITION_VALIDATION.POSITION_UPDATE_INTERVAL
	local currentTime = tick()

	if not self._lastUpdateTime or (currentTime - self._lastUpdateTime) >= updateInterval then
		self._lastUpdateTime = currentTime
		self:_sendPositionUpdate(humanoidRootPart.Position, currentTime)
	end
end

---@param humanoidRootPart BasePart
---@param direction Vector3
---@param speed number
---@param deltaTime number
function MovementService:_applyBodyPosition(humanoidRootPart, direction, speed, deltaTime)
	local bodyPosition = humanoidRootPart:FindFirstChild("BodyPosition")
	if not bodyPosition then
		warn("ClientMovementService: BodyPosition not found - jetpack may not be equipped")
		return
	end

	local currentPosition = humanoidRootPart.Position

	-- Calculate horizontal movement per second, then multiply by deltaTime
	local horizontalMovement = Vector3.new(0, 0, 0)
	if direction.Magnitude > 0 then
		-- Apply horizontal movement based on direction
		local horizontalSpeed = speed * 0.8 -- horizontal movement speed per second
		horizontalMovement = direction * horizontalSpeed * deltaTime
	end

	-- Calculate vertical movement (upward) per second, then multiply by deltaTime
	local upwardSpeed = speed * 0.1 -- upward movement speed per second
	local verticalMovement = Vector3.new(0, upwardSpeed * deltaTime, 0)

	-- Combine movements
	local totalMovement = horizontalMovement + verticalMovement
	local targetPosition = currentPosition + totalMovement

	bodyPosition.Position = targetPosition
	bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000) -- force on all axes
	bodyPosition.D = 100 -- damping
end

---@param humanoidRootPart BasePart
---@param cameraCFrame CFrame
function MovementService:_applyBodyGyro(humanoidRootPart, cameraCFrame)
	local bodyGyro = humanoidRootPart:FindFirstChild("BodyGyro")
	if not bodyGyro then
		warn("ClientMovementService: BodyGyro not found - jetpack may not be equipped")
		return
	end

	-- Lock pitch (Y axis) while allowing yaw and roll to follow camera
	local cameraPosition = cameraCFrame.Position
	local cameraLookVector = cameraCFrame.LookVector
	-- Project look vector onto horizontal plane to remove vertical component
	local horizontalLook = Vector3.new(cameraLookVector.X, 0, cameraLookVector.Z).Unit
	bodyGyro.CFrame = CFrame.new(cameraPosition, cameraPosition + horizontalLook)
	bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000) -- maximum torque
	bodyGyro.D = 100 -- damping
end

---@param position Vector3
---@param timestamp number
function MovementService:_sendPositionUpdate(position, timestamp)
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireServer(constants.REMOTE_EVENTS.POSITION_UPDATE, {
		position = position,
		timestamp = timestamp,
	})
end

function MovementService:_disableBodyMovers()
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
	if bodyPosition then
		bodyPosition.MaxForce = Vector3.new(0, 0, 0)
	end

	local bodyGyro = humanoidRootPart:FindFirstChild("BodyGyro")
	if bodyGyro then
		bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
	end
end

return MovementService
