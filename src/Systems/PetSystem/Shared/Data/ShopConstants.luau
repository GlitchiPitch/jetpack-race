---@alias ShopConstantsItemNames '"ITEM_NAME_1"' | '"ITEM_NAME_2"' | '"ITEM_NAME_3"'
---@alias ShopConstantsGamepasses '"GAMEPASS_NAME_1"' | '"GAMEPASS_NAME_2"'
---@alias ShopConstantsCoinsPurchaseBlackList '"COINS_PURCHASE_BLACK_LIST"'
---@alias ShopMode '"COINS"' | '"ROBUX"' | '"GIFT"'

---@class ShopConstants
local ShopConstants = {}

-- Item Names
ShopConstants.ITEMS = {
	ITEM_NAME_1 = {name = "item_name_1", displayName = "Item 1"},
	ITEM_NAME_2 = {name = "item_name_2", displayName = "Item 2"},
	ITEM_NAME_3 = {name = "item_name_3", displayName = "Item 3"},
}

ShopConstants.GAMEPASSES = {
	GAMEPASS_NAME_1 = {name = "gamepass_name_1", displayName = "Gamepass 1"},
	GAMEPASS_NAME_2 = {name = "gamepass_name_2", displayName = "Gamepass 2"},
}

ShopConstants.COINS_PURCHASE_BLACK_LIST = {
	ShopConstants.GAMEPASSES.GAMEPASS_NAME_1.name,
	ShopConstants.ITEMS.ITEM_NAME_1.name,
}

ShopConstants.UPDATED_ITEMS = {
	ShopConstants.GAMEPASSES.GAMEPASS_NAME_2.name,
}

ShopConstants.GIFT_BLACKLIST = {
	ShopConstants.ITEMS.ITEM_NAME_3.name,
}

-- UI Colors
ShopConstants.COLORS = {
	LOADING_BG = Color3.new(0, 0, 0),
	LOADING_TEXT = Color3.new(1, 1, 1),
	SELECTED_USER = Color3.new(0.968627, 1, 0.0980392),
	NOTIFICATION_SUCCESS = Color3.new(0, 1, 0),
	NOTIFICATION_NEUTRAL = Color3.new(1, 1, 1),
	NOTIFICATION_WARNING = Color3.new(1, 0.5, 0),
	NOTIFICATION_ERROR = Color3.new(1, 0.2, 0.2),
}

-- Purchase Types
ShopConstants.PURCHASE_TYPES = {
	PRODUCT = "Product",
	GAMEPASS = "Gamepass",
}

ShopConstants.SHOP_MODES = {
	COINS = "COINS",
	ROBUX = "ROBUX",
	GIFT = "GIFT",
}

-- Image Assets
ShopConstants.IMAGES = {
	ROBUX_ICON = "rbxassetid://80776786154551",
	COINS_ICON = "rbxassetid://113833840486362",
}

-- UI Sizes and Positions
ShopConstants.UI = {
	LOADING_INDICATOR_SIZE = UDim2.fromOffset(200, 30),
	LOADING_INDICATOR_POSITION = UDim2.new(0.5, -100, 0.95, -15),
	LOADING_INDICATOR_ANCHOR = Vector2.new(0.5, 0.5),
	GIFT_ICON_SIZE = UDim2.fromScale(0.3, 0.3),
	GIFT_ICON_POSITION = UDim2.fromScale(0.7, 0.1),
}

ShopConstants.REMOTE_EVENTS = {
	PLAYER_UPDATED = "PlayerUpdated",
	EXECUTE_GIFT = "ExecuteGift",
}

return ShopConstants
