# Claude AI Tools Configuration and Usage

## 🤖 Available Tools

### Claude Code CLI
- **Binary name:** `claude` (not `claude-code`)
- **Installation:** Via npm in container
- **Purpose:** Interactive AI assistance for development tasks
- **Configuration:** Auto-configured in `/home/developer/.config/claude/`

### Claude Swarm
- **Binary name:** `claude-swarm`
- **Installation:** Via gem in container
- **Purpose:** Multi-agent coordination for complex development tasks
- **Configuration:** Requires `claude-swarm.yml` in project root

## 🛠️ Installation Requirements

### Claude CLI Installation (Prerequisite)
Claude CLI must be installed first before Claude Swarm:
```bash
npm install -g @anthropic-ai/claude-code
```

### Claude Swarm Installation
**Option 1: Direct installation**
```bash
gem install claude_swarm
```

**Option 2: Using Gemfile**
Add to Gemfile and run `bundle install`:
```ruby
gem 'claude_swarm', "~> 0.3.2"
```

### System Requirements
- **Ruby Version:** Requires Ruby 3.2.0+ (container uses Ruby 3.2.0+)
- **Node.js:** Required for Claude CLI (container uses Node.js v20.18.0)
- **Configuration:** Tools are auto-configured during container initialization

## ⚙️ Configuration Setup

### Automatic Configuration
- Configuration is automatically set up during container initialization via `setup-claude-tools.sh`
- Claude CLI config stored in `/home/developer/.config/claude/`
- No manual configuration required for basic usage

### Claude Swarm Configuration File
Create `claude-swarm.yml` in container workspace (`/workspace/`):

```yaml
version: 1
swarm:
  name: "Minecraft Mod Development Team"
  main: mod_developer
  instances:
    mod_developer:
      description: "Core Minecraft mod implementation specialist"
      prompt: |
        You are a Minecraft mod development specialist focused on the Micro Biome Pruner mod. Your expertise includes NeoForge 21.1.193 modding, Minecraft 1.21.1 biome systems, Java development, and NeoGradle build systems. 
        
        Focus on implementing core biome pruning functionality, developing biome generation algorithms, and ensuring NeoForge compatibility. Always reference configs/ documentation for standards and coordinate with the test_specialist for comprehensive coverage.
      directory: /workspace
      model: sonnet
      connections: [test_specialist, documentation_writer]
      allowed_tools:
        - Edit
        - Write
        - MultiEdit
        - Read
        - Glob
        - Grep
        - Bash
        - LS
        - TodoWrite
    test_specialist:
      description: "Minecraft mod testing and validation specialist"
      prompt: |
        You are a testing specialist for Minecraft mod development, ensuring the Micro Biome Pruner mod works reliably. Your expertise includes mod testing frameworks, unit testing, integration testing with Minecraft servers, and test automation.
        
        Design comprehensive test suites, create unit tests for mod components, develop integration tests for live Minecraft environments, and establish testing workflows. Reference configs/testing-standards.md for requirements.
      directory: /workspace
      model: sonnet
      connections: [mod_developer, documentation_writer]
      allowed_tools:
        - Edit
        - Write
        - MultiEdit
        - Read
        - Glob
        - Grep
        - Bash
        - LS
    documentation_writer:
      description: "Internal mod development documentation maintainer"
      prompt: |
        You are the documentation specialist for the Minecraft mod development team, maintaining internal development documentation within the container environment.
        
        Create code architecture documentation, document mod APIs and data structures, maintain development workflows, and create user documentation. Focus on internal mod development docs (separate from configs/ interface docs) while working closely with other team members.
      directory: /workspace
      model: sonnet
      connections: [mod_developer, test_specialist]
      allowed_tools:
        - Edit
        - Write
        - MultiEdit
        - Read
        - Glob
        - Grep
        - LS
```

### Configuration Options

#### Instance Configuration
- **instances:** Define multiple AI agents with specific roles
- **directory:** Set working directory for each instance  
- **model:** Choose AI model (opus, sonnet, haiku)
- **allowed_tools:** Restrict tools available to each instance
- **connections:** Define which instances can communicate
- **vibe:** Enable all tools access (use with caution)

#### Team Structure
- **mod_developer:** Main coordinator for core mod implementation
- **test_specialist:** Minecraft mod testing and validation specialist
- **documentation_writer:** Internal container documentation maintainer

## 🚀 Usage Patterns

### Claude Code CLI
```bash
# Start Claude Code CLI
claude

# Check Claude CLI version
claude --version

# Note: Binary is 'claude', not 'claude-code'
```

### Claude Swarm
```bash
# Launch swarm with configuration file
claude-swarm

# Launch with all tools enabled
claude-swarm --vibe

# Check Claude Swarm version
claude-swarm --version

# Get help
claude-swarm --help
```

### Container Usage
```bash
# Use Claude tools from within container
docker exec -it micro-biome-dev claude --version
docker exec -it micro-biome-dev claude-swarm --help

# Interactive session
docker exec -it micro-biome-dev bash
# Then use tools directly: claude, claude-swarm
```

## 🔧 Development Integration

### Workflow Integration
- **Code Development:** Use Claude CLI for individual development tasks
- **Complex Features:** Use Claude Swarm for multi-component features
- **Code Review:** Leverage AI agents for code analysis and suggestions
- **Testing:** Use test-coordinator agent for test development

### Best Practices
- **Single Tasks:** Use Claude CLI for focused, individual tasks
- **Complex Projects:** Use Claude Swarm for coordinated multi-agent work
- **Security:** Be cautious with `--vibe` flag (enables all tools)
- **Specialization:** Assign agents to specific domains (biomes, testing)

## 🔍 Validation and Health Checks

### Tool Validation
```bash
# Comprehensive health check (includes Claude tools)
health-check.sh

# Check specific tool versions
claude --version
claude-swarm --version
node --version
ruby --version
```

### Configuration Validation
```bash
# Verify Claude CLI configuration
ls -la /home/developer/.config/claude/

# Check Claude Swarm configuration
cat claude-swarm.yml

# Validate Ruby gems
gem list | grep claude_swarm
```

### Environment Checks
```bash
# Check development tools status
docker exec micro-biome-dev claude --version
docker exec micro-biome-dev node --version
docker exec micro-biome-dev ruby --version

# Verify container initialization
docker exec micro-biome-dev ls -la /workspace/
```

## 🐛 Troubleshooting

### Common Issues

#### Claude CLI Not Found
```bash
# Check if npm installation succeeded
npm list -g @anthropic-ai/claude-code

# Manually install if needed
npm install -g @anthropic-ai/claude-code
```

#### Claude Swarm Installation Issues
```bash
# Check Ruby version (must be 3.2.0+)
ruby --version

# Check gem installation
gem list claude_swarm

# Reinstall if needed
gem uninstall claude_swarm
gem install claude_swarm
```

#### Configuration Issues
```bash
# Reset Claude CLI configuration
rm -rf /home/developer/.config/claude/
setup-claude-tools.sh

# Validate Swarm configuration file
claude-swarm --validate-config
```

### Debug Commands
```bash
# Comprehensive system check
health-check.sh

# Container resource monitoring
docker stats micro-biome-dev

# Check container logs for initialization errors
docker logs micro-biome-dev
```

## 🔐 Security Considerations

### Tool Access Control
- **Restricted Tools:** Use `allowed_tools` in configuration to limit capabilities
- **Vibe Mode:** Use `--vibe` cautiously as it enables all tools
- **Directory Isolation:** Configure agents with specific working directories
- **Connection Limits:** Restrict inter-agent communications as needed

### Data Protection
- No secrets in agent configurations
- Configuration files should be version controlled
- Limit agent access to sensitive directories
- Regular security reviews of agent permissions

## 📈 Performance Optimization

### Resource Management
- **Memory Usage:** Monitor agent memory consumption
- **Concurrent Agents:** Limit number of simultaneous agents
- **Tool Restrictions:** Use specific tool allowlists to reduce overhead
- **Directory Scope:** Limit agent working directories to reduce file scanning

### Best Practices for Performance
- Use specific agents for specialized tasks
- Avoid running multiple swarms simultaneously
- Configure appropriate model types for task complexity
- Monitor container resource usage during AI operations