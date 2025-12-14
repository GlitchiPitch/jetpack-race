---@class ServerCommands
local Commands = {}
Commands.__index = Commands

---@return ServerCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
