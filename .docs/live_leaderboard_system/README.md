# Live Leaderboard System

## Overview
The Live Leaderboard System provides real-time competitive tracking for Jetpack Race. It calculates and displays player positions based on race progress, speed, and performance metrics, optimized for smooth performance with 15-20 concurrent players.

## Architecture

### Core Components
- **Position Calculator**: Tracks player progress and rankings
- **Update Manager**: Handles real-time synchronization
- **UI Controller**: Manages leaderboard display
- **Performance Monitor**: Tracks system efficiency

### Data Flow
```
Player Movement → Position Tracking → Rank Calculation → UI Updates → Client Sync
```

## How It Works

### 1. Position Tracking
The system uses multiple metrics to determine player rankings:

#### Primary Metrics
- **Race Progress**: Distance traveled along the track (0-100%)
- **Current Speed**: Real-time velocity affecting position changes
- **Checkpoint Progress**: Major milestones completed

#### Secondary Metrics
- **Time Alive**: Survival duration in competitive modes
- **Boost Usage**: Strategic performance indicators
- **Consistency**: Stable racing performance

### 2. Update Frequency
```lua
local UPDATE_RATE = 0.1 -- 10 updates per second
local BATCH_SIZE = 20 -- Max players per server
```

### 3. Ranking Algorithm
```lua
-- PositionCalculator.lua
local function CalculateRankings()
    local players = getActiveRacers()
    local rankings = {}

    for _, player in ipairs(players) do
        local progress = getRaceProgress(player)
        local speed = getCurrentSpeed(player)
        local score = calculateScore(progress, speed)

        table.insert(rankings, {
            player = player,
            score = score,
            position = 0 -- To be set
        })
    end

    -- Sort by score (highest first)
    table.sort(rankings, function(a, b)
        return a.score > b.score
    end)

    -- Assign positions
    for i, ranking in ipairs(rankings) do
        ranking.position = i
    end

    return rankings
end
```

## Real-Time Synchronization

### Network Optimization
- **Compressed Updates**: Only send changed positions
- **Batch Processing**: Group updates for multiple players
- **Delta Encoding**: Send position changes, not absolute values

### Client-Side Prediction
```lua
-- LeaderboardUI.lua (Client)
local function UpdateDisplay(serverData)
    -- Predict positions between updates
    local predictedPositions = predictPositions(serverData)

    -- Smooth transitions
    TweenService:Create(display, TweenInfo.new(0.1), {
        Position = predictedPositions
    }):Play()
end
```

## Performance Optimization

### Memory Management
- **Object Pooling**: Reuse ranking objects
- **Data Compression**: Minimize network payload
- **Cleanup Systems**: Remove inactive players immediately

### Scalability Features
- **Rate Limiting**: Prevent update spam
- **Load Balancing**: Distribute calculations across server
- **Caching**: Store frequently accessed data

## UI Integration

### Display Modes
- **Full Leaderboard**: Top 10 players with details
- **Mini View**: Current position + 2 above/below
- **Proximity Alerts**: Warnings for position changes

### Events System
```lua
-- Fired events
Events.PositionChanged:Fire(oldPosition, newPosition)
Events.PlayerOvertaken:Fire(overtakenPlayer, overtakingPlayer)
Events.LeaderboardUpdate:Fire(fullRankings)
```

## Configuration

### System Settings
```lua
local LEADERBOARD_CONFIG = {
    UPDATE_INTERVAL = 0.1,
    MAX_DISPLAYED = 10,
    POSITION_BUFFER = 3, -- Players shown around current position
    COMPRESSION_THRESHOLD = 0.01, -- Minimum change to send update
    MAX_PLAYERS = 20
}
```

### Scoring Weights
```lua
local SCORING_WEIGHTS = {
    PROGRESS = 0.7,    -- 70% race completion
    SPEED = 0.2,       -- 20% current velocity
    BONUS = 0.1        -- 10% special achievements
}
```

## Competitive Features

### Proximity Detection
- **Overtake Alerts**: Warn when being passed
- **Catch-up Opportunities**: Highlight players to pass
- **Position Battles**: Special UI for close races

### Anti-Cheat Measures
- **Speed Validation**: Server verifies movement
- **Position Verification**: Cross-reference with physics
- **Anomaly Detection**: Flag suspicious ranking changes

## Data Persistence

### Session Storage
- **Temporary Rankings**: Cleared on server restart
- **Best Times**: Persisted to DataStore
- **Statistics**: Track player performance over time

### Cross-Server Support
- **Global Leaderboards**: Top players across all servers
- **Regional Rankings**: Location-based competitions
- **Event Leaderboards**: Special race mode rankings

## Monitoring & Analytics

### Performance Metrics
- **Update Latency**: Time to calculate and send updates
- **Memory Usage**: Track leaderboard data size
- **Network Traffic**: Monitor bandwidth consumption

### Debug Tools
```lua
-- Debug commands
Commands.ShowLeaderboardData() -- Display raw data
Commands.TestPositionUpdates() -- Simulate ranking changes
Commands.PerformanceReport()   -- Show system metrics
```

## Future Enhancements
- **Advanced Scoring**: Multi-factor ranking algorithms
- **Tournament Mode**: Bracket-based competitions
- **Team Leaderboards**: Group-based rankings
- **Historical Tracking**: Race replay and statistics
