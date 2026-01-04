--- AnimationService - Client-side animation management for player actions
---
--- This service handles loading and controlling character animations,
--- specifically designed for jetpack flight mechanics and player state changes.
---
--- Key Features:
--- - Loads and manages animation tracks from the Shared Assets
--- - Controls flight idle animations during jetpack operation
--- - Provides clean animation state management (play/stop/reset)
--- - Integrates with player entity system for character access
---
--- Animation States:
--- - **flyIdle**: Looping animation played during jetpack flight
--- - Supports smooth transitions between animation states
---
--- @class AnimationService
--- @field diContainer DIContainer Dependency injection container for resolving other services
--- @field _animTracks table<string, AnimationTrack> Map of animation names to their AnimationTrack instances
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
