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
	local logger = self.iocContainer:resolve("Logger")
	logger:info("PetSystemClient", "Initializing PetSystem client...")

	self.application:init()
	self.presentation:init()

	logger:info("PetSystemClient", "PetSystem client initialized successfully")
end

return Client