local Domain = require(script.Domain)
local Infrastructure = require(script.Infrastructure)
local Config = require(script.Config)
local Application = require(script.Application)
local Data = require(script.Data)
local Constants = require(script.Constants)

---@class RaceSystemShared
---@field Domain RaceSystemDomain
---@field Infrastructure Infrastructure
---@field Config SharedConfig
---@field Application RaceSystemSharedApplication
local Shared = {}
Shared.__index = Shared

---@return RaceSystemShared
function Shared.new()
	local self = setmetatable({}, Shared)
	self.Data = Data
	self.Config = Config
	self.Constants = Constants
	self.Domain = Domain.new()
	self.Infrastructure = Infrastructure.new()
	self.Application = Application.new(self.Infrastructure.DIContainer, self.Config)
	self:_register()

	return self
end

function Shared:_register()
	self.Infrastructure.DIContainer:singleton("Entities", function()
		return self.Domain.Entities
	end)

	self.Infrastructure.DIContainer:singleton("Shared.Config", function()
		return self.Config
	end)

	self.Infrastructure.DIContainer:singleton("Shared.Application", function()
		return self.Application
	end)

	self.Infrastructure.DIContainer:singleton("Shared.Data", function()
		return self.Data
	end)

	self.Infrastructure.DIContainer:singleton("Shared.Assets", function()
		return self.Domain.Assets
	end)

	self.Infrastructure.DIContainer:singleton("Shared.Constants", function()
		return self.Constants
	end)
end

return Shared
