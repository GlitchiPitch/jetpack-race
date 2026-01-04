---@class JetpackEntity
---@field _instance Accessory
---@field linearVelocity LinearVelocity
---@field alignOrientation AlignOrientation
---@field speed number
---@field nitro number
---@field _maxNitro number
---@field _defaultSpeed number
local JetpackEntity = {}
JetpackEntity.__index = JetpackEntity

---@class jetpackData
---@field _instance Accessory,
---@field alignOrientation AlignOrientation,
---@field linearVelocity LinearVelocity
---@field speed number
---@field nitro number

---@param data jetpackData
---@return JetpackEntity
function JetpackEntity.new(data)
	local self = setmetatable({}, JetpackEntity)
	self._instance = data._instance
	self.linearVelocity = data.linearVelocity or Instance.new("LinearVelocity")
	self.alignOrientation = data.alignOrientation or Instance.new("AlignOrientation")

	self._defaultSpeed = data.speed or 50
	self._maxNitro = data.nitro or 100
	self._nitroIsActivated = false

	self.speed = self._defaultSpeed
	self.nitro = 0
	self:_setup()
	return self
end

function JetpackEntity:_setup()
	self.linearVelocity.Parent = self._instance.Handle
	self.alignOrientation.Parent = self._instance.Handle
	self.linearVelocity.Attachment0 = self._instance.Handle.BodyBackAttachment
	self.alignOrientation.Attachment0 = self._instance.Handle.BodyBackAttachment
	self.alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	self.linearVelocity.MaxForce = 4000
	self.linearVelocity.Enabled = false
	self.alignOrientation.Enabled = false
end

function JetpackEntity:getData()
	return {
		_instance = self._instance,
		linearVelocity = self.linearVelocity,
		alignOrientation = self.alignOrientation,
		speed = self._defaultSpeed,
		nitro = self._maxNitro,
	}
end

---@param playerEntity PlayerEntity
function JetpackEntity:equipToPlayer(playerEntity)
	local character = playerEntity.player.Character
	self._instance.Parent = character
end

---@class jetpackMoversData
---@field isActive boolean
---@field vectorVelocity Vector3
---@field orientationCFrame CFrame

---@param data jetpackMoversData
function JetpackEntity:setMovers(data)
	self.linearVelocity.Enabled = data.isActive
	self.alignOrientation.Enabled = data.isActive

	if data.isActive then
		self.linearVelocity.VectorVelocity = data.vectorVelocity
		self.alignOrientation.CFrame = data.orientationCFrame
	end
end

function JetpackEntity:updateNitro()
	if self._nitroIsActivated and self.nitro > 0 then
		self.nitro -= 1
	end
end

---@param state boolean
function JetpackEntity:toggleNitro(state)
	self._nitroIsActivated = state

	if self._nitroIsActivated then
		self.speed *= 2.5
	else
		self.speed = self._defaultSpeed
	end
end

function JetpackEntity:destroy()
	self._instance:Destroy()
end

return JetpackEntity
