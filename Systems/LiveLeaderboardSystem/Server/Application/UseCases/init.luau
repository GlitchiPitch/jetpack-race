---@class LiveLeaderboardSystemServerUseCases
local UseCases = {}
UseCases.__index = UseCases

---@return LiveLeaderboardSystemServerUseCases
function UseCases.new()
	local self = setmetatable({}, UseCases)
	return self
end

return UseCases
