local Entities = require(script.Entities)
local Assets = require(script.Assets)
---@class RaceSystemDomain
---@field Entities RaceSystemEntities
---@field Assets RaceSystemAssets
local Domain = {}
Domain.__index = Domain

---@return RaceSystemDomain
function Domain.new()
    local self = setmetatable({}, Domain)
    self.Entities = Entities
    self.Assets = Assets
    return self
end

return Domain
