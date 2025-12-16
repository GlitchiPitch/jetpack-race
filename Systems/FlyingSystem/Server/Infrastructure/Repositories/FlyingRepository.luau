---@class FlyingRepository
local FlyingRepository = {}
FlyingRepository.__index = FlyingRepository

---@param diContainer DIContainer
---@return FlyingRepository
function FlyingRepository.new(diContainer)
	local self = setmetatable({}, FlyingRepository)
	self.diContainer = diContainer
	self._cache = {}
	return self
end

---@param player Player
---@return any
function FlyingRepository:getFlyingEntity(player: Player): any
	if self._cache[player] then
		return self._cache[player]
	end

	---@type FlyingSystemAssets
	local assets = self.diContainer:resolve("Assets")
	local flyingData = assets.FlyingData:Clone()

	---@type PlayerEntity
	local playerEntity = self.diContainer:resolve("PlayerRepository"):getPlayerEntity(player)

	---@type FlyingEntity
	local entities = self.diContainer:resolve("Entities")
	---@type FlyingEntity
	local FlyingEntity = entities.FlyingEntity

	local flyingEntity = FlyingEntity.new(playerEntity, flyingData)
	self._cache[player] = flyingEntity

	return flyingEntity
end

---@param player Player
---@param entity any
function FlyingRepository:SaveFlyingEntity(player: Player, entity: any)
	self._cache[player] = entity

	local gameStats = self.playerSystem:GetGameStats(player)
	gameStats.Sprint.Value = entity.State.SpeedMultiplier
end

---@param player Player
function FlyingRepository:clearCache(player: Player)
	self._cache[player] = nil
end

---@param player Player
---@return boolean
function FlyingRepository:hasEntity(player: Player): boolean
	return self._cache[player] ~= nil
end

return FlyingRepository
