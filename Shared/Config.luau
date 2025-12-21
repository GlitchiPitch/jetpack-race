---@class SharedConfig
local Config = {
    -- Game version and compatibility
    GAME_VERSION = "1.0.0",
    MIN_CLIENT_VERSION = "1.0.0",

    -- Server settings
    MAX_PLAYERS = 50,
    SERVER_TICK_RATE = 30,

    -- Player settings
    DEFAULT_STARTING_COINS = 1000,
    DEFAULT_STARTING_GEMS = 10,
    MAX_PLAYER_LEVEL = 100,

    -- Race system settings
    RACE_SETTINGS = {
        PREPARATION_TIME = 3, -- seconds before race starts
        COOLDOWN_TIME = 1, -- seconds before allowing forward movement
        MAX_RACE_TIME = 300, -- 5 minutes max race time
        SCORE_PER_SECOND = 10, -- points earned per second in race
        BOOST_MULTIPLIER = 2, -- score multiplier when using boosts
    },

    -- Boost settings
    BOOST_SETTINGS = {
        SPAWN_INTERVAL_MIN = 5, -- minimum seconds between spawns
        SPAWN_INTERVAL_MAX = 8, -- maximum seconds between spawns
        DEFAULT_DURATION = 20, -- default boost lifetime in seconds
        WAYPOINT_SPACING = 2, -- spawn every Nth waypoint
        SPEED_BOOST_AMOUNT = 1.5, -- speed multiplier
        FLYING_BOOST_AMOUNT = 2.0, -- flying speed multiplier
    },

    -- Pet system settings
    PET_SETTINGS = {
        MAX_EQUIPPED_PETS = 1,
        EXPERIENCE_PER_LEVEL = 100,
        MAX_PET_LEVEL = 50,
        PET_STATS_MULTIPLIER = 1.1, -- stat increase per level
        PET_EVOLUTION_THRESHOLD = 25, -- level to evolve
    },

    -- Reward system settings
    REWARD_SETTINGS = {
        DAILY_REWARD_CYCLE = 7, -- days
        DAILY_REWARD_BASE_AMOUNT = 10, -- base coins per day
        DAILY_REWARD_MULTIPLIER = 2, -- multiplier for higher days
        MAX_DAILY_STREAK = 30, -- maximum streak days
        ACHIEVEMENT_REWARD_MULTIPLIER = 5, -- coins per achievement point
        STREAK_BONUS_MULTIPLIER = 1.5, -- bonus for maintaining streaks
    },

    -- Leaderboard settings
    LEADERBOARD_SETTINGS = {
        MAX_LEADERBOARD_SIZE = 100,
        UPDATE_INTERVAL = 60, -- seconds between leaderboard updates
        SCORE_DECAY_RATE = 0.95, -- daily score decay multiplier
        MIN_ACTIVITY_DAYS = 7, -- days of inactivity before score decay
        RANK_REFRESH_INTERVAL = 300, -- 5 minutes between rank calculations
    },

    -- Shop settings
    SHOP_SETTINGS = {
        MAX_ITEMS_PER_PLAYER = 100,
        PRICE_GEM_MULTIPLIER = 10, -- gems worth 10x coins
        LIMITED_STOCK_REFRESH_TIME = 86400, -- 24 hours
        DISCOUNT_COOLDOWN = 3600, -- 1 hour between discounts
    },

    -- Flying system settings
    FLYING_SETTINGS = {
        BASE_FLYING_SPEED = 50,
        MAX_FLYING_SPEED = 200,
        ACCELERATION_RATE = 10,
        DECELERATION_RATE = 5,
        BOOST_DURATION = 15,
        COOLDOWN_DURATION = 30,
    },

    -- UI settings
    UI_SETTINGS = {
        LEADERBOARD_UPDATE_RATE = 5, -- seconds
        NOTIFICATION_DURATION = 3, -- seconds
        ANIMATION_SPEED = 0.3, -- seconds
        MAX_VISIBLE_LEADERBOARD_ENTRIES = 10,
    },

    -- Data persistence settings
    DATA_SETTINGS = {
        AUTO_SAVE_INTERVAL = 60, -- seconds
        MAX_BACKUP_FILES = 5,
        COMPRESSION_ENABLED = true,
        ENCRYPTION_ENABLED = false,
    },

    -- Network settings
    NETWORK_SETTINGS = {
        REMOTE_EVENT_TIMEOUT = 10, -- seconds
        MAX_REMOTE_CALLS_PER_SECOND = 20,
        COMPRESSION_THRESHOLD = 1024, -- bytes
    },

    -- Debug settings (should be false in production)
    DEBUG_SETTINGS = {
        ENABLE_LOGGING = true,
        SHOW_DEBUG_UI = false,
        LOG_LEVEL = "info", -- "debug", "info", "warn", "error"
        PERFORMANCE_MONITORING = true,
    },
}

return Config
