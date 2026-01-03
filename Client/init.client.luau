local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.Shared)

local Presentation = require(script.Presentation)
local Application = require(script.Application)
local Infrastructure = require(script.Infrastructure)

---@class ShopClient
---@field application ClientApplication
---@field presentation Presentation
---@field shared Shared
---@field infrastructure ClientInfrastructure
local Client = {}
Client.__index = Client

---@return ShopClient
function Client.new()
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	self.infrastructure = Infrastructure.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Client:init()
	self.application:init()
	self.presentation:init()

	task.wait(4)

	self.application.services.raceService:activateTrigger()
end

local client = Client.new()

if ReplicatedStorage:GetAttribute(client.shared.Constants.SERVER_INITIALIZED) then
	client:init()
else
	ReplicatedStorage:GetAttributeChangedSignal(client.shared.Constants.SERVER_INITIALIZED):Connect(function()
		client:init()
	end)
end
