---@class FlyingCompositionRoot
local FlyingCompositionRoot = {}

function FlyingCompositionRoot:ComposeServer(): any
    local flyingEntityFactory = require("FlyingModule.Shared.Domain.Entities.FlyingEntity")

    local flyingRepository = require("FlyingModule.Server.Infrastructure.Repositories.FlyingRepository").new({
        playerSystem = require(game.ServerStorage.Systems.Player.Interface),
        flyingEntityFactory = flyingEntityFactory.new
    })

    local flyingService = require("FlyingModule.Server.Infrastructure.Services.RobloxFlyingService").new()

    local executeFlyingUseCase = require("FlyingModule.Server.Application.UseCases.ExecuteFlyingUseCase").new({
        flyingRepository = flyingRepository,
        flyingService = flyingService,
        constants = require("FlyingModule.Shared.Types.Constants")
    })

    local toggleSprintUseCase = require("FlyingModule.Server.Application.UseCases.ToggleSprintUseCase").new({
        flyingRepository = flyingRepository,
        constants = require("FlyingModule.Shared.Types.Constants")
    })

    local remoteService = require(game.ReplicatedStorage.Events.RemoteEvent)

    local controller = require("FlyingModule.Server.InterfaceAdapters.Controllers.FlyingController").new({
        executeFlyingUseCase = executeFlyingUseCase,
        toggleSprintUseCase = toggleSprintUseCase,
        remoteService = remoteService
    })

    return controller
end

return FlyingCompositionRoot