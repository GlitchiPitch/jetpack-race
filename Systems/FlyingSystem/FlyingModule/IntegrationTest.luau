-- Integration Test for FlyingModule
-- This script tests if all modules can be properly instantiated

local function testServerModule()
    print("Testing Server Module...")
    local success, result = pcall(function()
        local ServerModule = require(game.ServerScriptService.FlyingModule.Server)
        local server = ServerModule.new()
        return server
    end)

    if success then
        print("✅ Server Module instantiated successfully")
        return true
    else
        warn("❌ Server Module failed:", result)
        return false
    end
end

local function testClientModule()
    print("Testing Client Module...")
    local success, result = pcall(function()
        local ClientModule = require(game.StarterPlayer.StarterPlayerScripts.FlyingModule.Client)
        local client = ClientModule.new()
        return client
    end)

    if success then
        print("✅ Client Module instantiated successfully")
        return true
    else
        warn("❌ Client Module failed:", result)
        return false
    end
end

local function testSharedModule()
    print("Testing Shared Module...")
    local success, result = pcall(function()
        local SharedModule = require(game.ReplicatedStorage.FlyingModule.Shared)
        return SharedModule
    end)

    if success then
        print("✅ Shared Module loaded successfully")
        return true
    else
        warn("❌ Shared Module failed:", result)
        return false
    end
end

local function testDomainEntities()
    print("Testing Domain Entities...")
    local success, result = pcall(function()
        local FlyingEntity = require(game.ReplicatedStorage.FlyingModule.Shared.Domain.Entities.FlyingEntity)

        local initialState = {
            IsActive = true,
            SpeedMultiplier = 1.0,
            ChargeLevel = 100,
            SprintActivated = false,
            MaxCharge = 100
        }

        local entity = FlyingEntity.new(initialState)

        -- Test basic functionality
        assert(entity:CanFly() == true, "Entity should be able to fly")
        assert(entity:CanSprint() == true, "Entity should be able to sprint")
        assert(entity:CalculateSpeed(10, 2) == 10, "Speed calculation should work")

        return true
    end)

    if success then
        print("✅ Domain Entities working correctly")
        return true
    else
        warn("❌ Domain Entities failed:", result)
        return false
    end
end

-- Run all tests
local testsPassed = 0
local totalTests = 4

if testSharedModule() then testsPassed = testsPassed + 1 end
if testDomainEntities() then testsPassed = testsPassed + 1 end

-- Note: Server and Client tests would require proper Roblox environment
-- These would typically be run in Studio with proper services available
print(`Integration test complete: {testsPassed}/{totalTests} tests passed`)

if testsPassed == totalTests then
    print("🎉 All tests passed! FlyingModule is ready for use.")
else
    warn(`⚠️  Some tests failed. Please check the warnings above.`)
end