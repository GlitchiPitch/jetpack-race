---@interface IFlyingRepository
local IFlyingRepository = {
    ---@param player Player
    ---@return FlyingEntity
    GetFlyingEntity = "function",

    ---@param player Player
    ---@param entity FlyingEntity
    SaveFlyingEntity = "function"
}

return IFlyingRepository