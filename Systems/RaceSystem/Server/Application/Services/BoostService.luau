---@class RaceSystemServerBoostService
local BoostService = {}
BoostService.__index = BoostService

---@return RaceSystemServerBoostService
function BoostService.new()
	local self = setmetatable({}, BoostService)
	return self
end

function BoostService:init()
end

function BoostService:applyBoost(player, boostType)
end

function BoostService:removeBoost(player, boostType)
end

function BoostService:getBoost(player, boostType)
end

function BoostService:spawnBoost(boostType, position)
    local boost = Instance.new("Part")
    boost.Name = boostType
    boost.Position = position
    boost.Parent = workspace
    boost.CanCollide = false
    boost.Transparency = 0.5
    boost.Size = Vector3.new(1, 1, 1)
    boost.Color = Color3.fromRGB(255, 255, 255)
    boost.Anchored = true
end

return BoostService