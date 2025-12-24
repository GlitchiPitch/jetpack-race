---@class SharedRingsService
local RingsService = {}
RingsService.__index = RingsService

---@return SharedRingsService
function RingsService.new(diContainer)
	local self = setmetatable({}, RingsService)
	self.diContainer = diContainer
	return self
end

function RingsService:init()
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RingsService", "Initializing RingsService...")

	self.assets = self.diContainer:resolve("Shared.Assets")
end

---@param race RaceEntity
---@param ringFolder Instance
---@param waypoints Instance?
function RingsService:createRings(race, ringFolder, waypoints)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RingsService", "Creating rings for race:", race.id)

	---@type RaceSystemEntities
	local entities = self.diContainer:resolve("Entities")
	local raceEntity = entities.Race.new({
		id = race.id,
	})

	-- Get checkpoint waypoints or use default positions
	local checkpointPositions = self:_getCheckpointPositions(waypoints)

	for i, position in ipairs(checkpointPositions) do
		---@type RingEntity
		local ringEntity = entities.Ring.new({
			model = self.assets.Ring:Clone(),
			parent = ringFolder,
			checkpointId = i,
			position = position,
		})

		raceEntity.rings[tostring(i)] = ringEntity
		raceEntity.totalCheckpoints = raceEntity.totalCheckpoints + 1
	end

	logger:debug("RingsService", "Created", raceEntity.totalCheckpoints, "rings for race:", race.id)
	return raceEntity
end

---@param waypoints Instance?
---@return table<number, CFrame>
function RingsService:_getCheckpointPositions(waypoints)
	local positions = {}

	-- If waypoints provided, use them
	if waypoints then
		local waypointChildren = waypoints:GetChildren()
		table.sort(waypointChildren, function(a, b)
			local aIndex = tonumber(a.Name) or 0
			local bIndex = tonumber(b.Name) or 0
			return aIndex < bIndex
		end)

		for _, waypoint in ipairs(waypointChildren) do
			local position = waypoint.Position + Vector3.new(0, 3, 0) -- Slightly above waypoint
			table.insert(positions, CFrame.new(position))
		end
	else
		-- Default positions for testing (10 rings in a line)
		for i = 1, 10 do
			local position = Vector3.new(i * 20, 10, 0)
			table.insert(positions, CFrame.new(position))
		end
	end

	return positions
end

return RingsService
