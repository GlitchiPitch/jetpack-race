---@class ClientApplicationUseCases
local UseCases = {}
UseCases.__index = UseCases

---@param diContainer DIContainer
---@return ClientApplicationUseCases
function UseCases.new(diContainer)
	local self = setmetatable({}, UseCases)
	self.diContainer = diContainer
	return self
end

return UseCases
