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
	self._connection = RunService.RenderStepped:Connect(function()
		self:_updateMovement()
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

function MovementService:_updateMovement()
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

	local hasBodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity") ~= nil
	local hasBodyGyro = humanoidRootPart:FindFirstChild("BodyGyro") ~= nil

	if not (hasBodyVelocity and hasBodyGyro) then
		-- Jetpack not equipped, skip movement
		return
	end

	-- Get movement direction from character orientation (character rotates with camera horizontally)
	local characterCFrame = character and character.PrimaryPart and character.PrimaryPart.CFrame or CFrame.new()

	-- Use character's orientation for movement (character rotates with horizontal camera movement)
	local characterForward = characterCFrame.LookVector
	local characterRight = characterCFrame.RightVector

	-- Always fly forward automatically (ignore W/S completely, only A/D for lateral movement)
	local inputService = self.diContainer:resolve("InputService")

	local movementInput = inputService:GetMovementInput()
	local lateralInput = movementInput.X

	-- Only lateral movement from A/D keys, always forward
	local horizontalInput = characterRight * lateralInput + characterForward * 1

	-- Only normalize if there's input, otherwise use zero vector
	local moveDirection = horizontalInput.Magnitude > 0 and horizontalInput.Unit or Vector3.new(0, 0, 0)

	-- Apply body movers
	local camera = workspace.CurrentCamera
	self:_applyBodyVelocity(humanoidRootPart, moveDirection)
	self:_applyBodyGyro(humanoidRootPart, camera.CFrame)

	-- Send position update to server for validation (throttled)
	local sharedConstants = self.diContainer:resolve("Shared.Constants")
	local updateInterval = sharedConstants.POSITION_VALIDATION.POSITION_UPDATE_INTERVAL
	local currentTime = tick()

	if not self._lastUpdateTime or (currentTime - self._lastUpdateTime) >= updateInterval then
		self._lastUpdateTime = currentTime
		self:_sendPositionUpdate(humanoidRootPart.Position, currentTime)
	end
end

---@param humanoidRootPart BasePart
---@param direction Vector3
function MovementService:_applyBodyVelocity(humanoidRootPart, direction)
	local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
	if not bodyVelocity then
		warn("ClientMovementService: BodyVelocity not found - jetpack may not be equipped")
		return
	end

	---@type FlyingSystemClientRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Calculate horizontal velocity
	local horizontalVelocity = Vector3.new(0, 0, 0)
	if direction.Magnitude > 0 then
		-- Apply horizontal velocity based on direction
		local horizontalSpeed = constants.BASE_SIDE_MOVE_SPEED
		horizontalVelocity = direction * horizontalSpeed
	end

	-- Calculate additional velocity based on flying mode
	local additionalVelocity = Vector3.new(0, 0, 0)

	if flyingEntity:isRaceStarted() then
		-- Race mode: forward movement instead of upward
		local forwardSpeed = constants.BASE_FORWARD_MOVE_SPEED
		local character = game.Players.LocalPlayer.Character
		if character and character.PrimaryPart then
			local forwardDirection = character.PrimaryPart.CFrame.LookVector
			additionalVelocity = forwardDirection * forwardSpeed
		end
	else
		-- Normal flying mode: upward movement
		local upwardSpeed = constants.BASE_FORWARD_MOVE_SPEED * 0.05 -- upward velocity multiplier
		additionalVelocity = Vector3.new(0, upwardSpeed, 0)
	end

	-- Combine velocities
	local totalVelocity = horizontalVelocity + additionalVelocity

	-- Clamp vertical velocity if approaching max height
	local currentY = humanoidRootPart.Position.Y
	local maxHeight = constants.JETPACK_HEIGHTS.MAX_FLYING_HEIGHT
	if currentY >= maxHeight - 10 then -- start reducing upward velocity near max height
		local heightFactor = math.max(0, (maxHeight - currentY) / 10)
		totalVelocity = Vector3.new(totalVelocity.X, totalVelocity.Y * heightFactor, totalVelocity.Z)
	end

	bodyVelocity.Velocity = totalVelocity
	bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000) -- force on all axes
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
	local horizontalLook = Vector3.new(cameraLookVector.X, cameraLookVector.Y, cameraLookVector.Z).Unit
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

	local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
	if bodyVelocity then
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
	end

	local bodyGyro = humanoidRootPart:FindFirstChild("BodyGyro")
	if bodyGyro then
		bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
	end
end

return MovementService
