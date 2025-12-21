---@class FlyingSystemConstants
local Constants = {
	-- Speed values
	BASE_SPRINT_VALUE = 1.0,
	ACTIVATED_SPRINT_VALUE = 2.5,
	BASE_SIDE_MOVE_SPEED = 25, -- speed for A/D lateral movement
	BASE_FORWARD_MOVE_SPEED = 15, -- speed for forward movement in race mode
	CAMERA_SPEED = { X = 40, Y = 60 },

	-- Charge system
	BASE_SPRINT_COST_VALUE = 5,
	REALOAD_CHARGE_VALUE = 2,

	-- Physics
	BODY_VELOCITY_P = 1000,
	BODY_GYRO_P = 1000,
	BODY_POSITION_P = 1000,
	BODY_GYRO_Y_LIMIT = 30, -- degrees limit for pitch rotation

	-- Position validation
	POSITION_VALIDATION = {
		MAX_SPEED = 120, -- units per second (base 50 * sprint 2 * buffer 1.2)
		POSITION_UPDATE_INTERVAL = 0.1, -- seconds between position updates
		MAX_VIOLATIONS = 10, -- violations before severe action
		BOUNDS_CHECK_ENABLED = true, -- enable out-of-bounds character reload
	},

	-- Game states
	GAME_STATES = {
		ROUND = "Round",
		PREPARE = "Prepare",
		TIME_OUT = "TimeOut",
		FINAL = "Final",
		INTERMISSION = "Intermission",
	},

	-- Jetpack states
	JETPACK_STATES = {
		INACTIVE = "Inactive",
		ACTIVATING = "Activating",
		IDLE = "Idle",
		FLYING = "Flying",
		DEACTIVATING = "Deactivating",
	},

	-- Jetpack heights
	JETPACK_HEIGHTS = {
		GROUND = -50,
		FLYING = 50,
		MAX_FLYING_HEIGHT = 50, -- maximum height limit for jetpack flight
	},

	-- Input keys
	INPUT_KEYS = {
		SPRINT = Enum.KeyCode.LeftShift,
		SWITCH_SHOULDER = Enum.KeyCode.X,
		MOVE_LEFT = Enum.KeyCode.A,
		MOVE_RIGHT = Enum.KeyCode.D,
	},

	-- Remote events
	REMOTE_EVENTS = {
		PLAYER_UPDATED = "player_updated",
		POSITION_UPDATE = "position_update",
		SPRINT = "sprint",
	},

	-- Camera settings
	CAMERA_OFFSET = {
		Z = 15,
		Y = 4,
		X = 3,
	},
	CAMERA_SHOULDER = {
		LEFT = -3, -- X offset for left shoulder
		RIGHT = 3, -- X offset for right shoulder
	},
	CAMERA_SETTINGS = {
		SPEED_MULTIPLIER = 0.2,
		Y_EXTREME = 5,
		X_EXTREME = 45,
		AUTO_ROTATE_DELAY = 0.5,
		MOUSE_DEAD_ZONE = 5,
	},
}

return Constants
