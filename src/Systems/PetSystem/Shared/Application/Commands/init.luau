---@class SharedCommands
local Commands = {}
Commands.__index = Commands

---@return SharedCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
