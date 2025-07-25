#!/bin/bash

# Development container initialization script
# Sets up NeoGradle environment and validates tools

set -e

echo "🚀 Initializing Minecraft Micro Biome Pruner Development Environment..."

# Function to print status messages
print_status() {
    echo "📋 $1"
}

# Function to print success messages
print_success() {
    echo "✅ $1"
}

# Function to print error messages
print_error() {
    echo "❌ $1"
}

# Validate Java installation
print_status "Validating Java 21 installation..."
if java -version 2>&1 | grep -q "openjdk version \"21"; then
    print_success "Java 21 is properly installed"
else
    print_error "Java 21 validation failed"
    exit 1
fi

# Validate Node.js installation
print_status "Validating Node.js installation..."
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    print_success "Node.js $NODE_VERSION is installed"
else
    print_error "Node.js is not installed"
    exit 1
fi

# Validate Ruby installation
print_status "Validating Ruby installation..."
if command -v ruby >/dev/null 2>&1; then
    RUBY_VERSION=$(ruby --version)
    print_success "Ruby $RUBY_VERSION is installed"
else
    print_error "Ruby is not installed"
    exit 1
fi

# Set up Claude tools configuration
print_status "Setting up Claude AI tools..."
/usr/local/bin/setup-claude-tools.sh

# Validate Docker CLI
print_status "Validating Docker CLI..."
if command -v docker >/dev/null 2>&1; then
    print_success "Docker CLI is installed"
else
    print_error "Docker CLI is not installed"
    exit 1
fi

# Set up NeoGradle environment if not already present
if [ ! -f "/workspace/build.gradle" ]; then
    print_status "Setting up NeoGradle MDK template..."
    
    # Clone MDK template if not already present
    if [ ! -d "/tmp/mdk-template" ]; then
        git clone https://github.com/NeoForgeMDKs/MDK-1.21.1-NeoGradle.git /tmp/mdk-template
    fi
    
    # Copy template files to workspace
    cp -r /tmp/mdk-template/* /workspace/
    cp /tmp/mdk-template/.* /workspace/ 2>/dev/null || true
    
    print_success "NeoGradle MDK template set up successfully"
fi

# Make gradlew executable
if [ -f "/workspace/gradlew" ]; then
    chmod +x /workspace/gradlew
    print_success "Gradle wrapper is executable"
fi

# Set up Git configuration if not already set
if [ ! -f "/workspace/.git/config" ] || ! git config --get user.name >/dev/null 2>&1; then
    print_status "Setting up Git configuration..."
    # Set default git config (can be overridden by user)
    git config --global user.name "Developer"
    git config --global user.email "developer@microbiome.local"
    git config --global init.defaultBranch main
    print_success "Git configuration set up"
fi

# Initialize Git repository if not already initialized
if [ ! -d "/workspace/.git" ]; then
    print_status "Initializing Git repository..."
    cd /workspace
    git init
    git add .
    git commit -m "Initial commit: NeoGradle MDK template setup"
    print_success "Git repository initialized"
fi

print_success "🎉 Development environment initialization complete!"
print_status "📚 Available commands:"
echo "  ./gradlew build          - Build the mod"
echo "  ./gradlew runServer      - Run development server"
echo "  ./gradlew runClient      - Run development client"
echo "  claude-code              - Start Claude Code CLI"
echo "  claude_swarm             - Start Claude Swarm"
echo "  docker ps                - List running containers"

# Start interactive bash shell
print_status "🔧 Starting interactive development shell..."
exec /bin/bash