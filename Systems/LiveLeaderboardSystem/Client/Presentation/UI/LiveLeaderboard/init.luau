---@class LiveLeaderboardUI
local LiveLeaderboardUI = {}
LiveLeaderboardUI.__index = LiveLeaderboardUI

---@return LiveLeaderboardUI
function LiveLeaderboardUI.new()
    local self = setmetatable({}, LiveLeaderboardUI)
    return self
end

return LiveLeaderboardUI