---@class ValidateFlyingStateUseCase
local ValidateFlyingStateUseCase = {}
ValidateFlyingStateUseCase.__index = ValidateFlyingStateUseCase

---@return ValidateFlyingStateUseCase
function ValidateFlyingStateUseCase.new(): ValidateFlyingStateUseCase
    return setmetatable({}, ValidateFlyingStateUseCase)
end

---@param flyingEntity any
---@return boolean
function ValidateFlyingStateUseCase:Execute(flyingEntity: any): boolean
    if not flyingEntity or not flyingEntity.State then
        return false
    end

    local state = flyingEntity.State
    return state.ChargeLevel >= 0 and
           state.ChargeLevel <= state.MaxCharge and
           state.SpeedMultiplier >= 0
end

return ValidateFlyingStateUseCase