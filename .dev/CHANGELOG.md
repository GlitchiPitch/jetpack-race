# Changelog

## [v0.4.5] - 2025-12-19 [ Complete ]

### Changes
- Increased boost spawn rate in RaceSystem by reducing spawn interval from 10-15 seconds to 5-8 seconds
- Updated boost spawning constants in RaceSystem/Shared/Constants.luau

## [v0.4.4] - 2025-12-19 [ Complete ]

### Changes
- Changed sprint logic from toggle to hold-to-sprint (hold mouse button to sprint)
- Updated sprint button color indication system
- Swapped sprint button colors: green for ready-to-sprint, yellow for sprinting active
- Removed interactive sprint button, now mouse button controls sprint directly
- Moved sprint activation logic from UI to CameraService for better input handling

## [v0.4.1] - 2025-12-19 [ Process ]

### Changes
- Added race countdown sequence (3, 2, 1, Go!) in RaceService
- Enhanced camera settings with X_EXTREME limit for better control
- Optimized jetpack movement logic by commenting out redundant BodyVelocity cleanup
- Improved race preparation flow with countdown UI

## [v0.4.0] - 2025-12-18 [ Process ]

### Changes
- Refactored FlyingSystem client architecture with service reorganization
- Moved CameraService from Shared to Client layer for better separation
- Updated JetpackService initialization and service integration
- Enhanced Constants configuration for FlyingSystem components
- Improved service initialization and dependency management

## [v0.3.5] - 2025-12-18 [ Complete ]

### Changes
- Refactored jetpack movement system with independent speed constants
- Added BASE_SIDE_MOVE_SPEED constant for A/D lateral movement control
- Added BASE_FORWARD_MOVE_SPEED constant for forward movement in race mode
- Updated MovementService to use separate speed values instead of multipliers

## [v0.3.4] - 2025-12-17 [ Complete ]

### Changes
- Enhanced FlyingSystem with camera, input, and movement services
- Updated RaceSystem client integration and services
- Improved jetpack controls and position validation
- Refined flying entity logic and asset configurations

## [v0.3.3] - 2025-12-17 [ Process ]

### Changes
- Updated FlyingSystem components and services
- Modified flying entity logic and constants
- Updated jetpack and movement services
- Enhanced input handling and UI presentation

### Previous Versions
- [v0.3.2] - Previous stable version
- [v0.3.1] - Initial FlyingSystem implementation
- [v0.3.0] - Core systems foundation