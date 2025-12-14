local DIContainer = require(script.DIContainer)
local Services = require(script.Services)

---@class PetSystemSharedInfrastructure
---@field DIContainer DIContainer
---@field Services PetSystemSharedInfrastructureServices
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@return PetSystemSharedInfrastructure
function Infrastructure.new()
    local self = setmetatable({}, Infrastructure)
    self.DIContainer = DIContainer.new()
    self.Services = Services.new(self.DIContainer)
    return self
end

return Infrastructure