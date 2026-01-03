local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
---@class ClientPresentationRaceService
---@field diContainer DIContainer
---@field player Player
---@field _triggers Model[]
local RaceService = {}
RaceService.__index = RaceService

---@param diContainer DIContainer
---@return ClientPresentationRaceService
function RaceService.new(diContainer)
	local self = setmetatable({}, RaceService)
	self.diContainer = diContainer
	self.player = Players.LocalPlayer
	self._triggers = {}
	return self
end

function RaceService:init()
	---@type Shared
	local shared = self.diContainer:resolve("Shared")

	---@param trigger Model
	local function onInstanceAdded(trigger)
		if not table.find(self._triggers, trigger) and trigger:IsDescendantOf(Workspace) then
			self:_setupTrigger(trigger)
		end
	end

	---@param trigger Model
	local function onInstanceRemoved(trigger) end

	for _, trigger in CollectionService:GetTagged(shared.Constants.TAGS.TRIGGER_ZONE) do
		
		onInstanceAdded(trigger)
	end

	CollectionService:GetInstanceAddedSignal(shared.Constants.TAGS.TRIGGER_ZONE):Connect(onInstanceAdded)
	CollectionService:GetInstanceRemovedSignal(shared.Constants.TAGS.TRIGGER_ZONE):Connect(onInstanceRemoved)
end

---@param trigger Model
function RaceService:_setupTrigger(trigger)
	---@type Presentation
	local presentation = self.diContainer:resolve("Presentation")
	---@param player Player
	local function callback(player)
		self:_triggered(player)
	end

	local prompt = presentation.ui.Components.CustomPrompt.new(trigger.PrimaryPart)
	prompt:setCallback(callback)

	table.insert(self._triggers, trigger)
end

---@param player Player
function RaceService:_triggered(player)
	if player == self.player then
		---@type ClientApplication
		local application = self.diContainer:resolve("Application")
		application.services.raceService:activateTrigger()
	end
end

return RaceService
