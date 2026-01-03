local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = require(ReplicatedStorage.Shared)

local ServerInfrastructure = require(script.Infrastructure)
local ServerApplication = require(script.Application)

---@class Server
---@field shared Shared
---@field infrastructure ServerInfrastructure
---@field application ServerApplication
local Server = {}
Server.__index = Server

---@return Server
function Server.new()
	local self = setmetatable({}, Server)
	self.shared = Shared.new()
	self.infrastructure = ServerInfrastructure.new(self.shared.Infrastructure.DIContainer)
	self.application = ServerApplication.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Server:init()
	self.application:init()

	local function onPlayerAdded(player)
		self.application.services.playerService:onPlayerAdded(player)
	end

	local function onPlayerRemoving(player)
		self.application.services.playerService:onPlayerRemoving(player)
	end

	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)

    ReplicatedStorage:SetAttribute(self.shared.Constants.SERVER_INITIALIZED, true)
end

local server = Server.new()
server:init()
