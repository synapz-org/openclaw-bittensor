# OpenClaw Agent Container for Basilica Deployment
# Runs a 24/7 agent with persistent state via Hippius

FROM node:22-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create agent user (non-root for security)
RUN useradd -m -s /bin/bash agent
USER agent
WORKDIR /home/agent

# Create workspace directory
RUN mkdir -p workspace .openclaw .config/moltbook

# Copy workspace files (baked into image or mounted)
# In production, these come from Hippius on startup
COPY --chown=agent:agent workspace/ ./workspace/

# Copy configuration
COPY --chown=agent:agent config/openclaw.json ./.openclaw/openclaw.json

# Expose gateway port
EXPOSE 18789

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:18789/health || exit 1

# Entrypoint script handles:
# 1. Restore state from Hippius (if configured)
# 2. Start gateway
# 3. Sync state to Hippius periodically
COPY --chown=agent:agent scripts/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
