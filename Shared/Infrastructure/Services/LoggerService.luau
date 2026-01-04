local RunService = game:GetService("RunService")

--- LoggerService - Centralized logging system with configurable filtering
---
--- This service provides a comprehensive logging solution for the entire application,
--- supporting multiple log levels, service-based filtering, and both server/client
--- execution contexts. It helps maintain clean console output by allowing
--- selective suppression of verbose services.
---
--- Log Levels (in order of verbosity):
--- - **DEBUG**: Detailed diagnostic information for development
--- - **INFO**: General information about application operation
--- - **WARN**: Warning messages about potential issues
--- - **ERROR**: Error messages that indicate failures
---
--- Key Features:
--- - Hierarchical log level filtering (DEBUG < INFO < WARN < ERROR)
--- - Service-specific log suppression for cleaner output
--- - Automatic timestamp and service name prefixing
--- - Server/client context awareness
--- - Configurable blocked services list
---
--- @class LoggerService
--- @field _logLevel number Current logging level threshold
--- @field _isServer boolean Whether running on server (affects output formatting)
--- @field _blockedServices table<string, boolean> Map of service names that should be silenced
--- @field LEVELS table Available logging levels with numeric values
local LoggerService = {}
LoggerService.__index = LoggerService

-- Уровни логирования
LoggerService.LEVELS = {
	DEBUG = 1,
	INFO = 2,
	WARN = 3,
	ERROR = 4,
}

-- Префиксы для разных уровней
local LEVEL_PREFIXES = {
	[LoggerService.LEVELS.DEBUG] = "[DEBUG]",
	[LoggerService.LEVELS.INFO] = "[INFO]",
	[LoggerService.LEVELS.WARN] = "[WARN]",
	[LoggerService.LEVELS.ERROR] = "[ERROR]",
}

---@param logLevel number?
---@return LoggerService
function LoggerService.new(logLevel)
	local self = setmetatable({}, LoggerService)
	self._isServer = RunService:IsServer()
	self._blockedServices = {} -- Блокировка verbose сервисов для очистки логов

	-- На сервере и клиенте по умолчанию INFO для отображения основных логов работы систем
	self._logLevel = logLevel or self.LEVELS.INFO

	return self
end

---@param level number
function LoggerService:setLogLevel(level)
	self._logLevel = level
end

---@param level number
---@param serviceName string?
---@return boolean
function LoggerService:_shouldLog(level, serviceName)
	if level < self._logLevel then
		return false
	end

	if serviceName and self._blockedServices[serviceName] then
		return false
	end

	return true
end

---@param serviceName string
---@return boolean
function LoggerService:isServiceBlocked(serviceName)
	return self._blockedServices[serviceName] == true
end

---@param level number
---@param serviceName string
---@param message string
---@vararg any
function LoggerService:_log(level, serviceName, message, ...)
	if not self:_shouldLog(level, serviceName) then
		return
	end

	local prefix = LEVEL_PREFIXES[level] or "[UNKNOWN]"
	local timestamp = os.date("%H:%M:%S")

	local fullMessage
	if serviceName then
		fullMessage = string.format("[%s] %s [%s] %s", timestamp, prefix, serviceName, message)
	else
		fullMessage = string.format("[%s] %s %s", timestamp, prefix, message)
	end

	-- Добавляем дополнительные аргументы
	if ... then
		local args = { ... }
		for _, arg in ipairs(args) do
			fullMessage = fullMessage .. " " .. tostring(arg)
		end
	end

	-- Используем соответствующую функцию Roblox
	if level == self.LEVELS.ERROR or level == self.LEVELS.WARN then
		warn(fullMessage)
	else
		print(fullMessage)
	end
end

---@param serviceName string
---@param message string
---@vararg any
function LoggerService:debug(serviceName, message, ...)
	self:_log(self.LEVELS.DEBUG, serviceName, message, ...)
end

---@param serviceName string
---@param message string
---@vararg any
function LoggerService:info(serviceName, message, ...)
	self:_log(self.LEVELS.INFO, serviceName, message, ...)
end

---@param serviceName string
---@param message string
---@vararg any
function LoggerService:warn(serviceName, message, ...)
	self:_log(self.LEVELS.WARN, serviceName, message, ...)
end

---@param serviceName string
---@param message string
---@vararg any
function LoggerService:error(serviceName, message, ...)
	self:_log(self.LEVELS.ERROR, serviceName, message, ...)
end

return LoggerService
