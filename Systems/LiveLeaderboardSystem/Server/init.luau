local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.JetpackRace.Systems.LiveLeaderboardSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class LiveLeaderboardSystemServer
---@field shared Shared
---@field infrastructure LiveLeaderboardSystemServerInfrastructure
---@field application LiveLeaderboardSystemServerApplication
local Server = {}
Server.__index = Server

---@param iocContainer DIContainer
---@return LiveLeaderboardSystemServer
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

	self.logger:info("LiveLeaderboardSystemServer", "Initializing LiveLeaderboardSystem server...")

	self.logger:info("LiveLeaderboardSystemServer", "LiveLeaderboardSystem server initialized successfully")
end

function Server:onPlayerAdded(player)
	self.logger:info(
		"LiveLeaderboardSystemServer",
		"Player added to live leaderboard system:",
		player.Name,
		"(ID:",
		player.UserId,
		")"
	)

	self.application.services.playerService:onPlayerAdded(player)
end

function Server:onPlayerRemoving(player)
	self.application.services.playerService:onPlayerRemoving(player)
end

return Server
