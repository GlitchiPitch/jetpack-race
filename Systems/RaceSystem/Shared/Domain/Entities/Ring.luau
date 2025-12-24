---@class RingData
---@field model Model
---@field parent Instance
---@field checkpointId number
---@field position CFrame

---@class RingEntity
---@field model Model
---@field parent Instance
---@field checkpointId number
---@field position CFrame
---@field isPassed boolean
---@field touchConnection RBXScriptConnection?
local Ring = {}

---@return RingEntity
function Ring.new(data)
	local self = setmetatable({}, Ring)
	self.model = data.model
	self.parent = data.parent
	self.checkpointId = data.checkpointId or 1
	self.position = data.position or CFrame.new()
	self.isPassed = false
	self:_setup()
	return self
end

function Ring:_setup()
	self.model.Parent = self.parent
	self:setPosition(self.position)

	-- Setup touch trigger for checkpoint detection
	local touchPart = self.model:FindFirstChild("TouchPart")
	if touchPart then
		self.touchConnection = touchPart.Touched:Connect(function(hit)
			self:_onTouched(hit)
		end)
	end
end

---@param position CFrame
function Ring:setPosition(position)
	self.position = position
	self.model:PivotTo(position)
end

---@param hit BasePart
function Ring:_onTouched(hit)
	-- This will be overridden by server implementation for checkpoint logic
end

function Ring:destroy()
	if self.touchConnection then
		self.touchConnection:Disconnect()
		self.touchConnection = nil
	end

	if self.model then
		self.model:Destroy()
	end
end

return Ring
