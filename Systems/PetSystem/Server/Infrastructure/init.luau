local Repositories = require(script.Repositories)

---@class PetSystemServerInfrastructure
---@field diContainer DIContainer
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return PetSystemServerInfrastructure
function Infrastructure.new(diContainer)
    local self = setmetatable({}, Infrastructure)
    self.diContainer = diContainer
    self:_register()
    return self
end

function Infrastructure:_register()
    self.diContainer:singleton("PlayerRepository", function()
        return Repositories.PlayerRepository.new(self.diContainer:resolve("PlayerEntity"))
    end)
end


return Infrastructure