---@class ShopEntity
local ShopEntity = {}
ShopEntity.__index = ShopEntity

---@return ShopEntity
function ShopEntity.new()
	local self = setmetatable({}, ShopEntity)
	return self
end

return ShopEntity
