---@class ServerJetpackService
---@field diContainer DIContainer
local JetpackService = {}
JetpackService.__index = JetpackService

---@param diContainer DIContainer
---@return ServerJetpackService
function JetpackService.new(diContainer)
	local self = setmetatable({}, JetpackService)
	self.diContainer = diContainer
	return self
end

---@param playerEntity PlayerEntity
function JetpackService:equipJetpack(playerEntity)
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	local jetpack = self:_getPlayerJetpack(playerEntity)
	playerEntity:equipJetpack(jetpack)
	playerEntity._state = shared.Constants.PLAYER_STATES.JETPACK_EQUIPPED
end

---@param playerEntity PlayerEntity
function JetpackService:unequipJetpack(playerEntity)
	---@type Shared
	local shared = self.diContainer:resolve("Shared")

	playerEntity:unequipJetpack()
	playerEntity._state = shared.Constants.PLAYER_STATES.IDLE
end

---@param playerEntity PlayerEntity
---@return JetpackEntity
function JetpackService:_getPlayerJetpack(playerEntity)
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	local jetpackAsset = shared.Assets.Jetpack[playerEntity.equippedJetpack] or shared.Assets.Jetpack.Default
	local jetpack = shared.Domain.Entities.Jetpack.new(jetpackAsset)
	return jetpack
end

return JetpackService
