# Development Standards

## 🎯 Overview
This document establishes coding standards, development practices, and workflow guidelines for the Minecraft Micro Biome Pruner mod development.

**Related Documentation:**
- Container workflows and usage: [container-workflows.md](container-workflows.md)
- Build processes and commands: [build-standards.md](build-standards.md)
- Testing requirements: [testing-standards.md](testing-standards.md)
- Claude AI tools: [claude-tools.md](claude-tools.md)
- Development scripts: [scripts-reference.md](scripts-reference.md)

## 📝 Coding Standards and Conventions

### Java Code Standards
- **Java Version:** OpenJDK 21 (LTS)
- **Code Style:** Follow standard Java conventions with 4-space indentation
- **Naming Conventions:**
  - Classes: PascalCase (e.g., `BiomePruner`)
  - Methods/Variables: camelCase (e.g., `generateBiome()`)
  - Constants: UPPER_SNAKE_CASE (e.g., `MAX_BIOME_SIZE`)
  - Packages: lowercase with dots (e.g., `com.microbiome.pruner`)

### File Organization
```
src/
├── main/
│   ├── java/com/microbiome/pruner/
│   │   ├── core/           # Core mod functionality
│   │   ├── biomes/         # Biome generation logic
│   │   ├── config/         # Configuration handling
│   │   └── utils/          # Utility classes
│   └── resources/
│       ├── META-INF/       # Mod metadata
│       └── assets/         # Textures, models, etc.
└── test/
    └── java/com/microbiome/pruner/
        └── tests/          # Unit tests
```

### Documentation Requirements
- All public classes and methods must have Javadoc comments
- Complex algorithms require inline comments
- README files for each major module


## 🌿 Git Workflow and Branching Strategy

### Branch Structure
- **main:** Production-ready code
- **develop:** Integration branch for features
- **feature/[name]:** Individual feature development
- **hotfix/[name]:** Critical bug fixes
- **release/[version]:** Release preparation

### Commit Message Format
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:** feat, fix, docs, style, refactor, test, chore

**Examples:**
```
feat(biomes): add micro biome generation algorithm
fix(config): resolve config file loading issue
docs(readme): update installation instructions
```

### Merge Requirements
- All commits must pass automated tests
- Code review required for main branch
- Squash commits for feature merges




## 🔒 Security and Best Practices

### Code Security
- Input validation for all configuration parameters
- No hardcoded passwords or API keys
- Sanitize all user-provided data
- Follow OWASP security guidelines
- Use secure random number generation
- Validate file paths to prevent directory traversal
- Implement proper error handling without information leakage

### Data Security
- Never commit secrets or sensitive data to version control
- Use environment variables for configuration secrets
- Implement proper access controls for mod features
- Validate all external data sources

## 📊 Performance Standards

### Runtime Performance Requirements
- **Biome generation:** < 100ms per chunk
- **Memory efficiency:** Avoid memory leaks, use object pooling where appropriate
- **CPU optimization:** Minimize unnecessary calculations in hot paths
- **I/O operations:** Batch file operations and cache frequently accessed data

### Code Performance Guidelines
- Use efficient data structures (HashMap vs LinkedList consideration)
- Implement lazy loading for expensive operations
- Cache computed values when appropriate
- Profile code to identify bottlenecks
- Avoid premature optimization, but design with performance in mind

### Performance Monitoring
- Include performance tests for critical algorithms
- Monitor memory usage patterns
- Profile biome generation under various conditions
- Track performance regression in CI

## 🔄 Continuous Integration

### Automated Checks
- **Code formatting:** Enforce consistent code style
- **Static analysis:** Detect potential bugs and code smells
- **Unit tests:** All tests must pass
- **Security scanning:** Check for known vulnerabilities
- **Documentation:** Ensure Javadoc coverage for public APIs

### Quality Gates
- All automated tests must pass
- Code coverage thresholds met (80% minimum)
- No critical security vulnerabilities
- Code style compliance
- Performance benchmarks satisfied
- All public APIs documented

## 📋 Definition of Done

### Feature Completion Criteria
- [ ] Code implements requirements completely
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] Documentation updated
- [ ] Code review completed
- [ ] Performance requirements met
- [ ] Security review passed

### Release Criteria
- [ ] All automated tests passing
- [ ] Manual testing completed
- [ ] Documentation current
- [ ] Performance benchmarks met
- [ ] Security scan clean
- [ ] Release notes prepared

---

*This document should be reviewed and updated regularly as the project evolves.*