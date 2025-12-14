local UserInputService = game:GetService("UserInputService")
local Constants = require("FlyingModule.Shared.Types.Constants")

---@class RobloxInputService
local RobloxInputService = {}
RobloxInputService.__index = RobloxInputService

---@return RobloxInputService
function RobloxInputService.new(): RobloxInputService
    return setmetatable({}, RobloxInputService)
end

---@return CFrame
function RobloxInputService:GetCameraCFrame(): CFrame
    return workspace.CurrentCamera.CFrame
end

---@return boolean
function RobloxInputService:IsSprintInputActive(): boolean
    return UserInputService:IsKeyDown(Constants.INPUT_KEYS.SPRINT)
end

return RobloxInputService