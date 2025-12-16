local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.JetpackRace.Systems.RaceSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class RaceSystemServer
---@field shared Shared
---@field infrastructure RaceSystemServerInfrastructure
---@field application RaceSystemServerApplication
local Server = {}
Server.__index = Server

---@return RaceSystemServer
---@param iocContainer DIContainer
function Server.new(iocContainer)
	local self = setmetatable({}, Server)
	self.shared = Shared.new()
	self.iocContainer = iocContainer
	self.infrastructure = ServerInfrastructure.new(self.shared.Infrastructure.DIContainer)
	self.application = ServerApplication.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Server:init()
	---@type LoggerService
	self.logger = self.iocContainer:resolve("Logger")
	---@type RemoteEventService
	self.remoteEventService = self.iocContainer:resolve("RemoteEventService")
	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.logger
	end)

	
	self.shared.Infrastructure.DIContainer:singleton("RemoteEventService", function()
		return self.remoteEventService
	end)


	self.logger:info("RaceSystemServer", "Initializing RaceSystem server...")
	self.logger:debug("RaceSystemServer", "Setting up DI container and shared infrastructure")

	-- Initialize infrastructure first
	self.logger:debug("RaceSystemServer", "Initializing server infrastructure...")
	self.infrastructure:init()
	self.logger:debug("RaceSystemServer", "Server infrastructure initialized")

	-- Initialize application layer
	self.logger:debug("RaceSystemServer", "Initializing server application...")
	self.application:init()
	self.logger:debug("RaceSystemServer", "Server application initialized")

	self.logger:info("RaceSystemServer", "RaceSystem server initialized successfully")
end

function Server:onPlayerAdded(player)
	self.logger:info("RaceSystemServer", "Player added to rewards system:", player.Name, "(ID:", player.UserId, ")")

	---@type RaceSystemServerApplicationServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type RaceSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerAdded(player)
end

function Server:onPlayerRemoving(player)
	---@type RaceSystemServerApplicationServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type RaceSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerRemoving(player)
end

return Server
