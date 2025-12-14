local UI = require(script.UI)


---@class FlyingSystemPresentation
local Presentation = {}
Presentation.__index = Presentation

---@param diContainer DIContainer
---@return FlyingSystemPresentation
function Presentation.new(diContainer)
	local self = setmetatable({}, Presentation)
	self.diContainer = diContainer
	self.ui = UI.new(self.diContainer)
	return self
end

function Presentation:init()
	self.ui:init()
end

return Presentation