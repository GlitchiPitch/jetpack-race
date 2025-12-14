local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace.Systems.RewardsSystem)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

---@class RewardsSystemClient
---@field shared Shared
---@field application RewardsSystemClientApplication
---@field presentation RewardsSystemClientPresentation
---@field iocContainer DIContainer
local Client = {}
Client.__index = Client

---@return RewardsSystemClient
---@param iocContainer DIContainer
function Client.new(iocContainer)
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.iocContainer = iocContainer
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Client:init()
	self.logger = self.iocContainer:resolve("Logger")
	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.logger
	end)
	self.logger:info("RewardsSystemClient", "Initializing RewardsSystem client...")

	self.logger:debug("RewardsSystemClient", "Setting up DI container and shared infrastructure")

	-- Initialize application layer
	self.logger:debug("RewardsSystemClient", "Initializing client application...")
	self.application:init()
	self.logger:debug("RewardsSystemClient", "Client application initialized")

	-- Initialize presentation layer
	self.logger:debug("RewardsSystemClient", "Initializing client presentation...")
	self.presentation:init()
	self.logger:debug("RewardsSystemClient", "Client presentation initialized")

	self.logger:info("RewardsSystemClient", "RewardsSystem client initialized successfully")
end

return Client