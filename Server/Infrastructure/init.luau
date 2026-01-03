local Repositories = require(script.Repositories)
local Services = require(script.Services)
---@class ServerInfrastructure
---@field diContainer DIContainer
---@field repositories Repositories
---@field services ServerInfrastructureServices
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return ServerInfrastructure
function Infrastructure.new(diContainer)
	local self = setmetatable({}, Infrastructure)
	self.diContainer = diContainer
	self.repositories = Repositories.new(diContainer)
	self.services = Services.new(diContainer)
    
	self:_register()
	return self
end

function Infrastructure:_register()
	self.diContainer:singleton("Infrastructure", function()
		return self
	end)
end
return Infrastructure
