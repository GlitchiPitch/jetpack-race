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
	return playerEntity:getCharacter()
end

---@param data table<string, any>
function PlayerService:updatePlayerData(data)
	---@type ClientInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	infrastructure.repositories.playerRepository:updateEntity(data)
end

function PlayerService:disableDefaultControl()
	---@type ClientInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	local playerEntity = infrastructure.repositories.playerRepository:getPlayerEntity()
	playerEntity:disableDefaultControl()
end

return PlayerService
