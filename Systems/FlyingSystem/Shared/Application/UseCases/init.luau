---@class FlyingSystemSharedUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return FlyingSystemSharedUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
