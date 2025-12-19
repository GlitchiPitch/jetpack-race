local MainUI = require(script.Main)
local Components = require(script.Components)

---@class UI
---@field mainUI MainUI
---@field components Components
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return UI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer
	self.mainUI = MainUI.new(self.diContainer)
	self.components = Components.new(self.diContainer)
	return self
end

function UI:init()
end

return UI