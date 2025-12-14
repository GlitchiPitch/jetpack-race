local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

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