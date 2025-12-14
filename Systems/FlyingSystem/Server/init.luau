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
	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.logger
	end)

	self.logger:info("FlyingSystemServer", "Initializing FlyingSystem server...")

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

return Server
