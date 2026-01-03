local RaceService = require(script.RaceService)
local JetpackService = require(script.JetpackService)
local PlayerService = require(script.PlayerService)
local CameraService = require(script.CameraService)
local AnimationService = require(script.AnimationService)
local CheckpointService = require(script.CheckpointService)

---@class ClientApplicationServices
---@field diContainer DIContainer
---@field raceService ClientApplicationRaceService
---@field playerService ClientPlayerService
---@field jetpackService ClientJetpackService
---@field cameraService CameraService
---@field animationService AnimationService
---@field checkpointService ClientCheckpointService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return ClientApplicationServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.raceService = RaceService.new(diContainer)
	self.playerService = PlayerService.new(diContainer)
	self.jetpackService = JetpackService.new(diContainer)
	self.cameraService = CameraService.new(diContainer)
	self.animationService = AnimationService.new(diContainer)
	self.checkpointService = CheckpointService.new(diContainer)
	return self
end

return Services
