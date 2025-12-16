local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace.Systems.PetSystem)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

---@class PetSystemClient
---@field shared Shared
---@field application PetSystemClientApplication
---@field presentation PetSystemClientPresentation
local Client = {}
Client.__index = Client

---@return PetSystemClient
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
	self.remoteEventService = self.iocContainer:resolve("RemoteEventService")
	self.shared.Infrastructure.DIContainer:singleton("Logger", function()
		return self.logger
	end)

	
	self.shared.Infrastructure.DIContainer:singleton("RemoteEventService", function()
		return self.remoteEventService
	end)

	self.logger:info("PetSystemClient", "Initializing PetSystem client...")

	self.application:init()
	self.presentation:init()

	self.logger:info("PetSystemClient", "PetSystem client initialized successfully")
end

return Client