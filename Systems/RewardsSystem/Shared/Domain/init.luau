local Entities = require(script.Entities)
---@class RewardsSystemDomain
---@field Entities RewardsSystemEntities
local Domain = {}
Domain.__index = Domain

---@return RewardsSystemDomain
function Domain.new()
    local self = setmetatable({}, Domain)
    self.Entities = Entities
    return self
end

return Domain
