local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
local Constants = require(script.Constants)
    
---@class PetSystemSharedApplication
---@field commands PetSystemSharedCommands
---@field useCases PetSystemSharedUseCases
---@field services PetSystemSharedServices
---@field config PetSystemSharedConfig
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@param config SharedConfig
---@return PetSystemSharedApplication
function Application.new(diContainer, config)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
    self.config = config
    self.constants = Constants
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
    self.diContainer:singleton("Shared.Constants", function()
		return self.constants
	end)
end

function Application:init()
	self.commands = self.diContainer:resolve("Shared.Application.Commands")
	self.useCases = self.diContainer:resolve("Shared.Application.UseCases")
	self.services = self.diContainer:resolve("Shared.Application.Services")
	self.config = self.diContainer:resolve("Shared.Config")
end

return Application
