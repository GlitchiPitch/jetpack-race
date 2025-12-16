# Changelog

## [v0.3.1] - 2025

### Process
- [Process] Code refactoring and process improvements
- Updated game version to v0.3.1

## [v0.3.0] - 2024

### Added
- RaceSystem: Added RaceService for handling race start with proximity prompts
- RaceSystem: Added TriggerZone model with ProximityPrompt for race interaction
- FlyingSystem: Added client-side JetpackService (basic implementation)
- FlyingSystem: Added EventService infrastructure for event handling
- FlyingSystem: Enhanced jetpack equipping logic in RaceService
- FlyingSystem: Improved UI components for jetpack display

### Changed
- FlyingSystem: Enhanced JetpackService on server with jetpack equipping functionality
- FlyingSystem: Updated PlayerService to integrate with jetpack mechanics
- RaceSystem: Improved service initialization and integration
- Shared: Enhanced Player entity with additional properties

### Fixed
- Fixed various service initialization issues across systems

## [v0.2.0] - 2024

### Added
- FlyingSystem: Added client-side FlyingService for handling flight state changes
- FlyingSystem: Added client infrastructure repositories (FlyingRepository)
- FlyingSystem: Added FlyingData.model.json and leaderstats assets
- FlyingSystem: Implemented sprint event handling on server

### Changed
- FlyingSystem: Updated service initialization on client and server
- FlyingSystem: Improved repository integration in DI container

### Fixed
- Fixed FlyingEntity handling on server

## [v0.1.9] - 2024
- Previous version
