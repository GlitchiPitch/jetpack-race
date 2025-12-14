---@class PetEntity
local Pet = {}
Pet.__index = Pet

---@return PetEntity
function Pet.new()
	local self = setmetatable({}, Pet)
	return self
end

return Pet