---@class ShopSystemServerPlayerRepository
local DataStoreService = game:GetService("DataStoreService")
local PlayerRepository = {}
PlayerRepository.__index = PlayerRepository

---@param PlayerEntity PlayerEntity
---@return ShopSystemServerPlayerRepository
function PlayerRepository.new(PlayerEntity)
	local self = setmetatable({}, PlayerRepository)
	self.playerEntities = {}
	self.PlayerEntity = PlayerEntity
	self.dataStore = DataStoreService:GetDataStore("PlayerShopData_v1")
	return self
end

---@param player Player
---@return PlayerEntity
function PlayerRepository:getPlayerEntity(player)
	if not self.playerEntities[player] then
		local playerData = self:_loadPlayerData(player)
		self.playerEntities[player] = self.PlayerEntity.new(player, playerData)
	end

	return self.playerEntities[player]
end

---@param player Player
function PlayerRepository:savePlayerData(player)
	local playerEntity = self.playerEntities[player]
	if not playerEntity then return end

	local playerData = playerEntity:getData()
	local success, errorMessage = pcall(function()
		self.dataStore:SetAsync("Player_" .. player.UserId, playerData)
	end)

	if not success then
		warn("Failed to save player data for " .. player.Name .. ": " .. errorMessage)
	else
		print("Player data saved for " .. player.Name)
	end
end

---@param player Player
---@return table|nil
function PlayerRepository:_loadPlayerData(player)
	local success, data = pcall(function()
		return self.dataStore:GetAsync("Player_" .. player.UserId)
	end)

	if success and data then
		print("Player data loaded for " .. player.Name)
		return data
	else
		print("No saved data found for " .. player.Name .. ", using defaults")
		return nil
	end
end

---@param player Player
function PlayerRepository:removePlayerEntity(player)
	-- Save data before removing
	self:savePlayerData(player)
	self.playerEntities[player] = nil
end

return PlayerRepository
