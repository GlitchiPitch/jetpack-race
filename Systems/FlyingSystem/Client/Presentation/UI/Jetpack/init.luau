local Players = game:GetService("Players")

---@class JetpackUI
local JetpackUI = {}
JetpackUI.__index = JetpackUI

---@param diContainer DIContainer
---@return JetpackUI
function JetpackUI.new(diContainer)
	local self = setmetatable({}, JetpackUI)
	self.diContainer = diContainer
	self.ui = script.JetpackUI:Clone()
	self.player = Players.LocalPlayer
	self.ui.Parent = self.player.PlayerGui
	self:hide()
	return self
end

function JetpackUI:show()
	self.ui.Enabled = true
end

function JetpackUI:hide()
	self.ui.Enabled = false
end

---@param state boolean
function JetpackUI:set(state)
	warn(state)
	if state then
		self:show()
	else
		self:hide()
	end
end

---@param speedMultiplier number
function JetpackUI:setSpeedMultiplier(speedMultiplier)
	self.ui.SpeedMultiplier.Text = speedMultiplier
end

---@param chargeLevel number
function JetpackUI:setChargeLevel(chargeLevel)
	self.ui.ChargeLevel.Text = chargeLevel
end

---@param sprintActivated boolean
function JetpackUI:setSprintActivated(sprintActivated)
	self.ui.SprintActivated.Text = sprintActivated
end

---@param maxCharge number
function JetpackUI:setMaxCharge(maxCharge)
	self.ui.MaxCharge.Text = maxCharge
end

return JetpackUI
