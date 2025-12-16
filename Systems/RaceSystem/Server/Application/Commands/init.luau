---@class RaceSystemServerCommands
local Commands = {}
Commands.__index = Commands

---@return RaceSystemServerCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
