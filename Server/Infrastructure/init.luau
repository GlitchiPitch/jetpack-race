local Repositories = require(script.Repositories)

---@class ServerInfrastructure
---@field diContainer DIContainer
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return ServerInfrastructure
function Infrastructure.new(diContainer)
    local self = setmetatable({}, Infrastructure)
    self.diContainer = diContainer
    self:_register()
    return self
end

function Infrastructure:_register()
    self.diContainer:singleton("PlayerRepository", function()
        ---@type Entities
        local entities = self.diContainer:resolve("Entities")
        return Repositories.PlayerRepository.new(entities)
    end)
end


return Infrastructure