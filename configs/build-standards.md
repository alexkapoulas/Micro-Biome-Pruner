# Build Standards and Processes

## 🔧 Build System Configuration

### NeoGradle Setup
- **Build System:** NeoGradle (with MDK-1.21.1-NeoGradle template)
- **NeoForge Version:** 21.1.193
- **Minecraft Version:** 1.21.1
- **Java Version:** OpenJDK 21 (LTS)
- **Base System:** Oracle Linux with microdnf package manager

### Automatic Initialization
- Container automatically runs `init-dev.sh` on startup
- Sets up NeoGradle MDK template and validates tools
- No manual setup required for development environment

## 🛠️ Build Commands

### Helper Scripts (Recommended)
```bash
# Enhanced build with validation and error handling
build-mod.sh

# Test execution orchestration
run-tests.sh

# Container and tools validation
health-check.sh
```

### Direct NeoGradle Commands
```bash
# Basic build operations
./gradlew clean build           # Clean build
./gradlew build                 # Incremental build

# Development and testing
./gradlew runServer            # Development server
./gradlew runClient            # Development client
./gradlew test                 # Run unit tests

# Distribution
./gradlew shadowJar            # Generate shadow JAR for distribution
./gradlew publishToMavenLocal  # Publish to local Maven repository
```

### Container Initialization Commands
```bash
# Container initialization (automatic on startup)
init-dev.sh                    # Sets up NeoGradle MDK template

# Manual tool setup (if needed)
setup-claude-tools.sh          # Configure Claude tools
```

## ✅ Build Validation Requirements

Before committing code, ensure all of the following pass:

### Core Build Validation
- [ ] `build-mod.sh` completes without errors (or `./gradlew build`)
- [ ] All unit tests pass (`run-tests.sh` or `./gradlew test`)
- [ ] Container health check passes (`health-check.sh`)
- [ ] No compilation warnings
- [ ] Mod loads correctly in development server (`./gradlew runServer`)

### Tool Validation
- [ ] Claude tools are functional (`claude --version`)
- [ ] Container can access Docker socket (for orchestration)
- [ ] All helper scripts execute without errors

### Code Quality
- [ ] Code follows established formatting standards
- [ ] All public methods have Javadoc documentation
- [ ] No hardcoded secrets or API keys
- [ ] Input validation for all configuration parameters

## 📊 Performance Standards

### Build Performance Requirements
- **Incremental builds:** < 30 seconds
- **Clean builds:** < 2 minutes  
- **Container startup:** < 30 seconds
- **Test execution:** < 5 minutes full suite

### Monitoring and Optimization
- Container resource usage tracking
- Build time metrics collection
- Memory leak detection during builds
- Gradle daemon optimization

### Resource Management
- Gradle cache properly configured in `/home/developer/.gradle`
- Build artifacts stored in appropriate volumes
- Temporary files cleaned up after builds

## 🔄 Build Automation

### Automated Checks
- Code formatting validation
- Unit test execution
- Integration test suite (when available)
- Security vulnerability scanning
- Performance regression testing

### Quality Gates
- All tests must pass
- Code coverage thresholds met
- No critical security vulnerabilities
- Performance benchmarks satisfied
- Build artifacts generated successfully

## 🚨 Troubleshooting

### Common Build Issues
```bash
# Check container health and tools
health-check.sh

# View detailed build logs
./gradlew build --info --stacktrace

# Clean and rebuild if needed
./gradlew clean build

# Validate container environment
docker-mgmt.sh validate
```

### Debug Information
```bash
# Check development tools status
java -version
./gradlew --version
claude --version

# Verify container resources
df -h                          # Disk space
free -h                        # Memory usage
```

### Performance Debugging
```bash
# Monitor build performance
./gradlew build --profile

# Check Gradle daemon status
./gradlew --status

# Monitor container resources during build
docker stats micro-biome-dev
```

## 📋 Release Build Process

### Distribution Build
```bash
# Generate release artifacts
./gradlew shadowJar

# Validate release build
./gradlew check

# Test release build in clean environment
docker-mgmt.sh create-test [seed]
```

### Release Validation
- [ ] Shadow JAR generated successfully
- [ ] Mod loads in fresh Minecraft instance
- [ ] All features work as expected
- [ ] Performance meets requirements
- [ ] Security scan passes