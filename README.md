# 🚀 Jetpack Race

A high-performance jetpack racing game built with Roblox and Luau, featuring advanced flight mechanics, real-time multiplayer racing, and a clean architecture design.

## ✨ Features

* **Advanced Flight System**: Sophisticated jetpack mechanics with collision detection and smooth camera controls
* **Real-time Racing**: Checkpoint-based race system with progress tracking
* **Multiplayer Support**: Server-authoritative networking with client prediction
* **Clean Architecture**: Well-structured codebase following Clean Architecture principles
* **Comprehensive Logging**: Configurable logging system for debugging and monitoring

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
├── Client/           # Client-side game logic
│   ├── Application/  # Use cases and services
│   ├── Infrastructure/ # Repositories and external interfaces
│   └── Presentation/ # UI and presentation logic
├── Server/           # Server-side game logic
│   ├── Application/  # Business logic and services
│   └── Infrastructure/ # Data persistence and external services
└── Shared/           # Cross-platform code
    ├── Domain/       # Business entities and rules
    ├── Infrastructure/ # Shared infrastructure services
    └── Assets/       # Game assets and configurations
```

## 📦 Completed Services

### ✅ **Fully Implemented**

* **PlayerService** (Client & Server) - Player lifecycle and data management
* **CameraService** (Client) - Advanced flight camera with collision detection
* **CheckpointService** (Client & Server) - Race checkpoint system
* **AnimationService** (Client) - Character animation management
* **RemoteEventService** (Shared) - Networking communication layer
* **LoggerService** (Shared) - Centralized logging system
* **PlayerRepository** (Client & Server) - Data persistence layer

### ⚠️ **Partially Complete**

* **RaceService** (Server) - Race orchestration (basic structure ready)
* **FlyingService** (Server) - Flight validation (needs implementation)

### ❌ **Needs Implementation**

* **BoostsService** (Server) - Boost pickup system
* **JetpackService** (Client) - Jetpack controls (blocking code issues)

## 🚀 Getting Started

### Prerequisites

* Roblox Studio
* Basic understanding of Luau/Roblox development

### Installation

1. Clone the repository
2. Open the project in Roblox Studio using `default.project.json`
3. Run the game to test current features

### Project Structure

```
jetpack-race/
├── Client/          # Client scripts
├── Server/          # Server scripts
├── Shared/          # Shared scripts and assets
├── Workspace/       # Game world objects
└── default.project.json  # Roblox project configuration
```

## 🎮 Game Mechanics

### Flight System

* **Mouse Controls**: Camera rotation and flight direction
* **Nitro Boost**: Left-click for speed boost with camera effects
* **Camera Modes**:
  * Normal: Standard flight view
  * Aim: Precision mode (Right-click)
  * Nitro: Dynamic camera with screen shake

### Racing

* **Checkpoint System**: Sequential checkpoint progression
* **Progress Tracking**: Visual feedback and server validation
* **Race Completion**: Automatic finish detection

## 🛠️ Development

### Code Standards

* **EmmyLua Documentation**: All services include comprehensive type annotations
* **Clean Architecture**: Strict separation between layers
* **Dependency Injection**: Services use DIContainer for loose coupling
* **Error Handling**: Proper validation and logging

### Key Technologies

* **Luau**: Roblox's Lua dialect with type annotations
* **Roblox Services**: RunService, UserInputService, ReplicatedStorage
* **Clean Architecture**: Domain-driven design principles

## 📚 Documentation

### Project Documentation

* **[Project Plan](.docs/plan.md)** - Overall project planning and roadmap
* **[Questions](.docs/questions.md)** - Development questions and clarifications

### System Documentation

* **[Flying System](.docs/flying_system/README.md)** - Jetpack flight mechanics and controls
* **[Live Leaderboard System](.docs/live_leaderboard_system/README.md)** - Real-time leaderboard functionality
* **[Pet System](.docs/pet_system/README.md)** - Pet mechanics and features

## 🤝 Contributing

1. Follow the established Clean Architecture patterns
2. Add comprehensive documentation to new services
3. Test changes in a multiplayer environment
4. Ensure proper error handling and logging

## 📊 Progress Tracking

View our development progress on [GitHub](https://github.com/GlitchiPitch/jetpack-race)

## 📝 License

This project is part of a development portfolio. See individual files for licensing information.

***

**⭐ If you find this project interesting, please give it a star!**
