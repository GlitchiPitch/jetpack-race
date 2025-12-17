local DIContainer = require(script.DIContainer)
local Services = require(script.Services)

---@class Infrastructure
---@field DIContainer DIContainer
---@field IoCContainer DIContainer
---@field Services SharedInfrastructureServices
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@return Infrastructure
function Infrastructure.new()
    local self = setmetatable({}, Infrastructure)
    self.DIContainer = DIContainer.new()
    self.IoCContainer = DIContainer.new()
    self.Services = Services.new(self.DIContainer)
    return self
end

return Infrastructure