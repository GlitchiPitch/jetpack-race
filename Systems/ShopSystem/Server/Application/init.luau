local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
---@class ShopSystemServerApplication
---@field application ShopSystemSharedApplication
---@field diContainer DIContainer
---@field useCases ShopSystemServerUseCases
---@field commands ShopSystemServerCommands
---@field remoteEventService RemoteEventService
---@field services ShopSystemServerServices
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return ShopSystemServerApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
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
		return Services.new(c)
	end)
end

function Application:init()
	local services = self.diContainer:resolve("Server.Application.Services")
	services:init()
end


return Application
