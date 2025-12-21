local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.JetpackRace.Systems.ShopSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class ShopSystemServer
---@field shared ShopSystemShared
---@field infrastructure ServerInfrastructure
---@field application ServerApplication
local Server = {}
Server.__index = Server

---@return ShopSystemServer
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
	---@type ShopSystemServerPlayerService
	self.playerService = self.iocContainer:resolve("PlayerService")

	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.logger
	end)

	self.shared.Infrastructure.DIContainer:singleton("PlayerService", function()
		return self.playerService
	end)

	self.shared.Infrastructure.DIContainer:singleton("RemoteEventService", function()
		return self.remoteEventService
	end)

	self.logger:info("ShopSystemServer", "Initializing ShopSystem server...")

	self.infrastructure:init()
	self.application:init()
end

function Server:onPlayerAdded(player)
	self.logger:info("ShopSystemServer", "Player added to flying system:", player.Name, "(ID:", player.UserId, ")")

	---@type ShopSystemServerServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type ShopSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerAdded(player)
end

function Server:onPlayerRemoving(player)
	---@type ShopSystemServerServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type ShopSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerRemoving(player)
end

return Server
