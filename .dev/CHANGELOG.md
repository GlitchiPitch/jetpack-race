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
