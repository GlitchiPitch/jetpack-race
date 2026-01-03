---@class CustomPrompt
---@field prompt ProximityPrompt
---@field customPromptUI GuiObject
---@field _connections RBXScriptConnection[]
---@field _callback function
local CustomPrompt = {}
CustomPrompt.__index = CustomPrompt

---@param parent Instance
---@return CustomPrompt
function CustomPrompt.new(parent)
	local self = setmetatable({}, CustomPrompt)
	self.prompt = script.Prompt:Clone()
	self.customPromptUI = script.CustomPromptUI:Clone()
	self.parent = parent
	self._connections = {}
	return self
end

function CustomPrompt:_setup()
	---@param state boolean
	local function setVisible(state)
		self.customPromptUI.Visible = state
	end

	local function promptShown()
		setVisible(true)
	end

	local function promptHidden()
		setVisible(false)
	end

	---@param player Player
	local function onTriggered(player)
		if self._callback then
			self._callback(player)
		end
	end

	self.prompt.Parent = self.parent
	self.customPromptUI.Parent = self.parent

	self._connections = {
		self.prompt.PromptShown:Connect(promptShown),
		self.prompt.PromptHidden:Connect(promptHidden),
		self.prompt.Triggered:Connect(onTriggered),
	}
end

---@param callback function
function CustomPrompt:setCallback(callback)
	self._callback = callback
end

function CustomPrompt:destroy()
	self.prompt:Destroy()
	self.customPromptUI:Destroy()

	for _, conn in self._connections do
		conn:Disconnect()
	end
end

return CustomPrompt
