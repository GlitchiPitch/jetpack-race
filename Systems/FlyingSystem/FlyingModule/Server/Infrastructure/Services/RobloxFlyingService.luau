---@class RobloxFlyingService
local RobloxFlyingService = {}
RobloxFlyingService.__index = RobloxFlyingService

---@return RobloxFlyingService
function RobloxFlyingService.new(): RobloxFlyingService
    return setmetatable({}, RobloxFlyingService)
end

---@param cameraCFrame CFrame
---@param speed number
---@param flyingEntity any
---@return Vector3
function RobloxFlyingService:CalculateVelocity(cameraCFrame: CFrame, speed: number, flyingEntity: any): Vector3
    local forwardVector = cameraCFrame:VectorToWorldSpace(Vector3.new(0, 0, -1))
    local sideVector = cameraCFrame:VectorToWorldSpace(Vector3.new(-1, 0, 0))

    local localControlVector = CFrame.new(Vector3.new(0, 0, 0), cameraCFrame.LookVector * Vector3.new(1, 0, 1))
        :VectorToObjectSpace(cameraCFrame.LookVector.Unit)

    local newPush = Vector3.zero
    newPush += forwardVector * speed * -localControlVector.Z
    newPush += sideVector * speed * -localControlVector.X

    return newPush
end

---@param player Player
---@param velocity Vector3
function RobloxFlyingService:ApplyVelocity(player: Player, velocity: Vector3)
    if not player.Character then return end

    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local flightPower = humanoidRootPart:FindFirstChildOfClass("BodyVelocity")
    local flightSpin = humanoidRootPart:FindFirstChildOfClass("BodyGyro")
    local flightHold = humanoidRootPart:FindFirstChildOfClass("BodyPosition")

    if not flightPower or not flightSpin or not flightHold then
        return
    end

    if velocity.Magnitude < 1 then
        flightHold.MaxForce = Vector3.new(flightHold.P, flightHold.P, flightHold.P)
        flightPower.MaxForce = Vector3.zero
        flightHold.Position = humanoidRootPart.Position
    else
        flightHold.MaxForce = Vector3.zero
        flightPower.MaxForce = Vector3.new(flightPower.P * 100, flightPower.P * 100, flightPower.P * 100)
    end

    flightPower.Velocity = velocity
    flightSpin.CFrame = CFrame.new(Vector3.zero, velocity.Unit)
end

---@param character Model
function RobloxFlyingService:SetupBodyMovers(character: Model)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- BodyVelocity for movement
    if not humanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.P = 1000
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = humanoidRootPart
    end

    -- BodyGyro for rotation
    if not humanoidRootPart:FindFirstChildOfClass("BodyGyro") then
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(300, 300, 300)
        bodyGyro.P = 1000
        bodyGyro.Parent = humanoidRootPart
    end

    -- BodyPosition for holding position
    if not humanoidRootPart:FindFirstChildOfClass("BodyPosition") then
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.zero
        bodyPosition.P = 1000
        bodyPosition.Position = humanoidRootPart.Position
        bodyPosition.Parent = humanoidRootPart
    end
end

return RobloxFlyingService