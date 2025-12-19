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

	-- Boost settings
	BOOST_SETTINGS = {
		SPAWN_INTERVAL_MIN = 5, -- minimum seconds between spawns
		SPAWN_INTERVAL_MAX = 8, -- maximum seconds between spawns
		DEFAULT_DURATION = 20, -- default boost lifetime in seconds
		WAYPOINT_SPACING = 2, -- spawn every Nth waypoint
	},

	-- Boost types
	BOOST_TYPES = {
		FLYING_SPEED = "flyingSpeed",
		FLYING_SPEED_BOOST = "flyingSpeedBoost",
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