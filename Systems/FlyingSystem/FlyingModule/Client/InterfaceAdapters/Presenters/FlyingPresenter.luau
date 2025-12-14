local UserInputService = game:GetService("UserInputService")
local Constants = require("FlyingModule.Shared.Types.Constants")

---@class FlyingPresenter
local FlyingPresenter = {}
FlyingPresenter.__index = FlyingPresenter

---@param dependencies table
---@return FlyingPresenter
function FlyingPresenter.new(dependencies: {
    remoteService: any,
    inputService: any
}): FlyingPresenter
    return setmetatable({
        remoteService = dependencies.remoteService,
        inputService = dependencies.inputService,
        isActive = false,
        _connections = {}
    }, FlyingPresenter)
end

function FlyingPresenter:Activate()
    if self.isActive then return end
    self.isActive = true

    self._connections.inputChanged = UserInputService.InputChanged:Connect(function()
        self:OnCameraChanged()
    end)

    self._connections.inputBegan = UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            self:OnInputBegan(input)
        end
    end)

    self._connections.inputEnded = UserInputService.InputEnded:Connect(function(input, processed)
        if not processed then
            self:OnInputEnded(input)
        end
    end)
end

function FlyingPresenter:Deactivate()
    self.isActive = false

    for _, connection in self._connections do
        connection:Disconnect()
    end
    self._connections = {}
end

function FlyingPresenter:OnCameraChanged()
    if not self.isActive then return end

    local cameraCFrame = self.inputService:GetCameraCFrame()
    self.remoteService:Fire("flying", cameraCFrame)
end

function FlyingPresenter:OnInputBegan(input)
    if input.KeyCode == Constants.INPUT_KEYS.SPRINT then
        self.remoteService:Fire("sprint", true)
    end
end

function FlyingPresenter:OnInputEnded(input)
    if input.KeyCode == Constants.INPUT_KEYS.SPRINT then
        self.remoteService:Fire("sprint", false)
    end
end

return FlyingPresenter