local PlayerService = require(script.PlayerService)

---@class RaceSystemServerApplicationServices
---@field playerService RaceSystemServerPlayerService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return RaceSystemServerApplicationServices
function Services.new(diContainer)
    local self = setmetatable({}, Services)
    self.diContainer = diContainer
    self.playerService = PlayerService.new(self.diContainer)
    return self
end

function Services:init()
    ---@type LoggerService
    local logger = self.diContainer:resolve("Logger")

    logger:debug("RaceSystemServerApplicationServices", "Initializing PlayerService...")
    self.playerService:init()
    logger:debug("RaceSystemServerApplicationServices", "PlayerService initialized")
end

return Services