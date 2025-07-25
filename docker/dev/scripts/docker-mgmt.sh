#!/bin/bash

# Docker container management script for development environment
# Provides helper functions for managing test containers and orchestration

set -e

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

print_info() {
    echo "💡 $1"
}

# Validate Docker socket access
validate_docker_access() {
    print_status "Validating Docker socket access..."
    
    if ! docker info >/dev/null 2>&1; then
        print_error "Cannot access Docker daemon. Check socket mount."
        return 1
    fi
    
    print_success "Docker socket access is working"
    return 0
}

# List all containers in the micro-biome network
list_containers() {
    print_status "Listing containers in micro-biome network..."
    
    docker network inspect micro-biome-net >/dev/null 2>&1 || {
        print_error "micro-biome-net network not found"
        return 1
    }
    
    echo "🐳 Containers in micro-biome-net:"
    docker network inspect micro-biome-net | jq -r '.[] | .Containers | to_entries[] | "  - \(.value.Name) (\(.value.IPv4Address))"' 2>/dev/null || {
        docker ps --filter network=micro-biome-net --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    }
}

# Create a test server container
create_test_server() {
    local seed="${1:-12345}"
    local container_name="test-server-${seed}"
    
    print_status "Creating test server with seed: $seed"
    
    # Check if container already exists
    if docker ps -a --format "{{.Names}}" | grep -q "^${container_name}$"; then
        print_info "Container $container_name already exists. Removing..."
        docker rm -f "$container_name" >/dev/null 2>&1
    fi
    
    # Check if test image is available
    if ! docker image inspect micro-biome-test >/dev/null 2>&1; then
        print_error "micro-biome-test image not found. Build it first."
        return 1
    fi
    
    # Create and start the container
    docker run -d \
        --name "$container_name" \
        --network micro-biome-net \
        -e MINECRAFT_SEED="$seed" \
        -e RCON_PASSWORD="test$(date +%s)" \
        -v /workspace/build/libs:/mods:ro \
        micro-biome-test
    
    if [ $? -eq 0 ]; then
        print_success "Test server '$container_name' created successfully"
        
        # Wait for container to be ready
        print_status "Waiting for server to start..."
        sleep 10
        
        # Get container IP
        local container_ip=$(docker inspect "$container_name" | jq -r '.[0].NetworkSettings.Networks["micro-biome-net"].IPAddress' 2>/dev/null || echo "unknown")
        print_info "Server IP: $container_ip"
        print_info "RCON port: 25575"
        print_info "Game port: 25565"
    else
        print_error "Failed to create test server"
        return 1
    fi
}

# Run test suite using test-runner
run_test_suite() {
    local suite="${1:-all}"
    
    print_status "Running test suite: $suite"
    
    # Check if test-runner image is available
    if ! docker image inspect micro-biome-test-runner >/dev/null 2>&1; then
        print_error "micro-biome-test-runner image not found. Build it first."
        return 1
    fi
    
    # Run the test suite
    docker run --rm \
        --network micro-biome-net \
        -v /workspace/test-definitions:/tests:ro \
        -v micro-biome-results:/results \
        -v /var/run/docker.sock:/var/run/docker.sock \
        micro-biome-test-runner --suite "$suite"
    
    if [ $? -eq 0 ]; then
        print_success "Test suite '$suite' completed successfully"
    else
        print_error "Test suite '$suite' failed"
        return 1
    fi
}

# Clean up test containers
cleanup_test_containers() {
    print_status "Cleaning up test containers..."
    
    # Find and remove test server containers
    local test_containers=$(docker ps -a --filter name=test-server- --format "{{.Names}}")
    
    if [ -n "$test_containers" ]; then
        echo "$test_containers" | while read container; do
            print_status "Removing container: $container"
            docker rm -f "$container" >/dev/null 2>&1
        done
        print_success "Test containers cleaned up"
    else
        print_info "No test containers to clean up"
    fi
}

# Show container logs
show_logs() {
    local container_name="$1"
    
    if [ -z "$container_name" ]; then
        print_error "Container name required"
        return 1
    fi
    
    if ! docker ps -a --format "{{.Names}}" | grep -q "^${container_name}$"; then
        print_error "Container '$container_name' not found"
        return 1
    fi
    
    print_status "Showing logs for container: $container_name"
    docker logs -f "$container_name"
}

# Print usage information
show_help() {
    echo "🐳 Docker Management Script for Micro Biome Pruner Development"
    echo ""
    echo "Usage: docker-mgmt.sh <command> [options]"
    echo ""
    echo "Commands:"
    echo "  validate              - Validate Docker socket access"
    echo "  list                  - List containers in micro-biome network"
    echo "  create-test [seed]    - Create test server (default seed: 12345)"
    echo "  run-tests [suite]     - Run test suite (default: all)"
    echo "  cleanup               - Remove all test containers"
    echo "  logs <container>      - Show logs for specific container"
    echo "  help                  - Show this help message"
    echo ""
    echo "Examples:"
    echo "  docker-mgmt.sh create-test 67890"
    echo "  docker-mgmt.sh run-tests biome-generation"
    echo "  docker-mgmt.sh logs test-server-12345"
}

# Main script logic
case "${1:-help}" in
    validate)
        validate_docker_access
        ;;
    list)
        validate_docker_access && list_containers
        ;;
    create-test)
        validate_docker_access && create_test_server "$2"
        ;;
    run-tests)
        validate_docker_access && run_test_suite "$2"
        ;;
    cleanup)
        validate_docker_access && cleanup_test_containers
        ;;
    logs)
        validate_docker_access && show_logs "$2"
        ;;
    help|*)
        show_help
        ;;
esac