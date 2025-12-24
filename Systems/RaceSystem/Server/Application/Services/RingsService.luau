---@class RingsService
local RingsService = {}
RingsService.__index = RingsService

---@param diContainer DIContainer
---@return RingsService
function RingsService.new(diContainer)
	local self = setmetatable({}, RingsService)
	self.diContainer = diContainer
	self.activeRaces = {} -- player -> race entity
	self.touchConnections = {} -- ring id -> connection
	return self
end

function RingsService:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RingsService", "Initializing RingsService...")
end

---@param player Player
---@param race RaceEntity
function RingsService:createRings(player, race)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RingsService", "Creating rings for race:", race.id)

	-- Get checkpoint waypoints from the race track
	local checkpointsFolder = workspace.JetpackRace.RaceTrack:FindFirstChild("CheckpointWaypoints")
	if not checkpointsFolder then
		logger:warn("RingsService", "CheckpointWaypoints folder not found, using default positions")
	end

	-- Create rings using shared service
	local assetsSpawnService = self.diContainer:resolve("AssetsSpawnService")
	local raceEntity = assetsSpawnService:spawnRing(race, checkpointsFolder)

	-- Store race entity for this player
	self.activeRaces[player] = raceEntity

	-- Setup checkpoint detection for each ring
	self:_setupCheckpointDetection(player, raceEntity)

	logger:info("RingsService", "Created", raceEntity.totalCheckpoints, "checkpoints for player:", player.Name)
	return raceEntity
end

---@param player Player
---@param raceEntity RaceEntity
function RingsService:_setupCheckpointDetection(player, raceEntity)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	for checkpointId, ringEntity in pairs(raceEntity.rings) do
		-- Override the touch handler for server-side logic
		local touchPart = ringEntity.model:FindFirstChild("TouchPart")
		if touchPart then
			local connection = touchPart.Touched:Connect(function(hit)
				self:_onCheckpointTouched(player, raceEntity, ringEntity, hit)
			end)

			-- Store connection for cleanup
			if not self.touchConnections[player] then
				self.touchConnections[player] = {}
			end
			self.touchConnections[player][checkpointId] = connection
		else
			logger:warn("RingsService", "TouchPart not found in ring model for checkpoint:", checkpointId)
		end
	end
end

---@param player Player
---@param raceEntity RaceEntity
---@param ringEntity RingEntity
---@param hit BasePart
function RingsService:_onCheckpointTouched(player, raceEntity, ringEntity, hit)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	-- Check if the toucher is the player's character
	local character = player.Character
	if not character or not hit:IsDescendantOf(character) then
		return
	end

	-- Check if checkpoint is already passed
	if ringEntity.isPassed then
		return
	end

	-- Mark checkpoint as passed
	ringEntity.isPassed = true
	raceEntity:markCheckpointPassed(ringEntity.checkpointId)

	logger:info("RingsService", "Player", player.Name, "passed checkpoint", ringEntity.checkpointId)

	-- Send progress update to client
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.CHECKPOINT_PASSED, {
		checkpointId = ringEntity.checkpointId,
		passedCount = raceEntity:getPassedCheckpointsCount(),
		totalCount = raceEntity.totalCheckpoints,
		isRaceCompleted = raceEntity:isRaceCompleted(),
	})

	-- Check if race is completed
	if raceEntity:isRaceCompleted() then
		logger:info("RingsService", "Player", player.Name, "completed all checkpoints")

		-- Trigger race completion (this will be handled by RaceService)
		remoteEventService:fireClient(player, constants.REMOTE_EVENTS.RACE_COMPLETED, {
			passedCount = raceEntity:getPassedCheckpointsCount(),
			totalCount = raceEntity.totalCheckpoints,
		})
	end
end

---@param player Player
function RingsService:destroyRings(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RingsService", "Destroying rings for player:", player.Name)

	local raceEntity = self.activeRaces[player]
	if not raceEntity then
		return
	end

	-- Disconnect touch events
	if self.touchConnections[player] then
		for _, connection in pairs(self.touchConnections[player]) do
			if connection then
				connection:Disconnect()
			end
		end
		self.touchConnections[player] = nil
	end

	-- Destroy ring models
	for _, ringEntity in pairs(raceEntity.rings) do
		ringEntity:destroy()
	end

	-- Clear race data
	self.activeRaces[player] = nil
	logger:info("RingsService", "Destroyed rings for player:", player.Name)
end

---@param player Player
---@return RaceEntity?
function RingsService:getPlayerRace(player)
	return self.activeRaces[player]
end

return RingsService
