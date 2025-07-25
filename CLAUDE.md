# Minecraft Micro Biome Pruner - Project Overview

**📊 Implementation Status:**
- ✅ **Phase 1:** Foundation Setup - Complete
- ✅ **Phase 2:** Development Container - Complete  
- 🔄 **Phase 3:** Minecraft Test Server - Planned
- 🔄 **Phase 4:** Test Runner Framework - Planned
- 🔄 **Phase 5:** Integration & Testing - Planned

## 📖 Documentation Structure

**Container-Accessible Documentation** (located in `configs/`):
- **[Container Workflows](configs/container-workflows.md)** - Container usage patterns, development workflows, and volume management
- **[Build Standards](configs/build-standards.md)** - Build processes, NeoGradle commands, and validation requirements
- **[Testing Standards](configs/testing-standards.md)** - Test execution, requirements, and coverage standards
- **[Claude Tools](configs/claude-tools.md)** - Claude CLI and Swarm setup, configuration, and usage patterns
- **[Scripts Reference](configs/scripts-reference.md)** - Development scripts documentation and usage
- **[Development Standards](configs/development-standards.md)** - Coding standards, Git workflow, and best practices

## 🚀 Quick Start

```bash
# Start development environment
docker-compose up -d dev

# Enter development container
docker exec -it micro-biome-dev bash

# Container auto-initializes with NeoGradle MDK
# Build mod: build-mod.sh
# Run tests: run-tests.sh  
# Health check: health-check.sh
```

## 🏗️ Architecture Overview

**Containers:**
- **Development Container** (`docker/dev/`) - Primary NeoGradle development environment with Claude AI tools
- **Minecraft Test Server** (`docker/minecraft-test/`) - Isolated test servers with RCON control [Planned]
- **Test Runner** (`docker/test-runner/`) - Automated testing orchestration [Planned]

**Network:** Dedicated `micro-biome-net` bridge network (172.20.0.0/16)

**Volumes:** Shared storage for source code, Gradle cache, test results, and configurations

## 🤖 Claude Swarm Configuration

**Docker Architecture Team** (Host-Side):
```bash
# Launch Docker architecture team
claude-swarm

# Team focuses on phases 3-5 implementation:
# - Minecraft Test Server containers
# - Test Runner Framework
# - Integration & Testing
```

**Minecraft Development Team** (Container-Side):
```bash
# From within development container
docker exec -it micro-biome-dev bash
cd /workspace
claude-swarm

# Team focuses on mod development:
# - Core mod implementation
# - Testing frameworks
# - Internal documentation
```

## 📋 Documentation Boundaries

**Architecture Team Maintains**:
- `CLAUDE.md` - Project overview and Docker swarm configuration
- `configs/*.md` - Container interface documentation (consumed by containers)

**Container Development Team Maintains**:
- Internal mod development documentation within container filesystem
- Code architecture and API documentation
- Development workflows specific to mod implementation

## 🐛 Host-Side Debugging

```bash
# Container health and logs
docker logs micro-biome-dev
health-check.sh

# Tool validation  
docker exec micro-biome-dev claude --version
docker exec micro-biome-dev java -version

# Container management
docker exec micro-biome-dev docker-mgmt.sh validate
```

---
*For detailed information, see the documentation files in the `configs/` directory.*