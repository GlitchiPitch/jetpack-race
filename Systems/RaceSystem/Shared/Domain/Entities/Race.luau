---@class RaceEntity
---@field rings table<string, RingEntity>
---@field winners table<string, WinnerEntity>
local Race = {}
Race.__index = Race

---@return RaceEntity
function Race.new(data)
	local self = setmetatable({}, Race)
	self.rings = {}
	self.winners = {}
	self.id = data.id
	return self
end

function Race:start()
	
end

function Race:finish()
	
end

---@param winner WinnerEntity
function Race:addWinner(winner)
	table.insert(self.winners, winner)
end

function Race:getResult()
	return {
		winners = self.winners,

	}
end

return Race
