local ShopUI = require(script.ShopUI)

---@class LiveLeaderboardSystemClientPresentationUI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return LiveLeaderboardSystemClientPresentationUI
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