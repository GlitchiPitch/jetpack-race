---@class BaseFrame
local BaseFrame = {}
BaseFrame.__index = BaseFrame

---@param diContainer DIContainer
---@param parent Instance
---@return BaseFrame
function BaseFrame.new(diContainer, parent)
	local self = setmetatable({}, BaseFrame)
	self.diContainer = diContainer
	self.frame = script.BaseFrame:Clone()
	self.frame.Parent = parent
	return self
end



function BaseFrame:open()
	self.frame.Visible = true
end

function BaseFrame:close()
	self.frame.Visible = false
end

return BaseFrame