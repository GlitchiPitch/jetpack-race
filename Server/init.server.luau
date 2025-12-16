local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = require(ReplicatedStorage.JetpackRace)

local FlyingSystemServer = require(script.Systems.FlyingSystem)
local PetSystemServer = require(script.Systems.PetSystem)
local LiveLeaderboardSystemServer = require(script.Systems.LiveLeaderboardSystem)
local RewardsSystemServer = require(script.Systems.RewardsSystem)
local ShopSystemServer = require(script.Systems.ShopSystem)
local RaceSystemServer = require(script.Systems.RaceSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class Server
---@field shared Shared
---@field infrastructure ServerInfrastructure
---@field application ServerApplication
---@field flyingSystemServer FlyingSystemServer
---@field petSystemServer PetSystemServer
---@field liveLeaderboardSystemServer LiveLeaderboardSystemServer
---@field rewardsSystemServer RewardsSystemServer
---@field raceSystemServer RaceSystemServer
local Server = {}
Server.__index = Server

---@return Server
function Server.new()
	local self = setmetatable({}, Server)
	self.shared = Shared.new()
	self.infrastructure = ServerInfrastructure.new(self.shared.Infrastructure.DIContainer)
	self.application = ServerApplication.new(self.shared.Infrastructure.DIContainer)

	self.flyingSystemServer = FlyingSystemServer.new(self.shared.Infrastructure.IoCContainer)
	self.petSystemServer = PetSystemServer.new(self.shared.Infrastructure.IoCContainer)
	self.liveLeaderboardSystemServer = LiveLeaderboardSystemServer.new(self.shared.Infrastructure.IoCContainer)
	self.rewardsSystemServer = RewardsSystemServer.new(self.shared.Infrastructure.IoCContainer)
	self.shopSystemServer = ShopSystemServer.new(self.shared.Infrastructure.IoCContainer)
	self.raceSystemServer = RaceSystemServer.new(self.shared.Infrastructure.IoCContainer)
	return self
end

function Server:init()
	self.shared.Infrastructure.IoCContainer:singleton("Logger", function()
		return self.shared.Infrastructure.DIContainer:resolve("Logger")
	end)

	self.shared.Infrastructure.IoCContainer:singleton("RemoteEventService", function()
		return self.shared.Infrastructure.DIContainer:resolve("RemoteEventService")
	end)

	self.shared.Infrastructure.IoCContainer:singleton("PlayerRepository", function()
		return self.shared.Infrastructure.DIContainer:resolve("PlayerRepository")
	end)
	
	self.shared.Infrastructure.IoCContainer:singleton("JetpackService", function()
		---@type FlyingSystemServerServices
		local flyingServices =
			self.flyingSystemServer.shared.Infrastructure.DIContainer:resolve("Server.Application.Services")
		return flyingServices.jetpackService
	end)

	self.flyingSystemServer:init()
	self.petSystemServer:init()
	self.liveLeaderboardSystemServer:init()
	self.rewardsSystemServer:init()
	self.raceSystemServer:init()

	---@type ServerApplicationServices
	local applicationServices = self.infrastructure.diContainer:resolve("Server.Application.Services")
	---@type PlayerService
	local playerService = applicationServices.playerService

	Players.PlayerAdded:Connect(function(player)
		local logger = self.shared.Infrastructure.DIContainer:resolve("Logger")
		logger:info("Server", "Player joined the game:", player.Name, "(ID:", player.UserId, ")")

		playerService:onPlayerAdded(player)
		self.flyingSystemServer:onPlayerAdded(player)
		self.petSystemServer:onPlayerAdded(player)
		self.rewardsSystemServer:onPlayerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		playerService:onPlayerRemoving(player)
		self.petSystemServer:onPlayerRemoving(player)
		self.rewardsSystemServer:onPlayerRemoving(player)
	end)

	ReplicatedStorage:SetAttribute(self.shared.Constants.SERVER_IS_LOADED, true)
end

local server = Server.new()
server:init()
