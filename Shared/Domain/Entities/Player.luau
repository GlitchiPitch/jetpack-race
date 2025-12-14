---@class PlayerEntity
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param data table<string, any>
---@return PlayerEntity
function PlayerEntity.new(player, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player

	self.skillsConfig = {
		flyingSpeed = {
			level = 1,
			cooldown = 10,
			duration = 10,
			amount = 1.0,
			description = "Increases the speed of the flying entity",
			icon = "rbxassetid://1234567890",
			cost = 100,
			requiredLevel = 1,
			requiredSkillPoints = 10,
		},
		flyingSpeedBoost = {
			level = 1,
			cooldown = 10,
			duration = 10,
			amount = 1.0,
			description = "Increases the speed of the flying entity",
			icon = "rbxassetid://1234567890",
			cost = 100,
			requiredLevel = 1,
			requiredSkillPoints = 10,
		},
	}
	return self
end

function PlayerEntity:getData()
	return self.data
end

return PlayerEntity
