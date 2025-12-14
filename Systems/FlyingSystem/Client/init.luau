local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace.Systems.FlyingSystem)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

---@class FlyingSystemClient
local Client = {}
Client.__index = Client

---@return FlyingSystemClient
function Client.new()
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Client:init()
	self.application:init()
	self.presentation:init()
end

return Client
