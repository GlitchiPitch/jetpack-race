local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
local Constants = require(script.Constants)
    
---@class RewardsSystemSharedApplication
---@field commands RewardsSystemSharedCommands
---@field useCases RewardsSystemSharedUseCases
---@field services RewardsSystemSharedServices
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@param config SharedConfig
---@return RewardsSystemSharedApplication
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
end

return Application
