---@class FlyingState
local FlyingState = {}
FlyingState.__index = FlyingState

---@param initialState FlyingState
---@return FlyingState
function FlyingState.new(initialState: any): FlyingState
    return setmetatable({
        IsActive = initialState.IsActive or false,
        SpeedMultiplier = initialState.SpeedMultiplier or 1.0,
        ChargeLevel = initialState.ChargeLevel or 100,
        SprintActivated = initialState.SprintActivated or false,
        MaxCharge = initialState.MaxCharge or 100
    }, FlyingState)
end

---@param charge number
---@return FlyingState
function FlyingState:withCharge(charge: number): FlyingState
    local newState = table.clone(self)
    newState.ChargeLevel = math.clamp(charge, 0, self.MaxCharge)
    return FlyingState.new(newState)
end

---@param speedMultiplier number
---@return FlyingState
function FlyingState:withSpeedMultiplier(speedMultiplier: number): FlyingState
    local newState = table.clone(self)
    newState.SpeedMultiplier = speedMultiplier
    return FlyingState.new(newState)
end

---@param sprintActivated boolean
---@return FlyingState
function FlyingState:withSprintActivated(sprintActivated: boolean): FlyingState
    local newState = table.clone(self)
    newState.SprintActivated = sprintActivated
    return FlyingState.new(newState)
end

---@param isActive boolean
---@return FlyingState
function FlyingState:withActive(isActive: boolean): FlyingState
    local newState = table.clone(self)
    newState.IsActive = isActive
    return FlyingState.new(newState)
end

return FlyingState