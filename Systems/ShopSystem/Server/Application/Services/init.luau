local PlayerService = require(script.PlayerService)
local ShopService = require(script.ShopService)
local DeveloperProductsService = require(script.DeveloperProductsService)

---@class ShopSystemServerServices
---@field playerService ShopSystemServerPlayerService
---@field shopService ShopSystemServerShopService
---@field developerProductsService DeveloperProductsService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return ShopSystemServerServices
function Services.new(diContainer)
    local self = setmetatable({}, Services)
    self.diContainer = diContainer
    self.playerService = PlayerService.new(self.diContainer)
    self.shopService = ShopService.new(self.diContainer)
    self.developerProductsService = DeveloperProductsService.new(self.diContainer)
    return self
end

function Services:init()
    self.playerService:init()
    self.shopService:init()
    self.developerProductsService:init()
end

return Services