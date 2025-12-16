local Players = game:GetService("Players")
---@class FlyingSystemClientRepository
local FlyingRepostiory = {}
FlyingRepostiory.__index = FlyingRepostiory

---@param diContainer DIContainer
---@return FlyingSystemClientRepository
function FlyingRepostiory.new(diContainer)
	local self = setmetatable({}, FlyingRepostiory)
	self.diContainer = diContainer
	self.player = Players.LocalPlayer
	return self
end

---@return FlyingEntity
function FlyingRepostiory:getFlyingEntity()
	if self.playerEntity then
		return self.playerEntity
	end

	---@type Entities
	local mainEntities = self.diContainer:resolve("Main.Entities")
	---@type PlayerEntity
	local playerEntity = mainEntities.Player.new(self.player)
	---@type FlyingSystemEntities
	local entities = self.diContainer:resolve("Entities")
	---@type FlyingEntity
	local FlyingEntity = entities.FlyingEntity

	local flyingData = self.player:WaitForChild("FlyingData")
	self.playerEntity = FlyingEntity.new(playerEntity, flyingData)
	return self.playerEntity
end

return FlyingRepostiory
