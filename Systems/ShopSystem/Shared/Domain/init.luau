local Entities = require(script.Entities)
---@class ShopSystemDomain
---@field Entities ShopSystemEntities
local Domain = {}
Domain.__index = Domain

---@return ShopSystemDomain
function Domain.new()
    local self = setmetatable({}, Domain)
    self.Entities = Entities
    return self
end

return Domain
