local Domain = require(script.Domain)
local Infrastructure = require(script.Infrastructure)
local Config = require(script.Config)
local Application = require(script.Application)
local Data = require(script.Data)
local Constants = require(script.Constants)
local Assets = require(script.Assets)

---@class Shared
---@field Domain Domain
---@field Infrastructure Infrastructure
---@field Config SharedConfig
---@field Constants SharedConstants
---@field Assets Assets
local Shared = {}
Shared.__index = Shared

---@return Shared
function Shared.new()
	local self = setmetatable({}, Shared)
	self.Data = Data
	self.Config = Config
	self.Constants = Constants
	self.Assets = Assets

	self.Domain = Domain.new()
	self.Infrastructure = Infrastructure.new()
	self.Application = Application.new(self.Infrastructure.DIContainer, self.Config)
	self:_register()

	self.Application:init()

	return self
end

function Shared:_register()
	self.Infrastructure.DIContainer:singleton("Shared", function()
		return self
	end)
end

return Shared
