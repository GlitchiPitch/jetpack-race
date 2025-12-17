---@class RaceSystemServerRaceService
local RaceService = {}
RaceService.__index = RaceService

---@param diContainer DIContainer
---@return RaceSystemServerRaceService
function RaceService.new(diContainer)
	local self = setmetatable({}, RaceService)
	self.diContainer = diContainer
	self.playerRaceStates = {} -- player -> race state
	self.activeTimers = {} -- player -> timer connection
	return self
end

function RaceService:init()
	warn("RaceService:init")
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemServerRaceService", "Initializing RaceService...")
	self:setupProximityPrompt(workspace.JetpackRace.TriggerZone)
end

function RaceService:setupProximityPrompt(triggerZone)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	local proximityPrompt = triggerZone:FindFirstChild("ProximityPrompt")
	if not proximityPrompt then
		logger:warn("RaceSystemServerRaceService", "ProximityPrompt not found in TriggerZone")
		return
	end

	proximityPrompt.ActionText = "Start Race"
	proximityPrompt.Triggered:Connect(function(player)
		self:startRace(player)
	end)
end

---@param player Player
function RaceService:startRace(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	-- Check if player is already in a race
	if self.playerRaceStates[player] and self.playerRaceStates[player] ~= "Idle" then
		logger:info("RaceSystemServerRaceService", "Player already in race:", player.Name)
		return
	end

	local character = player.Character
	if not character then
		logger:warn("RaceSystemServerRaceService", "No character found for player:", player.Name)
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		logger:warn("RaceSystemServerRaceService", "No humanoid found for player:", player.Name)
		return
	end

	logger:info("RaceSystemServerRaceService", "Starting race for player:", player.Name)

	-- Set race state to preparing
	self.playerRaceStates[player] = "Preparing"

	-- Notify client about race preparation
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.RACE_PREPARING, {
		preparationTime = constants.RACE_SETTINGS.PREPARATION_TIME,
	})

	-- Start preparation timer
	local preparationTime = constants.RACE_SETTINGS.PREPARATION_TIME
	local cooldownTime = constants.RACE_SETTINGS.COOLDOWN_TIME

	-- Cancel existing timer if any
	if self.activeTimers[player] then
		self.activeTimers[player]:Disconnect()
	end

	self.activeTimers[player] = task.delay(preparationTime, function()
		self:activateRaceFlying(player)
	end)

	-- Ensure jetpack is equipped
	local hasJetpack = false
	for _, accessory in ipairs(humanoid:GetAccessories()) do
		if accessory.Name == "Default Jetpack" then
			hasJetpack = true
			break
		end
	end

	if not hasJetpack then
		-- Equip jetpack through JetpackService
		---@type FlyingSystemServerJetpackService
		local jetpackService = self.diContainer:resolve("JetpackService")
		jetpackService:equipDefaultJetpack(player)
		logger:info("RaceSystemServerRaceService", "Equipped Default Jetpack to player:", player.Name)
	end
end

---@param player Player
function RaceService:activateRaceFlying(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemServerRaceService", "Activating flying for race player:", player.Name)

	-- Set race state to started
	self.playerRaceStates[player] = "Started"

	-- Notify client about race start
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.RACE_STARTED, {})

	-- Start cooldown timer before allowing forward movement
	local cooldownTime = constants.RACE_SETTINGS.COOLDOWN_TIME

	self.activeTimers[player] = task.delay(cooldownTime, function()
		self:enableForwardMovement(player)
	end)
end

---@param player Player
function RaceService:enableForwardMovement(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	---@type FlyingRepository
	local flyingEntity = flyingRepository:getFlyingEntity(player)

	-- Activate flying
	flyingEntity:activateFlying()
	logger:info("RaceSystemServerRaceService", "Flying activated for player:", player.Name)

	logger:info("RaceSystemServerRaceService", "Enabling forward movement for player:", player.Name)

	-- Notify client to enable auto-forward movement
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.ENABLE_FORWARD_MOVEMENT, {})

	-- Clear timer
	if self.activeTimers[player] then
		self.activeTimers[player] = nil
	end
end

---@param player Player
function RaceService:finishRace(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemServerRaceService", "Finishing race for player:", player.Name)

	-- Set race state to finished
	self.playerRaceStates[player] = "Finished"

	-- Notify client about race finish
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local constants = self.diContainer:resolve("Shared.Constants")

	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.RACE_FINISHED, {})

	-- Deactivate flying
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	---@type FlyingRepository
	local flyingEntity = flyingRepository:getFlyingEntity(player)

	-- Deactivate flying
	flyingEntity:deactivateFlying()
	logger:info("RaceSystemServerRaceService", "Flying deactivated for player:", player.Name)

	-- Reset race state after delay
	task.delay(2, function()
		self.playerRaceStates[player] = "Idle"
	end)
end ---@param player Player
function RaceService:onPlayerRemoving(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemServerRaceService", "Player removing, cleaning up race state:", player.Name)

	-- Cancel any active timers
	if self.activeTimers[player] then
		self.activeTimers[player]:Disconnect()
		self.activeTimers[player] = nil
	end

	-- Clear race state
	self.playerRaceStates[player] = nil
end

return RaceService
