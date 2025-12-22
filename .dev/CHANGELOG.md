# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.8] - 2024-12-21

### Fixed
- Shop System integration and bug fixes
- UI component initialization issues
- Server-side synchronization problems
- Remote event handling optimizations
- Flying system camera corrections
- Race system boost mechanics
- Live leaderboard data synchronization
- Pet system entity updates across all systems
- Player service repository consistency
- Infrastructure initialization improvements

### Changed
- Enhanced Shop System with full UI implementation
- Updated ShopFrame, ShopCatalog, ItemPreview, and PurchaseDialog
- Improved Player entities across all systems (Race, Rewards, Pet)
- Enhanced Flying System camera service
- Updated Race System boost and player services
- Optimized Live Leaderboard System
- Refactored infrastructure initialization across systems
- Improved Shared Config and DIContainer usage

### Added
- Complete Shop System implementation with monetization
- Enhanced error handling and logging
- Performance optimizations for UI components
- Better service integration and communication
- Improved debugging capabilities

## [0.4.9] - 2024-12-22

### Added
- Race System core entities: Race, Ring, Winner
- RingsService for ring creation and management
- AssetsSpawnService for asset spawning
- RacePlayer entity with race-specific properties
- Ring collection and boost mechanics
- Winner tracking and reward calculation

### Changed
- Enhanced Race System architecture with proper entity separation
- Updated Race System infrastructure services
- Improved Race UI components integration
- Refactored Race entities initialization

### Fixed
- Race System entity imports and dependencies
- Removed duplicate Pet entity from Race System
- Fixed Race UI initialization issues

## [Unreleased]

## [0.4.5] - 2024-12-XX

### Added
- Flying System enhancements
- Race System improvements
- Live Leaderboard System

### Changed
- Architecture improvements with better separation of concerns

## [0.4.0] - 2024-12-XX

### Added
- Initial game architecture with multiple systems
- Pet System, Rewards System, Race System
- Clean Architecture implementation

### Changed
- Migrated from basic structure to full system architecture

## [0.1.0] - 2024-12-XX

### Added
- Initial project setup
- Basic game structure
- Core systems foundation