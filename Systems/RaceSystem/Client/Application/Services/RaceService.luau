---@class RaceSystemClientRaceService
local RaceService = {}
RaceService.__index = RaceService

---@param diContainer DIContainer
---@return RaceSystemClientRaceService
function RaceService.new(diContainer)
	local self = setmetatable({}, RaceService)
	self.diContainer = diContainer
	self.raceState = "Idle"
	return self
end

function RaceService:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemClientRaceService", "Initializing RaceService...")

	self:setupRemoteEventListeners()

	logger:info("RaceSystemClientRaceService", "RaceService initialization completed")
end

function RaceService:setupRemoteEventListeners()
	---@type RemoteEventService
	local remoteEventService = self.diContainer:resolve("RemoteEventService")
	---@type RaceSystemConstants
	local constants = self.diContainer:resolve("Shared.Constants")

	-- Listen for race preparing event
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.RACE_PREPARING, function(data)
		self:onRacePreparing(data.preparationTime)
	end)

	-- Listen for race started event
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.RACE_STARTED, function(data)
		self:onRaceStarted()
	end)

	-- Listen for race finished event
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.RACE_FINISHED, function(data)
		self:onRaceFinished()
	end)
end

---@param preparationTime number
function RaceService:onRacePreparing(preparationTime)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemClientRaceService", "Race preparing, countdown:", preparationTime)

	self.raceState = "Preparing"

	-- Show preparation UI
	self:showRaceUI("Подготовка к гонке...", preparationTime)
end

function RaceService:onRaceStarted()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemClientRaceService", "Race started!")

	self.raceState = "Started"

	-- Show race started UI
	self:showRaceUI("Гонка началась! Ждите разрешения на движение...", 1)
end

function RaceService:onRaceFinished()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemClientRaceService", "Race finished!")

	self.raceState = "Finished"

	-- Show race finished UI
	self:showRaceUI("Гонка завершена!", 2)

	-- Reset race state after delay
	task.delay(2, function()
		self.raceState = "Idle"
		self:hideRaceUI()
	end)
end

---@param message string
---@param duration number
function RaceService:showRaceUI(message, duration)
	-- Create or update UI notification
	local player = game.Players.LocalPlayer
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then
		return
	end

	-- Remove existing notification
	local existingNotification = playerGui:FindFirstChild("RaceNotification")
	if existingNotification then
		existingNotification:Destroy()
	end

	-- Create new notification
	local notification = Instance.new("ScreenGui")
	notification.Name = "RaceNotification"
	notification.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.5, 0, 0.2, 0)
	frame.Position = UDim2.new(0.25, 0, 0.4, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.3
	frame.BorderSizePixel = 2
	frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
	frame.Parent = notification

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = message
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = frame

	-- Auto-hide after duration
	if duration > 0 then
		task.delay(duration, function()
			if notification.Parent then
				notification:Destroy()
			end
		end)
	end
end

function RaceService:hideRaceUI()
	local player = game.Players.LocalPlayer
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then
		return
	end

	local notification = playerGui:FindFirstChild("RaceNotification")
	if notification then
		notification:Destroy()
	end
end

---@return string
function RaceService:getRaceState()
	return self.raceState
end

return RaceService
