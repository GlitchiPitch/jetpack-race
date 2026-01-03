local UI = require(script.UI)
local Services = require(script.Services)

---@class Presentation
---@field diContainer DIContainer
---@field ui UI
---@field services ClientPresentationServices
local Presentation = {}
Presentation.__index = Presentation

---@param diContainer DIContainer
---@return Presentation
function Presentation.new(diContainer)
	local self = setmetatable({}, Presentation)
	self.diContainer = diContainer
	self.ui = UI.new(self.diContainer)
	self.services = Services.new(diContainer)
	self:_register()
	return self
end

function Presentation:_register()
	self.diContainer:singleton("Presentation", function()
		return self
	end)
end

function Presentation:init()
	self.ui:init()
	self.services:init()

	self:_connectToEvents()
end

function Presentation:_connectToEvents()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")

	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.FLYING_ACTIVATED,
		function(args)
			self.ui.mainUI:toggleJetpackUI(true)
		end
	)
end

return Presentation
