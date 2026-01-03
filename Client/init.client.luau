local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.Shared)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

---@class ShopClient
local Client = {}
Client.__index = Client

---@return ShopClient
function Client.new()
	local self = setmetatable({}, Client)
	self.shared = Shared.new()
	self.application = Application.new(self.shared.Infrastructure.DIContainer)
	self.presentation = Presentation.new(self.shared.Infrastructure.DIContainer)
	return self
end

function Client:init()
	self.application:init()
	self.presentation:init()
end

local client = Client.new()

if ReplicatedStorage:GetAttribute(Shared.Constants.SERVER_INITIALIZED) then
	client:init()
else
	ReplicatedStorage:GetAttributeChangedSignal(Shared.Constants.SERVER_INITIALIZED):Connect(function()
		client:init()
	end)
end
