local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

---@class MainUI
---@field diContainer DIContainer
---@field _ui GuiObject
---@field player Player
---@field raceUI Frame
---@field jetpackUI Frame
---@field body Frame
---@field _renderConnect RBXScriptConnection
local MainUI = {}
MainUI.__index = MainUI

---@param diContainer DIContainer
function MainUI.new(diContainer)
	local self = setmetatable({}, MainUI)
	self.diContainer = diContainer
	self.player = Players.LocalPlayer
	self._ui = script.MainUI:Clone()
	self:_setup()
	return self
end

function MainUI:_setup()
	self._ui.Parent = self.player.PlayerGui

	self.raceUI = self._ui.RaceUI
	self.jetpackUI = self._ui.JetpackUI
	self.body = self._ui.Body

	self:toggleJetpackUI(false)
	self:toggleRaceUI(false)
	self:toggleBody(false)
end

---@param state boolean
function MainUI:toggleRaceUI(state)
	self.raceUI.Visible = state
	if state then
		self:_updateRaceUI()
	else
		if self._raceRenderConnect then
			self._raceRenderConnect:Disconnect()
		end
	end
end

---@param state boolean
function MainUI:toggleJetpackUI(state)
	self.jetpackUI.Visible = state
	if state then
		self:_updateJetpackUI()
	else
		if self._renderConnect then
			self._renderConnect:Disconnect()
		end
	end
end

---@param state boolean
function MainUI:toggleBody(state)
	self.body.Visible = state
end

---@param value number
function MainUI:_updateNitro(value, maxValue)
	self.jetpackUI.Nitro.NitroValue.Text = `{value}/{maxValue}`
end

---@param value number
function MainUI:_updateSpeed(value)
	self.jetpackUI.Speed.TextLabel.Text = `{value} speed`
end

---@param value number
function MainUI:_updateCheckpointIndex(value, maxValue)
	self.raceUI.Place.TextLabel.Text = `{value}/{maxValue}`
	local function calculateProgressBarSize(current, max)
		if max == 0 then
			return UDim2.fromScale(0, 1)
		end
		return UDim2.fromScale(math.clamp(current / max, 0, 1), 1)
	end

	self.raceUI.ProgressBar.Scale.Size = calculateProgressBarSize(value, maxValue)
end

function MainUI:_updateJetpackUI()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local checkpointService = application.services.checkpointService

	local _deltaTime = 0

	---@param deltaTime number
	local function onRender(deltaTime)
		_deltaTime += deltaTime
		if _deltaTime >= 0.3 then
			_deltaTime = 0
			self:_updateCheckpointIndex(checkpointService._currentPoint - 1, checkpointService._maxPoints)
		end
	end

	self._renderConnect = RunService.RenderStepped:Connect(onRender)
end

function MainUI:_updateRaceUI()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local playerService = application.services.playerService

	local _deltaTime = 0

	---@param deltaTime number
	local function onRender(deltaTime)
		_deltaTime += deltaTime
		if _deltaTime >= 0.3 then
			_deltaTime = 0
			local playerJetpack = playerService:getPlayerJetpack()
			if playerJetpack then
				self:_updateSpeed(playerJetpack.speed)
				self:_updateNitro(playerJetpack.nitro, playerJetpack._maxNitro)
			end
		end
	end

	self._raceRenderConnect = RunService.RenderStepped:Connect(onRender)
end

return MainUI
