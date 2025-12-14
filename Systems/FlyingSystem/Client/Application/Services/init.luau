---@class FlyingSystemApplicationServices
---@field diContainer DIContainer
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@return FlyingSystemApplicationServices
function Services.new(diContainer)
	local self = setmetatable({}, Services)
	self.diContainer = diContainer
    self:_register()
	return self
end

function Services:_register()

end

return Services