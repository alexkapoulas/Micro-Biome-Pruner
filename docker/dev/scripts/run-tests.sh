#!/bin/bash

# Test execution script for development environment
# Orchestrates both local and containerized testing

set -e

echo "🧪 Running Minecraft Micro Biome Pruner Tests..."

cd /workspace

# Function to print status messages
print_status() {
    echo "📋 $1"
}

print_success() {
    echo "✅ $1"
}

print_error() {
    echo "❌ $1"
}

# Build the mod first
print_status "Building mod before testing..."
./gradlew build

if [ $? -ne 0 ]; then
    print_error "Build failed. Cannot run tests."
    exit 1
fi

# Run unit tests
print_status "Running unit tests..."
./gradlew test

if [ $? -eq 0 ]; then
    print_success "Unit tests passed!"
else
    print_error "Unit tests failed!"
    exit 1
fi

# Check for test-runner container availability
if docker image inspect micro-biome-test-runner >/dev/null 2>&1; then
    print_status "Running integration tests with test-runner..."
    docker run --rm \
        --network micro-biome-net \
        -v /workspace/build/libs:/mods:ro \
        -v micro-biome-results:/results \
        micro-biome-test-runner --suite smoke
    
    if [ $? -eq 0 ]; then
        print_success "Integration tests passed!"
    else
        print_error "Integration tests failed!"
        exit 1
    fi
else
    print_status "Test-runner container not available. Skipping integration tests."
fi

print_success "🎉 All available tests completed successfully!"