local ShopUI = require(script.ShopUI)

---@class UI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return UI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer
	self.shopUI = ShopUI.new(self.diContainer)
	return self
end

function UI:init()
	self.shopUI:init()
end

return UI