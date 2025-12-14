# Pet System Refactor & Monetization

## Overview
The Pet System provides collectible companions that follow players during races. This refactored system supports multiple variants (normal/shiny/rainbow), expanded limits, and monetization hooks for breeding, trading, and exclusive unlocks.

## Architecture

### Core Components
- **Pet Manager**: Central system for pet lifecycle management
- **Variant System**: Handles different pet appearances and rarities
- **Inventory System**: Manages pet ownership and limits
- **Monetization Layer**: Dev Products and Gamepass integration

### Data Structure
```lua
-- PetData structure
PetData = {
    id = "pet_unique_id",
    templateId = "golden_retriever",
    variant = "normal", -- normal/shiny/rainbow
    level = 1,
    experience = 0,
    stats = {
        speed = 1.0,
        luck = 1.0,
        rarity = 1.0
    },
    unlocked = true,
    owned = true
}
```

## How It Works

### 1. Pet Lifecycle
```
Creation → Equipping → Following → Upgrading → Breeding
```

### 2. Variant System
- **Normal Pets**: Base appearance and stats
- **Shiny Pets**: Rare golden variants (2% drop rate)
- **Rainbow Pets**: Ultra-rare animated variants (0.1% drop rate)
- **Locked/Shadow**: Teaser state for unreleased pets

### 3. Pet Following Mechanics
```lua
-- PetFollower.lua
local function UpdatePetPosition()
    local playerPosition = getPlayerPosition()
    local targetOffset = calculateTargetOffset()

    -- Smooth following with spring physics
    local force = (targetPosition - petPosition) * SPRING_STRENGTH
    petBodyVelocity.Velocity = force - petBodyVelocity.Velocity * DAMPING
end
```

## Inventory Management

### Pet Limits
- **Base Limit**: 3 pets
- **Expanded Limits**: +3/+7 via purchases
- **Premium Tiers**: Gamepass unlocks for higher limits

### Storage System
```lua
-- PetInventory.lua
local PetInventory = {
    equipped = {},     -- Currently active pets (max 3)
    collection = {},   -- Owned pets in storage
    limits = {
        base = 3,
        purchased = 0,
        premium = 0
    }
}
```

## Monetization Integration

### Dev Products
- **Instant Shiny**: Convert normal pet to shiny (high cost)
- **Pet Slot Expansion**: +3 or +7 additional slots
- **Rare Pet Packs**: Guaranteed shiny or rainbow pets
- **Stat Boosters**: Temporary pet performance increases

### Gamepass Features
- **Premium Collection**: Exclusive pet templates
- **Auto-Shiny**: All new pets have shiny chance
- **Breeding Access**: Early access to breeding mechanics
- **Trading Hub**: Marketplace for pet exchanges

## Variant System Details

### Shiny Mechanics
```lua
-- Shiny chance calculation
local function CalculateShinyChance(playerData)
    local baseChance = 0.02 -- 2%
    local modifiers = {
        gamepass = playerData.hasShinyPass and 2.0 or 1.0,
        streak = math.min(playerData.winStreak * 0.1, 1.0),
        events = getActiveEventModifier()
    }

    local finalChance = baseChance
    for _, modifier in pairs(modifiers) do
        finalChance = finalChance * modifier
    end

    return math.min(finalChance, 0.5) -- Max 50%
end
```

### Rainbow System
- **Ultra Rare**: 0.1% base chance
- **Special Events**: Increased during holiday events
- **Achievement Unlocks**: Reward for specific accomplishments
- **Animated Effects**: Unique particle systems and animations

## UI Integration

### Pet Management Interface
- **Collection View**: Grid display of owned pets
- **Stats Panel**: Detailed pet information
- **Equipping System**: Drag-and-drop pet assignment
- **Upgrade Screen**: Experience and stat progression

### Billboard System
```lua
-- PetBillboard.lua
local function UpdateBillboard(pet)
    billboard.Enabled = true
    billboard.Name.Text = pet.name
    billboard.Level.Text = "Lv. " .. pet.level

    -- Variant-specific styling
    if pet.variant == "shiny" then
        billboard.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    elseif pet.variant == "rainbow" then
        billboard.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
        -- Add rainbow animation
    end
end
```

## Future Systems Foundation

### Breeding Mechanics
- **Gene System**: Inherited traits from parent pets
- **Rarity Breeding**: Higher chance for better variants
- **Stat Inheritance**: Combine parent statistics
- **Cooldown System**: Prevent breeding spam

### Trading System
- **Marketplace**: Player-to-player pet exchanges
- **Auction House**: Competitive bidding system
- **Trade Validation**: Server-side security checks
- **Fee Structure**: Platform cut on transactions

## Performance Optimization

### Memory Management
- **Object Pooling**: Reuse pet instances
- **LOD System**: Reduce detail for distant pets
- **Batch Updates**: Group pet position updates
- **Cleanup**: Remove inactive pets immediately

### Network Efficiency
- **Compressed Sync**: Minimal data for pet states
- **Predictive Updates**: Client-side pet movement prediction
- **Rate Limiting**: Control update frequency

## Configuration

### System Settings
```lua
local PET_CONFIG = {
    MAX_EQUIPPED = 3,
    BASE_LIMIT = 3,
    EXPANSION_PACKS = {3, 7},
    SHINY_CHANCE = 0.02,
    RAINBOW_CHANCE = 0.001,
    BREEDING_COOLDOWN = 3600, -- 1 hour
    TRADING_FEE = 0.05 -- 5%
}
```

### Pet Templates
```lua
local PET_TEMPLATES = {
    ["golden_retriever"] = {
        name = "Golden Retriever",
        baseStats = {speed = 1.0, luck = 1.2},
        rarity = "common",
        unlockMethod = "free"
    },
    ["dragon"] = {
        name = "Baby Dragon",
        baseStats = {speed = 1.5, luck = 0.8},
        rarity = "legendary",
        unlockMethod = "purchase"
    }
}
```

## Analytics & Monitoring

### Usage Tracking
- **Popular Pets**: Most equipped variants
- **Monetization Metrics**: Purchase conversion rates
- **Performance Data**: System resource usage
- **Player Behavior**: Breeding and trading patterns

### Debug Tools
```lua
-- Debug commands
Commands.GivePet(player, templateId, variant) -- Grant specific pet
Commands.ResetInventory(player) -- Clear all pets
Commands.ShowPetStats() -- Display system metrics
```

## Future Enhancements
- **Pet Customization**: Colors, accessories, animations
- **Guild System**: Team-based pet collections
- **Evolution Trees**: Pet progression paths
- **Mini-Games**: Pet-based challenges and rewards
