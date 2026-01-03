---@class ServerCheckpointService
---@field diContainer DIContainer
local CheckpointService = {}
CheckpointService.__index = CheckpointService

---@param diContainer DIContainer
function CheckpointService.new(diContainer)
	local self = setmetatable({}, CheckpointService)
	self.diContainer = diContainer
	self.folder = Instance.new("Folder")
	self.folder.Parent = workspace.Workspace
	self.pointIndex = 1
	self.points = {}
	return self
end

function CheckpointService:generate()
	---@type ServerInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type Shared
	local shared = self.diContainer:resolve("Shared")

	local jetpackTrajectories = {
		{
			startPos = Vector3.new(0, 20, 0),
			endPos = Vector3.new(500, 20, 0),
			controlDelta = Vector3.new(0, 0, 0),
		},
		{
			startPos = Vector3.new(600, 20, 0),
			endPos = Vector3.new(1100, 200, 0),
			controlDelta = Vector3.new(0, 150, 0),
		},
		{
			startPos = Vector3.new(1200, 200, 0),
			endPos = Vector3.new(1200, 200, -800),
			controlDelta = Vector3.new(800, 0, 0),
		},
		{
			startPos = Vector3.new(1200, 200, -900),
			endPos = Vector3.new(1200, 200, -1400),
			controlDelta = Vector3.new(-800, 0, 0),
		},
	}

	local minDistance = 100

	local points = infrastructure.services.trajectoryPathService:generateTrack(jetpackTrajectories, minDistance)

	-- Optionally orient all parts to face the next part
	for i = 1, #points do
		local currentPart = points[i]
		local nextPart = points[i + 1]
		local pointCFrame

		if currentPart and nextPart then
			pointCFrame = CFrame.new(currentPart, nextPart)
		else
			pointCFrame = CFrame.new(currentPart, points[i - 1])
		end

		local p = shared.Domain.Entities.Checkpoint.new({
			_instance = shared.Assets.Checkpoint:Clone(),
			cframe = pointCFrame,
			index = self.pointIndex,
			parent = self.folder,
		})

		self.points[self.pointIndex] = {
			point = currentPart,
			instance = p._instance,
		}

		self.pointIndex += 1
	end
end

---@return checkpointData[]
function CheckpointService:getCheckpoints()
	return self.points
end

return CheckpointService
