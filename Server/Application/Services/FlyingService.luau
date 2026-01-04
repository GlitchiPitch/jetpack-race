local RunService = game:GetService("RunService")
--[[
    Validation of the client flying logic
]]

---@class ServerFlyingService
---@field diContainer DIContainer
---@field flyingPlayers PlayerEntity[]
---@field _updateConnect RBXScriptConnection?
---@field _updateTime number
---@field _deltaTime number
---@field _playerPositions table<number, Vector3>
local FlyingService = {}
FlyingService.__index = FlyingService

---@param diContainer DIContainer
---@return ServerFlyingService
function FlyingService.new(diContainer)
	local self = setmetatable({}, FlyingService)
	self.diContainer = diContainer
	self.flyingPlayers = {}
	self._updateTime = 1
	self._deltaTime = 0

	self._playerPositions = {}
	return self
end

---@param player Player
function FlyingService:onPlayerRemoving(player)
	if self._playerPositions[player.UserId] then
		self._playerPositions[player.UserId] = nil
	end
end

---@param playerEntity PlayerEntity
function FlyingService:connectPlayerFly(playerEntity)
	if not table.find(self.flyingPlayers, playerEntity) then
		table.insert(self.flyingPlayers, playerEntity)
	end
end

---@param playerEntity PlayerEntity
function FlyingService:disconnectPlayerFly(playerEntity)
	local playerIndex = table.find(self.flyingPlayers, playerEntity)
	if playerIndex then
		table.remove(self.flyingPlayers, playerIndex)
	end
end

---@param state boolean
function FlyingService:setUpdate(state)
	if state then
		self:_update()
	else
		if self._updateConnect then
			self._updateConnect:Disconnect()
		end
	end
end

function FlyingService:_update()
	---@param deltaTime number
	local function onRender(deltaTime)
		self._deltaTime += deltaTime
		if self._deltaTime >= self._updateTime then
			self._deltaTime = 0
			for i, playerEntity in self.flyingPlayers do
				if not self:_validateFly(playerEntity) then
					self:_kickPlayer(playerEntity, i)
				end
			end
		end
	end

	self._updateConnect = RunService.Heartbeat:Connect(onRender)
end

---@param playerEntity PlayerEntity
---@return boolean
function FlyingService:_validateFly(playerEntity)
	local character = playerEntity:getCharacter()
	local lastPosition = self._playerPositions[playerEntity.player.UserId]
	return true
end

---@param playerEntity PlayerEntity
---@param index number
function FlyingService:_kickPlayer(playerEntity, index)
	table.remove(self.flyingPlayers, index)
	---@type ServerApplication
	local application = self.diContainer:resolve("Application")
	application.services.playerService:kickPlayer(playerEntity)
end

return FlyingService
