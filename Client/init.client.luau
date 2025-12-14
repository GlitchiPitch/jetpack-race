local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

local PetSystemClient = require(script.Systems.PetSystem)
local FlyingSystemClient = require(script.Systems.FlyingSystem)
local LiveLeaderboardSystemClient = require(script.Systems.LiveLeaderboardSystem)

---@class Client
---@field shared Shared
---@field application ClientApplication
---@field presentation ClientPresentation
---@field petSystemClient PetSystemClient
---@field flyingSystemClient FlyingSystemClient
---@field liveLeaderboardSystemClient LiveLeaderboardSystemClient
local Client = {}
Client.__index = Client

---@return Client
function Client.new()
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	self.petSystemClient = PetSystemClient.new(self.shared.Infrastructure.DIContainer)
	self.flyingSystemClient = FlyingSystemClient.new(self.shared.Infrastructure.DIContainer)
	self.liveLeaderboardSystemClient = LiveLeaderboardSystemClient.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Client:init()
	self.application:init()
	self.presentation:init()
end

local client = Client.new()
print(client)
if ReplicatedStorage:GetAttribute(client.shared.Constants.SERVER_IS_LOADED) then
	client:init()
else
	ReplicatedStorage:GetAttributeChangedSignal(client.shared.Constants.SERVER_IS_LOADED):Connect(function()
		client:init()
	end)
end
