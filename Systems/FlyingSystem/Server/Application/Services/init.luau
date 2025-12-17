local PlayerService = require(script.PlayerService)
local JetpackService = require(script.JetpackService)
local MovementService = require(script.MovementService)
local PositionValidator = require(script.PositionValidator)

---@class FlyingSystemServerServices
---@field playerService FlyingSystemServerPlayerService
---@field jetpackService FlyingSystemServerJetpackService
---@field movementService FlyingSystemServerMovementService
---@field positionValidator FlyingSystemServerPositionValidator
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return FlyingSystemServerServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
	self.playerService = PlayerService.new(self.diContainer)
	self.jetpackService = JetpackService.new(self.diContainer)
	self.movementService = MovementService.new(self.diContainer)
	self.positionValidator = PositionValidator.new(self.diContainer)
	return self
end

function Services:init()
	self.playerService:init()
end

return Services
