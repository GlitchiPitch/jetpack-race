---@class FlyingSystemClientFlyingService
local FlyingService = {}
FlyingService.__index = FlyingService

---@param diContainer DIContainer
---@return FlyingSystemClientFlyingService
function FlyingService.new(diContainer)
	local self = setmetatable({}, FlyingService)
	self.diContainer = diContainer
	self._jetpackEquipped = false
	return self
end

function FlyingService:init()
	---@type FlyingSystemClientRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()

	-- Listen for enable forward movement event
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	local RaceSystemConstants = self.diContainer:resolve("RaceSystemConstants")
	warn(RaceSystemConstants)
	remoteEventService:connectToEvent(RaceSystemConstants.REMOTE_EVENTS.ENABLE_FORWARD_MOVEMENT, function()
		warn("FlyingService: Received enable forward movement event")
		flyingEntity:setAutoForwardMovement(true)
	end)

	flyingEntity.isActive.Changed:Connect(function(value)
		warn("FlyingService: isActive changed to:", value)
		print(value)
	end)
	flyingEntity.speedMultiplier.Changed:Connect(function(value)
		print(value)
	end)
	flyingEntity.sprintActivated.Changed:Connect(function(value)
		print(value)
	end)

	-- Add jetpack state change listener
	if flyingEntity.jetpackState then
		flyingEntity.jetpackState.Changed:Connect(function(value)
			warn("FlyingService: jetpackState changed to:", value)
		end)
		warn("FlyingService: Initial jetpackState:", flyingEntity.jetpackState.Value)
	else
		warn("FlyingService: jetpackState not found!")
	end

	warn("FlyingService: flyingEntity:", flyingEntity)

	-- Listen for jetpack being equipped via accessory added
	self:_setupJetpackDetection()
end

function FlyingService:_setupJetpackDetection()
	local player = game.Players.LocalPlayer
	if not player then
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	warn("FlyingService: Setting up jetpack detection for character:", character)

	-- Listen for accessory added to character (accessories are children of character, not humanoid)
	character.ChildAdded:Connect(function(child)
		if child:IsA("Accessory") and child.Name == "Default Jetpack" then
			warn("FlyingService: Jetpack accessory detected")
			self:_onJetpackEquipped(child)
		end
	end)

	-- Also listen to humanoid accessory changes (just in case)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.ChildAdded:Connect(function(child)
		if child:IsA("Accessory") and child.Name == "Default Jetpack" then
			warn("FlyingService: Jetpack accessory detected on humanoid")
			self:_onJetpackEquipped(child)
		end
	end)

	-- Check if jetpack already exists
	local accessories = humanoid:GetAccessories()
	for _, accessory in ipairs(accessories) do
		if accessory.Name == "Default Jetpack" then
			warn("FlyingService: Existing jetpack found")
			self:_onJetpackEquipped(accessory)
			break
		end
	end

	-- Also check character children for accessories
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Accessory") and child.Name == "Default Jetpack" then
			warn("FlyingService: Found jetpack in character children")
			self:_onJetpackEquipped(child)
			break
		end
	end

	-- Set up a periodic check for jetpack (in case it's added later)
	task.spawn(function()
		while true do
			task.wait(0.5) -- Check every 0.5 seconds
			if not self._jetpackEquipped then
				local currentAccessories = humanoid:GetAccessories()
				for _, accessory in ipairs(currentAccessories) do
					if accessory.Name == "Default Jetpack" then
						warn("FlyingService: Jetpack found during periodic check")
						self:_onJetpackEquipped(accessory)
						self._jetpackEquipped = true
						break
					end
				end

				-- Also check character children
				for _, child in ipairs(character:GetChildren()) do
					if child:IsA("Accessory") and child.Name == "Default Jetpack" then
						warn("FlyingService: Jetpack found in character children during periodic check")
						self:_onJetpackEquipped(child)
						self._jetpackEquipped = true
						break
					end
				end
			end
		end
	end)
end

function FlyingService:_onJetpackEquipped(jetpack)
	warn("FlyingService: Calling JetpackService:equipJetpack")
	self._jetpackEquipped = true
	local jetpackService = self.diContainer:resolve("JetpackService")
	jetpackService:equipJetpack(jetpack)
end

return FlyingService
