---@class PetSystemServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return PetSystemServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:init()
	---@type PetSystemEntities
	local entities = self.diContainer:resolve("Entities")
	---@type PetSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	self.PlayerEntity = entities.Player
	self.playerRepository = playerRepository
end

function PlayerService:onPlayerAdded(player)
	self.playerRepository:getPlayerEntity(player)
end

function PlayerService:onPlayerRemoving(player)
	self.playerRepository:removePlayerEntity(player)
end

function PlayerService:updatePlayer(player)
    ---@type PetSystemPlayerEntity
	local playerEntity = self.playerRepository:getPlayerEntity(player)
    ---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
    ---@type PetSystemConstants
    local constants = self.diContainer:resolve("Shared.Constants")

    remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, {
        playerData = playerEntity:getData(),
    })
end

return PlayerService
