local DIContainer = require(script.DIContainer)
local Services = require(script.Services)

---@class RaceSystemSharedInfrastructure
---@field DIContainer DIContainer
---@field Services RaceSystemSharedInfrastructureServices
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@return RaceSystemSharedInfrastructure
function Infrastructure.new()
    local self = setmetatable({}, Infrastructure)
    self.DIContainer = DIContainer.new()
    self.Services = Services.new(self.DIContainer)
    return self
end

return Infrastructure