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
	warn("Client: Starting initialization...")

	-- Register cross-system dependencies
	local success, errorMsg = pcall(function()
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
	end)

	if not success then
		warn("Client: Failed to register dependencies:", errorMsg)
		return
	end

	-- Initialize systems with error handling
	local systems = {
		{ name = "PetSystem", init = function() self.petSystemClient:init() end },
		{ name = "FlyingSystem", init = function() self.flyingSystemClient:init() end },
		{ name = "LiveLeaderboardSystem", init = function() self.liveLeaderboardSystemClient:init() end },
		{ name = "RewardsSystem", init = function() self.rewardsSystemClient:init() end },
		{ name = "ShopSystem", init = function() self.shopSystemClient:init() end },
		{ name = "RaceSystem", init = function() self.raceSystemClient:init() end },
	}

	for _, system in ipairs(systems) do
		local ok, err = pcall(system.init)
		if ok then
			warn("Client: " .. system.name .. " initialized successfully")
		else
			warn("Client: Failed to initialize " .. system.name .. ":", err)
		end
	end

	-- Initialize core application
	local ok, err = pcall(function()
		self.application:init()
		warn("Client: Application initialized")
		self.presentation:init()
		warn("Client: Presentation initialized")
	end)

	if not ok then
		warn("Client: Failed to initialize core systems:", err)
		return
	end

	warn("Client: Initialization completed successfully")
end

local client = Client.new()

-- Optional: Wait for server confirmation and perform any post-init setup
local function onServerLoaded()
	warn("Client: Server loaded confirmation received")
	-- Initialize client immediately - systems should handle server availability gracefully
	client:init()
	-- Any additional setup that requires server to be ready
end

if ReplicatedStorage:GetAttribute(client.shared.Constants.SERVER_IS_LOADED) then
	onServerLoaded()
else
	ReplicatedStorage:GetAttributeChangedSignal(client.shared.Constants.SERVER_IS_LOADED):Connect(onServerLoaded)
end
