local CompositionRoot = require(script.CompositionRoot.FlyingCompositionRoot)

---@class FlyingModuleServer
local Server = {}
Server.__index = Server

---@return FlyingModuleServer
function Server.new()
    local self = setmetatable({}, Server)
    self.controller = CompositionRoot:ComposeServer()
    return self
end

function Server:init()
    self.controller:Initialize()
end

function Server:cleanup()
    self.controller:Cleanup()
end

return Server
