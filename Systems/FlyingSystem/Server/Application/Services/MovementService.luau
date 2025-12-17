---@class FlyingSystemServerMovementService
local MovementService = {}
MovementService.__index = MovementService

---@param diContainer DIContainer
---@return FlyingSystemServerMovementService
function MovementService.new(diContainer)
	local self = setmetatable({}, MovementService)
	self.diContainer = diContainer
	return self
end

---@param player Player
---@param positionData table {position: Vector3, timestamp: number}
function MovementService:validatePlayerPosition(player, positionData)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	---@type FlyingSystemServerPositionValidator
	local positionValidator = self.diContainer:resolve("Server.Application.Services").positionValidator

	local flyingEntity = flyingRepository:getFlyingEntity(player)
	if not flyingEntity:canFly() then
		logger:debug("MovementService", "Player cannot fly, skipping validation:", player.Name)
		return
	end

	-- Validate position with anti-cheat system
	local isValid, violationReason = positionValidator:validatePosition(player, positionData)

	if not isValid then
		logger:warn("MovementService", "Invalid position detected for player:", player.Name,
			"Reason:", violationReason)
		-- Position correction is handled by PositionValidator
	else
		logger:debug("MovementService", "Position validated for player:", player.Name)
	end
end

-- Body mover application methods removed - now handled client-side

---@param player Player
function MovementService:stopFlyingMovement(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	---@type FlyingSystemServerPositionValidator
	local positionValidator = self.diContainer:resolve("Server.Application.Services").positionValidator

	-- Clear position validation data for this player
	positionValidator:clearPlayerData(player)

	logger:debug("MovementService", "Cleared position validation data for player:", player.Name)

	-- Note: Body movers are now managed by the client and will be cleaned up there
end

return MovementService
