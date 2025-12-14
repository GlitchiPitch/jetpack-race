---@class FlyingSystemUI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return FlyingSystemUI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer
	return self
end

function UI:init() end

return UI
