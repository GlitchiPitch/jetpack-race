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
---@param cameraCFrame CFrame
function MovementService:handleFlyingMovement(player, cameraCFrame)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")

	local flyingEntity = flyingRepository:getFlyingEntity(player)
	if not flyingEntity:canFly() then
		logger:warn("MovementService", "Player cannot fly:", player.Name)
		return
	end

	local character = player.Character
	if not character then
		logger:warn("MovementService", "Character not found for player:", player.Name)
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		logger:warn("MovementService", "HumanoidRootPart not found for player:", player.Name)
		return
	end

	-- Получить направление движения из камеры
	local cameraDirection = cameraCFrame.LookVector
	local moveDirection = Vector3.new(cameraDirection.X, 0, cameraDirection.Z).Unit

	-- Рассчитать скорость полета
	local baseSpeed = 50 -- базовая скорость полета
	local sprintMultiplier = 2 -- множитель спринта
	local speed = flyingEntity:calculateSpeed(baseSpeed, sprintMultiplier)

	-- Применить BodyPosition для движения и высоты
	self:_applyBodyPosition(humanoidRootPart, moveDirection, speed)

	-- Применить BodyGyro для ориентации
	self:_applyBodyGyro(humanoidRootPart, cameraCFrame)

	logger:debug("MovementService", "Applied flying movement for player:", player.Name)
end

---@param humanoidRootPart BasePart
---@param direction Vector3
---@param speed number
function MovementService:_applyBodyPosition(humanoidRootPart, direction, speed)
	local bodyPosition = humanoidRootPart:FindFirstChild("BodyPosition")
	if not bodyPosition then
		warn("MovementService: BodyPosition not found for player - jetpack may not be equipped")
		return
	end

	-- Установить позицию с высотой Y=50
	local targetPosition = Vector3.new(
		humanoidRootPart.Position.X + direction.X * speed * 0.1,
		50, -- фиксированная высота полета
		humanoidRootPart.Position.Z + direction.Z * speed * 0.1
	)

	bodyPosition.Position = targetPosition
	bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000) -- сила по всем осям
	bodyPosition.D = 100 -- демпфирование
end

---@param humanoidRootPart BasePart
---@param direction Vector3
---@param speed number
function MovementService:_applyBodyVelocity(humanoidRootPart, direction, speed)
	local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
	if not bodyVelocity then
		warn("MovementService: BodyVelocity not found for player - jetpack may not be equipped")
		return
	end

	bodyVelocity.Velocity = direction * speed
	bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000) -- сила только по горизонтали
end

---@param humanoidRootPart BasePart
---@param cameraCFrame CFrame
function MovementService:_applyBodyGyro(humanoidRootPart, cameraCFrame)
	local bodyGyro = humanoidRootPart:FindFirstChild("BodyGyro")
	if not bodyGyro then
		warn("MovementService: BodyGyro not found for player - jetpack may not be equipped")
		return
	end

	bodyGyro.CFrame = cameraCFrame
	bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000) -- максимальный крутящий момент
	bodyGyro.D = 100 -- демпфирование
end

---@param player Player
function MovementService:stopFlyingMovement(player)
	local character = player.Character
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	-- Удалить body movers при остановке полета
	local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
	if bodyVelocity then
		bodyVelocity:Destroy()
	end

	local bodyGyro = humanoidRootPart:FindFirstChild("BodyGyro")
	if bodyGyro then
		bodyGyro:Destroy()
	end

	local bodyPosition = humanoidRootPart:FindFirstChild("BodyPosition")
	if bodyPosition then
		bodyPosition:Destroy()
	end
end

return MovementService
