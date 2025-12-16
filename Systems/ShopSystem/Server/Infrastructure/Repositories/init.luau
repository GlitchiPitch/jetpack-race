local PlayerRepository = require(script.PlayerRepository)
local FlyingRepository = require(script.FlyingRepository)

---@class ShopSystemServerRepositories
local Repositories = {
	PlayerRepository = PlayerRepository,
	FlyingRepository = FlyingRepository,
}

return Repositories
