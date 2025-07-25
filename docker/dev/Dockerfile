# Multi-runtime development container for Minecraft Micro Biome Pruner
# Supports Java 21, Node.js, Ruby for complete development environment

FROM openjdk:21-jdk

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/local/openjdk-21
ENV GRADLE_OPTS="-Xmx2g -Dorg.gradle.daemon=false"
ENV JAVA_OPTS="-Xmx2g"

# Install system dependencies and package managers
RUN microdnf update && microdnf install -y \
    curl \
    wget \
    unzip \
    git \
    vim \
    nano \
    findutils \
    procps-ng \
    gcc \
    gcc-c++ \
    make \
    tar \
    gzip \
    && microdnf clean all

# Install Node.js (for Claude Code CLI)
RUN curl -fsSL https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz -o node.tar.xz \
    && tar -xf node.tar.xz -C /usr/local --strip-components=1 \
    && rm node.tar.xz \
    && ln -s /usr/local/bin/node /usr/bin/node \
    && ln -s /usr/local/bin/npm /usr/bin/npm

# Install Ruby (for Claude Swarm)
RUN microdnf install -y \
    ruby \
    ruby-devel \
    rubygems \
    && microdnf clean all

# Install Docker CLI (client only, no daemon)
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.7.tgz -o docker.tgz \
    && tar -xzf docker.tgz --strip-components=1 -C /usr/local/bin docker/docker \
    && rm docker.tgz \
    && chmod +x /usr/local/bin/docker

# Install Claude Code CLI via npm
RUN npm install -g @anthropic-ai/claude-code

# Install Claude Swarm via gem
RUN gem install claude_swarm

# Create workspace directory
WORKDIR /workspace

# Create user for development (non-root)
RUN groupadd -g 1000 developer \
    && useradd -u 1000 -g developer -m -s /bin/bash developer \
    && usermod -aG docker developer

# Set up proper permissions for workspace
RUN chown -R developer:developer /workspace

# Copy development scripts
COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

# Expose Minecraft development server port
EXPOSE 25565

# Switch to developer user for security
USER developer

# Set up development environment
CMD ["/usr/local/bin/init-dev.sh"]