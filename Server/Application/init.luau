local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
---@class ServerApplication
---@field application SharedApplication
---@field diContainer DIContainer
---@field constants SharedConstants
---@field useCases ServerUseCases
---@field commands ServerCommands
---@field remoteEventService RemoteEventService
---@field services ServerApplicationServices
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return ServerApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer

	self.commands = Commands
	self.useCases = UseCases
	self.services = Services
	self:_register()
	return self
end

function Application:_register()
	self.diContainer:singleton("Application", function()
		return self
	end)
end

function Application:init()
	self:_connectToEvents()
end

function Application:_connectToEvents()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	shared.Infrastructure.services.remoteEventService:connectToEvent(
		shared.Constants.REMOTE_EVENTS.RACE_TRIGGER_ACTIVATED,
		function(player, _)
			local playerEntity = self.services.playerService:getPlayerEntity(player)
			self.services.raceService:triggerActivated(playerEntity)
		end
	)
end

return Application
