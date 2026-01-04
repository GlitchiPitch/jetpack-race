local Players = game:GetService("Players")
--- @class ServerBoostsService
--- @field diContainer DIContainer
--- @field folder Folder
--- @field pointIndex number
--- @field points table<number, table<any, any>>
local BoostsService = {}
BoostsService.__index = BoostsService

---@param diContainer DIContainer
function BoostsService.new(diContainer)
	local self = setmetatable({}, BoostsService)
	self.diContainer = diContainer
	self.points = {}
	self.pointIndex = 1
	self.folder = Instance.new("Folder")

	self:_setup()
	return self
end

function BoostsService:_setup()
	self.folder.Name = "Boosts"
	self.folder.Parent = workspace.Workspace
end

function BoostsService:generate()
	---@type ServerInfrastructure
	local infrastructure = self.diContainer:resolve("Infrastructure")
	---@type Shared
	local shared = self.diContainer:resolve("Shared")
	---@type ServerApplication
	local application = self.diContainer:resolve("Application")

	---@param hit BasePart
	local function touchCallback(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			local playerEntity = application.services.playerService:getPlayerEntity(player)
			playerEntity.jetpack.nitro += 5
			return true
		end

		return false
	end

	-- local boostTrajectories = {
	-- 	{
	-- 		startPos = Vector3.new(50, 20, 0),
	-- 		endPos = Vector3.new(550, 20, 0),
	-- 		controlDelta = Vector3.new(0, 0, 0),
	-- 	},
	-- 	{
	-- 		startPos = Vector3.new(650, 20, 0),
	-- 		endPos = Vector3.new(1150, 200, 0),
	-- 		controlDelta = Vector3.new(0, 150, 0),
	-- 	},
	-- 	{
	-- 		startPos = Vector3.new(1200, 200, 0),
	-- 		endPos = Vector3.new(1200, 200, -800),
	-- 		controlDelta = Vector3.new(800, 0, 0),
	-- 	},
	-- 	{
	-- 		startPos = Vector3.new(1200, 200, -950),
	-- 		endPos = Vector3.new(1200, 200, -1450),
	-- 		controlDelta = Vector3.new(-800, 0, 0),
	-- 	},
	-- }

	-- local minDistance = 100

	local points = {} --infrastructure.services.trajectoryPathService:generateTrack(boostTrajectories, minDistance)

	for _, v in workspace.Workspace.BoostZones:GetChildren() do
		table.insert(points, v.Position)
	end

	-- Optionally orient all parts to face the next part
	for i = 1, #points do
		local currentPart = points[i]
		local pointCFrame = CFrame.new(currentPart)
		local p = shared.Domain.Entities.Boost.new({
			_instance = shared.Assets.Boost.Nitro:Clone(),
			cframe = pointCFrame,
			parent = self.folder,
		}, touchCallback)

		self.points[self.pointIndex] = {
			point = currentPart,
			instance = p._instance,
			index = self.pointIndex,
		}

		self.pointIndex += 1
	end
end

function BoostsService:clear() end

return BoostsService
