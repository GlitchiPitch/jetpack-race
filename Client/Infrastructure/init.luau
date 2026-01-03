local Repositories = require(script.Repositories)

---@class ClientInfrastructure
---@field diContainer DIContainer
---@field Repositories ClientRepositories
local Infrastructure = {}
Infrastructure.__index = Infrastructure

function Infrastructure.new(diContainer)
	local self = setmetatable({}, Infrastructure)
	self.diContainer = diContainer
	self.Repositories = Repositories
	self:_register()
	return self
end

function Infrastructure:_register()
	self.diContainer:singleton("Infrastructure", function()
		return self
	end)
end

return Infrastructure
