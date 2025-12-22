---@class RewardData
---@field xp number
---@field coins number
---@field items table<string, number>?

---@class WinnerData
---@field startTime number
---@field finishTime number
---@field playerEntity RacePlayerEntity
---@field passedRings number
---@field collectedBoosts number
---@field reward RewardData

---@class WinnerEntity
---@field startTime number
---@field finishTime number
---@field playerEntity RacePlayerEntity
---@field passedRings number
---@field collectedBoosts number
---@field reward RewardData
local Winner = {}
Winner.__index = Winner

---@return WinnerEntity
function Winner.new(data)
	local self = setmetatable({}, Winner)
	self.startTime = data.startTime
	self.finishTime = data.finishTime
	self.playerEntity = data.playerEntity
	self.passedRings = data.passedRings
	self.collectedBoosts = data.collectedBoosts
	self.reward = data.reward
	return self
end

return Winner
