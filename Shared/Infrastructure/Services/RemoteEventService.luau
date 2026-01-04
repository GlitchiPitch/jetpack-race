local RunService = game:GetService("RunService")
--- RemoteEventService - Unified networking layer for client-server communication
---
--- This service provides a centralized interface for all network communication
--- between client and server, handling event registration, firing, and cleanup.
--- It abstracts away direct RemoteEvent usage and provides consistent logging.
---
--- Key Features:
--- - Bidirectional event communication (client-to-server and server-to-client)
--- - Automatic connection management and cleanup
--- - Comprehensive logging for all network operations
--- - Type-safe event handling with proper separation of concerns
--- - Support for broadcasting events to all clients
---
--- Event Flow:
--- - **Server**: Listens for client events, fires targeted client events
--- - **Client**: Sends events to server, receives server broadcasts
--- - All events are logged with timestamps and service context
---
--- @class RemoteEventService
--- @field _connections table<string, RBXScriptConnection> Map of event names to their connection objects
--- @field remoteEvent RemoteEvent The underlying Roblox RemoteEvent instance
--- @field _isServer boolean Whether this instance is running on the server
--- @field logger LoggerService Logger instance for network operation tracking
local RemoteEventService = {}
RemoteEventService.__index = RemoteEventService

---@param remoteEvent RemoteEvent
---@param logger LoggerService
---@return RemoteEventService
function RemoteEventService.new(remoteEvent, logger)
	local self = setmetatable({}, RemoteEventService)
	self._isServer = RunService:IsServer()
	self.remoteEvent = remoteEvent
	self._connections = {}
	self.logger = logger

	return self
end

---@param event string
---@param callback fun(...) -> ()
function RemoteEventService:connectToEvent(event, callback)
	self.logger:debug("RemoteEventService", "Connecting to event:", event)
	if self._isServer then
		self._connections[event] = self.remoteEvent.OnServerEvent:Connect(function(player, _event, args)
			if event == _event then
				self.logger:debug("RemoteEventService", "Received server event:", event, "from player:", player.Name)
				callback(player, args)
			end
		end)
	else
		self._connections[event] = self.remoteEvent.OnClientEvent:Connect(function(_event, args)
			if event == _event then
				self.logger:debug("RemoteEventService", "Received client event:", event)
				callback(args)
			end
		end)
	end
end

---@param event string
function RemoteEventService:disconnectFromEvent(event)
	self._connections[event]:Disconnect()
	self._connections[event] = nil
end

---@param event string
---@param args any[]
function RemoteEventService:fireServer(event, args)
	self.logger:debug("RemoteEventService", "Firing server event:", event)
	self.remoteEvent:FireServer(event, args)
end

---@param event string
---@param player Player
---@param args table<string, any>
function RemoteEventService:fireClient(player, event, args)
	self.logger:debug("RemoteEventService", "Firing client event:", event, "to player:", player.Name)
	self.remoteEvent:FireClient(player, event, args)
end

---@param event string
---@param args any[]
function RemoteEventService:fireAll(event, args)
	self.logger:debug("RemoteEventService", "Firing event to all clients:", event)
	self.remoteEvent:FireAllClients(event, args)
end

return RemoteEventService
