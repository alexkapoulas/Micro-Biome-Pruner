# Development Scripts Reference

## 📋 Core Scripts Overview

The development container includes several helper scripts to streamline development workflows. All scripts are available in the container PATH and can be executed directly.

### Script Categories
- **Initialization:** Container setup and environment preparation  
- **Build & Test:** Code compilation and validation
- **Health & Validation:** System and tool verification
- **Container Management:** Docker orchestration and control
- **Tool Setup:** Claude AI tools configuration

## 🚀 Initialization Scripts

### `init-dev.sh`
**Purpose:** Container initialization and NeoGradle MDK setup

**When it runs:**
- Automatically on container startup
- Sets up NeoGradle MDK template
- Validates development environment
- Configures Claude tools

**Usage:**
```bash
# Runs automatically on container startup
# Manual execution (if needed):
init-dev.sh
```

**What it does:**
- Initializes NeoGradle MDK-1.21.1-NeoGradle template
- Sets up project structure if not present
- Validates Java, Node.js, and Ruby installations
- Configures Claude CLI and Swarm tools
- Creates necessary directories and permissions

## 🔨 Build & Test Scripts

### `build-mod.sh`
**Purpose:** Enhanced NeoGradle build with validation and error handling

**Usage:**
```bash
# Standard build
build-mod.sh

# Build with verbose output
build-mod.sh --verbose

# Clean build
build-mod.sh --clean
```

**Features:**
- Enhanced error handling and reporting
- Automatic dependency validation
- Build artifact verification
- Integration with health checks
- Detailed logging and diagnostics

**What it does:**
- Runs `./gradlew build` with enhanced error handling
- Validates build artifacts
- Checks for common build issues
- Reports build metrics and timing
- Integrates with container health validation

### `run-tests.sh`
**Purpose:** Test execution orchestration

**Usage:**
```bash
# Run all tests
run-tests.sh

# Run specific test class
run-tests.sh --class "BiomePrunerTest"

# Run tests with coverage
run-tests.sh --coverage

# Dry run (validate test environment)
run-tests.sh --dry-run
```

**Features:**
- Orchestrates unit test execution
- Generates coverage reports
- Validates test environment
- Handles test data isolation
- Future integration with test-runner containers

**What it does:**
- Executes `./gradlew test` with enhanced reporting
- Manages test data and cleanup
- Generates test reports and coverage data
- Validates test environment prerequisites
- Prepares for integration with Phase 4 testing framework

## 🏥 Health & Validation Scripts

### `health-check.sh`
**Purpose:** Container and tools validation

**Usage:**
```bash
# Full health check
health-check.sh

# Quick check (essential tools only)
health-check.sh --quick

# Verbose output with diagnostics
health-check.sh --verbose

# Check specific component
health-check.sh --component claude
```

**Validation Categories:**
- **System Health:** Container resources, disk space, memory
- **Development Tools:** Java, Node.js, Ruby versions
- **Build System:** NeoGradle, Minecraft toolchain
- **AI Tools:** Claude CLI, Claude Swarm functionality
- **Container Access:** Docker socket, volume mounts
- **Network Connectivity:** Internal container networking

**What it checks:**
```bash
# System components
- Container resource usage
- Disk space availability
- Memory usage
- CPU availability

# Development environment
- Java version and JAVA_HOME
- Node.js and npm functionality
- Ruby and gem functionality
- NeoGradle installation and configuration

# AI tools
- Claude CLI installation and authentication
- Claude Swarm availability and configuration
- Tool configuration files

# Container integration
- Docker socket access
- Volume mount accessibility
- Network connectivity (future phases)
```

## 🐳 Container Management Scripts

### `docker-mgmt.sh`
**Purpose:** Container orchestration and management

**Usage:**
```bash
# Validate container configuration
docker-mgmt.sh validate

# List all project containers
docker-mgmt.sh list

# Create test container (Phase 3)
docker-mgmt.sh create-test [seed]

# Stop and cleanup test containers
docker-mgmt.sh cleanup-tests

# Container status overview
docker-mgmt.sh status
```

**Functions:**
- **validate:** Verify container configuration and health
- **list:** Show all containers in the micro-biome network
- **create-test:** Spawn new test server containers (Phase 3)
- **cleanup-tests:** Remove stopped test containers
- **status:** Display container resource usage and status

**Future Integration:**
- Container orchestration for test servers (Phase 3)
- Test runner container management (Phase 4)
- Resource monitoring and optimization
- Automated container lifecycle management

## 🛠️ Tool Setup Scripts

### `setup-claude-tools.sh`
**Purpose:** Claude tools configuration and setup

**Usage:**
```bash
# Initial setup (runs during container initialization)
setup-claude-tools.sh

# Reconfigure tools
setup-claude-tools.sh --reset

# Validate configuration
setup-claude-tools.sh --validate

# Update tools
setup-claude-tools.sh --update
```

**What it does:**
- Installs Claude CLI via npm
- Installs Claude Swarm via gem
- Configures authentication and settings
- Creates configuration directories
- Validates tool installation
- Sets up project-specific configurations

**Configuration Management:**
- Creates `/home/developer/.config/claude/` directory
- Configures Claude CLI authentication
- Validates Ruby gem installation
- Sets up Claude Swarm project configuration
- Tests tool functionality

## 📊 Script Execution Patterns

### Development Workflow Integration
```bash
# Container startup (automatic)
init-dev.sh

# Development cycle
build-mod.sh                    # Build changes
run-tests.sh                    # Validate with tests
health-check.sh                 # System validation

# Container management
docker-mgmt.sh validate         # Verify container state
docker-mgmt.sh create-test 12345 # Create test environment
```

### Troubleshooting Workflow
```bash
# Comprehensive system check
health-check.sh --verbose

# Validate specific components
health-check.sh --component build
health-check.sh --component claude

# Reset and reconfigure tools
setup-claude-tools.sh --reset
health-check.sh --quick
```

## 🔧 Script Customization

### Environment Variables
Scripts can be customized via environment variables:

```bash
# Build script options
export BUILD_VERBOSE=true
export BUILD_PROFILE=true

# Test script options
export TEST_PARALLEL=true
export TEST_COVERAGE=true

# Health check options
export HEALTH_CHECK_TIMEOUT=30
export HEALTH_CHECK_VERBOSE=true
```

### Configuration Files
Scripts read configuration from:
- `/configs/` directory (mounted volume)
- Container environment variables
- Project-specific settings in workspace

## 🐛 Troubleshooting Scripts

### Common Script Issues

#### Permission Problems
```bash
# Fix script permissions
chmod +x /usr/local/bin/*.sh

# Check script locations
which build-mod.sh
which health-check.sh
```

#### Path Issues
```bash
# Verify scripts are in PATH
echo $PATH | grep /usr/local/bin

# Manual script location
ls -la /usr/local/bin/*.sh
```

#### Execution Failures
```bash
# Run with debug output
bash -x build-mod.sh

# Check container logs
docker logs micro-biome-dev

# Validate container environment
health-check.sh --verbose
```

## 📈 Performance Monitoring

### Script Performance Metrics
- **build-mod.sh:** < 2 minutes for clean builds
- **run-tests.sh:** < 5 minutes for full test suite
- **health-check.sh:** < 30 seconds for full validation
- **init-dev.sh:** < 30 seconds for container initialization

### Monitoring Usage
```bash
# Time script execution
time build-mod.sh

# Monitor resource usage during script execution
docker stats micro-biome-dev

# Profile script performance
bash -x build-mod.sh 2>&1 | ts
```