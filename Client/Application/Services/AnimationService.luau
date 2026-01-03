---@class AnimationService
---@field diContainer DIContainer
local AnimationService = {}
AnimationService.__index = AnimationService

---@param diContainer DIContainer
function AnimationService.new(diContainer)
    local self = setmetatable({}, AnimationService)
    self.diContainer = diContainer
    return self
end

function AnimationService:activateFlyingIdle()
    ---@type Shared
    local shared = self.diContainer:resolve("Shared")
    ---@type ClientInfrastructure
    local infrastucture = self.diContainer:resolve("Infrastructure")
    local animations = shared.Assets.Animations
    local playerEntity = infrastucture.repositories.playerRepository:getPlayerEntity()
    local animator = playerEntity:getAnimator()
    local animTrack = animator:LoadAnimation(animations.flyIdle)
    animTrack.Looped = true
    animTrack:Play()
end

return AnimationService