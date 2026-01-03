---@class checkpointEntityData
---@field _instance Model
---@field cframe CFrame
---@field index number
---@field parent Instance

---@class CheckpointEntity
---@field index number
---@field _instance Model
local CheckpointEntity = {}
CheckpointEntity.__index = CheckpointEntity

---@param data checkpointEntityData
function CheckpointEntity.new(data)
	local self = setmetatable({}, CheckpointEntity)
	self._instance = data._instance
	self.index = data.index

	if data.cframe then
		self._instance:PivotTo(data.cframe)
	end

	if data.parent then
		self._instance.Parent = data.parent
	end
	return self
end

function CheckpointEntity:destroy() end

return CheckpointEntity
