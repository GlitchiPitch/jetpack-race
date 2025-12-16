---@class JetpackUI
local JetpackUI = {}
JetpackUI.__index = JetpackUI

---@param diContainer DIContainer
---@return JetpackUI
function JetpackUI.new(diContainer)
	local self = setmetatable({}, JetpackUI)
	self.diContainer = diContainer
	return self
end

function JetpackUI:init()
end

return JetpackUI