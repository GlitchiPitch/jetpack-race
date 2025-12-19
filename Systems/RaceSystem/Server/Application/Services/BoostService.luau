---@class RaceSystemServerBoostService
local BoostService = {}
BoostService.__index = BoostService

---@return RaceSystemServerBoostService
function BoostService.new()
	local self = setmetatable({}, BoostService)
	self.activeBoosts = {} -- boostId -> boost data
	self.boostCounter = 0
	return self
end

function BoostService:init()
	warn("BoostService: Initialized")
end

function BoostService:applyBoost(player, boostType)
	warn("BoostService: Applying boost", boostType, "to player", player.Name)
	-- TODO: Implement boost effect application through FlyingSystem
end

function BoostService:removeBoost(player, boostType)
	warn("BoostService: Removing boost", boostType, "from player", player.Name)
	-- TODO: Implement boost effect removal through FlyingSystem
end

function BoostService:getBoost(player, boostType)
	warn("BoostService: Getting boost", boostType, "for player", player.Name)
	-- TODO: Implement boost status retrieval
	return nil
end

-- Enhanced spawnBoost with timer and trigger
function BoostService:spawnBoost(boostType, position, duration)
	self.boostCounter = self.boostCounter + 1
	local boostId = "boost_" .. self.boostCounter

	local boost = Instance.new("Part")
	boost.Name = boostType
	boost.Position = position
	boost.Parent = workspace
	boost.CanCollide = false
	boost.Transparency = 0.2
	boost.Size = Vector3.new(5, 5, 5)
	boost.Color = Color3.fromRGB(49, 13, 255)
	boost.Anchored = true

	-- Add boost metadata
	local boostData = {
		id = boostId,
		type = boostType,
		part = boost,
		position = position,
		spawnedAt = tick(),
		duration = 30, --duration or 30, -- 30 sec default
	}

	self.activeBoosts[boostId] = boostData

	-- Setup proximity prompt for collection
	local trigger = Instance.new("ProximityPrompt")
	trigger.ActionText = "Collect " .. boostType
	trigger.ObjectText = "Boost"
	trigger.Parent = boost

	trigger.Triggered:Connect(function(player)
		self:collectBoost(player, boostId)
	end)

	-- Auto-despawn after duration
	task.delay(duration, function()
		self:removeBoostById(boostId)
	end)

	warn("BoostService: Spawned boost", boostId, "of type", boostType, "at position", tostring(position))
	return boostId
end

-- Spawn boost at specific waypoint
function BoostService:spawnBoostAtWaypoint(boostType, waypointIndex, duration)
	local waypoints = workspace.JetpackRace.RaceTrack.BoostWaypoints
	local waypoint = waypoints:FindFirstChild(waypointIndex)

	if not waypoint then
		warn("BoostService: Waypoint not found:", waypointIndex)
		return nil
	end

	local position = waypoint.Position + Vector3.new(0, 5, 0) -- Above waypoint
	return self:spawnBoost(boostType, position, duration)
end

-- Spawn boosts along the entire track
function BoostService:spawnBoostsAlongTrack(boostType, spacing, duration)
	local waypoints = workspace.JetpackRace.RaceTrack.SpawnBoosterZones
	local boostIds = {}

	if not waypoints then
		warn("BoostService: WayPoints not found in RaceTrack")
		return boostIds
	end

	-- Get all waypoint children and sort them by index
	local waypointChildren = waypoints:GetChildren()
	table.sort(waypointChildren, function(a, b)
		local aIndex = tonumber(a.Name) or 0
		local bIndex = tonumber(b.Name) or 0
		return aIndex < bIndex
	end)

	for i, waypoint in ipairs(waypointChildren) do
		if i % spacing == 0 then -- Every Nth waypoint
			local waypointIndex = tonumber(waypoint.Name)
			if waypointIndex then
				local boostId = self:spawnBoostAtWaypoint(boostType, waypointIndex, duration)
				if boostId then
					table.insert(boostIds, boostId)
				end
			end
		end
	end

	warn("BoostService: Spawned", #boostIds, "boosts along track with spacing", spacing)
	return boostIds
end

-- Spawn random boost in area
function BoostService:spawnRandomBoost(boostType, centerPosition, radius, duration)
	local angle = math.random() * math.pi * 2
	local distance = math.random() * radius

	local offset = Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)

	local position = centerPosition + offset
	return self:spawnBoost(boostType, position, duration)
end

-- Player collects boost
function BoostService:collectBoost(player, boostId)
	local boostData = self.activeBoosts[boostId]
	if not boostData then
		warn("BoostService: Boost not found for collection:", boostId)
		return
	end

	warn("BoostService: Player", player.Name, "collected boost", boostId, "of type", boostData.type)

	-- Apply boost effect to player
	self:applyBoost(player, boostData.type)

	-- Remove the boost
	self:removeBoostById(boostId)
end

-- Remove boost by ID
function BoostService:removeBoostById(boostId)
	local boostData = self.activeBoosts[boostId]
	if not boostData then
		return
	end

	if boostData.part and boostData.part.Parent then
		boostData.part:Destroy()
		warn("BoostService: Destroyed boost part for", boostId)
	end

	self.activeBoosts[boostId] = nil
end

-- Cleanup expired boosts
function BoostService:cleanupExpiredBoosts()
	local currentTime = tick()
	local removedCount = 0

	for boostId, boostData in pairs(self.activeBoosts) do
		if currentTime - boostData.spawnedAt > boostData.duration then
			self:removeBoostById(boostId)
			removedCount = removedCount + 1
		end
	end

	if removedCount > 0 then
		warn("BoostService: Cleaned up", removedCount, "expired boosts")
	end
end

return BoostService
