---@class ShopSystemConstants
local Constants = {
	-- Speed values
	BASE_SPRINT_VALUE = 1.0,
	ACTIVATED_SPRINT_VALUE = 2.5,
	CAMERA_SPEED = { X = 40, Y = 60 },

	-- Charge system
	BASE_SPRINT_COST_VALUE = 5,
	REALOAD_CHARGE_VALUE = 2,

	-- Physics
	BODY_VELOCITY_P = 1000,
	BODY_GYRO_P = 1000,
	BODY_POSITION_P = 1000,

	-- Game states
	GAME_STATES = {
		ROUND = "Round",
		PREPARE = "Prepare",
		TIME_OUT = "TimeOut",
		FINAL = "Final",
		INTERMISSION = "Intermission",
	},

	-- Input keys
	INPUT_KEYS = {
		SPRINT = Enum.KeyCode.LeftShift,
	},
}

return Constants
