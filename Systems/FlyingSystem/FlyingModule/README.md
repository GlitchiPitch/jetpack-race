# FlyingModule - Clean Architecture Implementation

A complete flying system implementation following Clean Architecture principles for Roblox games.

## 🏗️ Architecture Overview

This module implements a flying system using Clean Architecture with clear separation of concerns:

```
📁 FlyingModule/
├── 📁 Server/          # Server-side logic
├── 📁 Client/          # Client-side logic
└── 📁 Shared/          # Cross-platform code
```

### Architecture Layers

1. **Domain Layer** - Core business logic (Entities, Value Objects)
2. **Application Layer** - Use Cases, Interfaces, DTOs
3. **Infrastructure Layer** - External services, repositories
4. **Interface Adapters** - Controllers, presenters
5. **Composition Root** - Dependency injection setup

## 🚀 Quick Start

### Server Setup
```lua
local FlyingServer = require(path.to.FlyingModule.Server)
local server = FlyingServer.new()
server:init()
```

### Client Setup
```lua
local FlyingClient = require(path.to.FlyingModule.Client)
local client = FlyingClient.new()
client:init()
```

## 📋 Features

- ✅ **Camera-based Movement** - Fly using camera direction
- ✅ **Sprint System** - Boost speed with charge consumption
- ✅ **Charge Management** - Automatic charge regeneration
- ✅ **Physics Integration** - BodyVelocity, BodyGyro, BodyPosition
- ✅ **Network Synchronization** - Server-authoritative movement

## 🔧 Configuration

Edit `FlyingModule/Shared/Types/Constants.luau` to customize:

```lua
local Constants = {
    BASE_SPRINT_VALUE = 1.0,        -- Base speed multiplier
    ACTIVATED_SPRINT_VALUE = 2.5,   -- Sprint speed multiplier
    CAMERA_SPEED = { X = 40, Y = 60 }, -- Movement speeds
    BASE_SPRINT_COST_VALUE = 5,     -- Charge cost per second
    REALOAD_CHARGE_VALUE = 2,       -- Charge regen per second
}
```

## 🎮 Controls

- **WASD** - Move in camera direction
- **Left Shift** - Sprint (consumes charge)

## 🧪 Testing

Run the integration test:

```lua
require(path.to.FlyingModule.IntegrationTest)
```

## 📁 File Structure

```
FlyingModule/
├── IntegrationTest.luau      # Integration tests
├── README.md                 # This file
├── Server/
│   ├── init.luau
│   ├── Application/
│   │   └── UseCases/
│   │       ├── ExecuteFlyingUseCase.luau
│   │       └── ToggleSprintUseCase.luau
│   ├── Infrastructure/
│   │   ├── Services/
│   │   │   └── RobloxFlyingService.luau
│   │   └── Repositories/
│   │       └── FlyingRepository.luau
│   ├── InterfaceAdapters/
│   │   └── Controllers/
│   │       └── FlyingController.luau
│   └── CompositionRoot/
│       └── FlyingCompositionRoot.luau
├── Client/
│   ├── init.luau
│   ├── Infrastructure/
│   │   └── Services/
│   │       └── RobloxInputService.luau
│   ├── InterfaceAdapters/
│   │   └── Presenters/
│   │       └── FlyingPresenter.luau
│   └── CompositionRoot/
│       └── FlyingCompositionRoot.luau
└── Shared/
    ├── Domain/
    │   ├── Entities/
    │   │   └── FlyingEntity.luau
    │   └── ValueObjects/
    │       └── FlyingState.luau
    ├── Application/
    │   ├── Interfaces/
    │   │   ├── IFlyingRepository.luau
    │   │   ├── IFlyingService.luau
    │   │   └── IInputService.luau
    │   ├── UseCases/
    │   │   └── ValidateFlyingStateUseCase.luau
    │   └── DTOs/
    │       └── FlyingCommand.luau
    ├── Infrastructure/
    │   └── Utils/
    │       ├── VectorMath.luau
    │       └── init.luau
    └── Types/
        ├── FlyingTypes.luau
        ├── Constants.luau
        └── init.luau
```

## 🔄 Dependencies

- **ServerStorage.Systems.Player.Interface** - Player system interface
- **ReplicatedStorage.Events.RemoteEvent** - Remote event system
- **ReplicatedStorage.Constants** - Game constants (optional)

## 🏆 Clean Architecture Benefits

- **Testable** - Each layer can be tested independently
- **Maintainable** - Changes in one layer don't affect others
- **Framework Independent** - Core logic doesn't depend on Roblox
- **Extensible** - Easy to add new features or swap implementations
- **Separation of Concerns** - Clear boundaries between responsibilities

## 🐛 Troubleshooting

**Module not loading?**
- Check file paths in require statements
- Ensure all dependencies are available
- Verify Roblox services are accessible

**Flying not working?**
- Check that BodyMovers are properly set up
- Verify player has sufficient charge
- Check server console for errors

**Input not responding?**
- Ensure client module is initialized
- Check UserInputService permissions
- Verify input connections are active

## 📝 API Reference

### Server API
```lua
local server = FlyingServer.new()
server:init()           -- Start flying system
server:cleanup()        -- Stop and cleanup
```

### Client API
```lua
local client = FlyingClient.new()
client:init()           -- Start input handling
client:cleanup()        -- Stop input handling
```

### Domain API
```lua
local entity = FlyingEntity.new(initialState)
entity:CanFly()                    -- Check if can fly
entity:CanSprint()                 -- Check if can sprint
entity:CalculateSpeed(base, mult)  -- Calculate movement speed
entity:ConsumeCharge(amount)       -- Consume charge
entity:RechargeCharge(amount)      -- Recharge
```

## 🤝 Contributing

1. Follow Clean Architecture principles
2. Add tests for new features
3. Update documentation
4. Maintain separation of concerns

## 📄 License

This module is part of the larger game project. See project license for details.