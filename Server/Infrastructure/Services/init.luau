local TrajectoryPathService = require(script.TrajectoryPathService)

---@class ServerInfrastructureServices
---@field diContainer DIContainer
---@field trajectoryPathService TrajectoryPathService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
function Services.new(diContainer)
   local self = setmetatable({}, Services)
   self.diContainer = diContainer
   self.trajectoryPathService = TrajectoryPathService.new()
   return self 
end

return Services