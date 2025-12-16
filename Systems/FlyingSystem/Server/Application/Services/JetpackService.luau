---@class FlyingSystemServerJetpackService
local JetpackService = {}
JetpackService.__index = JetpackService

---@param diContainer DIContainer
---@return FlyingSystemServerJetpackService
function JetpackService.new(diContainer)
	local self = setmetatable({}, JetpackService)
	self.diContainer = diContainer
	return self
end

---@param playerEntity PlayerEntity
function JetpackService:setupStarterJetpack(playerEntity)
    ---@type FlyingSystemAssets
    local assets = self.diContainer:resolve("Shared.Assets")
    local defaultJetpack = assets.DefaultJetpack
    local defaultJetpackInstance = defaultJetpack:Clone()
    defaultJetpackInstance.Parent = playerEntity.player.StarterGear
end

return JetpackService