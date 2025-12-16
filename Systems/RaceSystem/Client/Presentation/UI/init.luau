---@class RaceSystemClientUI
local UI = {}
UI.__index = UI

---@param diContainer DIContainer
---@return RaceSystemClientUI
function UI.new(diContainer)
	local self = setmetatable({}, UI)
	self.diContainer = diContainer

	return self
end

function UI:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RaceSystemClientUI", "Creating client UI...")

	logger:debug("RaceSystemClientUI", "Initializing client UI...")

	-- TODO: Add UI initialization logic here
	logger:debug("RaceSystemClientUI", "Client UI initialization completed (no UI elements to initialize yet)")
end

return UI
