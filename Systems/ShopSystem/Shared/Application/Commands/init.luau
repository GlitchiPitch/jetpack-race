---@class ShopSystemSharedCommands
local Commands = {}
Commands.__index = Commands

---@return ShopSystemSharedCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
