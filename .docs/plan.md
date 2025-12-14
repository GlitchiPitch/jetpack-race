# Jetpack Race - Senior Gameplay Engineer Implementation Plan

## Phase 1 Scope - Total Budget: $500

### 1. Jetpack/Flying System (Highest Priority) - $250
**Target Delivery:** ~2 weeks

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

## Success Criteria
- Jetpack/flying system live in beta within ~2 weeks
- Boost framework implemented and functional
- Live leaderboard properly integrated
- Server memory stabilized
- Pet system refactored and monetization-ready
