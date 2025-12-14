local CompositionRoot = require(script.CompositionRoot.FlyingCompositionRoot)

---@class FlyingModuleClient
local Client = {}
Client.__index = Client

---@return FlyingModuleClient
function Client.new()
    local self = setmetatable({}, Client)
    self.presenter = CompositionRoot:ComposeClient()
    return self
end

function Client:init()
    self.presenter:Activate()
end

function Client:cleanup()
    self.presenter:Deactivate()
end

return Client
