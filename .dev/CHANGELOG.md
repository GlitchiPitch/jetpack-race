# Changelog

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