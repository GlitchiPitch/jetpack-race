---@class RaceSystemServerUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return RaceSystemServerUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
