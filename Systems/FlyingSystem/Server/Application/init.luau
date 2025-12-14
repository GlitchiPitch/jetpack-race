local Commands = require(script.Commands)
local UseCases = require(script.UseCases)
local Services = require(script.Services)
---@class FlyingSystemServerApplication
---@field application FlyingSystemSharedApplication
---@field diContainer DIContainer
---@field constants FlyingSystemSharedConstants
---@field useCases FlyingSystemServerUseCases
---@field commands FlyingSystemServerCommands
---@field remoteEventService RemoteEventService
---@field services FlyingSystemServerServices
local Application = {}
Application.__index = Application

---@param diContainer DIContainer
---@return FlyingSystemServerApplication
function Application.new(diContainer)
	local self = setmetatable({}, Application)
	self.diContainer = diContainer
	self:_register()
	return self
end

function Application:_register()
	self.diContainer:singleton("Server.Application.Commands", function()
		return Commands.new()
	end)
	self.diContainer:singleton("Server.Application.UseCases", function()
		return UseCases.new()
	end)
	self.diContainer:singleton("Server.Application.Services", function(c)
		return Services.new(c)
	end)
end

function Application:init()
	self.constants = self.diContainer:resolve("Shared.Constants")
	self.useCases = self.diContainer:resolve("Server.Application.UseCases")
	self.commands = self.diContainer:resolve("Server.Application.Commands")
	self.remoteEventService = self.diContainer:resolve("RemoteEventService")

	self.services = self.diContainer:resolve("Server.Application.Services")
	self.services:init()
	self:connectToEvents()
end

function Application:connectToEvents()
	self.remoteEventService:connectToEvent(self.constants.BUY_ITEM, function(player, args)
		local playerEntity = self.services.playerService:getPlayerEntity(player)
		local useCase = self.useCases.BuyItem.new(self.constants.SHOP_LIST, self.constants.SHOP_CONSTANTS)
		local command = self.commands.BuyItem.new({
			itemName = args.itemName,
			playerEntity = playerEntity,
			shopMode = args.shopMode,
		})

		if useCase:execute(command) then
			self.remoteEventService:fireClient(playerEntity, self.constants.BUY_ITEM_SUCCESS, args)
		else
			self.remoteEventService:fireClient(playerEntity, self.constants.BUY_ITEM_ERROR, args)
		end
	end)
end

return Application
