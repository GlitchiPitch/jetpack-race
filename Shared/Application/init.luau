local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
    
---@class SharedApplication
---@field commands SharedCommands
---@field useCases SharedUseCases
---@field services SharedServices
---@field config SharedConfig
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@param config SharedConfig
---@return SharedApplication
function Application.new(diContainer, config)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
    self.config = config
	self.commands = Commands.new()
	self.useCases = UseCases.new()
	self.services = Services.new(self.diContainer, self.config)
	self:_register()
	return self
end

function Application:_register()
	self.diContainer:singleton("Shared.Application.Commands", function()
		return self.commands
	end)
	self.diContainer:singleton("Shared.Application.UseCases", function()
		return self.useCases
	end)
	self.diContainer:singleton("Shared.Application.Services", function()
		return self.services
	end)
    self.diContainer:singleton("Shared.Application.Constants", function()
		return self.constants
	end)
end

function Application:init()
	
end

return Application
