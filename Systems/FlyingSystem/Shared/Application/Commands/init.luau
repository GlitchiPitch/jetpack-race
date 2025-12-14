---@class FlyingSystemSharedCommands
local Commands = {}
Commands.__index = Commands

---@return FlyingSystemSharedCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
