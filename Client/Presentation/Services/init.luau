local RaceService = require(script.RaceService)

---@class ClientPresentationServices
---@field raceService ClientPresentationRaceService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return ClientPresentationServices
function Services.new(diContainer)
    local self = setmetatable({}, Services)
    self.diContainer = diContainer
    self.raceService = RaceService.new(diContainer)
    return self
end

function Services:init()
    self.raceService:init()
end

return Services