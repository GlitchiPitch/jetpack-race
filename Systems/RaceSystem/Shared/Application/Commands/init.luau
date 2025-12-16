---@class RaceSystemSharedCommands
local Commands = {}
Commands.__index = Commands

---@return RaceSystemSharedCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
