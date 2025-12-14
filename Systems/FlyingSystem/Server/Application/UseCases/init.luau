---@class FlyingSystemServerUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return FlyingSystemServerUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
