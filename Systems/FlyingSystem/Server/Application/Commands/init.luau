---@class FlyingSystemServerCommands
local Commands = {}
Commands.__index = Commands

---@return FlyingSystemServerCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
