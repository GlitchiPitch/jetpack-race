---@class RewardsSystemServerUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return RewardsSystemServerUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
