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

	warn(remoteEventService)
	warn(constants)
	-- Listen for race preparing event
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.RACE_PREPARING, function(data)
		self:onRacePreparing(data.preparationTime)
	end)

	-- Listen for race started event
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.RACE_STARTED, function(_data)
		self:onRaceStarted()
	end)

	-- Listen for race finished event
	remoteEventService:connectToEvent(constants.REMOTE_EVENTS.RACE_FINISHED, function(_data)
		self:onRaceFinished()
	end)
end

---@param preparationTime number
function RaceService:onRacePreparing(preparationTime)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemClientRaceService", "Race preparing, countdown:", preparationTime)

	self.raceState = "Preparing"

	-- Start countdown sequence
	self:startCountdown()
end

function RaceService:startCountdown()
	local countdownSequence = {3, 2, 1, "Go!"}
	local currentIndex = 1

	local function showNextNumber()
		if currentIndex <= #countdownSequence then
			local text = countdownSequence[currentIndex]
			self:showRaceUI(tostring(text), 1)
			currentIndex = currentIndex + 1

			-- Schedule next number after 1 second
			task.delay(1, showNextNumber)
		end
	end

	-- Start the countdown
	showNextNumber()
end

function RaceService:onRaceStarted()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemClientRaceService", "Race started!")

	self.raceState = "Started"

	-- Set race started flag in FlyingEntity
	---@type FlyingSystemClientRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()
	flyingEntity:setRaceStarted(true)

	-- Race started UI is now handled by countdown sequence
	-- No need to show additional message here
end

function RaceService:onRaceFinished()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")

	logger:info("RaceSystemClientRaceService", "Race finished!")

	self.raceState = "Finished"

	-- Reset race started flag in FlyingEntity
	---@type FlyingSystemClientRepository
	local flyingRepository = self.diContainer:resolve("FlyingRepository")
	local flyingEntity = flyingRepository:getFlyingEntity()
	flyingEntity:setRaceStarted(false)

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
	frame.Size = UDim2.fromScale(0.5, 0.2)
	frame.Position = UDim2.fromScale(0.25, 0.4)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.3
	frame.BorderSizePixel = 2
	frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
	frame.Parent = notification

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.fromScale(1, 1)
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
