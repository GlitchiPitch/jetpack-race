---@class RaceEntity
---@field rings table<string, RingEntity>
---@field winners table<string, WinnerEntity>
---@field passedCheckpoints table<number, boolean>
---@field totalCheckpoints number
local Race = {}
Race.__index = Race

---@return RaceEntity
function Race.new(data)
	local self = setmetatable({}, Race)
	self.rings = {}
	self.winners = {}
	self.passedCheckpoints = {}
	self.totalCheckpoints = 0
	self.id = data.id
	return self
end

function Race:start() end

function Race:finish() end

---@param checkpointId number
function Race:markCheckpointPassed(checkpointId)
	if not self.passedCheckpoints[checkpointId] then
		self.passedCheckpoints[checkpointId] = true
	end
end

---@param checkpointId number
---@return boolean
function Race:isCheckpointPassed(checkpointId)
	return self.passedCheckpoints[checkpointId] == true
end

---@return number
function Race:getPassedCheckpointsCount()
	local count = 0
	for _, passed in pairs(self.passedCheckpoints) do
		if passed then
			count = count + 1
		end
	end
	return count
end

---@return boolean
function Race:isRaceCompleted()
	return self:getPassedCheckpointsCount() >= self.totalCheckpoints
end

---@param winner WinnerEntity
function Race:addWinner(winner)
	table.insert(self.winners, winner)
end

function Race:getResult()
	return {
		winners = self.winners,
		passedCheckpoints = self:getPassedCheckpointsCount(),
		totalCheckpoints = self.totalCheckpoints,
		isCompleted = self:isRaceCompleted(),
	}
end

return Race
