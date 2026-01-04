---@class AnimationService
---@field diContainer DIContainer
---@field _animTracks table<string, AnimationTrack>
local AnimationService = {}
AnimationService.__index = AnimationService

---@param diContainer DIContainer
---@return AnimationService
function AnimationService.new(diContainer)
	local self = setmetatable({}, AnimationService)
	self.diContainer = diContainer
	self._animTracks = {}
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

	self._animTracks["flyIdle"] = animTrack
end

function AnimationService:deactivateFlyingIdle()
	if self._animTracks["flyIdle"] then
		self._animTracks["flyIdle"]:Stop()
		self._animTracks["flyIdle"] = nil
	end
end

return AnimationService
