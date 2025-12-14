local Entities = require(script.Entities)
---@class LiveLeaderboardSystemDomain
---@field Entities LiveLeaderboardSystemEntities
local Domain = {}
Domain.__index = Domain

---@return LiveLeaderboardSystemDomain
function Domain.new()
    local self = setmetatable({}, Domain)
    self.Entities = Entities
    return self
end

return Domain
