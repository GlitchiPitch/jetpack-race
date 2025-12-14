---@class PetSystemServerCommands
local Commands = {}
Commands.__index = Commands

---@return PetSystemServerCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
