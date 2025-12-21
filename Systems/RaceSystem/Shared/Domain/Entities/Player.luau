---@class RacePlayerEntity
---@field player Player
---@field _playerData table<string, any>
---@field data table<string, any>
---@field raceState string -- "Idle", "Preparing", "Started", "Finished"
---@field raceStats table -- {startTime, finishTime, boostsCollected, etc.}
---@field activeBoosts table -- {boostType = {active = boolean, endTime = number}}
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param _playerData table<string, any>
---@param data table<string, any>
---@return RacePlayerEntity
function PlayerEntity.new(player, _playerData, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self._playerData = _playerData
	self.data = data or {}
	self.raceState = "Idle"
	self.raceStats = {
		startTime = nil,
		finishTime = nil,
		boostsCollected = 0,
		distanceTraveled = 0,
		bestTime = nil,
		racesCompleted = 0,
	}
	self.activeBoosts = {}
	return self
end

---@return table<string, any>
function PlayerEntity:getData()
	return self.data
end

---@return table<string, any>
function PlayerEntity:getPlayerData()
	return self._playerData
end

---@return string
function PlayerEntity:getRaceState()
	return self.raceState
end

---@param state string
function PlayerEntity:setRaceState(state)
	self.raceState = state
	if state == "Started" then
		self.raceStats.startTime = tick()
	elseif state == "Finished" then
		self.raceStats.finishTime = tick()
		self.raceStats.racesCompleted = self.raceStats.racesCompleted + 1
	end
end

---@return table
function PlayerEntity:getRaceStats()
	return self.raceStats
end

---@return number|nil
function PlayerEntity:getRaceTime()
	if self.raceStats.startTime and self.raceStats.finishTime then
		return self.raceStats.finishTime - self.raceStats.startTime
	end
	return nil
end

---@param boostType string
---@param duration number
function PlayerEntity:activateBoost(boostType, duration)
	self.activeBoosts[boostType] = {
		active = true,
		endTime = tick() + duration,
	}
	self.raceStats.boostsCollected = self.raceStats.boostsCollected + 1
end

---@param boostType string
---@return boolean
function PlayerEntity:hasActiveBoost(boostType)
	local boost = self.activeBoosts[boostType]
	return boost and boost.active and tick() < boost.endTime
end

---@param boostType string
---@return number|nil
function PlayerEntity:getBoostTimeRemaining(boostType)
	local boost = self.activeBoosts[boostType]
	if boost and boost.active then
		local remaining = boost.endTime - tick()
		return remaining > 0 and remaining or nil
	end
	return nil
end

function PlayerEntity:updateActiveBoosts()
	local currentTime = tick()
	for _, boost in pairs(self.activeBoosts) do
		if boost.active and currentTime >= boost.endTime then
			boost.active = false
		end
	end
end

---@return table
function PlayerEntity:getActiveBoosts()
	self:updateActiveBoosts()
	local activeBoosts = {}
	for boostType, boost in pairs(self.activeBoosts) do
		if boost.active then
			activeBoosts[boostType] = boost
		end
	end
	return activeBoosts
end

function PlayerEntity:resetRaceData()
	self.raceState = "Idle"
	self.raceStats.startTime = nil
	self.raceStats.finishTime = nil
	self.activeBoosts = {}
end

---@return boolean
function PlayerEntity:isInRace()
	return self.raceState ~= "Idle"
end

---@return boolean
function PlayerEntity:hasFinishedRace()
	return self.raceState == "Finished"
end

return PlayerEntity
