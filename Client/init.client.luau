local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

local PetSystemClient = require(script.Systems.PetSystem)
local FlyingSystemClient = require(script.Systems.FlyingSystem)
local LiveLeaderboardSystemClient = require(script.Systems.LiveLeaderboardSystem)
local RewardsSystemClient = require(script.Systems.RewardsSystem)
local ShopSystemClient = require(script.Systems.ShopSystem)
local RaceSystemClient = require(script.Systems.RaceSystem)

---@class Client
---@field shared Shared
---@field application ClientApplication
---@field presentation Presentation
---@field petSystemClient PetSystemClient
---@field flyingSystemClient FlyingSystemClient
---@field liveLeaderboardSystemClient LiveLeaderboardSystemClient
---@field rewardsSystemClient RewardsSystemClient
---@field raceSystemClient RaceSystemClient
---@field shopSystemClient ShopSystemClient
local Client = {}
Client.__index = Client

---@return Client
function Client.new()
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	warn("Application created")
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	warn("Presentation created")

	self.petSystemClient = PetSystemClient.new(self.shared.Infrastructure.IoCContainer)
	self.flyingSystemClient = FlyingSystemClient.new(self.shared.Infrastructure.IoCContainer)
	self.liveLeaderboardSystemClient = LiveLeaderboardSystemClient.new(self.shared.Infrastructure.IoCContainer)
	self.rewardsSystemClient = RewardsSystemClient.new(self.shared.Infrastructure.IoCContainer)
	self.shopSystemClient = ShopSystemClient.new(self.shared.Infrastructure.IoCContainer)
	self.raceSystemClient = RaceSystemClient.new(self.shared.Infrastructure.IoCContainer)

	warn("Client created")
	return self
end

function Client:init()
	self.shared.Infrastructure.IoCContainer:singleton("RaceSystemConstants", function()
		return self.raceSystemClient.shared.Infrastructure.DIContainer:resolve("Shared.Constants")
	end)

	self.shared.Infrastructure.IoCContainer:singleton("Logger", function()
		return self.shared.Infrastructure.DIContainer:resolve("Logger")
	end)

	self.shared.Infrastructure.IoCContainer:singleton("RemoteEventService", function()
		return self.shared.Infrastructure.DIContainer:resolve("RemoteEventService")
	end)

	self.shared.Infrastructure.IoCContainer:singleton("Entities", function()
		return self.shared.Infrastructure.DIContainer:resolve("Entities")
	end)

	self.shared.Infrastructure.IoCContainer:singleton("FlyingRepository", function()
		local flyingRepository = self.flyingSystemClient.shared.Infrastructure.DIContainer:resolve("FlyingRepository")
		return flyingRepository
	end)

	self.shared.Infrastructure.IoCContainer:singleton("UIComponents", function()
		return self.presentation.ui.components
	end)
	self.petSystemClient:init()
	self.flyingSystemClient:init()
	self.liveLeaderboardSystemClient:init()
	self.rewardsSystemClient:init()
	self.shopSystemClient:init()
	self.raceSystemClient:init()

	self.application:init()
	warn("Application initialized")
	self.presentation:init()
	warn("Presentation initialized")

	warn("Client initialized")
end

local client = Client.new()

if ReplicatedStorage:GetAttribute(client.shared.Constants.SERVER_IS_LOADED) then
	client:init()
else
	ReplicatedStorage:GetAttributeChangedSignal(client.shared.Constants.SERVER_IS_LOADED):Connect(function()
		client:init()
	end)
end
