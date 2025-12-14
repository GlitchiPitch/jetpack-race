# Jetpack Race - Senior Gameplay Engineer Implementation Plan

## Current Project Status (v0.1.4)
**Architecture Complete** | **Ready for Phase 1 Development**

### ✅ Completed Infrastructure (v0.1.0 - v0.1.4)
- **Modular Architecture**: Client/Server/Shared/Systems structure implemented
- **Dependency Injection**: DIContainer integrated across all game systems
- **Bug Fixes**: 4 critical runtime errors resolved (PlayerEntity constructors, service references, debug statements)
- **Version Control**: Semantic versioning and commit process established
- **Documentation**: Comprehensive system documentation created

### 🎯 Next Critical Step
**WAITING FOR TEAM ANSWERS** on movement mechanics, camera system, and acquisition methods before Phase 1 can begin.

## Phase 1 Scope - Total Budget: $500

### 1. Jetpack/Flying System (Highest Priority) - $250
**Target Delivery:** ~2 weeks
**Dependencies:** Team answers on movement controls, camera type, jetpack acquisition

**Status:** 📋 READY - Architecture prepared, awaiting specification details

#### Movement Requirements
- client-driven forward movement (bodyMovers) + server validation
- Implement constant base forward speed controlled by the system
- Add limited horizontal (left/right) control using lane-based mechanics
- Create dynamic speed modifiers:
  - Temporary speed boosts
  - Debuffs/slowdowns
  - Basic catch-up mechanics
- Build clean APIs for Dev Products and Gamepasses to trigger boosts in real-time
- Design to support future active mechanics (skill-based or minigame-style speed buildup)

#### Competitive & Leaderboard Integration
- make a live leaderboard in real-time 
- Update player standings in real-time based on race progress/speed
- Ensure leaderboard updates are performant and scalable

#### UI Integration
- Emit gameplay events and remotes that drive UI behavior
- Signal proximity-based opportunities (being passed or about to pass)
- Boost availability and cooldown indicators
- Competitive moments tied to leaderboard position
- Own gameplay → UI signal layer (not UI visuals themselves)

#### Performance Goals
- Stabilize server memory usage
- Support ~15-20 players per server
- Document performance baseline

### 2. Pet System Refactor & Monetization Foundations - $250
**Status:** 📋 READY - Architecture prepared, can start immediately after Phase 1.1

#### Required Scope
- Refactor existing pet system for clean, extensible architecture
- Enable support for:
  - Shiny pets
  - Expandability to rainbow pets
  - Locked/shadow pet indicators to build hype
  - Expanded pet limits (+3/+7 pets, etc.)
- Foundations for future features:
  - Pet breeding
  - Pet trading
- Associated Dev Product and Gamepass hooks (instant shiny pet, etc.)
- Integration with relevant pets billboard and screen GUIs
- Improved maintainability and performance

#### Technical Requirements
- Modular architecture for easy expansion
- Performance optimizations
- Clean data structures
- UI integration points

### Optional Add-On: LiveOps & Rebirth Foundations - +$50
*Only if interested in continuing beyond Phase 1*

#### Scope
- LiveOps hooks (event flags, cosmetic trails, jetpacks)
- World scaling inputs
- Rebirth system cleanup and extensibility
- Foundations for rebirth shop and late-game progression

## Technical Expectations
- Performance-first mindset
- Client-driven systems with server validation
- Willingness to refactor/rewrite legacy code
- Clear documentation of architectural decisions
- Trusted to make necessary changes without breaking unrelated features

## Compensation & Equity
- Phase 1: $500 total ($250 jetpack / $250 pets)
- Optional add-on: +$50 for LiveOps/Rebirth foundations
- ~10% revenue share of Jetpack Race while actively contributing
- Revenue share pauses if active contribution stops

## Current Blockers & Next Steps

### 🚫 ACTIVE BLOCKERS
1. **Movement Mechanics**: No specification for control scheme details
2. **Camera System**: Classic vs Scripted camera decision needed
3. **Jetpack Acquisition**: How players get jetpacks undefined
4. **Dev Products**: Detailed parameters missing

### 📅 IMMEDIATE NEXT STEPS
1. **Schedule sync meeting** for Q&A on critical questions (6-9 PM/AM EST)
2. **Get team answers** on movement, camera, and acquisition
3. **Finalize Phase 1.1 specifications** within 1 week
4. **Begin core development** immediately after answers received

### 📊 SUCCESS METRICS
- **Week 1**: Team answers received, detailed specs documented
- **Week 2**: Jetpack system core implemented and testable
- **Week 3**: Live leaderboard integrated, performance optimized
- **Week 4**: Beta testing ready, pet system refactored

## Success Criteria
- Jetpack/flying system live in beta within ~2 weeks
- Boost framework implemented and functional
- Live leaderboard properly integrated
- Server memory stabilized
- Pet system refactored and monetization-ready
