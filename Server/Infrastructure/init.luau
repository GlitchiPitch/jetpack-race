local Repositories = require(script.Repositories)

---@class ServerInfrastructure
---@field diContainer DIContainer
---@field Repositories Repositories
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return ServerInfrastructure
function Infrastructure.new(diContainer)
    local self = setmetatable({}, Infrastructure)
    self.diContainer = diContainer
    self.Repositories = Repositories
    self:_register()
    return self
end

function Infrastructure:_register()
    self.diContainer:singleton("Infrastructure", function()
        return self
    end)
end
return Infrastructure