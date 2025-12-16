---@class ShopEntity
---@field isActive boolean
---@field speedMultiplier number
---@field chargeLevel number
---@field sprintActivated boolean
---@field maxCharge number
local ShopEntity = {}
ShopEntity.__index = ShopEntity

---@return ShopEntity
function ShopEntity.new()
	local self = setmetatable({}, ShopEntity)
	self.isActive = false
	self.speedMultiplier = 1.0
	self.chargeLevel = 100
	self.sprintActivated = false
	self.maxCharge = 100
	return self
end

return ShopEntity
