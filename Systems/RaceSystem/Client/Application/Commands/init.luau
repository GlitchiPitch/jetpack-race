---@class RaceSystemClientCommands
local Commands = {}
Commands.__index = Commands

---@param diContainer DIContainer
---@return RaceSystemClientCommands
function Commands.new(diContainer)
	local self = setmetatable({}, Commands)
	self.diContainer = diContainer
	return self
end

return Commands
