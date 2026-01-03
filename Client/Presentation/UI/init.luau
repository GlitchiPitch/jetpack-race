local Components = require(script.Components)
local MainUI = require(script.Main)

---@class UI
---@field Components Components
---@field mainUI MainUI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return UI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer
	self.Components = Components
	self.mainUI = MainUI.new(diContainer)
	return self
end

function UI:init()
end

return UI
