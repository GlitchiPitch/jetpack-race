# TODO

## Completed Tasks (Priority: Completed)
- [x] **Bug Fixes v0.1.1**: Fixed 4 critical bugs in codebase
  - [x] PlayerEntity constructor parameter mismatch
  - [x] Removed debug warn() statements from production code
  - [x] Fixed service reference errors in connectToEvents methods
  - [x] Removed non-existent shopService calls preventing runtime errors
- [x] **RewardsSystem Integration v0.1.5**: Successfully integrated RewardsSystem into main game initialization
  - [x] Added RewardsSystemServer to server initialization
  - [x] Added RewardsSystemClient to client initialization
  - [x] Fixed Logger service registration timing issues
  - [x] Added comprehensive logging for debugging
  - [x] Fixed syntax error in server init file

## Current Development Questions (Priority: High)
These questions need to be answered by the team before proceeding with implementation:

### Movement Mechanics
- [ ] Define jetpack movement axes (X, Y, Z movement capabilities)
- [ ] Determine movement trigger (constant forward movement vs activation-based)
- [ ] Specify mouse + WASD control scheme details

### Jetpack Acquisition
- [ ] Define how players obtain jetpacks (prompt activation, purchase, etc.)
- [ ] Determine jetpack representation (tool vs accessory)

### Camera System
- [ ] Choose camera type (classic vs scripted)
- [ ] Define camera behavior requirements (follow player, zoom, rotation)
- [ ] Determine camera modes (race, menu, cutscenes)

### Dev Products
- [ ] Define available in-flight purchase items
  - [ ] Speed boosts
  - [ ] Respawns
  - [ ] Other items TBD

## Implementation Plan (Priority: Medium)

### Phase 1: Core Systems
- [ ] Implement basic jetpack movement mechanics
- [ ] Set up camera system
- [ ] Create jetpack acquisition system

### Phase 2: Game Features
- [ ] Implement dev products system
- [ ] Add racing mechanics
- [ ] Create leaderboard system

### Phase 3: Polish & Testing
- [ ] UI/UX improvements
- [ ] Performance optimization
- [ ] Bug fixes and testing

## Infrastructure Tasks
- [ ] Set up automated testing pipeline
- [ ] Implement CI/CD workflow
- [ ] Add code quality checks

## v0.1.4 Completed Tasks
- [x] **Dependency Injection Enhancement**: Successfully implemented DIContainer injection across all game systems
- [x] **Architecture Refinement**: Enhanced client initialization with proper shared infrastructure dependencies

## v0.1.5 Completed Tasks
- [x] **RewardsSystem Integration**: Fully integrated RewardsSystem into main game architecture
- [x] **Logger Service Fixes**: Resolved DI container service registration timing issues
- [x] **Syntax Error Resolution**: Fixed incomplete statement error in server initialization

## Next Steps (v0.1.6 Development Plan)
1. **Immediate Priority**: Test RewardsSystem initialization and logging output
2. **Short-term**: Implement core RewardsSystem functionality (reward tracking, player data persistence)
3. **Medium-term**: Continue with Phase 1 core systems (jetpack movement mechanics, camera system)
4. **Long-term**: Complete game features (dev products, racing mechanics, leaderboard integration)

## Development Questions Status
Still awaiting team input on:
- [ ] Jetpack movement axes and control scheme
- [ ] Jetpack acquisition mechanics
- [ ] Camera system requirements
- [ ] Dev products catalog

## Project Status
- ✅ **Project Structure**: Modular architecture established
- ✅ **Bug Fixes**: Critical runtime errors resolved
- ✅ **RewardsSystem**: Successfully integrated into main game loop
- ⏳ **Core Questions**: Awaiting team input on game mechanics
- 📋 **Ready for Development**: Codebase prepared for feature implementation
