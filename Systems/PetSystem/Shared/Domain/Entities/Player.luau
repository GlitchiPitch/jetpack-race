---@class PetPlayerEntity
---@field player Player
---@field _playerData table<string, any>
---@field data table<string, any>
---@field ownedPets table<string, boolean> -- petId -> owned
---@field equippedPet string|nil -- currently equipped pet ID
---@field petStats table -- current pet stats (speed, etc.)
---@field petExperience number -- experience points for pet leveling
---@field petLevel number -- current pet level
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param _playerData table<string, any>
---@param data table<string, any>
---@return PetPlayerEntity
function PlayerEntity.new(player, _playerData, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self._playerData = _playerData
	self.data = data or {}
	self.ownedPets = self.data.ownedPets or {}
	self.equippedPet = self.data.equippedPet or nil
	self.petStats = self.data.petStats or {
		speed = 0,
		defense = 0,
		attack = 0,
	}
	self.petExperience = self.data.petExperience or 0
	self.petLevel = self.data.petLevel or 1
	return self
end

---@return table<string, any>
function PlayerEntity:getData()
	return {
		ownedPets = self.ownedPets,
		equippedPet = self.equippedPet,
		petStats = self.petStats,
		petExperience = self.petExperience,
		petLevel = self.petLevel,
	}
end

---@return table<string, any>
function PlayerEntity:getPlayerData()
	return self._playerData
end

---@param petId string
---@return boolean
function PlayerEntity:ownsPet(petId)
	return self.ownedPets[petId] or false
end

---@param petId string
function PlayerEntity:addPet(petId)
	self.ownedPets[petId] = true
end

---@param petId string
function PlayerEntity:removePet(petId)
	self.ownedPets[petId] = nil
	if self.equippedPet == petId then
		self.equippedPet = nil
	end
end

---@return table<string, boolean>
function PlayerEntity:getOwnedPets()
	return self.ownedPets
end

---@return string|nil
function PlayerEntity:getEquippedPet()
	return self.equippedPet
end

---@param petId string
---@return boolean
function PlayerEntity:equipPet(petId)
	if not self:ownsPet(petId) then
		return false
	end
	self.equippedPet = petId
	self:updatePetStats()
	return true
end

function PlayerEntity:unequipPet()
	self.equippedPet = nil
	self.petStats = { speed = 0, defense = 0, attack = 0 }
end

function PlayerEntity:updatePetStats()
	if not self.equippedPet then
		self.petStats = { speed = 0, defense = 0, attack = 0 }
		return
	end

	-- Get pet data from shared data
	local petsData = require(script.Parent.Parent.Parent.Data.Pets)
	local petData = petsData[self.equippedPet]

	if petData and petData.stats then
		self.petStats = {
			speed = (petData.stats.speed or 0) * self.petLevel,
			defense = (petData.stats.defense or 0) * self.petLevel,
			attack = (petData.stats.attack or 0) * self.petLevel,
		}
	else
		self.petStats = { speed = 0, defense = 0, attack = 0 }
	end
end

---@return table
function PlayerEntity:getPetStats()
	return self.petStats
end

---@return number
function PlayerEntity:getPetExperience()
	return self.petExperience
end

---@return number
function PlayerEntity:getPetLevel()
	return self.petLevel
end

---@param amount number
function PlayerEntity:addPetExperience(amount)
	self.petExperience = self.petExperience + amount

	-- Check for level up (simple leveling: 100 exp per level)
	local newLevel = math.floor(self.petExperience / 100) + 1
	if newLevel > self.petLevel then
		self.petLevel = newLevel
		self:updatePetStats()
		return true -- leveled up
	end

	return false -- no level up
end

---@return number
function PlayerEntity:getExperienceToNextLevel()
	local nextLevelExp = self.petLevel * 100
	return nextLevelExp - self.petExperience
end

---@return boolean
function PlayerEntity:hasActivePet()
	return self.equippedPet ~= nil
end

---@return table -- {petId, stats, level, experience}
function PlayerEntity:getEquippedPetInfo()
	if not self.equippedPet then
		return nil
	end

	local petsData = require(script.Parent.Parent.Parent.Data.Pets)
	local petData = petsData[self.equippedPet]

	return {
		petId = self.equippedPet,
		data = petData,
		stats = self.petStats,
		level = self.petLevel,
		experience = self.petExperience,
		experienceToNext = self:getExperienceToNextLevel(),
	}
end

return PlayerEntity