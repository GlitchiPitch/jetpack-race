---@class ToggleSprintUseCase
local ToggleSprintUseCase = {}
ToggleSprintUseCase.__index = ToggleSprintUseCase

---@param dependencies table
---@return ToggleSprintUseCase
function ToggleSprintUseCase.new(dependencies: {
    flyingRepository: any,
    constants: any
}): ToggleSprintUseCase
    return setmetatable({
        flyingRepository = dependencies.flyingRepository,
        constants = dependencies.constants
    }, ToggleSprintUseCase)
end

---@param player Player
---@param activate boolean
function ToggleSprintUseCase:Execute(player: Player, activate: boolean)
    local flyingEntity = self.flyingRepository:GetFlyingEntity(player)

    if activate then
        if flyingEntity:CanSprint() then
            flyingEntity.State = flyingEntity.State:withSprintActivated(true)
            flyingEntity.State = flyingEntity.State:withSpeedMultiplier(self.constants.ACTIVATED_SPRINT_VALUE)
            flyingEntity:ConsumeCharge(self.constants.BASE_SPRINT_COST_VALUE)
        end
    else
        flyingEntity.State = flyingEntity.State:withSprintActivated(false)
        flyingEntity.State = flyingEntity.State:withSpeedMultiplier(self.constants.BASE_SPRINT_VALUE)
    end

    self.flyingRepository:SaveFlyingEntity(player, flyingEntity)
end

return ToggleSprintUseCase