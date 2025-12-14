---@interface IFlyingService
local IFlyingService = {
    ---@param cameraCFrame CFrame
    ---@param speed number
    ---@param flyingEntity FlyingEntity
    ---@return Vector3
    CalculateVelocity = "function",

    ---@param player Player
    ---@param velocity Vector3
    ApplyVelocity = "function",

    ---@param character Model
    SetupBodyMovers = "function"
}

return IFlyingService