local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.JetpackRace.Systems.RewardsSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class RewardsSystemServer
---@field shared Shared
---@field infrastructure RewardsSystemServerInfrastructure
---@field application RewardsSystemServerApplication
local Server = {}
Server.__index = Server

---@return RewardsSystemServer
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


	self.logger:info("RewardsSystemServer", "Initializing RewardsSystem server...")
	self.logger:debug("RewardsSystemServer", "Setting up DI container and shared infrastructure")

	-- Initialize infrastructure first
	self.logger:debug("RewardsSystemServer", "Initializing server infrastructure...")
	self.infrastructure:init()
	self.logger:debug("RewardsSystemServer", "Server infrastructure initialized")

	-- Initialize application layer
	self.logger:debug("RewardsSystemServer", "Initializing server application...")
	self.application:init()
	self.logger:debug("RewardsSystemServer", "Server application initialized")

	self.logger:info("RewardsSystemServer", "RewardsSystem server initialized successfully")
end

function Server:onPlayerAdded(player)
	self.logger:info("RewardsSystemServer", "Player added to rewards system:", player.Name, "(ID:", player.UserId, ")")

	---@type RewardsSystemServerApplicationServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type RewardsSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerAdded(player)
end

function Server:onPlayerRemoving(player)
	---@type RewardsSystemServerApplicationServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type RewardsSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerRemoving(player)
end

return Server
