

---@class FlyingRepository
local FlyingRepository = {}
FlyingRepository.__index = FlyingRepository

---@param diContainer DIContainer
---@return FlyingRepository
function FlyingRepository.new(diContainer)
    local self = setmetatable({}, FlyingRepository)
    self.diContainer = diContainer
    return self
end

---@param player Player
---@return any
function FlyingRepository:GetFlyingEntity(player: Player): any
    if self._cache[player] then
        return self._cache[player]
    end

    local gameStats = self.playerSystem:GetGameStats(player)
    local stats = self.playerSystem:GetStats(player)

    local initialState = {
        IsActive = gameStats.InGame.Value,
        SpeedMultiplier = gameStats.Sprint.Value,
        ChargeLevel = gameStats.Charge.Value,
        SprintActivated = gameStats.Sprint.Value > 1,
        MaxCharge = 100 -- or from constants based on player level
    }

    local flyingEntity = self.flyingEntityFactory(initialState)
    self._cache[player] = flyingEntity

    return flyingEntity
end

---@param player Player
---@param entity any
function FlyingRepository:SaveFlyingEntity(player: Player, entity: any)
    self._cache[player] = entity

    local gameStats = self.playerSystem:GetGameStats(player)
    gameStats.Sprint.Value = entity.State.SpeedMultiplier
    gameStats.Charge.Value = entity.State.ChargeLevel
end

---@param player Player
function FlyingRepository:ClearCache(player: Player)
    self._cache[player] = nil
end

---@param player Player
---@return boolean
function FlyingRepository:HasEntity(player: Player): boolean
    return self._cache[player] ~= nil
end

return FlyingRepository