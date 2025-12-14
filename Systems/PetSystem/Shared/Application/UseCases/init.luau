---@class PetSystemSharedUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return PetSystemSharedUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
