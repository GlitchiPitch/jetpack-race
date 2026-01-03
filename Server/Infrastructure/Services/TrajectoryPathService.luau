---@class TrajectoryPathService
---@field diContainer DIContainer
---@field folder Folder
---@field pointIndex number
local TrajectoryPathService = {}
TrajectoryPathService.__index = TrajectoryPathService

-- Generate quadratic Bézier curve point
local function quadraticBezierPoint(t: number, p0: Vector3, p1: Vector3, p2: Vector3): Vector3
	local u = 1 - t
	local tt = t * t
	local uu = u * u
	return uu * p0 + 2 * u * t * p1 + tt * p2
end

---@param diContainer DIContainer
---@return TrajectoryPathService
function TrajectoryPathService.new(diContainer)
	local self = setmetatable({}, TrajectoryPathService)
	self.diContainer = diContainer
	return self
end

---@class jetpackTrajectory
---@field startPos Vector3
---@field endPos Vector3
---@field controlDelta Vector3


---@param jetpackTrajectories jetpackTrajectory[]
---@param minDistance number
---@return Vector3[]
function TrajectoryPathService:generateTrack(jetpackTrajectories, minDistance)
	local allParts = {}

	for _, def in ipairs(jetpackTrajectories) do
		local midPoint = (def.startPos + def.endPos) / 2
		local controlPoint = midPoint + def.controlDelta
		local controlPoints = { def.startPos, controlPoint, def.endPos }
		local segmentParts = self:generatePathWithMinDistance(controlPoints, minDistance)
		for _, part in ipairs(segmentParts or {}) do
			table.insert(allParts, part)
		end
	end

	return allParts
end

-- Generate path with minimum distance between points
-- @param controlPoints: {startPoint, controlPoint, endPoint}
-- @param minDistance: minimum distance between consecutive points
-- @return {Vector3}: array of points with controlled spacing
function TrajectoryPathService:generatePathWithMinDistance(controlPoints: { Vector3 }, minDistance: number): { Vector3 }
	local path = {}
	local p0, p1, p2 = controlPoints[1], controlPoints[2], controlPoints[3]

	table.insert(path, p0) -- Always include start point

	local previousPoint = p0
	local totalLength = 0

	-- First pass: calculate approximate total curve length
	local testSegments = 100
	for i = 1, testSegments do
		local t1 = (i - 1) / testSegments
		local t2 = i / testSegments

		local point1 = quadraticBezierPoint(t1, p0, p1, p2)
		local point2 = quadraticBezierPoint(t2, p0, p1, p2)

		totalLength += (point2 - point1).Magnitude
	end

	-- Second pass: sample points with minimum distance
	local estimatedSegments = math.ceil(totalLength / minDistance)
	local step = 1 / estimatedSegments

	for i = 1, estimatedSegments - 1 do
		local t = i * step
		local point = quadraticBezierPoint(t, p0, p1, p2)

		-- Check distance from previous point
		if (point - previousPoint).Magnitude >= minDistance then
			table.insert(path, point)
			previousPoint = point
		end
	end

	table.insert(path, p2) -- Always include end point
	return path
end

-- Filter existing path to ensure minimum distance between points
-- @param path: array of Vector3 points
-- @param minDistance: minimum distance between consecutive points
-- @return {Vector3}: filtered array with controlled spacing
function TrajectoryPathService:filterPathPoints(path: { Vector3 }, minDistance: number): { Vector3 }
	if #path <= 2 then
		return path
	end

	local filteredPath = { path[1] } -- Always keep first point
	local previousPoint = path[1]

	for i = 2, #path - 1 do
		local currentPoint = path[i]
		if (currentPoint - previousPoint).Magnitude >= minDistance then
			table.insert(filteredPath, currentPoint)
			previousPoint = currentPoint
		end
	end

	table.insert(filteredPath, path[#path]) -- Always keep last point
	return filteredPath
end

-- Generate path with fixed number of points (reduces density)
-- @param controlPoints: {startPoint, controlPoint, endPoint}
-- @param numPoints: desired number of points (lower = more spacing)
-- @return {Vector3}: array with specified number of points
function TrajectoryPathService:generateSparsePath(controlPoints: { Vector3 }, numPoints: number): { Vector3 }
	local path = {}
	local p0, p1, p2 = controlPoints[1], controlPoints[2], controlPoints[3]

	for i = 0, numPoints - 1 do
		local t = i / (numPoints - 1) -- Ensure t goes from 0 to 1
		local point = quadraticBezierPoint(t, p0, p1, p2)
		table.insert(path, point)
	end

	return path
end

return TrajectoryPathService
