---@class RewardsSystemPetEntity
local Pet = {}
Pet.__index = Pet

---@return RewardsSystemPetEntity
function Pet.new()
	local self = setmetatable({}, Pet)
	return self
end

return Pet