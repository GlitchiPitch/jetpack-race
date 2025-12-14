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
	local flyingEntityFactory = require("FlyingModule.Shared.Domain.Entities.FlyingEntity")

	local flyingRepository = require("FlyingModule.Server.Infrastructure.Repositories.FlyingRepository").new({
		playerSystem = require(game.ServerStorage.Systems.Player.Interface),
		flyingEntityFactory = flyingEntityFactory.new,
	})

	local flyingService = require("FlyingModule.Server.Infrastructure.Services.RobloxFlyingService").new()

	local executeFlyingUseCase = require("FlyingModule.Server.Application.UseCases.ExecuteFlyingUseCase").new({
		flyingRepository = flyingRepository,
		flyingService = flyingService,
		constants = require("FlyingModule.Shared.Types.Constants"),
	})

	local toggleSprintUseCase = require("FlyingModule.Server.Application.UseCases.ToggleSprintUseCase").new({
		flyingRepository = flyingRepository,
		constants = require("FlyingModule.Shared.Types.Constants"),
	})

	local remoteService = require(game.ReplicatedStorage.Events.RemoteEvent)

	local controller = require("FlyingModule.Server.InterfaceAdapters.Controllers.FlyingController").new({
		executeFlyingUseCase = executeFlyingUseCase,
		toggleSprintUseCase = toggleSprintUseCase,
		remoteService = remoteService,
	})
end

return Application
