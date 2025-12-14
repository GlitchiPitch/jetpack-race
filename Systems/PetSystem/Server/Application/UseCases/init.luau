---@class PetSystemServerUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return PetSystemServerUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
