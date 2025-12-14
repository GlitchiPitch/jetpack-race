---@class LiveLeaderboardSystemSharedCommands
local Commands = {}
Commands.__index = Commands

---@return LiveLeaderboardSystemSharedCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
