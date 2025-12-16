---@class ShopSystemServerUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return ShopSystemServerUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
