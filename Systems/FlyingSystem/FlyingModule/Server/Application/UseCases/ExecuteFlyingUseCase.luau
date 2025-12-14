---@class ExecuteFlyingUseCase
local ExecuteFlyingUseCase = {}
ExecuteFlyingUseCase.__index = ExecuteFlyingUseCase

---@param dependencies table
---@return ExecuteFlyingUseCase
function ExecuteFlyingUseCase.new(dependencies: {
    flyingRepository: any,
    flyingService: any,
    constants: any
}): ExecuteFlyingUseCase
    return setmetatable({
        flyingRepository = dependencies.flyingRepository,
        flyingService = dependencies.flyingService,
        constants = dependencies.constants
    }, ExecuteFlyingUseCase)
end

---@param player Player
---@param cameraCFrame CFrame
function ExecuteFlyingUseCase:Execute(player: Player, cameraCFrame: CFrame)
    local flyingEntity = self.flyingRepository:GetFlyingEntity(player)

    if not flyingEntity:CanFly() then
        return
    end

    local baseSpeed = self.constants.CAMERA_SPEED.X
    local speedMultiplier = flyingEntity.State.SpeedMultiplier
    local currentSpeed = flyingEntity:CalculateSpeed(baseSpeed, speedMultiplier)

    local velocity = self.flyingService:CalculateVelocity(
        cameraCFrame,
        currentSpeed,
        flyingEntity
    )

    self.flyingService:ApplyVelocity(player, velocity)
    self.flyingRepository:SaveFlyingEntity(player, flyingEntity)
end

return ExecuteFlyingUseCase