local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

local PetSystemClient = require(script.Systems.PetSystem)
local FlyingSystemClient = require(script.Systems.FlyingSystem)
local LiveLeaderboardSystemClient = require(script.Systems.LiveLeaderboardSystem)

---@class Client
local Client = {}
Client.__index = Client

---@return Client
function Client.new()
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	self.petSystemClient = PetSystemClient.new()
	self.flyingSystemClient = FlyingSystemClient.new()
	self.liveLeaderboardSystemClient = LiveLeaderboardSystemClient.new()
	return self
end

function Client:init()
	self.application:init()
	self.presentation:init()
end

local client = Client.new()
client:init()
