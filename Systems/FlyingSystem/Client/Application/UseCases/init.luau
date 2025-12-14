---@class FlyingSystemApplicationUseCases
local UseCases = {}
UseCases.__index = UseCases

---@param diContainer DIContainer
---@return FlyingSystemApplicationUseCases
function UseCases.new(diContainer)
	local self = setmetatable({}, UseCases)
	self.diContainer = diContainer
	return self
end

return UseCases
