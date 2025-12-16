local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
---@class RaceSystemServerApplication
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return RaceSystemServerApplication
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

function Application:init() end

return Application
