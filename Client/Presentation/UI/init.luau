local Components = require(script.Components)

---@class UI
---@field Components Components
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return UI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer
	self.Components = Components
	return self
end

function UI:init() end

return UI
