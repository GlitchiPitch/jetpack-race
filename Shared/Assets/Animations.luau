---@return Animation
local function _createAnimation(animationId)
	local animation = Instance.new("Animation")
	animation.AnimationId = animationId
	return animation
end

local Animations = {
	flyIdle = "rbxassetid://112369720793155",
}

for i, v in Animations do
	Animations[i] = _createAnimation(v)
end

return Animations
