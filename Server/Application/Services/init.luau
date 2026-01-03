local PlayerService = require(script.PlayerService)
local RaceService = require(script.RaceService)
local JetpackService = require(script.JetpackService)
local FlyingService = require(script.FlyingService)
local CheckpointService = require(script.CheckpointService)
local BoostsService = require(script.BoostsService)
---@class ServerApplicationServices
---@field playerService ServerPlayerService
---@field raceService ServerRaceService
---@field jetpackService ServerJetpackService
---@field flyingService ServerFlyingService
---@field checkpointService ServerCheckpointService
---@field boostsService ServerBoostsService
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
	self.checkpointService = CheckpointService.new(diContainer)
	self.boostsService = BoostsService.new(diContainer)
	return self
end

return Services
