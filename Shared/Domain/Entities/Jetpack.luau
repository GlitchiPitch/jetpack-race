---@class JetpackEntity
---@field _instance Accessory
local Jetpack = {}
Jetpack.__index = Jetpack

---@param accessory Accessory
---@return JetpackEntity
function Jetpack.new(accessory)
	local self = setmetatable({}, Jetpack)
	self._instance = accessory
	return self
end

---@param playerEntity PlayerEntity
function Jetpack:equipToPlayer(playerEntity)
	local character = playerEntity.player.Character
	self._instance.Parent = character
end

function Jetpack:destroy()
	self._instance:Destroy()
end

return Jetpack