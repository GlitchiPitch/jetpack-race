---@class SharedConstants
local Constants = {
	SERVER_INITIALIZED = "ServerInitialized",
	REMOTE_EVENTS = {
		PLAYER_UPDATED = "PlayerUpdated",
		RACE_TRIGGER_ACTIVATED = "RaceTriggerActivated",
		FLYING_ACTIVATED = "FlyingActivated",
		RACE_START = "RaceStart",
		CHECKPOINT_REACHED = "CheckpointReached",
		FINISH_RACE = "FinishRace",
		FLYING_DEACTIVATED = "FlyingDeactivated",
	},
	PLAYER_STATES = {
		IDLE = "Idle",
		JETPACK_EQUIPPED = "JetpackEquipped",
	},
	TAGS = {
		TRIGGER_ZONE = "TriggerZone",
	},
}

return Constants
