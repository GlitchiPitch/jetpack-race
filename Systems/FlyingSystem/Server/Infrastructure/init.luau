local Repositories = require(script.Repositories)

---@class FlyingSystemServerInfrastructure
---@field diContainer DIContainer
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return FlyingSystemServerInfrastructure
function Infrastructure.new(diContainer)
    local self = setmetatable({}, Infrastructure)
    self.diContainer = diContainer
    self:_register()
    return self
end

function Infrastructure:_register()
    self.diContainer:singleton("PlayerRepository", function()
        ---@type FlyingSystemEntities
        local entities = self.diContainer:resolve("Entities")
        ---@type PlayerEntity
        local playerEntity = entities.Player
        return Repositories.PlayerRepository.new(playerEntity)
    end)
end


return Infrastructure