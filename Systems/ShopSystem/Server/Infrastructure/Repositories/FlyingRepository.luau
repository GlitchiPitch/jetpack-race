---@class ShopSystemRepository
local ShopRepository = {}
ShopRepository.__index = ShopRepository

---@param diContainer DIContainer
---@return ShopSystemRepository
function ShopRepository.new(diContainer)
	local self = setmetatable({}, ShopRepository)
	self.diContainer = diContainer
	return self
end

return ShopRepository
