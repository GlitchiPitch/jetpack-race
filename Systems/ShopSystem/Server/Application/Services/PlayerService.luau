---@class ShopSystemServerPlayerService
local PlayerService = {}
PlayerService.__index = PlayerService

---@param diContainer DIContainer
---@return ShopSystemServerPlayerService
function PlayerService.new(diContainer)
	local self = setmetatable({}, PlayerService)
	self.diContainer = diContainer
	return self
end

function PlayerService:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("ShopSystemPlayerService", "Initializing PlayerService...")
end

function PlayerService:onPlayerAdded(player)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopSystemPlayerService", "Player added to shop system:", player.Name, "(ID:", player.UserId, ")")

	---@type ShopSystemServerPlayerRepository
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	logger:info("ShopSystemPlayerService", "Loading/creating player entity for", player.Name)
	local playerEntity = playerRepository:getPlayerEntity(player)

	if playerEntity then
		local currency = playerEntity:getCurrencyData()
		local inventory = playerEntity:getInventory()
		logger:info("ShopSystemPlayerService", "Player entity loaded successfully - Currency: Coins=", currency.coins, "Gems=", currency.gems, "Inventory items:", #inventory)

		-- Send initial player data to client after a short delay to ensure client is ready
		logger:info("ShopSystemPlayerService", "Scheduling initial player data send to client for", player.Name)
		task.delay(0.5, function()
			if player:IsDescendantOf(game.Players) then -- Check if player is still in game
				logger:info("ShopSystemPlayerService", "Sending initial player data to client for", player.Name)
				self:updatePlayer(player)
			else
				logger:warn("ShopSystemPlayerService", "Player", player.Name, "left before initial data could be sent")
			end
		end)
	else
		logger:warn("ShopSystemPlayerService", "Failed to load/create player entity for", player.Name)
	end
end

function PlayerService:onPlayerRemoving(player)
	local playerRepository = self.diContainer:resolve("PlayerRepository")
	playerRepository:removePlayerEntity(player)
end

function PlayerService:updatePlayer(player)
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopSystemPlayerService", "Updating player data for:", player.Name, "(ID:", player.UserId, ")")

	local playerRepository = self.diContainer:resolve("PlayerRepository")
	---@type PlayerEntity
	local playerEntity = playerRepository:getPlayerEntity(player)

	if not playerEntity then
		logger:warn("ShopSystemPlayerService", "Cannot update player - entity not found for:", player.Name)
		return
	end

	local playerData = playerEntity:getData()
	logger:info("ShopSystemPlayerService", "Retrieved player data - Currency: Coins=", playerData.currency.coins, "Gems=", playerData.currency.gems, "Inventory items:", #playerData.inventory)

	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type ShopSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	local eventData = {
		playerData = playerData,
		timestamp = tick()
	}

	logger:info("ShopSystemPlayerService", "Firing PLAYER_UPDATED event to client for", player.Name)
	remoteEventService:fireClient(player, constants.REMOTE_EVENTS.PLAYER_UPDATED, eventData)
end

---@param player Player
function PlayerService:savePlayerData(player)
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopSystemPlayerService", "Saving player data for:", player.Name, "(ID:", player.UserId, ")")

	local playerRepository = self.diContainer:resolve("PlayerRepository")

	local startTime = tick()
	local success = playerRepository:savePlayerData(player)
	local saveTime = tick() - startTime

	if success then
		logger:info("ShopSystemPlayerService", "Player data saved successfully for", player.Name, "in", string.format("%.3f", saveTime), "seconds")
	else
		logger:warn("ShopSystemPlayerService", "Failed to save player data for", player.Name)
	end

	return success
end

---@param player Player
---@return PlayerEntity
function PlayerService:getPlayerEntity(player)
	local logger = self.diContainer:resolve("Logger")
	logger:info("ShopSystemPlayerService", "Getting player entity for:", player.Name, "(ID:", player.UserId, ")")

	local playerRepository = self.diContainer:resolve("PlayerRepository")
	local playerEntity = playerRepository:getPlayerEntity(player)

	if playerEntity then
		logger:info("ShopSystemPlayerService", "Player entity retrieved successfully for", player.Name)
	else
		logger:warn("ShopSystemPlayerService", "Player entity not found for", player.Name)
	end

	return playerEntity
end

return PlayerService
