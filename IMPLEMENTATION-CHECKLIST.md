# Minecraft Micro Biome Pruner - Docker Implementation Checklist

## 📋 Implementation Phases

### Phase 1: Foundation Setup ✅
- [x] Create project directory structure
- [x] Set up Docker network configuration  
- [x] Define shared volumes
- [x] Create base docker-compose.yml
- [x] Establish development environment standards

### Phase 2: Development Container ✅
- [x] Create Dockerfile for development environment
- [x] Install NeoForge 21.1.193 toolchain  
- [x] Configure OpenJDK 21 + NeoGradle build system
- [x] Add Claude Code CLI and Claude Swarm (updated: corrected Ruby version requirement to 3.2.0+, fixed command syntax, added configuration documentation)
- [x] Set up Docker socket access
- [x] Configure development tools (git, vim, utilities)
- [x] Test container build and basic functionality

### Phase 3: Minecraft Test Server 🎮
- [ ] Create Dockerfile for Minecraft test server
- [ ] Configure Minecraft Server 1.21.1 with NeoForge
- [ ] Set up RCON server configuration
- [ ] Implement configurable server properties
- [ ] Add volume mounts for mods data
- [ ] Create startup scripts and health checks
- [ ] Test server startup and RCON connectivity

### Phase 4: Test Runner Framework 🧪
- [ ] Create Dockerfile for test orchestration
- [ ] Set up Python 3.11+ environment
- [ ] Install RCON client libraries
- [ ] Implement YAML test definition parser
- [ ] Create Docker API client integration
- [ ] Build parallel test execution engine
- [ ] Add JUnit XML output generation
- [ ] Implement test result aggregation

### Phase 5: Integration & Testing 🔗
- [ ] Create complete docker-compose.yml
- [ ] Test inter-container communication
- [ ] Validate volume sharing and persistence
- [ ] Run end-to-end test scenarios
- [ ] Performance benchmarking
- [ ] Documentation and examples

---

## 🏗️ Technical Specifications Matrix

### Development Container (`micro-biome-dev`)
| Component | Version/Config | Status | Notes |
|-----------|----------------|--------|-------|
| Base Image | `openjdk:21-jdk` | ⏳ |  |
| NeoForge | 21.1.193 | ⏳ |  |
| Gradle | 8.x | ⏳ |  |
| Claude Code CLI | Latest | ⏳ |  |
| Claude Swarm | Latest | ✅ | Corrected installation/config docs |
| Docker CLI | Latest | ⏳ |  |
| Network IP | 172.20.0.10 | ⏳ |  |
| Volumes | source, gradle | ⏳ |  |

### Minecraft Test Server (`micro-biome-test`)
| Component | Version/Config | Status | Notes |
|-----------|----------------|--------|-------|
| Base Image | `openjdk:21-jre` | ⏳ |  |
| Minecraft Server | 1.21.1 | ⏳ |  |
| NeoForge | 21.1.193 | ⏳ |  |
| RCON Port | 25575 | ⏳ |  |
| Game Port | 25565 | ⏳ |  |
| Network IP | 172.20.0.100+ | ⏳ |  |
| Volumes | mods, worlds | ⏳ |  |

### Test Runner (`micro-biome-test-runner`)
| Component | Version/Config | Status | Notes |
|-----------|----------------|--------|-------|
| Base Image | `python:3.11-slim` | ⏳ |  |
| RCON Client | mcrcon | ⏳ |  |
| Docker API | docker-py | ⏳ |  |
| YAML Parser | PyYAML | ⏳ |  |
| Test Framework | pytest | ⏳ |  |
| Network IP | 172.20.0.20 | ⏳ |  |
| Volumes | tests, results | ⏳ |  |

---

## 📁 Configuration Templates

### docker-compose.yml Structure
```yaml
version: '3.8'

services:
  dev:
    # Development container config
    
  test-runner:
    # Test orchestration config
    
volumes:
  # Shared volume definitions
  
networks:
  # Network configuration
```

### Dockerfile Templates

#### Development Container
```dockerfile
FROM openjdk:21-jdk

# Install development tools
# Configure NeoForge environment  
# Add Claude tools
# Set up Docker CLI

WORKDIR /workspace
EXPOSE 25565

CMD ["bash"]
```

#### Test Server
```dockerfile  
FROM openjdk:21-jre

# Install Minecraft Server
# Configure NeoForge
# Set up RCON
# Add startup scripts

WORKDIR /minecraft
EXPOSE 25565 25575

CMD ["java", "-jar", "server.jar", "nogui"]
```

#### Test Runner
```dockerfile
FROM python:3.11-slim

# Install Python dependencies
# Add test framework
# Configure Docker API access

WORKDIR /tests
CMD ["python", "test_runner.py"]
```

---

## 🧪 Testing Matrix

### Unit Tests
- [ ] Container build validation
- [ ] Network connectivity tests  
- [ ] Volume mount verification
- [ ] Service health checks

### Integration Tests  
- [ ] Dev → Test Server communication
- [ ] Test Runner → Dev container orchestration
- [ ] RCON command execution
- [ ] Mod deployment and loading

### End-to-End Scenarios
- [ ] Complete development workflow
- [ ] Multi-server parallel testing
- [ ] Biome generation verification
- [ ] Performance under load

---

## 🚨 Troubleshooting Playbook

### Common Issues

#### Container Won't Start
**Symptoms:** Exit code 1, immediate container stop
**Checks:**
- [ ] Dockerfile syntax validation
- [ ] Base image availability
- [ ] Port conflicts
- [ ] Volume mount permissions

#### Network Communication Failure
**Symptoms:** Cannot reach other containers
**Checks:**
- [ ] Docker network creation
- [ ] Container IP assignments
- [ ] Firewall/security groups
- [ ] Service discovery

#### RCON Connection Issues
**Symptoms:** Connection refused, timeout
**Checks:**  
- [ ] RCON enabled in server.properties
- [ ] Correct port exposure (25575)
- [ ] Password configuration
- [ ] Network routing

#### Volume Mount Problems
**Symptoms:** Files not persisting, permission denied
**Checks:**
- [ ] Volume creation and naming
- [ ] Mount point paths
- [ ] File permissions (uid/gid)
- [ ] Host directory permissions

---

## 📊 Progress Tracking

### Overall Progress: ⬛⬛⬜⬜⬜ 12/25 Tasks Complete

**Phase 1 - Foundation:** ⬛⬛⬛⬛⬛ 5/5 ✅ COMPLETE  
**Phase 2 - Development:** ⬛⬛⬛⬛⬛⬛⬛ 7/7 ✅ COMPLETE  
**Phase 3 - Test Server:** ⬜⬜⬜⬜⬜⬜⬜ 0/7  
**Phase 4 - Test Runner:** ⬜⬜⬜⬜⬜⬜⬜⬜ 0/8  
**Phase 5 - Integration:** ⬜⬜⬜⬜⬜ 0/5  

---

## 📝 Implementation Notes & Scratchpad

### Architecture Decisions
| Decision | Rationale | Date | Impact |
|----------|-----------|------|--------|
| Static IPs for core services | Predictable networking for RCON | TBD | Medium |
| Separate test runner container | Isolation and scalability | TBD | High |
| Volume-based mod deployment | Hot-reload capability | TBD | Medium |

### Performance Requirements
- **Container Startup:** < 30 seconds per container
- **Mod Build Time:** < 2 minutes for incremental builds  
- **Test Execution:** < 5 minutes for full suite
- **Memory Usage:** < 4GB total for all containers
- **Storage:** < 10GB for development environment

### Security Considerations
- [ ] Docker socket access limited to dev container only
- [ ] RCON passwords via environment variables
- [ ] Network isolation from host system
- [ ] Volume mount permissions properly configured
- [ ] No sensitive data in container images

### Blockers & Issues
*Record any blockers encountered during implementation*

### Ideas & Improvements
*Space for future enhancements and optimizations*

### Resource Allocation
- **Development Container:** 2GB RAM, 2 CPU cores
- **Test Server (each):** 1GB RAM, 1 CPU core  
- **Test Runner:** 512MB RAM, 1 CPU core
- **Total Network:** 172.20.0.0/16 subnet
- **Storage Requirements:** 10GB+ available disk space

---

## ✅ Completion Criteria

**Definition of Done for Each Phase:**
1. All containers build successfully without errors
2. Inter-container communication working as designed
3. Volume mounts preserve data correctly
4. Health checks pass for all services
5. Basic functionality tests pass
6. Documentation updated with working examples
7. Performance meets specified requirements

**Final Acceptance:**
- [ ] Complete development workflow functional
- [ ] Automated testing pipeline operational  
- [ ] All documentation current and accurate
- [ ] Performance benchmarks met
- [ ] Security requirements satisfied