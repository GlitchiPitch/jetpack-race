local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace.Systems.FlyingSystem)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

---@class FlyingSystemClient
local Client = {}
Client.__index = Client

---@return FlyingSystemClient
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
	logger:info("FlyingSystemClient", "Initializing FlyingSystem client...")

	self.application:init()
	self.presentation:init()

end

return Client
