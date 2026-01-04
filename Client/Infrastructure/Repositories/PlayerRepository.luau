local Players = game:GetService("Players")
--- ClientPlayerRepository - Client-side player data management and caching
---
--- This repository manages the local player's entity on the client side,
--- providing access to player data and handling updates from the server.
--- It serves as the client-side counterpart to the server PlayerRepository.
---
--- Key Features:
--- - Singleton player entity management for the local player
--- - Jetpack equipment tracking and updates
--- - Player data synchronization from server updates
--- - Character and entity data access methods
---
--- Data Flow:
--- - Creates player entity on initialization using LocalPlayer
--- - Receives data updates from server via PlayerService
--- - Provides read/write access to player state and equipment
---
--- @class ClientPlayerRepository
--- @field diContainer DIContainer Dependency injection container for resolving other services
--- @field player Player The Roblox LocalPlayer instance
--- @field playerEntity PlayerEntity The local player's entity instance
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
	self.playerEntity = shared.Domain.Entities.Player.new(self.player, {})
end

---@return PlayerEntity
function PlayerRepository:getPlayerEntity()
	return self.playerEntity
end

---@param jetpack JetpackEntity
function PlayerRepository:updateJetpack(jetpack)
	self.playerEntity:equipJetpack(jetpack)
end

---@param data table<string, any>
function PlayerRepository:updateEntity(data)
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	local playerEntity = shared.Domain.Entities.Player.new(self.player, data)
	self.playerEntity = playerEntity
end

return PlayerRepository
