---@class ClientJetpackService
local JetpackService = {}
JetpackService.__index = JetpackService

---@param diContainer DIContainer
---@return ClientJetpackService
function JetpackService.new(diContainer)
	local self = setmetatable({}, JetpackService)
	self.diContainer = diContainer
	return self
end

function JetpackService:init() end

return JetpackService
