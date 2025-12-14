local Services = require(script.Services)

---@class LiveLeaderboardSystemClientApplication
---@field services LiveLeaderboardSystemClientApplicationServices
---@field diContainer DIContainer
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return LiveLeaderboardSystemClientApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
    self.services = Services.new(self.diContainer)
	self:_register()
	return self
end

function Application:_register() end

function Application:init()
	-- self.remoteEventService:connectToEvent(self.constants.BUY_ITEM, function(args)
	-- 	if self.useCases.SetCoinsPurchase:execute(self.commands.SetCoinsPurchase.new(args)) then
	-- 	end
	-- end)
end

return Application
