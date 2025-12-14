---@class LiveLeaderboardSystemSharedUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return LiveLeaderboardSystemSharedUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
