---@interface IInputService
local IInputService = {
    ---@return CFrame
    GetCameraCFrame = "function",

    ---@return boolean
    IsSprintInputActive = "function"
}

return IInputService
