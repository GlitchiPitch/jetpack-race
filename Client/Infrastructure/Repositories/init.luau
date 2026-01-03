local PlayerRepository = require(script.PlayerRepository)

---@class ClientRepositories
---@field playerRepository ClientPlayerRepository
---@field diContainer DIContainer
local Repositories = {}
Repositories.__index = Repositories

---@param diContainer DIContainer
function Repositories.new(diContainer)
	local self = setmetatable({}, Repositories)
	self.playerRepository = PlayerRepository.new(diContainer)
	return self
end

return Repositories
