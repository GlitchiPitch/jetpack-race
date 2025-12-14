local PlayerService = require(script.PlayerService)

---@class LiveLeaderboardSystemServerApplicationServices
---@field playerService LiveLeaderboardSystemServerPlayerService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return LiveLeaderboardSystemServerApplicationServices
function Services.new(diContainer)
    local self = setmetatable({}, Services)
    self.diContainer = diContainer
    self.playerService = PlayerService.new(self.diContainer)
    return self
end

function Services:init()
    self.playerService:init()
end

return Services