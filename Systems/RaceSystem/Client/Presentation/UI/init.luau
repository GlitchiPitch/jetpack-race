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

	-- Initialize RaceUI
	local RaceUI = require(script.Race.RaceUI)
	self.raceUI = RaceUI.new(self.diContainer)
	logger:debug("RaceSystemClientUI", "RaceUI initialized")

	logger:debug("RaceSystemClientUI", "Client UI initialization completed")
end

return UI
