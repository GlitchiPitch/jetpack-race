---@class ShopSystemSharedUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return ShopSystemSharedUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
