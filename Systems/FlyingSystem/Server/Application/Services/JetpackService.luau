---@class FlyingSystemServerJetpackService
local JetpackService = {}
JetpackService.__index = JetpackService

---@param diContainer DIContainer
---@return FlyingSystemServerJetpackService
function JetpackService.new(diContainer)
	local self = setmetatable({}, JetpackService)
	self.diContainer = diContainer
	return self
end

---@param player Player
function JetpackService:equipDefaultJetpack(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("JetpackService", "Equipping default jetpack for player:", player.Name)

	---@type FlyingSystemAssets
	local assets = self.diContainer:resolve("Assets")
	---@type FlyingRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")

	-- Получить или создать FlyingEntity для игрока
	local flyingEntity = flyingRepository:getFlyingEntity(player)

	-- Клонировать дефолтный джетпак
	local defaultJetpack = assets.DefaultJetpack:Clone()

	-- Назначить джетпак сущности
	flyingEntity:setJetpack(defaultJetpack)

	-- Экипировать джетпак на персонажа игрока
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:AddAccessory(defaultJetpack)
			logger:info("JetpackService", "Default jetpack equipped successfully for player:", player.Name)

			-- Настроить bodyMovers для полета
			self:_setupBodyMovers(character)
			logger:info("JetpackService", "BodyMovers set up for player:", player.Name)

			-- Активировать систему полета после экипировки джетпака
			flyingEntity:activateFlying()
			logger:info("JetpackService", "Flying system activated for player:", player.Name)
		else
			logger:warn("JetpackService", "Humanoid not found for player:", player.Name)
		end
	else
		logger:warn("JetpackService", "Character not found for player:", player.Name)
	end
end

---@param character Model
function JetpackService:_setupBodyMovers(character)
	---@type FlyingSystemAssets
	local assets = self.diContainer:resolve("Assets")

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	-- Создать и добавить BodyPosition
	local bodyPosition = assets.BodyMovers.BodyPosition:Clone()
	bodyPosition.Parent = humanoidRootPart
	bodyPosition.Position = humanoidRootPart.Position
	bodyPosition.MaxForce = Vector3.new(0, 0, 0) -- отключить до начала полета
	bodyPosition.D = 100

	-- Создать и добавить BodyGyro
	local bodyGyro = assets.BodyMovers.BodyGyro:Clone()
	bodyGyro.Parent = humanoidRootPart
	bodyGyro.MaxTorque = Vector3.new(0, 0, 0) -- отключить до начала полета
	bodyGyro.D = 100
end

return JetpackService
