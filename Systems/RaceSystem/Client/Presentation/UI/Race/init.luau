local Players = game:GetService("Players")

---@class RaceUI
local RaceUI = {}
RaceUI.__index = RaceUI

---@param diContainer DIContainer
---@return RaceUI
function RaceUI.new(diContainer)
    local self = setmetatable({}, RaceUI)
    self.diContainer = diContainer
    self.player = Players.LocalPlayer
    self.ui = script.RaceUI:Clone()
    self.ui.Parent = self.player.PlayerGui
    self.rankFrames = {}
    self.isVisible = false

    self:_setupUI()
    self:_setupRemoteEventListeners()
    self:hide()

    return self
end

function RaceUI:_setupUI()
    local rankFrame = self.ui:FindFirstChild("RankFrame")
    if not rankFrame then
        warn("RaceUI: RankFrame not found")
        return
    end

    local template = rankFrame:FindFirstChild("Template")
    if template then
        template.Visible = false
    end
end

function RaceUI:_setupRemoteEventListeners()
    local remoteEventService = self.diContainer:resolve("RemoteEventService")
    local constants = self.diContainer:resolve("Shared.Constants")

    -- Listen for race updates
    local raceUpdateConnection = remoteEventService:connectToEvent(
        constants.REMOTE_EVENTS.RACE_UPDATE,
        function(data)
            if data.raceData then
                self:updateRaceDisplay(data.raceData)
            end
        end
    )

    -- Store connection for cleanup
    self.remoteConnections = {
        raceUpdateConnection
    }
end

function RaceUI:updateRaceDisplay(raceData)
    local rankFrame = self.ui:FindFirstChild("RankFrame")
    if not rankFrame then return end

    -- Clear existing rank displays
    for _, frame in ipairs(self.rankFrames) do
        frame:Destroy()
    end
    self.rankFrames = {}

    local template = rankFrame:FindFirstChild("Template")
    if not template then return end

    -- Create rank displays for players
    for i, playerData in ipairs(raceData.players or {}) do
        local rankDisplay = template:Clone()
        rankDisplay.Name = "Rank" .. i
        rankDisplay.Visible = true
        rankDisplay.LayoutOrder = i
        rankDisplay.Parent = rankFrame

        -- Setup rank label
        local rankLabel = rankDisplay:FindFirstChild("RankLabel")
        if rankLabel then
            rankLabel.Text = "#" .. i
        end

        -- Setup player name and time
        local nameLabel = rankDisplay:FindFirstChildWhichIsA("TextLabel")
        if nameLabel and nameLabel ~= rankLabel then
            if playerData.playerName then
                nameLabel.Text = playerData.playerName
                if playerData.finishTime then
                    nameLabel.Text = nameLabel.Text .. " - " .. string.format("%.2fs", playerData.finishTime)
                end
            end
        end

        table.insert(self.rankFrames, rankDisplay)
    end
end

function RaceUI:show()
    self.isVisible = true
    self.ui.Enabled = true
end

function RaceUI:hide()
    self.isVisible = false
    self.ui.Enabled = false
end

function RaceUI:destroy()
    self:hide()

    if self.remoteConnections then
        for _, connection in ipairs(self.remoteConnections) do
            if connection then
                connection:Disconnect()
            end
        end
    end

    if self.ui then
        self.ui:Destroy()
    end
end

return RaceUI