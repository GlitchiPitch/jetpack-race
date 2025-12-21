---@class RaceSystemPetEntity
local Pet = {}
Pet.__index = Pet

---@return RaceSystemPetEntity
function Pet.new()
	local self = setmetatable({}, Pet)
	return self
end

return Pet