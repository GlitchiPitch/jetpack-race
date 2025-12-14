---@class RewardsSystemSharedUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return RewardsSystemSharedUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
