---@class LiveLeaderboardSystemServerCommands
local Commands = {}
Commands.__index = Commands

---@return LiveLeaderboardSystemServerCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
