local RunService = game:GetService("RunService")
---@class ClientCheckpointService
---@field diContainer DIContainer
---@field _checkpoints Vector3[]
---@field _deltaTime number
---@field _updateTime number
local CheckpointService = {}
CheckpointService.__index = CheckpointService

---@param diContainer DIContainer
---@return ClientCheckpointService
function CheckpointService.new(diContainer)
	local self = setmetatable({}, CheckpointService)
	self.diContainer = diContainer
	self._checkpoints = {}
	self._deltaTime = 0
	self._updateTime = 0.1
	self._currentPoint = 1
	return self
end

---@class checkpointData
---@field point Vector3
---@field instance Model

---@param checkpoints checkpointData[]
function CheckpointService:trackCheckpoints(checkpoints)
	---@param deltaTime number
	local function onRender(deltaTime)
		self._deltaTime += deltaTime
		if self._deltaTime >= self._updateTime then
			self._deltaTime = 0
			if self:_reachedCheckpoint() then
				local currentPoint = self._checkpoints[self._currentPoint]
				currentPoint.instance.PrimaryPart.BrickColor = BrickColor.Yellow()
				self._currentPoint += 1
			end
		end
	end

	self._checkpoints = checkpoints
	self._renderConnect = RunService.RenderStepped:Connect(onRender)
end

---@return boolean
function CheckpointService:_reachedCheckpoint()
	---@type ClientApplication
	local application = self.diContainer:resolve("Application")
	local character = application.services.playerService:getPlayerCharacter()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: Part
	local currentPoint = self._checkpoints[self._currentPoint]
	if currentPoint then
		local mag = (humanoidRootPart.Position - currentPoint.point).Magnitude
		return mag < 20
	end

	return true
end

return CheckpointService
