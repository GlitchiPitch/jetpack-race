---@class BoostEntity
---@field _instance Model
---@field _isRobux boolean
---@field _hitbox Part
---@field _isTouched boolean
---@field _touchCallback function
local BoostEntity = {}
BoostEntity.__index = BoostEntity

---@class boostData
---@field _instance Model
---@field cframe CFrame
---@field parent Instance

---@param boostData boostData
---@param touchCallback function
---@return BoostEntity
function BoostEntity.new(boostData, touchCallback)
	local self = setmetatable({}, BoostEntity)
	self._instance = boostData._instance
	self._isRobux = boostData.isRobux or false
	self._instance:PivotTo(boostData.cframe)
	self._instance.Parent = boostData.parent
	self._touchCallback = touchCallback
	self._isTouched = false
	self:_setup()
	return self
end

function BoostEntity:_setup()
	---@param hit Instance
	local function onTouched(hit)
		if self._isTouched then
			return
		end

		if self._touchCallback(hit) then
			self:destroy()
		end
	end

	self._hitbox = Instance.new("Part")
	self._hitbox.Transparency = 0.5
	self._hitbox.Anchored = true
	self._hitbox.Size = Vector3.one * 20
	self._hitbox.CFrame = self._instance.PrimaryPart.CFrame
	self._hitbox.Parent = self._instance
	self._hitbox.Shape = Enum.PartType.Ball
	self._hitbox.CanCollide = false
	self._hitbox.CanQuery = false

	self._hitboxConnect = self._hitbox.Touched:Connect(onTouched)
end

function BoostEntity:destroy()
	self._hitboxConnect:Disconnect()
	self._hitbox:Destroy()
	self._instance:Destroy()
end

return BoostEntity
