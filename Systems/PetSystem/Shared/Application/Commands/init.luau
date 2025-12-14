---@class PetSystemSharedCommands
local Commands = {}
Commands.__index = Commands

---@return PetSystemSharedCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
