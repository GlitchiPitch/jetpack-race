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

	self:_setupSprintButton()
	self:hide()
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
	if state then
		self:show()
	else
		self:hide()
	end
	self:_updateSprintButtonState()
end

---@param speedMultiplier number
function JetpackUI:setSpeedMultiplier(speedMultiplier)
	if self.ui.SpeedFrame:FindFirstChild("SpeedMultiplier") then
		self.ui.SpeedFrame.SpeedMultiplier.Text = string.format("%.1fx", speedMultiplier)
	end
end

---@param speed number
function JetpackUI:setSpeed(speed)
	if self.ui.SpeedFrame:FindFirstChild("SpeedValue") then
		self.ui.SpeedFrame.SpeedValue.Text = string.format("%.1f", speed)
	end
end

---@param sprintActivated boolean
function JetpackUI:setSprintActivated(sprintActivated)
	if self.ui:FindFirstChild("SprintActivated") then
		self.ui.SprintActivated.Text = sprintActivated and "SPRINT ACTIVE" or "SPRINT INACTIVE"
	end

	-- Show/hide sprint indicator
	if self.sprintIndicator then
		self.sprintIndicator.Visible = sprintActivated
	end

	-- Update sprint button appearance
	self:_updateSprintButtonState()
end

function JetpackUI:_setupSprintButton()
	self.sprintButton = self.ui:FindFirstChild("SprintButton")
	warn("SprintButton found:", self.sprintButton ~= nil)

	-- Create sprint indicator ImageLabel
	if self.sprintButton then
		self.sprintIndicator = Instance.new("ImageLabel")
		self.sprintIndicator.Name = "SprintIndicator"
		self.sprintIndicator.Size = UDim2.new(0.3, 0, 0.3, 0)
		self.sprintIndicator.Position = UDim2.new(0.7, 0, 0.1, 0)
		self.sprintIndicator.BackgroundTransparency = 1
		self.sprintIndicator.Image = "rbxassetid://123456789" -- Placeholder, will be updated
		self.sprintIndicator.Visible = false
		self.sprintIndicator.Parent = self.sprintButton
	end

	-- Button is now just for display, mouse handling moved to CameraService
end

function JetpackUI:_updateSprintButtonState()
	if not self.sprintButton then
		return
	end

	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()

	local canSprint = flyingEntity:canSprint()
	local isSprintActivated = flyingEntity:isSprintActivated()

	local imageLabel = self.sprintButton:FindFirstChild("ImageLabel")
	if not imageLabel then
		return
	end

	if not canSprint then
		-- Red: cannot sprint (jetpack not active)
		imageLabel.ImageColor3 = Color3.fromRGB(255, 100, 100)
		self.sprintButton.Text = "SPRINT"
	elseif isSprintActivated then
		-- Yellow: sprint is active
		imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 100)
		self.sprintButton.Text = "SPRINTING"
	else
		-- Green: can sprint but not active
		imageLabel.ImageColor3 = Color3.fromRGB(100, 255, 100)
		self.sprintButton.Text = "SPRINT"
	end
end

return JetpackUI
