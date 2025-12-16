local Entities = require(script.Entities)
---@class RaceSystemDomain
---@field Entities RaceSystemEntities
local Domain = {}
Domain.__index = Domain

---@return RaceSystemDomain
function Domain.new()
    local self = setmetatable({}, Domain)
    self.Entities = Entities
    return self
end

return Domain
