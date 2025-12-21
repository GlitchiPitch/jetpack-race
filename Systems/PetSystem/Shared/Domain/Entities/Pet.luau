---@class PetSystemPetEntity
local Pet = {}
Pet.__index = Pet

---@return PetSystemPetEntity
function Pet.new()
	local self = setmetatable({}, Pet)
	return self
end

return Pet