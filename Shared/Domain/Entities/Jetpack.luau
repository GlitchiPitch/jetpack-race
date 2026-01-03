---@class JetpackEntity
---@field _instance Accessory
---@field linearVelocity LinearVelocity
---@field alignOrientation AlignOrientation
local Jetpack = {}
Jetpack.__index = Jetpack

---@param accessory Accessory
---@return JetpackEntity
function Jetpack.new(accessory)
	local self = setmetatable({}, Jetpack)
	self._instance = accessory
	self.linearVelocity = Instance.new("LinearVelocity")
	self.alignOrientation = Instance.new("AlignOrientation")

	self:_setup()
	return self
end

function Jetpack:_setup()
	self.linearVelocity.Parent = self._instance.Handle
	self.alignOrientation.Parent = self._instance.Handle
	self.linearVelocity.Attachment0 = self._instance.Handle.BodyBackAttachment
	self.alignOrientation.Attachment0 = self._instance.Handle.BodyBackAttachment
	self.alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	self.linearVelocity.Enabled = false
	self.alignOrientation.Enabled = false
end

---@param playerEntity PlayerEntity
function Jetpack:equipToPlayer(playerEntity)
	local character = playerEntity.player.Character
	self._instance.Parent = character
end

---@class jetpackMoversData
---@field isActive boolean
---@field vectorVelocity Vector3
---@field orientationCFrame CFrame

---@param data jetpackMoversData
function Jetpack:setMovers(data)
	self.linearVelocity.Enabled = data.isActive
	self.alignOrientation.Enabled = data.isActive

	if data.isActive then
		self.linearVelocity.VectorVelocity = data.vectorVelocity
		self.alignOrientation.CFrame = data.orientationCFrame
	end
end

function Jetpack:destroy()
	self._instance:Destroy()
end

return Jetpack
