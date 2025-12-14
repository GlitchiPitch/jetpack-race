# Jetpack Flying System

## Overview
The Jetpack Flying System is the core movement mechanic for Jetpack Race. It replaces TweenService-driven movement with a client-driven system that provides smooth, competitive racing gameplay with server-side validation.

## Architecture

### Movement Components
- **Client-Side Movement**: Uses BodyMovers (BodyVelocity/BodyGyro) for smooth physics-based movement
- **Server Validation**: Validates client positions and prevents cheating
- **Speed Controller**: Manages base speed, boosts, debuffs, and catch-up mechanics

### Key Features
- Constant forward velocity with lane-based horizontal control
- Dynamic speed modifiers (boosts/debuffs)
- Real-time competitive positioning
- Performance optimized for 15-20 concurrent players

## How It Works

### 1. Movement Flow
```
Client Input → Movement Controller → BodyMovers → Physics Simulation → Server Validation
```

### 2. Speed Management
- **Base Speed**: Constant forward velocity (configurable)
- **Lane System**: Limited horizontal movement (left/right lanes)
- **Modifiers**: Temporary boosts (+speed) and debuffs (-speed)
- **Catch-up**: Automatic speed increases for trailing players

### 3. Client-Side Implementation
```lua
-- MovementController.lua (Client)
local function UpdateMovement()
    -- Apply base forward velocity
    bodyVelocity.Velocity = character.CFrame.LookVector * baseSpeed

    -- Apply horizontal input (lane-based)
    local horizontalInput = getHorizontalInput()
    bodyVelocity.Velocity += character.CFrame.RightVector * horizontalInput * laneSpeed

    -- Apply active modifiers
    local speedModifier = getActiveSpeedModifier()
    bodyVelocity.Velocity *= speedModifier
end
```

### 4. Server Validation
```lua
-- ServerValidator.lua (Server)
local function ValidateMovement(player, position, velocity)
    -- Check speed limits
    if velocity.Magnitude > maxAllowedSpeed then
        -- Teleport correction or kick
        return false, "Speed violation"
    end

    -- Validate lane boundaries
    if not isWithinLaneBounds(position) then
        return false, "Lane violation"
    end

    return true
end
```

## Speed Modifiers System

### Boost Types
- **Temporary Boosts**: +50% speed for 5 seconds (Dev Product)
- **Debuffs**: -25% speed for 3 seconds (environmental)
- **Catch-up Mechanic**: +10% speed when falling behind

### Activation Methods
- **Dev Products**: Purchase during flight via UI
- **Gamepasses**: Permanent boost access
- **Environmental**: Zone-based speed changes

## Competitive Integration

### Leaderboard Updates
- Real-time position tracking based on race progress
- Server-side calculation every 0.1 seconds
- Network-efficient updates (compressed data)

### Proximity System
- Detects when players are about to be passed/overtake
- Triggers UI signals for competitive moments
- Supports 15-20 concurrent players

## UI Integration

### Events Fired
- `BoostActivated` - When boost is used
- `SpeedChanged` - Speed modifier applied
- `ProximityAlert` - Player approaching/passing
- `LeaderboardUpdate` - Position changed

### Signal Examples
```lua
-- Client signals UI
Events.BoostAvailable:Fire(cooldownRemaining)
Events.PlayerPassed:Fire(passingPlayer, positionDelta)
```

## Performance Considerations

### Memory Optimization
- Object pooling for BodyMovers
- Efficient vector calculations
- Minimal network traffic

### Server Stability
- Rate-limited validation checks
- Automatic cleanup of disconnected players
- Memory monitoring and alerts

## Configuration

### Speed Settings
```lua
local CONFIG = {
    BASE_SPEED = 50,
    LANE_COUNT = 3,
    BOOST_MULTIPLIER = 1.5,
    DEBUFF_MULTIPLIER = 0.75,
    MAX_PLAYERS = 20
}
```

### Race Parameters
- Track length and checkpoints
- Speed zones and modifiers
- Win conditions and scoring

## Future Extensions
- Skill-based speed mechanics
- Minigame-style boost challenges
- Advanced catch-up systems
- Multiplayer competitive modes
