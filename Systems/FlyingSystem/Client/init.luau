local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace.Systems.FlyingSystem)

local Presentation = require(script.Presentation)
local Application = require(script.Application)
local Infrastructure = require(script.Infrastructure)

---@class FlyingSystemClient
---@field shared Shared
---@field iocContainer DIContainer
---@field application FlyingSystemClientApplication
---@field presentation FlyingSystemClientPresentation
local Client = {}
Client.__index = Client

---@return FlyingSystemClient
---@param iocContainer DIContainer
function Client.new(iocContainer)
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.iocContainer = iocContainer
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	self.infrastructure = Infrastructure.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Client:init()
	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.iocContainer:resolve("Logger")
	end)

	self.shared.Infrastructure.DIContainer:singleton("RaceSystemConstants", function()
		return self.iocContainer:resolve("RaceSystemConstants")
	end)

	self.shared.Infrastructure.DIContainer:singleton("Main.Entities", function()
		return self.iocContainer:resolve("Entities")
	end)

	self.shared.Infrastructure.DIContainer:singleton("RemoteEventService", function()
		return self.iocContainer:resolve("RemoteEventService")
	end)

	self.logger = self.iocContainer:resolve("Logger")
	self.logger:info("FlyingSystemClient", "Initializing FlyingSystem client...")

	self.application:init()
	self.presentation:init()
end

return Client
