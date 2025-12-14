local UI = require(script.UI)


---@class RewardsSystemClientPresentation
local Presentation = {}
Presentation.__index = Presentation

---@param diContainer DIContainer
---@return RewardsSystemClientPresentation
function Presentation.new(diContainer)
	local self = setmetatable({}, Presentation)
	self.diContainer = diContainer

	self.ui = UI.new(self.diContainer)

	return self
end

function Presentation:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RewardsSystemClientPresentation", "Creating client presentation...")
	logger:debug("RewardsSystemClientPresentation", "Client presentation UI created")

	logger:debug("RewardsSystemClientPresentation", "Initializing client presentation...")

	if self.ui.init then
		self.ui:init()
		logger:debug("RewardsSystemClientPresentation", "Client presentation UI initialized")
	end

	logger:debug("RewardsSystemClientPresentation", "Client presentation initialization completed")
end

return Presentation