# ============================================
# OpenClaw Agent Container for Basilica
# ============================================
# Runs a 24/7 AI agent with:
# - Chutes inference (Bittensor SN64)
# - Hippius state persistence (Bittensor SN75)
# - Telegram + Moltbook channels

FROM node:22-slim

LABEL org.opencontainers.image.source="https://github.com/synapz-org/openclaw-bittensor"
LABEL org.opencontainers.image.description="OpenClaw agent container for Basilica deployment"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create non-root agent user
RUN useradd -m -s /bin/bash agent
WORKDIR /home/agent

# Create directory structure
RUN mkdir -p \
    workspace \
    .openclaw \
    .config/moltbook \
    config

# Copy workspace (agent personality + knowledge)
COPY --chown=agent:agent workspace/ ./workspace/

# Copy config template
COPY --chown=agent:agent config/openclaw.json ./config/openclaw.json

# Copy entrypoint
COPY --chown=agent:agent scripts/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Switch to non-root user
USER agent

# Gateway port
EXPOSE 18789

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -sf http://localhost:18789/health || exit 1

ENTRYPOINT ["./entrypoint.sh"]
