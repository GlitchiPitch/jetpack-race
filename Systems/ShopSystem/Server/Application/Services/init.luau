local PlayerService = require(script.PlayerService)

---@class ShopSystemServerServices
---@field playerService ShopSystemServerPlayerService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return ShopSystemServerServices
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