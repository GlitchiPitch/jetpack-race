---@class AccessoryService
---@field diContainer DIContainer
local AccessoryService = {}
AccessoryService.__index = AccessoryService

---@param diContainer DIContainer
---@return AccessoryService
function AccessoryService.new(diContainer)
	local self = setmetatable({}, AccessoryService)
	self.diContainer = diContainer
	self.activeEffects = {} -- player -> {effectId -> effectInstance}

	return self
end

---@param player Player
function AccessoryService:applyPlayerAccessories(player)
	local logger = self.diContainer:resolve("Logger")
	local playerService = self.diContainer:resolve("PlayerService")
	local playerEntity = playerService:getPlayerEntity(player)

	if not playerEntity then
		logger:warn("AccessoryService", "Player entity not found for:", player.Name)
		return
	end

	-- Clear existing effects for this player
	self:clearPlayerEffects(player)

	-- Get player's equipped accessories
	local accessories = playerEntity:getAccessories()
	local shopData = self.diContainer:resolve("Shared.Data")

	-- Apply jetpack effects
	local jetpackId = playerEntity:getJetpack()
	if jetpackId and jetpackId ~= "Default Jetpack" then
		local jetpackData = nil
		for _, item in ipairs(shopData.ShopItems) do
			if item.id == jetpackId then
				jetpackData = item
				break
			end
		end

		if jetpackData then
			self:_applyJetpackEffect(player, jetpackData)
		end
	end

	-- Apply trail effects
	local trailAccessories = playerEntity:getAccessoriesByType("trail")
	for _, trailAccessory in ipairs(trailAccessories) do
		local trailData = nil
		for _, item in ipairs(shopData.ShopItems) do
			if item.id == trailAccessory.id then
				trailData = item
				break
			end
		end

		if trailData then
			self:_applyTrailEffect(player, trailData)
		end
	end

	-- Apply general effect accessories
	local effectAccessories = playerEntity:getAccessoriesByType("effect")
	for _, effectAccessory in ipairs(effectAccessories) do
		local effectData = nil
		for _, item in ipairs(shopData.ShopItems) do
			if item.id == effectAccessory.id then
				effectData = item
				break
			end
		end

		if effectData then
			self:_applyEffect(player, effectData)
		end
	end

	logger:info("AccessoryService", "Applied accessories for player:", player.Name)
end

---@param player Player
---@param jetpackData table
function AccessoryService:_applyJetpackEffect(player, jetpackData)
	local logger = self.diContainer:resolve("Logger")

	-- Find player's character and jetpack model
	local character = player.Character
	if not character then
		logger:warn("AccessoryService", "Character not found for player:", player.Name)
		return
	end

	-- This would need integration with the FlyingSystem to modify jetpack appearance/behavior
	-- For now, we'll just log the effect application
	logger:info("AccessoryService", "Applying jetpack effect:", jetpackData.name, "to player:", player.Name)

	-- Store effect data for potential cleanup or modification
	if not self.activeEffects[player] then
		self.activeEffects[player] = {}
	end

	self.activeEffects[player][jetpackData.id] = {
		type = "jetpack",
		data = jetpackData,
		appliedAt = tick()
	}
end

---@param player Player
---@param trailData table
function AccessoryService:_applyTrailEffect(player, trailData)
	local logger = self.diContainer:resolve("Logger")

	local character = player.Character
	if not character then
		logger:warn("AccessoryService", "Character not found for player:", player.Name)
		return
	end

	-- Find the HumanoidRootPart or create attachment point for trails
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		logger:warn("AccessoryService", "HumanoidRootPart not found for player:", player.Name)
		return
	end

	-- Create trail attachment
	local trailAttachment = Instance.new("Attachment")
	trailAttachment.Name = "JetpackTrailAttachment"
	trailAttachment.Position = Vector3.new(0, -1, 0) -- Position behind the player
	trailAttachment.Parent = rootPart

	-- Create trail effect
	local trail = Instance.new("Trail")
	trail.Name = "JetpackTrail_" .. trailData.id
	trail.Attachment0 = trailAttachment
	trail.Attachment1 = trailAttachment
	trail.Color = ColorSequence.new(trailData.effectData.color or Color3.fromRGB(255, 255, 255))
	trail.Lifetime = trailData.effectData.lifetime or 2.0
	trail.Transparency = NumberSequence.new(0, 1)
	trail.WidthScale = NumberSequence.new(0.5, 0)
	trail.Parent = rootPart

	-- Store effect reference for cleanup
	if not self.activeEffects[player] then
		self.activeEffects[player] = {}
	end

	self.activeEffects[player][trailData.id] = {
		type = "trail",
		instances = {trailAttachment, trail},
		data = trailData,
		appliedAt = tick()
	}

	logger:info("AccessoryService", "Applied trail effect:", trailData.name, "to player:", player.Name)
end

---@param player Player
---@param effectData table
function AccessoryService:_applyEffect(player, effectData)
	local logger = self.diContainer:resolve("Logger")

	local character = player.Character
	if not character then
		logger:warn("AccessoryService", "Character not found for player:", player.Name)
		return
	end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		logger:warn("AccessoryService", "HumanoidRootPart not found for player:", player.Name)
		return
	end

	-- Create effect attachment point
	local effectAttachment = Instance.new("Attachment")
	effectAttachment.Name = "JetpackEffectAttachment_" .. effectData.id
	effectAttachment.Position = Vector3.new(0, 0, 0)
	effectAttachment.Parent = rootPart

	-- Create particle effect
	local particles = Instance.new("ParticleEmitter")
	particles.Name = "JetpackEffect_" .. effectData.id
	particles.Rate = effectData.effectData.emissionRate or 50
	particles.Lifetime = NumberRange.new(1, 2)
	particles.Speed = NumberRange.new(2, 5)
	particles.Size = NumberSequence.new(effectData.effectData.size.X or 0.5)
	particles.Color = ColorSequence.new(Color3.fromRGB(255, 200, 100)) -- Default golden color
	particles.Parent = effectAttachment

	-- Store effect reference for cleanup
	if not self.activeEffects[player] then
		self.activeEffects[player] = {}
	end

	self.activeEffects[player][effectData.id] = {
		type = "effect",
		instances = {effectAttachment, particles},
		data = effectData,
		appliedAt = tick()
	}

	logger:info("AccessoryService", "Applied effect:", effectData.name, "to player:", player.Name)
end

---@param player Player
function AccessoryService:clearPlayerEffects(player)
	local logger = self.diContainer:resolve("Logger")

	if not self.activeEffects[player] then
		return
	end

	for effectId, effectInfo in pairs(self.activeEffects[player]) do
		-- Destroy effect instances
		if effectInfo.instances then
			for _, instance in ipairs(effectInfo.instances) do
				if instance and instance.Parent then
					instance:Destroy()
				end
			end
		end

		logger:info("AccessoryService", "Cleared effect:", effectId, "for player:", player.Name)
	end

	self.activeEffects[player] = {}

	logger:info("AccessoryService", "Cleared all effects for player:", player.Name)
end

---@param player Player
---@return table -- Array of active effect IDs
function AccessoryService:getActiveEffects(player)
	if not self.activeEffects[player] then
		return {}
	end

	local activeEffectIds = {}
	for effectId, _ in pairs(self.activeEffects[player]) do
		table.insert(activeEffectIds, effectId)
	end

	return activeEffectIds
end

---@param player Player
function AccessoryService:removePlayer(player)
	if self.activeEffects[player] then
		self:clearPlayerEffects(player)
		self.activeEffects[player] = nil
	end
end

return AccessoryService
