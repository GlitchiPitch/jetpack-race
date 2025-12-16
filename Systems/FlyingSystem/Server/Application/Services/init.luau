local PlayerService = require(script.PlayerService)
local JetpackService = require(script.JetpackService)

---@class FlyingSystemServerServices
---@field playerService FlyingSystemServerPlayerService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return FlyingSystemServerServices
function Services.new(diContainer)
    local self = setmetatable({}, Services)
    self.diContainer = diContainer
    self.playerService = PlayerService.new(self.diContainer)
    self.jetpackService = JetpackService.new(self.diContainer)
    return self
end

function Services:init()
    self.playerService:init()
end

return Services