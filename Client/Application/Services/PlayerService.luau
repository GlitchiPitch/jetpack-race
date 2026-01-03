---@class ClientPlayerService
---@field diContainer DIContainer
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return ClientPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

---@return JetpackEntity?
function PlayerService:getPlayerJetpack()
	---@type ClientInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	local playerEntity = infrastructure.Repositories.PlayerRepository:getPlayerEntity()
	return playerEntity.jetpack
end

---@return Model?
function PlayerService:getPlayerCharacter()
	---@type ClientInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	local playerEntity = infrastructure.Repositories.PlayerRepository:getPlayerEntity()
	return playerEntity.player.Character
end

return PlayerService