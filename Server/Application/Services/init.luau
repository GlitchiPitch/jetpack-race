local PlayerService = require(script.PlayerService)

---@class ServerApplicationServices
---@field playerService PlayerService
local Services = {}
Services.__index = Services

---@param diContainer DIContainer
---@param sharedIoCContainer DIContainer
---@return ServerApplicationServices
function Services.new(diContainer, sharedIoCContainer)
    local self = setmetatable({}, Services)
    self.diContainer = diContainer
    local remoteEventService = sharedIoCContainer:resolve("RemoteEventService")
    self.playerService = PlayerService.new(self.diContainer, remoteEventService)
    return self
end

function Services:init()
    self.playerService:init()
end

return Services