---@class FlyingSystemEventService
---@field event BindableEvent
local EventService = {}
EventService.__index = EventService

---@return FlyingSystemEventService
function EventService.new()
    local self = setmetatable({}, EventService)
    self.event = script.Event
    return self
end

function EventService:connectToEvent(event, callback)
    self.event.Event:Connect(function(player, _event, args)
        if event == _event then
            callback(player, args)
        end
    end)
end

function EventService:fireEvent(event, player, args)
    self.event.Event:Fire(player, event, args)
end

return EventService