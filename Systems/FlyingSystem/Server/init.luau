local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.JetpackRace.Systems.FlyingSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class FlyingSystemServer
---@field shared FlyingSystemShared
---@field infrastructure ServerInfrastructure
---@field application ServerApplication
local Server = {}
Server.__index = Server

---@return FlyingSystemServer
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
	---@type PlayerRepository
	self.playerRepository = self.iocContainer:resolve("PlayerRepository")

	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.logger
	end)

	self.shared.Infrastructure.DIContainer:singleton("PlayerRepository", function()
		return self.playerRepository
	end)
	
	self.shared.Infrastructure.DIContainer:singleton("RemoteEventService", function()
		return self.remoteEventService
	end)


	self.logger:info("FlyingSystemServer", "Initializing FlyingSystem server...")

	-- Подключение к remote событиям
	self.remoteEventService:connectToEvent("flying", function(player, cameraCFrame)
		self:onFlyingUpdate(player, cameraCFrame)
	end)

	self.remoteEventService:connectToEvent("sprint", function(player, isSprintActive)
		self:onSprintToggle(player, isSprintActive)
	end)

end

function Server:onPlayerAdded(player)
	self.logger:info("FlyingSystemServer", "Player added to flying system:", player.Name, "(ID:", player.UserId, ")")

	---@type FlyingSystemServerServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type FlyingSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerAdded(player)
end

function Server:onPlayerRemoving(player)
	---@type FlyingSystemServerServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type FlyingSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerRemoving(player)
end

function Server:onFlyingUpdate(player, cameraCFrame)
	self.logger:debug("FlyingSystemServer", "Received flying update from", player.Name, "camera:", cameraCFrame.Position)
	-- TODO: Обработать обновление камеры для полета
end

function Server:onSprintToggle(player, isSprintActive)
	self.logger:debug("FlyingSystemServer", "Sprint toggle from", player.Name, "active:", isSprintActive)

	---@type FlyingSystemServerServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type FlyingSystemServerPlayerService
	local playerService = applicationServices.playerService

	if isSprintActive then
		playerService:onSprintActivated(player)
	else
		playerService:onSprintDeactivated(player)
	end
end

return Server
