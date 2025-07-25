# Container Workflows and Usage Patterns

## 🐳 Container Architecture

### Development Container (docker/dev/)
**Purpose:** Primary development environment for NeoGradle mod development with Claude AI assistance

**What it contains:**
- **Base System:** Oracle Linux with microdnf package manager
- **Runtime:** OpenJDK 21 (LTS), Node.js v20.18.0, Ruby 3.2.0+
- **Build System:** NeoGradle with MDK-1.21.1-NeoGradle template
- **Minecraft:** Full 1.21.1 NeoForge 21.1.193 development toolchain
- **AI Tools:** Claude Code CLI (`claude` binary) and Claude Swarm (`claude-swarm`)
- **Container Tools:** Docker CLI with socket access for orchestration
- **Development Tools:** Git, vim, nano, curl, wget
- **Helper Scripts:** build-mod.sh, docker-mgmt.sh, health-check.sh, init-dev.sh, run-tests.sh, setup-claude-tools.sh

**Interactions:**
- **Docker Socket Access**: Can create/manage other containers via docker-mgmt.sh
- **NeoGradle Integration**: Automatically sets up MDK template on first run
- **Claude AI Tools**: Integrated Claude Code CLI and Claude Swarm for development
- **Helper Scripts**: Provides automated build, test, and validation workflows
- **Future Integration**: Will spawn minecraft-test containers (Phase 3) and trigger test-runner containers (Phase 4)

### Minecraft Test Server (docker/minecraft-test/) [Planned]
**Purpose:** Isolated NeoForge Minecraft servers for testing biome modifications

**What it contains:**
- Minecraft Server 1.21.1 with NeoForge 21.1.193
- RCON server for remote control
- Custom world generation configurations
- Biome analysis tools and scripts
- Log aggregation and monitoring
- Configurable server properties (seed, difficulty, etc.)
- Volume mounts for mod JARs and world data

**Interactions:**
- Created on-demand by test-runner or dev container
- Multiple instances can run in parallel (different seeds/configs)
- Receives built mod JAR via volume mount
- Controlled via RCON by test-runner

### Test Runner (docker/test-runner/) [Planned]
**Purpose:** Orchestrates automated testing across multiple Minecraft servers

**What it contains:**
- Python 3.11+ test orchestration framework
- RCON client libraries for Minecraft server control
- YAML test definition parser
- Biome verification and analysis tools
- Docker API client for container management
- Test result aggregation and reporting
- Parallel test execution engine
- JUnit XML output for CI integration

**Interactions:**
- Reads YAML test definitions
- Spawns minecraft-test containers as needed
- Connects to servers via RCON
- Teleports to coordinates, checks biomes
- Collects results and generates reports

## 🌐 Network Architecture

All containers communicate via a dedicated Docker network:

```yaml
# docker-compose.yml network configuration
networks:
  micro-biome-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

**Network Layout:**
- Development Container: `172.20.0.10` (static IP)
- Test Runner: `172.20.0.20` (static IP)  
- Minecraft Test Servers: `172.20.0.100+` (dynamic allocation)

## 💾 Volume Management

**Shared Volumes:**
- `micro-biome-source`: Source code and build artifacts → `/workspace` (developer user)
- `micro-biome-gradle`: NeoGradle cache and dependencies → `/home/developer/.gradle` (developer user)
- `micro-biome-results`: Test results and reports → `/results`
- `micro-biome-configs`: Configuration files and templates → `/configs`
- **Docker Socket:** `/var/run/docker.sock` → Container orchestration access

**Resource Limits:**
- **Development Container:** 2GB RAM, 2 CPU cores
- **Test Server:** 1GB RAM, 1 CPU core per instance
- **Test Runner:** 512MB RAM, 1 CPU core

## 🔄 Development Workflows

### Initial Setup
```bash
# Start development environment
docker-compose up -d dev

# Enter development container
docker exec -it micro-biome-dev bash
```

### Container Initialization (Automatic)
When the development container starts:
1. `init-dev.sh` runs automatically on container startup
2. Sets up NeoGradle MDK template
3. Configures Claude tools
4. Validates development environment

### Development Cycle
```bash
# 1. Container starts automatically with init-dev.sh (sets up NeoGradle MDK)
# 2. Code changes (edit Java files using NeoGradle/MDK structure)

# 3. Build mod using helper script or direct commands
build-mod.sh
./gradlew build

# 4. Test changes
./gradlew runServer  # or runClient for client testing
health-check.sh      # validate container and tools

# 5. Run container validation
docker-mgmt.sh validate

# 6. Generate release build (using NeoGradle)
./gradlew shadowJar
```

### Container Usage Patterns

**Code Development:**
- Edit files in `/workspace` (mounted from `./src`)
- Build with `build-mod.sh` or `./gradlew build`
- Test changes with `./gradlew runServer` or `./gradlew runClient`
- Validate environment with `health-check.sh`

**Testing (Current Phase):**
```bash
# Run unit tests
run-tests.sh  # or ./gradlew test

# Validate container health
health-check.sh

# Note: Integration testing will be available in Phase 4
```

### Data Management
- Persistent data only in designated volumes
- Regular backup of configuration files
- Version control for all configuration changes

### Security Considerations
- No secrets in container images
- RCON passwords via environment variables only
- Docker socket access limited to dev container
- Network isolation from host system