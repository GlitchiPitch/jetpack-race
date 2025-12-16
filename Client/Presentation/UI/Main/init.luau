local Players = game:GetService("Players")
---@class MainUI
local MainUI = {}
MainUI.__index = MainUI

---@param diContainer DIContainer
---@return MainUI
function MainUI.new(diContainer)
	local self = setmetatable({}, MainUI)
	self.diContainer = diContainer
	self.ui = script.MainUI:Clone()
	self.player = Players.LocalPlayer
    self:init()
	return self
end

function MainUI:init()
	self.ui.Parent = self.player.PlayerGui
end

return MainUI
