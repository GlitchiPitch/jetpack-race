---@class LeaderboardPlayerEntity
---@field player Player
---@field data table<string, any>
---@field totalScore number -- overall player score
---@field raceScore number -- score from racing activities
---@field petScore number -- score from pet-related activities
---@field rewardScore number -- score from reward achievements
---@field currentRank number -- current leaderboard position
---@field bestRank number -- best rank ever achieved
---@field scoreHistory table -- array of recent scores
---@field lastActivityTime number -- timestamp of last score-increasing activity
---@field leaderboardStats table -- various leaderboard statistics
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param data table<string, any>
---@return LeaderboardPlayerEntity
function PlayerEntity.new(player, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self.data = data or {}
	self.totalScore = self.data.totalScore or 0
	self.raceScore = self.data.raceScore or 0
	self.petScore = self.data.petScore or 0
	self.rewardScore = self.data.rewardScore or 0
	self.currentRank = self.data.currentRank or 0
	self.bestRank = self.data.bestRank or 0
	self.scoreHistory = self.data.scoreHistory or {}
	self.lastActivityTime = self.data.lastActivityTime or 0
	self.leaderboardStats = self.data.leaderboardStats or {
		racesCompleted = 0,
		petsOwned = 0,
		achievementsUnlocked = 0,
		totalPlayTime = 0,
	}
	return self
end

---@return table<string, any>
function PlayerEntity:getData()
	return {
		totalScore = self.totalScore,
		raceScore = self.raceScore,
		petScore = self.petScore,
		rewardScore = self.rewardScore,
		currentRank = self.currentRank,
		bestRank = self.bestRank,
		scoreHistory = self.scoreHistory,
		lastActivityTime = self.lastActivityTime,
		leaderboardStats = self.leaderboardStats,
	}
end

---@param amount number
---@param source string
function PlayerEntity:addScore(amount, source)
	local oldScore = self.totalScore
	self.totalScore = self.totalScore + amount
	self.lastActivityTime = tick()

	-- Update category scores
	if source == "race" then
		self.raceScore = self.raceScore + amount
		self.leaderboardStats.racesCompleted = self.leaderboardStats.racesCompleted + 1
	elseif source == "pet" then
		self.petScore = self.petScore + amount
		self.leaderboardStats.petsOwned = self.leaderboardStats.petsOwned + 1
	elseif source == "reward" or source == "achievement" then
		self.rewardScore = self.rewardScore + amount
		self.leaderboardStats.achievementsUnlocked = self.leaderboardStats.achievementsUnlocked + 1
	end

	-- Add to score history (keep last 20 entries)
	local scoreEntry = {
		score = amount,
		totalScore = self.totalScore,
		source = source,
		timestamp = tick(),
	}
	table.insert(self.scoreHistory, scoreEntry)

	if #self.scoreHistory > 20 then
		table.remove(self.scoreHistory, 1)
	end

	return self.totalScore - oldScore -- return actual score added
end

---@return number
function PlayerEntity:getTotalScore()
	return self.totalScore
end

---@return number
function PlayerEntity:getRaceScore()
	return self.raceScore
end

---@return number
function PlayerEntity:getPetScore()
	return self.petScore
end

---@return number
function PlayerEntity:getRewardScore()
	return self.rewardScore
end

---@param rank number
function PlayerEntity:setCurrentRank(rank)
	self.currentRank = rank
	if rank > 0 and (self.bestRank == 0 or rank < self.bestRank) then
		self.bestRank = rank
	end
end

---@return number
function PlayerEntity:getCurrentRank()
	return self.currentRank
end

---@return number
function PlayerEntity:getBestRank()
	return self.bestRank
end

---@return table
function PlayerEntity:getScoreHistory()
	return self.scoreHistory
end

---@return table
function PlayerEntity:getLeaderboardStats()
	return self.leaderboardStats
end

---@param statName string
---@param amount number
function PlayerEntity:updateStat(statName, amount)
	if self.leaderboardStats[statName] then
		self.leaderboardStats[statName] = self.leaderboardStats[statName] + amount
	else
		self.leaderboardStats[statName] = amount
	end
end

---@return number
function PlayerEntity:getLastActivityTime()
	return self.lastActivityTime
end

---@return boolean
function PlayerEntity:isActiveRecently()
	local currentTime = tick()
	local hours24 = 24 * 60 * 60 -- 24 hours in seconds
	return (currentTime - self.lastActivityTime) < hours24
end

---@return table
function PlayerEntity:getScoreBreakdown()
	return {
		total = self.totalScore,
		race = self.raceScore,
		pet = self.petScore,
		reward = self.rewardScore,
		racePercentage = self.totalScore > 0 and (self.raceScore / self.totalScore) or 0,
		petPercentage = self.totalScore > 0 and (self.petScore / self.totalScore) or 0,
		rewardPercentage = self.totalScore > 0 and (self.rewardScore / self.totalScore) or 0,
	}
end

---@param otherPlayer LeaderboardPlayerEntity
---@return number -- 1 if self is better, -1 if other is better, 0 if equal
function PlayerEntity:compareScore(otherPlayer)
	if self.totalScore > otherPlayer.totalScore then
		return 1
	elseif self.totalScore < otherPlayer.totalScore then
		return -1
	else
		-- If total scores are equal, compare by recent activity (more recent is better)
		if self.lastActivityTime > otherPlayer.lastActivityTime then
			return 1
		elseif self.lastActivityTime < otherPlayer.lastActivityTime then
			return -1
		else
			return 0
		end
	end
end

---@return table
function PlayerEntity:getDisplayInfo()
	return {
		playerName = self.player.Name,
		playerId = self.player.UserId,
		totalScore = self.totalScore,
		currentRank = self.currentRank,
		bestRank = self.bestRank,
		isActive = self:isActiveRecently(),
		lastActivityTime = self.lastActivityTime,
	}
end

return PlayerEntity