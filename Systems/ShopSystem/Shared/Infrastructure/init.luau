local DIContainer = require(script.DIContainer)
local Services = require(script.Services)

---@class ShopSystemInfrastructure
---@field DIContainer DIContainer
---@field Services ShopSystemInfrastructureServices
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@return Infrastructure
function Infrastructure.new()
    local self = setmetatable({}, Infrastructure)
    self.DIContainer = DIContainer.new()
    self.Services = Services.new(self.DIContainer)
    return self
end

return Infrastructure