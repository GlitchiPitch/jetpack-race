local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

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

    Players.PlayerAdded:Connect(function(player)
        self.application.services.playerService:onPlayerAdded(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        self.application.services.playerService:onPlayerRemoving(player)
    end)
end

return Server