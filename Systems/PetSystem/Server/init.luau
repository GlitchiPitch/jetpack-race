local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.JetpackRace.Systems.PetSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class PetSystemServer
---@field shared Shared
---@field infrastructure PetSystemServerInfrastructure
---@field application PetSystemServerApplication
local Server = {}
Server.__index = Server

---@return PetSystemServer
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

	self.logger:info("PetSystemServer", "Initializing PetSystem server...")
end

function Server:onPlayerAdded(player)
	self.logger:info("PetSystemServer", "Player added to pet system:", player.Name, "(ID:", player.UserId, ")")

	---@type PetSystemServerApplicationServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type PetSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerAdded(player)
end

function Server:onPlayerRemoving(player)
	---@type PetSystemServerApplicationServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type PetSystemServerPlayerService
	local playerService = applicationServices.playerService
	playerService:onPlayerRemoving(player)
end

return Server
