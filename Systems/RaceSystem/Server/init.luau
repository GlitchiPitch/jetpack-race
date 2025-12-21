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

	---@type FlyingSystemServerJetpackService
	self.jetpackService = self.iocContainer:resolve("JetpackService")
	---@type FlyingRepository
	self.flyingRepository = self.iocContainer:resolve("FlyingRepository")

	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.logger
	end)

	self.shared.Infrastructure.DIContainer:singleton("JetpackService", function()
		return self.jetpackService
	end)

	self.shared.Infrastructure.DIContainer:singleton("FlyingRepository", function()
		return self.flyingRepository
	end)

	self.shared.Infrastructure.DIContainer:singleton("RemoteEventService", function()
		return self.remoteEventService
	end)

	self.infrastructure:init()
	self.application:init()
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
