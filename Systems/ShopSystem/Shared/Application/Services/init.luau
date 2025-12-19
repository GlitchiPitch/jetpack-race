---@class ShopSystemSharedServices
---@field config SharedConfig
---@field diContainer DIContainer
---@field marketplaceService MarketplaceService
---@field inventoryService InventoryService
---@field accessoryService AccessoryService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@param config SharedConfig
---@return ShopSystemSharedServices
function Services.new(diContainer, config)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.config = config
	self.marketplaceService = require(script.MarketplaceService).new(diContainer)
	self.inventoryService = require(script.InventoryService).new(diContainer)
	self.accessoryService = require(script.AccessoryService).new(diContainer)
	return self
end

function Services:init()
end

return Services
