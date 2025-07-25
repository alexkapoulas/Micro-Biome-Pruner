# Testing Standards and Requirements

## 🧪 Test Categories

### 1. Unit Tests
- **Purpose:** Individual component testing
- **Scope:** Test individual classes and methods in isolation
- **Location:** `src/test/java/com/microbiome/pruner/tests/`
- **Current Status:** Available and implemented

### 2. Integration Tests
- **Purpose:** Container communication and component interaction
- **Scope:** Test interactions between different system components
- **Current Status:** Planned for Phase 4 (Test Runner Framework)

### 3. End-to-End Tests
- **Purpose:** Complete biome generation workflows
- **Scope:** Full system testing with real Minecraft environments
- **Current Status:** Planned for Phase 4 (Test Runner Framework)

### 4. Performance Tests
- **Purpose:** Load and stress testing
- **Scope:** Validate performance requirements under various conditions
- **Current Status:** Planned for Phase 5 (Integration & Testing)

## 📁 Test Structure

```
test-definitions/
├── unit/
│   ├── biome-generation.yml
│   └── config-handling.yml
├── integration/
│   ├── server-communication.yml
│   └── mod-loading.yml
└── e2e/
    ├── biome-pruning-workflow.yml
    └── multi-server-testing.yml
```

**Unit Test Organization:**
```
src/test/java/com/microbiome/pruner/
└── tests/
    ├── core/           # Core functionality tests
    ├── biomes/         # Biome generation tests
    ├── config/         # Configuration handling tests
    └── utils/          # Utility class tests
```

## ⚡ Test Execution

### Current Testing (Phase 2)
```bash
# Run unit tests using helper script (recommended)
run-tests.sh

# Direct NeoGradle command
./gradlew test

# Run tests with detailed output
./gradlew test --info

# Run specific test class
./gradlew test --tests "com.microbiome.pruner.tests.BiomePrunerTest"
```

### Future Testing (Phase 4)
```bash
# Run all test suites (via test-runner container)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./test-definitions:/tests \
  -v ./test-results:/results \
  micro-biome-test-runner

# Run specific test suite
docker run --rm micro-biome-test-runner --suite biome-generation

# Generate test report
docker run --rm micro-biome-test-runner --report-only
```

## 📊 Test Execution Standards

### Performance Requirements
- **Test execution time:** < 5 minutes for full suite
- **Individual test timeout:** < 30 seconds per test
- **Parallel execution:** Support for concurrent test runs
- **Resource usage:** < 1GB RAM during test execution

### Quality Requirements
- **Deterministic:** Tests must be repeatable and reliable
- **Isolated:** Test data must be isolated between runs
- **Automated:** All tests must be fully automated
- **Self-contained:** Tests should not depend on external services

### Test Data Management
- Use test-specific seeds for predictable world generation
- Clean up test artifacts after execution
- Isolated test environments for each test run
- Version-controlled test configurations

## 📈 Coverage Requirements

### Code Coverage Targets
- **Minimum overall coverage:** 80% for core functionality
- **Critical algorithms:** 100% coverage for biome generation algorithms
- **Public APIs:** 100% coverage for all public methods
- **Configuration handling:** 90% coverage for config parsing and validation

### Coverage Reporting
```bash
# Generate coverage report
./gradlew test jacocoTestReport

# View coverage report
open build/reports/jacoco/test/html/index.html
```

### Coverage Exclusions
- Generated code (NeoForge annotations)
- Simple getter/setter methods
- Logging statements
- Exception handling for unreachable code

## ✅ Test Validation Process

### Pre-Commit Testing
Before committing code, ensure:
- [ ] All unit tests pass (`run-tests.sh`)
- [ ] Test coverage meets minimum requirements
- [ ] No flaky or unstable tests
- [ ] Test execution time within limits
- [ ] All test dependencies available

### Test Quality Checks
- [ ] Tests follow naming conventions (`testMethodName_Scenario_ExpectedResult`)
- [ ] Each test validates a single concern
- [ ] Test data is properly isolated
- [ ] Assertions are clear and specific
- [ ] Error cases are properly tested

## 🔄 Continuous Integration Testing

### Automated Test Execution
- **Trigger:** Every commit and pull request
- **Environment:** Clean container environment
- **Reporting:** JUnit XML output for CI integration
- **Artifacts:** Test reports and coverage data

### Quality Gates
- [ ] All tests must pass
- [ ] Code coverage thresholds met
- [ ] No critical test failures
- [ ] Performance benchmarks satisfied
- [ ] Test execution time within limits

## 🐛 Test Debugging

### Debugging Failed Tests
```bash
# Run single test with debug output
./gradlew test --tests "TestClassName" --info --stacktrace

# Run tests with JVM debug port
./gradlew test --debug-jvm

# Check test environment
health-check.sh
```

### Test Environment Validation
```bash
# Verify container test environment
docker exec micro-biome-dev run-tests.sh --dry-run

# Check test dependencies
./gradlew dependencies --configuration testCompileClasspath

# Validate test data
ls -la src/test/resources/
```

## 📋 Future Testing Framework (Phase 4)

### Minecraft Test Server Integration
- **RCON Control:** Remote command execution for test scenarios
- **Multiple Seeds:** Parallel testing with different world configurations
- **Biome Validation:** Automated biome verification and analysis
- **Log Analysis:** Automated parsing of server logs for issues

### Test Orchestration
- **YAML Definitions:** Human-readable test scenario definitions
- **Parallel Execution:** Multiple test servers running simultaneously
- **Result Aggregation:** Consolidated reporting across all test runs
- **CI Integration:** Automated test execution in deployment pipeline

### Performance Testing
- **Load Testing:** High-volume biome generation scenarios
- **Memory Profiling:** Memory usage analysis during extended runs
- **Latency Testing:** Response time validation for biome operations
- **Stress Testing:** System behavior under extreme conditions