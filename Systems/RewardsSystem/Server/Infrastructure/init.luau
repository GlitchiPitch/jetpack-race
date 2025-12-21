local Repositories = require(script.Repositories)

---@class RewardsSystemServerInfrastructure
---@field diContainer DIContainer
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return RewardsSystemServerInfrastructure
function Infrastructure.new(diContainer)
    local self = setmetatable({}, Infrastructure)
    self.diContainer = diContainer
    return self
end

function Infrastructure:init()
    ---@type LoggerService
    local logger = self.diContainer:resolve("Logger")

    logger:debug("RewardsSystemServerInfrastructure", "Registering PlayerRepository...")
    self.diContainer:singleton("PlayerRepository", function()
        ---@type table
        local entities = self.diContainer:resolve("Entities")
        logger:debug("RewardsSystemServerInfrastructure", "Creating PlayerRepository instance")
        return Repositories.PlayerRepository.new(entities)
    end)
    logger:debug("RewardsSystemServerInfrastructure", "PlayerRepository registered successfully")
end


return Infrastructure