---@class RaceSystemSharedUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return RaceSystemSharedUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
