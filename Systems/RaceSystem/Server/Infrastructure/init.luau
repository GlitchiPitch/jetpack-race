local Repositories = require(script.Repositories)

---@class RaceSystemServerInfrastructure
---@field diContainer DIContainer
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return RaceSystemServerInfrastructure
function Infrastructure.new(diContainer)
    local self = setmetatable({}, Infrastructure)
    self.diContainer = diContainer
    return self
end

function Infrastructure:init()
    ---@type LoggerService
    local logger = self.diContainer:resolve("Logger")

    logger:debug("RaceSystemServerInfrastructure", "Registering PlayerRepository...")
    self.diContainer:singleton("PlayerRepository", function()
        ---@type RaceSystemPlayerEntity
        local entities = self.diContainer:resolve("Entities")
        logger:debug("RaceSystemServerInfrastructure", "Creating PlayerRepository instance")
        return Repositories.PlayerRepository.new(entities)
    end)
    logger:debug("RaceSystemServerInfrastructure", "PlayerRepository registered successfully")
end


return Infrastructure