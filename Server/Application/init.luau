local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
---@class ServerApplication
---@field application SharedApplication
---@field diContainer DIContainer
---@field useCases ServerUseCases
---@field commands ServerCommands
---@field remoteEventService RemoteEventService
---@field services ServerApplicationServices
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@param sharedIoCContainer DIContainer
---@return ServerApplication
function Application.new(diContainer, sharedIoCContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
	self.sharedIoCContainer = sharedIoCContainer
	self:_register()
	return self
end

function Application:_register()
	self.diContainer:singleton("Server.Application.Commands", function()
		return Commands.new()
	end)
	self.diContainer:singleton("Server.Application.UseCases", function()
		return UseCases.new()
	end)
	self.diContainer:singleton("Server.Application.Services", function(c)
		return Services.new(c, self.sharedIoCContainer)
	end)
end

return Application
