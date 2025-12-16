---@class RaceSystemServerRaceService
local RaceService = {}
RaceService.__index = RaceService

---@param diContainer DIContainer
---@return RaceSystemServerRaceService
function RaceService.new(diContainer)
	local self = setmetatable({}, RaceService)
	self.diContainer = diContainer
	return self
end

function RaceService:init()
    warn("RaceService:init")
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemServerRaceService", "Initializing RaceService...")
    self:setupProximityPrompt(workspace.JetpackRace.TriggerZone)
end

function RaceService:setupProximityPrompt(triggerZone)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	local proximityPrompt = triggerZone:FindFirstChild("ProximityPrompt")
	if not proximityPrompt then
		logger:warn("RaceSystemServerRaceService", "ProximityPrompt not found in TriggerZone")
		return
	end

    proximityPrompt.ActionText = "Start Race"
	proximityPrompt.Triggered:Connect(function(player)
		local character = player.Character
		if not character then return end

		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid then return end

		-- Проверить, есть ли уже джетпак у игрока
		local hasJetpack = false
		for _, accessory in ipairs(humanoid:GetAccessories()) do
			if accessory.Name == "Default Jetpack" then
				hasJetpack = true
				break
			end
		end

		if not hasJetpack then
			-- Выдать джетпак игроку через JetpackService
			---@type FlyingSystemServerJetpackService
			local jetpackService = self.diContainer:resolve("JetpackService")
			jetpackService:equipDefaultJetpack(player)
			logger:info("RaceSystemServerRaceService", "Equipped Default Jetpack to player:", player.Name)
		end
	end)
end



return RaceService