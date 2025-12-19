local BaseFrame = require(script.BaseFrame)

---@class Components
---@field BaseFrame BaseFrame
local Components = {}
Components.__index = Components

---@param diContainer DIContainer
---@return Components
function Components.new(diContainer)
	local self = setmetatable({}, Components)
	self.diContainer = diContainer
	self.BaseFrame = BaseFrame
	return self
end

return Components
