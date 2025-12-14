local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = require(ReplicatedStorage.JetpackRace.Systems.LiveLeaderboardSystem)

local Presentation = require(script.Presentation)
local Application = require(script.Application)

---@class ShopClient
---@field shared Shared
---@field application LiveLeaderboardSystemClientApplication
---@field presentation LiveLeaderboardSystemClientPresentation	
---@field iocContainer DIContainer
local Client = {}
Client.__index = Client

---@return ShopClient
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
	logger:info("LiveLeaderboardSystemClient", "Initializing LiveLeaderboardSystem client...")

	self.application:init()
	self.presentation:init()

end

return Client