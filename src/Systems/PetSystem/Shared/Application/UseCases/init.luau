---@class SharedUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return SharedUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
