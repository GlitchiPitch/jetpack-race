# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## \[0.1.6] - 2025-01-15

### Added

* Project documentation structure with CHANGELOG.md and TODO.md
* README.md with comprehensive documentation links

### Fixed

* FlyingModule init files require path corrections
* Translated questions.md to English

### Changed

* Updated project documentation structure
* Version bump to v0.1.6

## \[0.1.5] - 2025-01-14

### Added

* Initial project structure with Clean Architecture
* Flying System implementation with jetpack mechanics
* Live Leaderboard System
* Pet System
* Rewards System
* Player management system
* Project documentation in .docs/ folder

## \[0.1.7] - 2025-01-15

### Fixed

* Corrected duplicate class names in RewardsSystem (PetSystemEntities → RewardsSystemEntities)
* Fixed invalid Roblox service references (MarketPlayerService → MarketplaceService)
* Removed dead code with incorrect require paths in FlyingSystem
* Fixed type annotations and entity references in FlyingSystem
* Added .gitignore file for Roblox projects
* Resolved linter errors (reduced from 34 to 22 errors)

### Changed

* Improved code quality and type safety across all systems
* Updated FlyingSystem to properly use shared entities
* Enhanced project structure consistency

## \[0.4.2] - 2025-01-15

### Changed

* Increased camera rotation limits from ±25° to ±45° for horizontal axis and ±5° to ±45° for vertical axis in FlyingSystem
* Enhanced camera freedom for better jetpack flight control

## \[0.4.1] - 2025-01-15

### Fixed

* Various system fixes and improvements

## \[0.4.3] - 2025-01-15

### Changed

* Increased camera offset in FlyingSystem (Z: 8→15, Y: 2→4) for better camera positioning
* Enhanced camera service and input handling for improved jetpack controls
* Updated JetpackUI components and presentation layer

## \[Unreleased]

### Next Features

* UI for jetpack controls
* Developer Products (speed boosts, rebirths)
* Complete pet system mechanics
