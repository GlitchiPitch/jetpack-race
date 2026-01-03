---@class JetpackEntity
---@field _instance Accessory
---@field linearVelocity LinearVelocity
---@field alignOrientation AlignOrientation
local Jetpack = {}
Jetpack.__index = Jetpack

---@class jetpackData
---@field _instance Accessory,
---@field alignOrientation AlignOrientation,
---@field linearVelocity LinearVelocity

---@param data jetpackData
---@return JetpackEntity
function Jetpack.new(data)
	local self = setmetatable({}, Jetpack)
	self._instance = data._instance
	self.linearVelocity = data.linearVelocity or Instance.new("LinearVelocity")
	self.alignOrientation = data.alignOrientation or Instance.new("AlignOrientation")

	self:_setup()
	return self
end

function Jetpack:_setup()
	self.linearVelocity.Parent = self._instance.Handle
	self.alignOrientation.Parent = self._instance.Handle
	self.linearVelocity.Attachment0 = self._instance.Handle.BodyBackAttachment
	self.alignOrientation.Attachment0 = self._instance.Handle.BodyBackAttachment
	self.alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	self.linearVelocity.MaxForce = 4000
	self.linearVelocity.Enabled = false
	self.alignOrientation.Enabled = false
end

function Jetpack:getData()
	return {
		_instance = self._instance,
		linearVelocity = self.linearVelocity,
		alignOrientation = self.alignOrientation,
	}
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
