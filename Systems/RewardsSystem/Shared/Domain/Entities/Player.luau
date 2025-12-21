---@class RewardsPlayerEntity
---@field player Player
---@field _playerData table<string, any>
---@field data table<string, any>
---@field totalRewardsEarned number -- total rewards earned across all time
---@field dailyRewards table -- {day = number, claimed = boolean, lastClaimTime = number}
---@field achievementProgress table -- achievementId -> {current = number, target = number, completed = boolean}
---@field rewardStreak number -- current daily reward streak
---@field lastRewardClaimTime number -- timestamp of last reward claim
---@field rewardHistory table -- array of recent reward claims
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param _playerData table<string, any>
---@param data table<string, any>
---@return RewardsPlayerEntity
function PlayerEntity.new(player, _playerData, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self._playerData = _playerData
	self.data = data or {}
	self.totalRewardsEarned = self.data.totalRewardsEarned or 0
	self.dailyRewards = self.data.dailyRewards or {}
	self.achievementProgress = self.data.achievementProgress or {}
	self.rewardStreak = self.data.rewardStreak or 0
	self.lastRewardClaimTime = self.data.lastRewardClaimTime or 0
	self.rewardHistory = self.data.rewardHistory or {}
	return self
end

---@return table<string, any>
function PlayerEntity:getData()
	return {
		totalRewardsEarned = self.totalRewardsEarned,
		dailyRewards = self.dailyRewards,
		achievementProgress = self.achievementProgress,
		rewardStreak = self.rewardStreak,
		lastRewardClaimTime = self.lastRewardClaimTime,
		rewardHistory = self.rewardHistory,
	}
end

---@return table<string, any>
function PlayerEntity:getPlayerData()
	return self._playerData
end

---@param amount number
---@param rewardType string
---@param source string
function PlayerEntity:addReward(amount, rewardType, source)
	self.totalRewardsEarned = self.totalRewardsEarned + amount

	-- Add to reward history (keep last 50 entries)
	local rewardEntry = {
		amount = amount,
		type = rewardType,
		source = source,
		timestamp = tick(),
	}
	table.insert(self.rewardHistory, rewardEntry)

	if #self.rewardHistory > 50 then
		table.remove(self.rewardHistory, 1)
	end
end

---@return number
function PlayerEntity:getTotalRewardsEarned()
	return self.totalRewardsEarned
end

---@return table
function PlayerEntity:getRewardHistory()
	return self.rewardHistory
end

---@param day number
---@return boolean
function PlayerEntity:canClaimDailyReward(day)
	local today = self:getCurrentDay()
	local reward = self.dailyRewards[day]

	-- Can claim if not claimed today and day is available
	return not (
		reward
		and reward.claimed
		and reward.lastClaimTime
		and self:getDayFromTimestamp(reward.lastClaimTime) == today
	)
end

---@param day number
---@return boolean
function PlayerEntity:claimDailyReward(day)
	if not self:canClaimDailyReward(day) then
		return false
	end

	local today = self:getCurrentDay()
	self.dailyRewards[day] = {
		claimed = true,
		lastClaimTime = tick(),
		day = today,
	}

	-- Update streak
	if self:shouldIncrementStreak() then
		self.rewardStreak = self.rewardStreak + 1
	else
		self.rewardStreak = 1 -- reset streak
	end

	self.lastRewardClaimTime = tick()

	-- Add reward (example: coins based on day)
	local rewardAmount = day * 10 -- 10 coins for day 1, 20 for day 2, etc.
	self:addReward(rewardAmount, "coins", "daily_reward_day_" .. day)

	return true
end

---@return boolean
function PlayerEntity:shouldIncrementStreak()
	if self.lastRewardClaimTime == 0 then
		return true -- first claim
	end

	local lastClaimDay = self:getDayFromTimestamp(self.lastRewardClaimTime)
	local yesterday = self:getCurrentDay() - 1

	return lastClaimDay == yesterday
end

---@return number
function PlayerEntity:getCurrentDay()
	return math.floor(tick() / 86400) -- days since epoch
end

---@param timestamp number
---@return number
function PlayerEntity:getDayFromTimestamp(timestamp)
	return math.floor(timestamp / 86400)
end

---@return number
function PlayerEntity:getRewardStreak()
	return self.rewardStreak
end

---@return table
function PlayerEntity:getDailyRewardsStatus()
	local result = {}
	for day = 1, 7 do -- assuming 7-day cycle
		result[day] = {
			claimed = self.dailyRewards[day] and self.dailyRewards[day].claimed or false,
			canClaim = self:canClaimDailyReward(day),
		}
	end
	return result
end

---@param achievementId string
---@param current number
---@param target number
function PlayerEntity:updateAchievementProgress(achievementId, current, target)
	if not self.achievementProgress[achievementId] then
		self.achievementProgress[achievementId] = {
			current = 0,
			target = target,
			completed = false,
		}
	end

	local achievement = self.achievementProgress[achievementId]
	achievement.current = math.min(current, target)

	if achievement.current >= achievement.target and not achievement.completed then
		achievement.completed = true
		-- Could trigger reward here
		self:addReward(target * 5, "achievement", achievementId) -- example reward
	end
end

---@param achievementId string
---@return table|nil
function PlayerEntity:getAchievementProgress(achievementId)
	return self.achievementProgress[achievementId]
end

---@return table
function PlayerEntity:getAllAchievementProgress()
	return self.achievementProgress
end

---@return table
function PlayerEntity:getCompletedAchievements()
	local completed = {}
	for achievementId, progress in pairs(self.achievementProgress) do
		if progress.completed then
			completed[achievementId] = progress
		end
	end
	return completed
end

---@return number
function PlayerEntity:getAchievementCompletionRate()
	local total = 0
	local completed = 0

	for _, progress in pairs(self.achievementProgress) do
		total = total + 1
		if progress.completed then
			completed = completed + 1
		end
	end

	return total > 0 and (completed / total) or 0
end

return PlayerEntity
