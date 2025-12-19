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
	self.remoteEventService = diContainer:resolve("RemoteEventService")
	self:_setupSprintButton()
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

---@param sprintActivated boolean
function JetpackUI:setSprintActivated(sprintActivated)
	if self.ui:FindFirstChild("SprintActivated") then
		self.ui.SprintActivated.Text = sprintActivated and "SPRINT ACTIVE" or "SPRINT INACTIVE"
	end

	-- Update sprint button appearance
	if self.sprintButton then
		if sprintActivated then
			self.sprintButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100) -- Green when active
			self.sprintButton.Text = "SPRINTING"
		else
			self.sprintButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100) -- Red when inactive
			self.sprintButton.Text = "SPRINT"
		end
	end
end

function JetpackUI:_setupSprintButton()
	self.sprintButton = self.ui:FindFirstChild("SprintButton")
	if self.sprintButton then
		self.sprintButton.MouseButton1Click:Connect(function()
			self:_toggleSprint()
		end)
	end
end

function JetpackUI:_toggleSprint()
	-- Check if jetpack is equipped by verifying if sprint can be activated
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()

	if flyingEntity:canSprint() then
		local isCurrentlyActive = flyingEntity:isSprintActivated()
		self.remoteEventService:fireServer("sprint", not isCurrentlyActive)
	end
end

return JetpackUI
