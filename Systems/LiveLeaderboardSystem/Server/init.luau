local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = require(ReplicatedStorage.JetpackRace.Systems.LiveLeaderboardSystem)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class LiveLeaderboardSystemServerServer
---@field shared Shared
---@field infrastructure LiveLeaderboardSystemServerInfrastructure
---@field application LiveLeaderboardSystemServerApplication
local Server = {}
Server.__index = Server

---@return LiveLeaderboardSystemServerServer
function Server.new()
    local self = setmetatable({}, Server)
    self.shared = Shared.new()
    self.infrastructure = ServerInfrastructure.new(self.shared.Infrastructure.DIContainer)
    self.application = ServerApplication.new(self.shared.Infrastructure.DIContainer)
    return self
end

function Server:init()
    self.infrastructure:init()
    self.application:init()
end

function Server:onPlayerAdded(player)
    self.application.services.playerService:onPlayerAdded(player)
end

function Server:onPlayerRemoving(player)
    self.application.services.playerService:onPlayerRemoving(player)
end

return Server