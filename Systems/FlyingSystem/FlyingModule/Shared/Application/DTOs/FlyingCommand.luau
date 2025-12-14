---@class FlyingCommand
local FlyingCommand = {}

---@param action "fly" | "sprint"
---@param cameraCFrame CFrame?
---@param sprintActive boolean?
---@param timestamp number?
---@return FlyingCommand
function FlyingCommand.new(action: string, cameraCFrame: CFrame?, sprintActive: boolean?, timestamp: number?): any
    return {
        Action = action,
        CameraCFrame = cameraCFrame,
        SprintActive = sprintActive,
        Timestamp = timestamp or tick()
    }
end

return FlyingCommand