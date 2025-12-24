---@class AssetsSpawnService
local AssetsSpawnService = {}
AssetsSpawnService.__index = AssetsSpawnService

---@return AssetsSpawnService
function AssetsSpawnService.new(diContainer)
	local self = setmetatable({}, AssetsSpawnService)
	self.assets = {}
	self.ringFolder = Instance.new("Folder")
	self.diContainer = diContainer
	return self
end

function AssetsSpawnService:init()
	self.ringFolder.Name = "Rings"
	self.ringFolder.Parent = workspace
end

---@param race RaceEntity
---@param waypoints Instance?
function AssetsSpawnService:spawnRing(race, waypoints)
	---@type SharedServices
	local services = self.diContainer:resolve("RingsService")
	local ringsService = services:createRings(race, self.ringFolder, waypoints)
	return ringsService
end

return AssetsSpawnService
