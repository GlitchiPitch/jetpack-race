local Entities = require(script.Entities)
---@class PetSystemDomain
---@field Entities PetSystemEntities
local Domain = {}
Domain.__index = Domain

---@return PetSystemDomain
function Domain.new()
    local self = setmetatable({}, Domain)
    self.Entities = Entities
    return self
end

return Domain
