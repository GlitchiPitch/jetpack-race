--- ServerCheckpointService - Server-side checkpoint management and validation
---
--- This service handles the generation and validation of race checkpoints on the server.
--- It creates checkpoint entities along predefined race trajectories and tracks
--- player progress through the checkpoint system.
---
--- Key Features:
--- - Generates checkpoints along curved trajectories using TrajectoryPathService
--- - Validates checkpoint reach distances to prevent cheating
--- - Tracks individual player checkpoint progress
--- - Manages checkpoint entity cleanup on player removal
--- - Provides checkpoint data access for client synchronization
---
--- Checkpoint Generation:
--- - Uses trajectory data to place checkpoints at optimal intervals
--- - Orients checkpoints to face the next point in the path
--- - Creates collision-enabled checkpoint entities in the workspace
---
--- @class ServerCheckpointService
--- @field diContainer DIContainer Dependency injection container for resolving other services
--- @field _reachedCheckpoints table<number, number> Maps player UserIds to their last reached checkpoint index
--- @field folder Folder
--- @field pointIndex number
--- @field points table<number, table<any, any>>
local CheckpointService = {}
CheckpointService.__index = CheckpointService

---@param diContainer DIContainer
function CheckpointService.new(diContainer)
	local self = setmetatable({}, CheckpointService)
	self.diContainer = diContainer
	self.folder = Instance.new("Folder")
	self.pointIndex = 1
	self.points = {}
	self._reachedCheckpoints = {}

	self:_setup()

	return self
end

function CheckpointService:_setup()
	self.folder.Name = "Checkpoints"
	self.folder.Parent = workspace.Workspace
end

---@param playerEntity PlayerEntity
function CheckpointService:clearReachedPoints(playerEntity)
	if self._reachedCheckpoints[playerEntity.player.UserId] then
		self._reachedCheckpoints[playerEntity.player.UserId] = nil
	end
end

---@param player Player
function CheckpointService:onPlayerRemoving(player)
	if self._reachedCheckpoints[player.UserId] then
		self._reachedCheckpoints[player.UserId] = nil
	end
end

function CheckpointService:generate()
	---@type ServerInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type Shared
	local shared = self.diContainer:resolve("Shared")

	local jetpackTrajectories = {
		{
			startPos = workspace.Workspace.Track["1"].Position,
			endPos = workspace.Workspace.Track["2"].Position,
			controlDelta = Vector3.new(0, 0, 0),
		},
		{
			startPos = workspace.Workspace.Track["3"].Position,
			endPos = workspace.Workspace.Track["4"].Position,
			controlDelta = Vector3.new(0, 150, 0),
		},
		{
			startPos = workspace.Workspace.Track["5"].Position,
			endPos = workspace.Workspace.Track["6"].Position,
			controlDelta = Vector3.new(0, 0, -400),
		},
		{
			startPos = workspace.Workspace.Track["7"].Position,
			endPos = workspace.Workspace.Track["8"].Position,
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
			index = self.pointIndex,
		}

		self.pointIndex += 1
	end
end

---@return checkpointData[]
function CheckpointService:getCheckpoints()
	return self.points
end

---@param playerEntity PlayerEntity
---@param checkpointData checkpointData
function CheckpointService:checkpointReached(playerEntity, checkpointData)
	local character = playerEntity:getCharacter()
	if character then
		local mag = (character:GetPivot().Position - checkpointData.point).Magnitude
		warn(checkpointData, mag)
		if mag < 40 then
			self._reachedCheckpoints[playerEntity.player.UserId] = checkpointData.index
			warn(
				"self._reachedCheckpoints[playerEntity.player.UserId]",
				self._reachedCheckpoints[playerEntity.player.UserId]
			)
		else
			print("Player Kick")
		end
	end
end

return CheckpointService
