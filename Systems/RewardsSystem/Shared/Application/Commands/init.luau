---@class RewardsSystemSharedCommands
local Commands = {}
Commands.__index = Commands

---@return RewardsSystemSharedCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
