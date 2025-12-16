---@class ShopSystemServerCommands
local Commands = {}
Commands.__index = Commands

---@return ShopSystemServerCommands
function Commands.new()
	local self = setmetatable({}, Commands)
	return self
end

return Commands
