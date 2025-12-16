local UI = require(script.UI)


---@class RaceSystemClientPresentation
local Presentation = {}
Presentation.__index = Presentation

---@param diContainer DIContainer
---@return RaceSystemClientPresentation
function Presentation.new(diContainer)
	local self = setmetatable({}, Presentation)
	self.diContainer = diContainer

	self.ui = UI.new(self.diContainer)

	return self
end

function Presentation:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RaceSystemClientPresentation", "Creating client presentation...")
	logger:debug("RaceSystemClientPresentation", "Client presentation UI created")

	logger:debug("RaceSystemClientPresentation", "Initializing client presentation...")

	if self.ui.init then
		self.ui:init()
		logger:debug("RaceSystemClientPresentation", "Client presentation UI initialized")
	end

	logger:debug("RaceSystemClientPresentation", "Client presentation initialization completed")
end

return Presentation