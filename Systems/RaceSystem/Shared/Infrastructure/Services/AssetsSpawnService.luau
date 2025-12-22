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
function AssetsSpawnService:spawnRing(race)

    ---@type SharedServices
    local services = self.diContainer:resolve("RingsService")
    local ringsService = services:createRings(race, self.ringFolder)
    return ringsService
end

return AssetsSpawnService