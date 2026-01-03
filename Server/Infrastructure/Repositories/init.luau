local PlayerRepository = require(script.PlayerRepository)

---@class Repositories
---@field playerRepository PlayerRepository
local Repositories = {}
Repositories.__index = Repositories

---@param diContainer DIContainer
function Repositories.new(diContainer)
	local self = setmetatable({}, Repositories)
	self.playerRepository = PlayerRepository.new(diContainer)
	return self
end

return Repositories
