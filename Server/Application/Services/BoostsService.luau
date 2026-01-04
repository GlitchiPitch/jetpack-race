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
    
end

function BoostsService:clear()
    
end

return BoostsService