#!/bin/bash

# Development container health check script
# Validates all components and tools are working correctly

echo "🏥 Running Development Container Health Check..."

# Track overall health status
HEALTH_STATUS=0

# Function to check command availability and functionality
check_tool() {
    local tool_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    echo -n "📋 Checking $tool_name... "
    
    if command -v "$test_command" >/dev/null 2>&1; then
        if [ -n "$expected_pattern" ]; then
            if $test_command --version 2>&1 | grep -q "$expected_pattern"; then
                echo "✅ OK"
            else
                echo "❌ FAIL (version check failed)"
                HEALTH_STATUS=1
            fi
        else
            echo "✅ OK"
        fi
    else
        echo "❌ FAIL (not found)"
        HEALTH_STATUS=1
    fi
}

# Check core tools
check_tool "Java 21" "java" "openjdk version \"21"
check_tool "Node.js" "node" "v"
check_tool "Ruby" "ruby" "ruby"
check_tool "Git" "git" "git version"
check_tool "Docker CLI" "docker" "Docker version"

# Check Claude tools
check_tool "Claude Code CLI" "claude-code" ""
check_tool "Claude Swarm" "claude_swarm" ""

# Check workspace setup
echo -n "📋 Checking workspace setup... "
if [ -d "/workspace" ] && [ -w "/workspace" ]; then
    echo "✅ OK"
else
    echo "❌ FAIL (workspace not accessible)"
    HEALTH_STATUS=1
fi

# Check NeoGradle setup
echo -n "📋 Checking NeoGradle setup... "
if [ -f "/workspace/build.gradle" ] && [ -f "/workspace/gradlew" ]; then
    echo "✅ OK"
else
    echo "❌ FAIL (NeoGradle not set up)"
    HEALTH_STATUS=1
fi

# Check Docker socket access
echo -n "📋 Checking Docker socket access... "
if docker info >/dev/null 2>&1; then
    echo "✅ OK"
    
    # Additional Docker functionality check
    echo -n "📋 Checking Docker container management... "
    if docker ps >/dev/null 2>&1; then
        echo "✅ OK"
    else
        echo "❌ FAIL (cannot list containers)"
        HEALTH_STATUS=1
    fi
else
    echo "❌ FAIL (cannot access Docker daemon)"
    HEALTH_STATUS=1
fi

# Check network connectivity
echo -n "📋 Checking network connectivity... "
if ping -c 1 172.20.0.20 >/dev/null 2>&1; then
    echo "✅ OK"
else
    echo "⚠️  WARNING (test-runner not accessible)"
fi

# Final health report
echo ""
if [ $HEALTH_STATUS -eq 0 ]; then
    echo "🎉 Development container is healthy!"
    exit 0
else
    echo "🚨 Development container has health issues!"
    exit 1
fi