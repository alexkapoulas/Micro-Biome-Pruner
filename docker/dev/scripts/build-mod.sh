#!/bin/bash

# NeoGradle mod build script with validation
# Provides enhanced build process with error handling and validation

set -e

echo "🔨 Building Minecraft Micro Biome Pruner Mod..."

cd /workspace

# Validate NeoGradle setup
if [ ! -f "build.gradle" ]; then
    echo "❌ build.gradle not found. Run init-dev.sh first."
    exit 1
fi

if [ ! -f "gradlew" ]; then
    echo "❌ Gradle wrapper not found. Run init-dev.sh first."
    exit 1
fi

# Clean previous builds
echo "📋 Cleaning previous builds..."
./gradlew clean

# Build the mod with full validation
echo "📋 Building mod with NeoGradle..."
./gradlew build --info

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Mod build completed successfully!"
    
    # List generated artifacts
    if [ -d "build/libs" ]; then
        echo "📦 Generated artifacts:"
        ls -la build/libs/
    fi
    
    echo "🎉 Build process complete!"
else
    echo "❌ Build failed. Check the output above for errors."
    exit 1
fi