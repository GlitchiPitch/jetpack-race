---@class BoostEntity
---@field _instance Model
local BoostEntity = {}
BoostEntity.__index = BoostEntity

---@class boostData
---@field _instance Model
---@field cframe CFrame
---@field parent Instance

---@param boostData boostData
---@return BoostEntity
function BoostEntity.new(boostData)
    local self = setmetatable({}, BoostEntity)
    self._instance = boostData._instance
    self._instance:PivotTo(boostData.cframe)
    self._instance.Parent = boostData.parent
    self:_setup()
    return self
end

function BoostEntity:_setup()
    
end

return BoostEntity