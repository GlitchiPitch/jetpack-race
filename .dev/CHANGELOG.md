# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.1.0] - 2025-12-14

### Changed
- **Project Structure Refactoring**: Major restructuring of the project layout
  - Moved from `src/` directory structure to flat root-level organization
  - Created separate `Client/`, `Server/`, `Shared/`, and `Systems/` directories
  - Reorganized systems into dedicated folders (FlyingSystem, LiveLeaderboardSystem, PetSystem)
  - Improved separation of concerns between client, server, and shared code

### Removed
- Old `src/` directory structure and all contained files
- Redundant initialization files from previous structure

### Added
- New modular architecture with clear system separation
- Improved code organization for better maintainability
- Process documentation and development pipeline notes

### Documentation
- Added development workflow documentation (`.docs/notes.md`)
- Created project documentation structure (`.dev/` directory)
- Added commit process and version management guidelines

## [v0.1.1] - 2025-12-14

### Fixed
- **PlayerEntity Constructor Bug**: Fixed `PlayerRepository:getPlayerEntity()` calls to provide all required parameters (`player`, `_playerData`, `data`) to `PlayerEntity.new()` in FlyingSystem and PetSystem
- **Debug Statements Removal**: Removed all debug `warn()` statements from client initialization files and shared application files in FlyingSystem, PetSystem, and LiveLeaderboardSystem
- **Service Reference Bug**: Fixed `connectToEvents` methods to reference `self.services.playerService` instead of non-existent `self.playerService` in all server Application classes
- **ShopService Runtime Error**: Removed calls to non-existent `self.services.shopService:init()` from all Application:init() methods to prevent runtime errors

## [v0.1.5] - 2025-12-14

### Added
- **RewardsSystem Integration**: Fully integrated RewardsSystem into the main game initialization
  - Added RewardsSystemServer to server initialization with player event handling
  - Added RewardsSystemClient to client initialization
  - Fixed Logger service registration timing issues in DI container
  - Added comprehensive logging throughout the RewardsSystem for debugging

### Fixed
- **Syntax Error**: Removed stray character causing "Incomplete statement" error in Server/init.server.luau
- **DI Container Logger Registration**: Fixed Logger service resolution timing by moving Logger-dependent operations from constructors to init() methods
- **RewardsSystem Client Path**: Fixed incorrect Shared module path in RewardsSystem/Client/init.luau

### Changed
- **RewardsSystem Architecture**: Enhanced RewardsSystem with proper dependency injection and logging infrastructure
- **Initialization Order**: Improved component initialization sequence to ensure services are available when needed

## [v0.1.4] - 2025-12-14

### Changed
- **Dependency Injection Enhancement**: Improved dependency injection by passing `DIContainer` to system client constructors (PetSystemClient, FlyingSystemClient, LiveLeaderboardSystemClient)
- **Architecture Refinement**: Enhanced client initialization to properly inject shared infrastructure dependencies across all game systems

## [v0.1.3] - 2025-12-14

### Changed
- **Dependency Injection Enhancement**: Improved dependency injection by passing `DIContainer` to system client constructors (PetSystemClient, FlyingSystemClient, LiveLeaderboardSystemClient)
- **Architecture Refinement**: Enhanced client initialization to properly inject shared infrastructure dependencies across all game systems