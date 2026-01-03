local PlayerService = require(script.PlayerService)
local RaceService = require(script.RaceService)
local JetpackService = require(script.JetpackService)
local FlyingService = require(script.FlyingService)

---@class ServerApplicationServices
---@field playerService ServerPlayerService
---@field raceService ServerRaceService
---@field jetpackService ServerJetpackService
---@field flyingService ServerFlyingService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return ServerApplicationServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.playerService = PlayerService.new(self.diContainer)
	self.raceService = RaceService.new(self.diContainer)
	self.jetpackService = JetpackService.new(diContainer)
    self.flyingService = FlyingService.new(diContainer)
	return self
end

return Services
