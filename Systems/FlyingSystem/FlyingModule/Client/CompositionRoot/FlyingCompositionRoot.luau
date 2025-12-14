---@class FlyingCompositionRoot
local FlyingCompositionRoot = {}

function FlyingCompositionRoot:ComposeClient(): any
    local remoteService = require(game.ReplicatedStorage.Events.RemoteEvent)
    local inputService = require("FlyingModule.Client.Infrastructure.Services.RobloxInputService").new()

    local presenter = require("FlyingModule.Client.InterfaceAdapters.Presenters.FlyingPresenter").new({
        remoteService = remoteService,
        inputService = inputService
    })

    return presenter
end

return FlyingCompositionRoot