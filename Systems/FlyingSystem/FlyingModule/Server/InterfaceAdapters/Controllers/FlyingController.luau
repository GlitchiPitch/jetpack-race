---@class FlyingController
local FlyingController = {}
FlyingController.__index = FlyingController

---@param dependencies table
---@return FlyingController
function FlyingController.new(dependencies: {
    executeFlyingUseCase: any,
    toggleSprintUseCase: any,
    remoteService: any
}): FlyingController
    return setmetatable({
        executeFlyingUseCase = dependencies.executeFlyingUseCase,
        toggleSprintUseCase = dependencies.toggleSprintUseCase,
        remoteService = dependencies.remoteService,
        _connections = {}
    }, FlyingController)
end

function FlyingController:Initialize()
    local actions = self.remoteService:GetActions()

    self._connections.flying = self.remoteService:Connect(actions.flying, function(player: Player, cameraCFrame: CFrame)
        self.executeFlyingUseCase:Execute(player, cameraCFrame)
    end)

    self._connections.sprint = self.remoteService:Connect(actions.sprint, function(player: Player, isActivated: boolean)
        self.toggleSprintUseCase:Execute(player, isActivated)
    end)
end

function FlyingController:Cleanup()
    for _, connection in self._connections do
        connection:Disconnect()
    end
    self._connections = {}
end

return FlyingController