local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedEntities = require(ReplicatedStorage.JetpackRace.Domain.Entities)

---@class ShopSystemEntities
local Entities = {
	Player = SharedEntities.Player,
	FlyingEntity = require(script.FlyingEntity),
}

return Entities
