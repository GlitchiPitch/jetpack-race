
local Repositories = require(script.Repositories)

---@class FlyingSystemClientInfrastructure
---@field diContainer DIContainer
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return FlyingSystemClientInfrastructure
function Infrastructure.new(diContainer)
	local self = setmetatable({}, Infrastructure)
	self.diContainer = diContainer
    self:_register()
	return self
end

function Infrastructure:_register()
    self.diContainer:singleton("FlyingRepository", function(c)
        return Repositories.FlyingRepostiory.new(c)
    end)
end

return Infrastructure