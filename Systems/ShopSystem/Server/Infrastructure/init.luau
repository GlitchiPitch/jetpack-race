local Repositories = require(script.Repositories)

---@class ShopSystemServerInfrastructure
---@field diContainer DIContainer
local Infrastructure = {}
Infrastructure.__index = Infrastructure

---@param diContainer DIContainer
---@return ShopSystemServerInfrastructure
function Infrastructure.new(diContainer)
	local self = setmetatable({}, Infrastructure)
	self.diContainer = diContainer
	self:_register()
	return self
end

function Infrastructure:_register()
	self.diContainer:singleton("PlayerRepository", function()
		---@type ShopSystemEntities
		local entities = self.diContainer:resolve("Entities")
		---@type PlayerEntity
		local playerEntity = entities.Player
		return Repositories.PlayerRepository.new(playerEntity)
	end)
end

function Infrastructure:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("ShopSystemServerInfrastructure", "Infrastructure initialized successfully")
end

return Infrastructure
