local DIContainer = require(script.DIContainer)
local Services = require(script.Services)

---@class RewardsSystemSharedInfrastructure
---@field DIContainer DIContainer
---@field Services RewardsSystemSharedInfrastructureServices
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@return RewardsSystemSharedInfrastructure
function Infrastructure.new()
    local self = setmetatable({}, Infrastructure)
    self.DIContainer = DIContainer.new()
    self.Services = Services.new(self.DIContainer)
    return self
end

return Infrastructure