---@class RaceSystemConstants
local Constants = {
	-- Race states
	RACE_STATES = {
		IDLE = "Idle",
		PREPARING = "Preparing",
		STARTED = "Started",
		FINISHED = "Finished",
	},

	-- Race settings
	RACE_SETTINGS = {
		PREPARATION_TIME = 3, -- seconds before race starts
		COOLDOWN_TIME = 1, -- seconds before allowing forward movement
	},

	-- Remote events
	REMOTE_EVENTS = {
		RACE_STARTED = "race_started",
		RACE_FINISHED = "race_finished",
		RACE_PREPARING = "race_preparing",
		ENABLE_FORWARD_MOVEMENT = "enable_forward_movement",
	},
}

return Constants