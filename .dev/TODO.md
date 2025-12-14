# TODO

## Completed Tasks (Priority: Completed)
- [x] **Bug Fixes v0.1.1**: Fixed 4 critical bugs in codebase
  - [x] PlayerEntity constructor parameter mismatch
  - [x] Removed debug warn() statements from production code
  - [x] Fixed service reference errors in connectToEvents methods
  - [x] Removed non-existent shopService calls preventing runtime errors

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

## Next Steps
1. **Immediate**: Get answers to development questions from team (movement mechanics, jetpack acquisition, camera system, dev products)
2. **Short-term**: Create detailed implementation plan for Phase 1 core systems
3. **Medium-term**: Begin core systems development (jetpack movement, camera, acquisition)
4. **Long-term**: Implement game features (dev products, racing, leaderboard)
5. Schedule sync meetings for testing and planning (6-9 PM/AM EST)

## Project Status
- ✅ **Project Structure**: Modular architecture established
- ✅ **Bug Fixes**: Critical runtime errors resolved
- ⏳ **Core Questions**: Awaiting team input on game mechanics
- 📋 **Ready for Development**: Codebase prepared for feature implementation
