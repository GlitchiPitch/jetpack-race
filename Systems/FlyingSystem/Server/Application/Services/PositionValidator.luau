---@class FlyingSystemServerPositionValidator
local PositionValidator = {}
PositionValidator.__index = PositionValidator

---@param diContainer DIContainer
---@return FlyingSystemServerPositionValidator
function PositionValidator.new(diContainer)
	local self = setmetatable({}, PositionValidator)
	self.diContainer = diContainer
	self._lastPositions = {} -- player -> last validated position
	self._lastTimestamps = {} -- player -> last position update timestamp
	self._violationCounts = {} -- player -> number of violations
	return self
end

---@param player Player
---@param positionData table {position: Vector3, timestamp: number}
---@return boolean, string -- isValid, violationReason
function PositionValidator:validatePosition(player, positionData)
	local position = positionData.position
	local timestamp = positionData.timestamp or tick()

	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Get last known position and timestamp
	local lastPosition = self._lastPositions[player]
	local lastTimestamp = self._lastTimestamps[player] or timestamp

	if not lastPosition then
		-- First position update, accept it
		self._lastPositions[player] = position
		self._lastTimestamps[player] = timestamp
		return true
	end

	-- Calculate time delta and distance
	local timeDelta = timestamp - lastTimestamp
	local distance = (position - lastPosition).Magnitude

	-- Prevent time manipulation (timestamps should not go backwards)
	if timeDelta < 0 then
		logger:warn("PositionValidator", "Time manipulation detected for player:", player.Name)
		self:_handleViolation(player, "time_manipulation")
		return false, "Time manipulation"
	end

	-- Prevent extremely small time deltas that could cause issues
	local minTimeDelta = 0.01 -- minimum 10ms between updates
	if timeDelta < minTimeDelta then
		timeDelta = minTimeDelta
	end

	-- Prevent teleportation (unrealistic speed)
	local maxAllowedSpeed = constants.POSITION_VALIDATION.MAX_SPEED
	local maxAllowedDistance = maxAllowedSpeed * timeDelta

	if distance > maxAllowedDistance then
		logger:warn("PositionValidator", "Speed violation for player:", player.Name,
			"Distance:", distance, "Max allowed:", maxAllowedDistance,
			"Time delta:", timeDelta, "Calculated speed:", distance/timeDelta)
		self:_handleViolation(player, "speed_violation")
		return false, "Speed violation"
	end

	-- Check if player is on race track (placeholder - needs race track implementation)
	if not self:_isOnRaceTrack(position) then
		logger:warn("PositionValidator", "Off-track violation for player:", player.Name,
			"Position:", tostring(position))
		self:_handleViolation(player, "off_track")
		return false, "Off-track violation"
	end

	-- Update stored position and timestamp
	self._lastPositions[player] = position
	self._lastTimestamps[player] = timestamp

	-- Reset violation count on successful validation
	self._violationCounts[player] = 0

	return true
end

---@param position Vector3
---@return boolean
function PositionValidator:_isOnRaceTrack(position)
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Basic bounds checking - implement your race track boundaries here
	-- Example: Check if position is within reasonable game bounds
	local maxDistanceFromCenter = 1000 -- studs from origin
	local distanceFromCenter = (position - Vector3.new(0, 0, 0)).Magnitude

	if distanceFromCenter > maxDistanceFromCenter then
		return false
	end

	-- Check height bounds (prevent flying too high or underground)
	local minHeight = -50 -- studs below ground
	local maxHeight = 200 -- studs above ground

	if position.Y < minHeight or position.Y > maxHeight then
		return false
	end

	-- TODO: Add specific race track boundary checking
	-- This could be:
	-- - Region3 checks for track areas
	-- - Raycast to check if position is above valid terrain
	-- - Custom boundary definitions based on your track design

	return true
end

---@param player Player
---@param violationType string
function PositionValidator:_handleViolation(player, violationType)
	local violationCount = (self._violationCounts[player] or 0) + 1
	self._violationCounts[player] = violationCount

	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Handle different violation types differently
	if violationType == "off_track" and constants.POSITION_VALIDATION.BOUNDS_CHECK_ENABLED then
		-- Out of bounds - reload character immediately
		logger:warn("PositionValidator", "Player out of bounds, reloading character:", player.Name)
		self:_reloadPlayerCharacter(player)
		return
	end

	-- For speed violations, correct position first
	local lastValidPosition = self._lastPositions[player]
	if lastValidPosition then
		self:_correctPlayerPosition(player, lastValidPosition)
		logger:info("PositionValidator", "Corrected position for player:", player.Name,
			"Violation:", violationType, "Count:", violationCount)
	end

	-- If too many violations, take stronger action
	local maxViolations = constants.POSITION_VALIDATION.MAX_VIOLATIONS
	if violationCount >= maxViolations then
		logger:warn("PositionValidator", "Too many violations for player:", player.Name,
			"Count:", violationCount, "Type:", violationType)
		self:_handleSevereViolation(player)
	end
end

---@param player Player
---@param correctPosition Vector3
function PositionValidator:_correctPlayerPosition(player, correctPosition)
	local character = player.Character
	if not character then return end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end

	-- Smoothly correct position instead of teleporting
	local currentPosition = humanoidRootPart.Position
	local correctionVector = correctPosition - currentPosition

	-- Apply correction via body movers if available
	local bodyPosition = humanoidRootPart:FindFirstChild("BodyPosition")
	if bodyPosition then
		bodyPosition.Position = correctPosition
	else
		-- Fallback: direct position set (less smooth)
		humanoidRootPart.Position = correctPosition
	end
end

---@param player Player
function PositionValidator:_reloadPlayerCharacter(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	-- Clear position validation data for this player
	self:clearPlayerData(player)

	-- Stop flying movement
	---@type FlyingSystemServerMovementService
	local movementService = self.diContainer:resolve("Server.Application.Services").movementService
	movementService:stopFlyingMovement(player)

	-- Reload character to reset position
	player:LoadCharacter()

	logger:info("PositionValidator", "Reloaded character for out-of-bounds player:", player.Name)
end

---@param player Player
function PositionValidator:_handleSevereViolation(player)
	-- Severe violation handling - could include:
	-- 1. Force landing the player
	-- 2. Temporary ban from flying
	-- 3. Kick from server
	-- For now, just deactivate flying

	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity(player)

	flyingEntity:deactivateFlying()

	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:warn("PositionValidator", "Deactivated flying for player due to violations:", player.Name)
end

---@param player Player
function PositionValidator:clearPlayerData(player)
	self._lastPositions[player] = nil
	self._lastTimestamps[player] = nil
	self._violationCounts[player] = nil
end

return PositionValidator
