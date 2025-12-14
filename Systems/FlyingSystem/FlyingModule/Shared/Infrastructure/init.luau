---@class FlyingModuleSharedInfrastructure
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@return FlyingModuleSharedInfrastructure
function Infrastructure.new()
	local self = setmetatable({}, Infrastructure)

	return self
end

function Infrastructure:init() end

return Infrastructure