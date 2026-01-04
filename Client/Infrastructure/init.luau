local Repositories = require(script.Repositories)

---@class ClientInfrastructure
---@field diContainer DIContainer
---@field repositories ClientRepositories
local Infrastructure = {}
Infrastructure.__index = Infrastructure

function Infrastructure.new(diContainer)
	local self = setmetatable({}, Infrastructure)
	self.diContainer = diContainer
	self.repositories = Repositories.new(diContainer)
	self:_register()
	return self
end

function Infrastructure:addCallbackToUpdateLoop()
	
end

function Infrastructure:_register()
	self.diContainer:singleton("Infrastructure", function()
		return self
	end)
end

function Infrastructure:_startUpdateLoop()
	
end

return Infrastructure
