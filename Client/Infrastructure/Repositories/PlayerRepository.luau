local Players = game:GetService("Players")
---@class ClientPlayerRepository
---@field diContainer DIContainer
---@field player Player
---@field playerEntity PlayerEntity
local PlayerRepository = {}
PlayerRepository.__index = PlayerRepository

---@param diContainer DIContainer
---@return ClientPlayerRepository
function PlayerRepository.new(diContainer)
	local self = setmetatable({}, PlayerRepository)
	self.diContainer = diContainer
	self.player = Players.LocalPlayer
	self:_setup()
	return self
end

function PlayerRepository:_setup()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	self.playerEntity = shared.Domain.Entities.Player.new(self.player)
end

---@return PlayerEntity
function PlayerRepository:getPlayerEntity()
	return self.playerEntity
end

function PlayerRepository:updateEntity()
	
end

return PlayerRepository
