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
	local playerEntity = infrastructure.repositories.playerRepository:getPlayerEntity()
	return playerEntity.jetpack
end

---@return Model?
function PlayerService:getPlayerCharacter()
	---@type ClientInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	local playerEntity = infrastructure.repositories.playerRepository:getPlayerEntity()
	return playerEntity.player.Character
end

---@class playerData
---@field data table<string, any>
---@field jetpackAsset Accessory

---@param data playerData
function PlayerService:updatePlayerData(data)
warn(data)
	---@type ClientInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type Shared
	local shared = self.diContainer:resolve("Shared")

	local jetpack = shared.Domain.Entities.Jetpack.new(data.playerData)
	infrastructure.repositories.playerRepository:updateEntity(data.playerData, jetpack)
end

return PlayerService
