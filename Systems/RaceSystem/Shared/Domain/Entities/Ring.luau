---@class RingData
---@field model Model
---@field parent Instance

---@class RingEntity
---@field model Model
---@field parent Instance
local Ring = {}

---@return RingEntity
function Ring.new(data)
	local self = setmetatable({}, Ring)
	self.model = data.model
	self.parent = data.parent
	self:_setup()
	return self
end

function Ring:_setup()
	self.model.Parent = self.parent
end

return Ring
