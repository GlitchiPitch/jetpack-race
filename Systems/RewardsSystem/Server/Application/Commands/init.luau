---@class RewardsSystemServerCommands
local Commands = {}
Commands.__index = Commands

---@return RewardsSystemServerCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
