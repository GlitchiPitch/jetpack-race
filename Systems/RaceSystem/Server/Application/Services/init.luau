local PlayerService = require(script.PlayerService)
local RaceService = require(script.RaceService)
---@class RaceSystemServerApplicationServices
---@field playerService RaceSystemServerPlayerService
---@field raceService RaceSystemServerRaceService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return RaceSystemServerApplicationServices
function Services.new(diContainer)
    local self = setmetatable({}, Services)
    self.diContainer = diContainer
    self.playerService = PlayerService.new(self.diContainer)
    self.raceService = RaceService.new(self.diContainer)
    return self
end

function Services:init()
    warn("Services:init")
    ---@type LoggerService
    local logger = self.diContainer:resolve("Logger")

    logger:debug("RaceSystemServerApplicationServices", "Initializing PlayerService...")
    self.playerService:init()
    logger:debug("RaceSystemServerApplicationServices", "PlayerService initialized")

    logger:debug("RaceSystemServerApplicationServices", "Initializing RaceService...")
    self.raceService:init()
    logger:debug("RaceSystemServerApplicationServices", "RaceService initialized")
end

return Services