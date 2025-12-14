---@class RewardsSystemClientUI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return RewardsSystemClientUI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer

	return self
end

function UI:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RewardsSystemClientUI", "Creating client UI...")

	logger:debug("RewardsSystemClientUI", "Initializing client UI...")

	-- TODO: Add UI initialization logic here
	logger:debug("RewardsSystemClientUI", "Client UI initialization completed (no UI elements to initialize yet)")
end

return UI
