---@class RingsService
local RingsService = {}
RingsService.__index = RingsService

---@param diContainer DIContainer
---@return RingsService
function RingsService.new(diContainer)
    local self = setmetatable({}, RingsService)
    self.diContainer = diContainer
    return self
end

function RingsService:init()
    ---@type LoggerService
    local logger = self.diContainer:resolve("Logger")
    logger:debug("RingsService", "Initializing RingsService...")
end

---@param race RaceEntity
function RingsService:createRings(race)
    ---@type LoggerService
    local logger = self.diContainer:resolve("Logger")
    logger:debug("RingsService", "Creating rings for race:", race.id)
end

function RingsService:destroyRings(race)
    ---@type LoggerService
    local logger = self.diContainer:resolve("Logger")
    logger:debug("RingsService", "Destroying rings for race:", race.id)
end

return RingsService
