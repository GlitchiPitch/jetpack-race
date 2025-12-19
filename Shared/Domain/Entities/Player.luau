---@class PlayerEntity
---@field player Player
---@field sprintActivated boolean
---@field skillsConfig table<string, any>
---@field jetpack string
---@field accessories table -- Array of {type: string, id: string}
---@field currency table<string, number> -- {coins = 1000, gems = 50}
---@field inventory table<string, boolean> -- {itemId = true, ...}
local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

---@param player Player
---@param data table<string, any>
---@return PlayerEntity
function PlayerEntity.new(player, data)
	local self = setmetatable({}, PlayerEntity)
	self.player = player
	self.sprintActivated = false
	self.jetpack = data and data.jetpack or "Default Jetpack"
	self.accessories = data and data.accessories or {}
	self.currency = data and data.currency or {coins = 1000, gems = 10} -- Default starting currency
	self.inventory = data and data.inventory or {} -- Owned items

	self.skillsConfig = {
		flyingSpeed = {
			level = 1,
			cooldown = 10,
			duration = 10,
			amount = 1.0,
			description = "Increases the speed of the flying entity",
			icon = "rbxassetid://1234567890",
			cost = 100,
			requiredLevel = 1,
			requiredSkillPoints = 10,
		},
		flyingSpeedBoost = {
			level = 1,
			cooldown = 10,
			duration = 10,
			amount = 1.0,
			description = "Increases the speed of the flying entity",
			icon = "rbxassetid://1234567890",
			cost = 100,
			requiredLevel = 1,
			requiredSkillPoints = 10,
		},
	}
	return self
end

function PlayerEntity:getData()
	return {
		jetpack = self.jetpack,
		accessories = self.accessories,
		sprintActivated = self.sprintActivated,
		skillsConfig = self.skillsConfig,
		currency = self.currency,
		inventory = self.inventory
	}
end

function PlayerEntity:setSprintActivated(active)
	self.sprintActivated = active
end

function PlayerEntity:isSprintActivated()
	return self.sprintActivated
end

--- Get the current jetpack
---@return string
function PlayerEntity:getJetpack()
	return self.jetpack
end

--- Set the current jetpack
---@param jetpack string
function PlayerEntity:setJetpack(jetpack)
	self.jetpack = jetpack
end

--- Get all accessories
---@return table
function PlayerEntity:getAccessories()
	return self.accessories
end

--- Add an accessory
---@param accessoryType string
---@param accessoryId string
function PlayerEntity:addAccessory(accessoryType, accessoryId)
	table.insert(self.accessories, {
		type = accessoryType,
		id = accessoryId
	})
end

--- Remove accessory by index
---@param index number
function PlayerEntity:removeAccessory(index)
	table.remove(self.accessories, index)
end

--- Check if player has specific accessory
---@param accessoryType string
---@param accessoryId string
---@return boolean
function PlayerEntity:hasAccessory(accessoryType, accessoryId)
	for _, accessory in ipairs(self.accessories) do
		if accessory.type == accessoryType and accessory.id == accessoryId then
			return true
		end
	end
	return false
end

--- Get accessories by type
---@param accessoryType string
---@return table
function PlayerEntity:getAccessoriesByType(accessoryType)
	local filteredAccessories = {}
	for _, accessory in ipairs(self.accessories) do
		if accessory.type == accessoryType then
			table.insert(filteredAccessories, accessory)
		end
	end
	return filteredAccessories
end

--- Get currency amount
---@param currencyType "coins"|"gems"
---@return number
function PlayerEntity:getCurrency(currencyType)
	return self.currency[currencyType] or 0
end

--- Set currency amount
---@param currencyType "coins"|"gems"
---@param amount number
function PlayerEntity:setCurrency(currencyType, amount)
	self.currency[currencyType] = math.max(0, amount)
end

--- Add currency amount
---@param currencyType "coins"|"gems"
---@param amount number
function PlayerEntity:addCurrency(currencyType, amount)
	self.currency[currencyType] = (self.currency[currencyType] or 0) + amount
end

--- Subtract currency amount (returns false if insufficient funds)
---@param currencyType "coins"|"gems"
---@param amount number
---@return boolean
function PlayerEntity:subtractCurrency(currencyType, amount)
	local current = self.currency[currencyType] or 0
	if current >= amount then
		self.currency[currencyType] = current - amount
		return true
	end
	return false
end

--- Check if player has enough currency
---@param currencyType "coins"|"gems"
---@param amount number
---@return boolean
function PlayerEntity:hasEnoughCurrency(currencyType, amount)
	return (self.currency[currencyType] or 0) >= amount
end

--- Get all currency data
---@return table<string, number>
function PlayerEntity:getCurrencyData()
	return {
		coins = self.currency.coins or 0,
		gems = self.currency.gems or 0
	}
end

return PlayerEntity
