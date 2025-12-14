local Entities = require(script.Entities)
---@class FlyingSystemDomain
---@field Entities FlyingSystemEntities
local Domain = {}
Domain.__index = Domain

---@return FlyingSystemDomain
function Domain.new()
    local self = setmetatable({}, Domain)
    self.Entities = Entities
    return self
end

return Domain
