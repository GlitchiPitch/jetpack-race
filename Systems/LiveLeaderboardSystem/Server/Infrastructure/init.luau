local Repositories = require(script.Repositories)

---@class LiveLeaderboardSystemServerInfrastructure
---@field diContainer DIContainer
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return LiveLeaderboardSystemServerInfrastructure
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