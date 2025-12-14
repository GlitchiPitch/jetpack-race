---@class LiveLeaderboardSystemClientPresentationUI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return LiveLeaderboardSystemClientPresentationUI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer
	return self
end

function UI:init()
end

return UI