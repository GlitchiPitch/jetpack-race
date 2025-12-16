---@class FlyingSystemClientFlyingService
local FlyingService = {}
FlyingService.__index = FlyingService

---@param diContainer DIContainer
---@return FlyingSystemClientFlyingService
function FlyingService.new(diContainer)
	local self = setmetatable({}, FlyingService)
	self.diContainer = diContainer
	return self
end

function FlyingService:init()
	---@type FlyingSystemClientRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()

    flyingEntity.isActive.Changed:Connect(function(value)
        print(value)
    end)
    flyingEntity.speedMultiplier.Changed:Connect(function(value)
        print(value)
    end)
    flyingEntity.chargeLevel.Changed:Connect(function(value)
        print(value)
    end)
    flyingEntity.sprintActivated.Changed:Connect(function(value)
        print(value)
    end)
    flyingEntity.maxCharge.Changed:Connect(function(value)
        print(value)
    end)

    warn(flyingEntity)
end



return FlyingService
