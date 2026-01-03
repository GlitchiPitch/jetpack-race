---@class SharedConstants
local Constants = {
	SERVER_INITIALIZED = "ServerInitialized",
	REMOTE_EVENTS = {
		PLAYER_UPDATED = "PlayerUpdated",
		RACE_TRIGGER_ACTIVATED = "RaceTriggerActivated",
		FLYING_ACTIVATED = "FlyingActivated",
		RACE_START = "RaceStart",
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
