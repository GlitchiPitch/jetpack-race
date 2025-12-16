---@class RaceUI
local RaceUI = {}
RaceUI.__index = RaceUI

---@return RaceUI
function RaceUI.new()
    local self = setmetatable({}, RaceUI)
    return self
end

return RaceUI