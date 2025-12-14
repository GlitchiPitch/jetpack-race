local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = require(ReplicatedStorage.JetpackRace)

local FlyingSystemServer = require(script.Systems.FlyingSystem)
local PetSystemServer = require(script.Systems.PetSystem)
local LiveLeaderboardSystemServer = require(script.Systems.LiveLeaderboardSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class Server
---@field shared Shared
---@field infrastructure ServerInfrastructure
---@field application ServerApplication
---@field flyingSystemServer FlyingSystemServer
---@field petSystemServer PetSystemServer
---@field liveLeaderboardSystemServer LiveLeaderboardSystemServer
local Server = {}
Server.__index = Server

---@return Server
function Server.new()
	local self = setmetatable({}, Server)
	self.shared = Shared.new()
	self.infrastructure = ServerInfrastructure.new(self.shared.Infrastructure.DIContainer)
	self.application = ServerApplication.new(self.shared.Infrastructure.DIContainer)
	self.flyingSystemServer = FlyingSystemServer.new(self.shared.Infrastructure.DIContainer)
	self.petSystemServer = PetSystemServer.new(self.shared.Infrastructure.DIContainer)
	self.liveLeaderboardSystemServer = LiveLeaderboardSystemServer.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Server:init()
	---@type ServerApplicationServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type PlayerService
	local playerService = applicationServices.playerService


	Players.PlayerAdded:Connect(function(player)
		playerService:onPlayerAdded(player)
		self.flyingSystemServer:onPlayerAdded(player)
		self.petSystemServer:onPlayerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		playerService:onPlayerRemoving(player)
		self.petSystemServer:onPlayerRemoving(player)
	end)

	ReplicatedStorage:SetAttribute(self.shared.Constants.SERVER_IS_LOADED, true)
end

local server = Server.new()
server:init()
