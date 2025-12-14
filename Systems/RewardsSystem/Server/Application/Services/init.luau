local PlayerService = require(script.PlayerService)

---@class RewardsSystemServerApplicationServices
---@field playerService RewardsSystemServerPlayerService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return RewardsSystemServerApplicationServices
function Services.new(diContainer)
    local self = setmetatable({}, Services)
    self.diContainer = diContainer
    self.playerService = PlayerService.new(self.diContainer)
    return self
end

function Services:init()
    ---@type LoggerService
    local logger = self.diContainer:resolve("Logger")

    logger:debug("RewardsSystemServerApplicationServices", "Initializing PlayerService...")
    self.playerService:init()
    logger:debug("RewardsSystemServerApplicationServices", "PlayerService initialized")
end

return Services