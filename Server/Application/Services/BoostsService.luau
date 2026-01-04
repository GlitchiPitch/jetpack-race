---@class ServerBoostsService
---@field diContainer DIContainer
local BoostsService = {}
BoostsService.__index = BoostsService


---@param diContainer DIContainer
function BoostsService.new(diContainer)
    local self = setmetatable({}, BoostsService)
    self.diContainer = diContainer
    return self
end

function BoostsService:generate()
	---@type ServerInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type Shared
	local shared = self.diContainer:resolve("Shared")

	local boostTrajectories = {
		{
			startPos = Vector3.new(50, 20, 0),
			endPos = Vector3.new(550, 20, 0),
			controlDelta = Vector3.new(0, 0, 0),
		},
		{
			startPos = Vector3.new(650, 20, 0),
			endPos = Vector3.new(1150, 200, 0),
			controlDelta = Vector3.new(0, 150, 0),
		},
		{
			startPos = Vector3.new(1250, 200, 0),
			endPos = Vector3.new(1250, 200, -800),
			controlDelta = Vector3.new(800, 0, 0),
		},
		{
			startPos = Vector3.new(1250, 200, -900),
			endPos = Vector3.new(1250, 200, -1400),
			controlDelta = Vector3.new(-800, 0, 0),
		},
	}

	local minDistance = 100

	local points = infrastructure.services.trajectoryPathService:generateTrack(boostTrajectories, minDistance)

	-- Optionally orient all parts to face the next part
	for i = 1, #points do
		local currentPart = points[i]
		local nextPart = points[i + 1]
		local pointCFrame

		if currentPart and nextPart then
			pointCFrame = CFrame.new(currentPart, nextPart)
		else
			pointCFrame = CFrame.new(currentPart, points[i - 1])
		end

		local p = shared.Domain.Entities.Boost.new({
			_instance = shared.Assets.Boost.Nitro:Clone(),
			cframe = pointCFrame,
			parent = self.folder,
		})

		self.points[self.pointIndex] = {
			point = currentPart,
			instance = p._instance,
			index = self.pointIndex,
		}

		self.pointIndex += 1
	end
end

function BoostsService:clear()
    
end

return BoostsService