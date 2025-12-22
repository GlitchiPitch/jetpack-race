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
---@param ringFolder RaceEntity
function RingsService:createRings(race, ringFolder)
	---@type LoggerService
	local logger = self.diContainer:resolve("Logger")
	logger:debug("RingsService", "Creating rings for race:", race.id)

    ---@type RaceSystemEntities
    local entities = self.diContainer:resolve("Entities")
    local raceEntity = entities.Race.new({
        id = race.id,
    })
    
	for i = 1, 10 do
		---@type RingEntity
        local ringEntity = entities.Ring.new({
            model = self.assets.Ring,
            parent = ringFolder,
        })
    
		raceEntity.rings[ringEntity.id] = ringEntity
	end

    return raceEntity
end

return RingsService
