local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace.Systems.RaceSystem)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

---@class RaceSystemClient
---@field shared Shared
---@field application RaceSystemClientApplication
---@field presentation RaceSystemClientPresentation
---@field iocContainer DIContainer
local Client = {}
Client.__index = Client

---@return RaceSystemClient
---@param iocContainer DIContainer
function Client.new(iocContainer)
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.iocContainer = iocContainer
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Client:init()
	self.logger = self.iocContainer:resolve("Logger")
	self.remoteEventService = self.iocContainer:resolve("RemoteEventService")
	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.logger
	end)

	
	self.shared.Infrastructure.DIContainer:singleton("RemoteEventService", function()
		return self.remoteEventService
	end)

	self.logger:info("RaceSystemClient", "Initializing RaceSystem client...")

	self.logger:debug("RaceSystemClient", "Setting up DI container and shared infrastructure")

	-- Initialize application layer
	self.logger:debug("RaceSystemClient", "Initializing client application...")
	self.application:init()
	self.logger:debug("RaceSystemClient", "Client application initialized")

	-- Initialize presentation layer
	self.logger:debug("RaceSystemClient", "Initializing client presentation...")
	self.presentation:init()
	self.logger:debug("RaceSystemClient", "Client presentation initialized")

	self.logger:info("RaceSystemClient", "RaceSystem client initialized successfully")
end

return Client