#!/bin/bash

# Claude tools setup and configuration script
# Configures Claude Code CLI and Claude Swarm for optimal development

set -e

echo "🤖 Setting up Claude AI tools..."

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

# Verify Claude Code CLI installation
print_status "Verifying Claude Code CLI installation..."
if command -v claude-code >/dev/null 2>&1; then
    CLAUDE_CODE_VERSION=$(claude-code --version 2>/dev/null || echo "unknown")
    print_success "Claude Code CLI is installed (version: $CLAUDE_CODE_VERSION)"
else
    print_error "Claude Code CLI is not installed. Attempting to install..."
    npm install -g @anthropic-ai/claude-code
    if [ $? -eq 0 ]; then
        print_success "Claude Code CLI installed successfully"
    else
        print_error "Failed to install Claude Code CLI"
        exit 1
    fi
fi

# Verify Claude Swarm installation
print_status "Verifying Claude Swarm installation..."
if command -v claude_swarm >/dev/null 2>&1; then
    CLAUDE_SWARM_VERSION=$(claude_swarm --version 2>/dev/null || echo "unknown")
    print_success "Claude Swarm is installed (version: $CLAUDE_SWARM_VERSION)"
else
    print_error "Claude Swarm is not installed. Attempting to install..."
    gem install claude_swarm
    if [ $? -eq 0 ]; then
        print_success "Claude Swarm installed successfully"
    else
        print_error "Failed to install Claude Swarm"
        exit 1
    fi
fi

# Create Claude tools configuration directory
CLAUDE_CONFIG_DIR="/home/developer/.config/claude"
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    print_status "Creating Claude configuration directory..."
    mkdir -p "$CLAUDE_CONFIG_DIR"
    print_success "Configuration directory created"
fi

# Set up basic Claude Code configuration
CLAUDE_CODE_CONFIG="$CLAUDE_CONFIG_DIR/claude-code.json"
if [ ! -f "$CLAUDE_CODE_CONFIG" ]; then
    print_status "Creating Claude Code configuration..."
    cat > "$CLAUDE_CODE_CONFIG" << EOF
{
  "workspace": "/workspace",
  "auto_save": true,
  "project_type": "minecraft_mod",
  "build_system": "neogradle",
  "java_version": "21",
  "minecraft_version": "1.21.1",
  "neoforge_version": "21.1.193"
}
EOF
    print_success "Claude Code configuration created"
fi

# Set up Claude Swarm configuration
CLAUDE_SWARM_CONFIG="$CLAUDE_CONFIG_DIR/claude-swarm.yml"
if [ ! -f "$CLAUDE_SWARM_CONFIG" ]; then
    print_status "Creating Claude Swarm configuration..."
    cat > "$CLAUDE_SWARM_CONFIG" << EOF
# Claude Swarm configuration for Minecraft Mod Development
workspace: "/workspace"
project_type: "minecraft_mod"
build_system: "neogradle"

# Development preferences
editor: "vim"
auto_build: true
test_on_change: false

# Minecraft-specific settings
minecraft:
  version: "1.21.1"
  neoforge_version: "21.1.193"
  mod_id: "microbiomepruner"

# Code generation preferences
code_style:
  indentation: "spaces"
  tab_size: 4
  line_length: 120

# Testing configuration
testing:
  framework: "junit"
  integration_tests: true
  mock_minecraft: true
EOF
    print_success "Claude Swarm configuration created"
fi

# Set proper permissions for configuration files
chown -R developer:developer "$CLAUDE_CONFIG_DIR"
chmod 600 "$CLAUDE_CONFIG_DIR"/*

# Create helpful aliases for Claude tools
BASHRC_FILE="/home/developer/.bashrc"
if ! grep -q "# Claude Tools Aliases" "$BASHRC_FILE" 2>/dev/null; then
    print_status "Adding Claude tools aliases to .bashrc..."
    cat >> "$BASHRC_FILE" << 'EOF'

# Claude Tools Aliases
alias cc='claude-code'
alias cs='claude_swarm'
alias claude-help='echo "Available commands: claude-code (cc), claude_swarm (cs)"'

# NeoGradle shortcuts
alias build='./gradlew build'
alias run-server='./gradlew runServer'
alias run-client='./gradlew runClient'
alias clean='./gradlew clean'
EOF
    print_success "Claude tools aliases added to .bashrc"
fi

# Test Claude tools functionality
print_status "Testing Claude tools functionality..."

# Test Claude Code CLI
if claude-code --help >/dev/null 2>&1; then
    print_success "Claude Code CLI is functional"
else
    print_error "Claude Code CLI test failed"
fi

# Test Claude Swarm
if claude_swarm --help >/dev/null 2>&1; then
    print_success "Claude Swarm is functional"
else
    print_error "Claude Swarm test failed"
fi

print_success "🎉 Claude AI tools setup completed!"
print_status "💡 Usage tips:"
echo "  - Use 'claude-code' or 'cc' to start Claude Code CLI"
echo "  - Use 'claude_swarm' or 'cs' to start Claude Swarm"
echo "  - Configuration files are in ~/.config/claude/"
echo "  - Run 'claude-help' for quick reference"