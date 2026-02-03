# ============================================
# OpenClaw Agent Container for Basilica
# ============================================

FROM node:22-bookworm

LABEL org.opencontainers.image.source="https://github.com/synapz-org/openclaw-bittensor"
LABEL org.opencontainers.image.description="OpenClaw agent container for Basilica deployment"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create non-root agent user
RUN useradd -m -s /bin/bash agent

# Switch to agent user BEFORE creating directories
USER agent
WORKDIR /home/agent

# Create directory structure (as agent user)
RUN mkdir -p workspace .openclaw .config/moltbook config

# Copy files (still owned by agent due to --chown)
COPY --chown=agent:agent workspace/ ./workspace/
COPY --chown=agent:agent config/openclaw.json ./config/openclaw.json
COPY --chown=agent:agent scripts/entrypoint.sh ./entrypoint.sh

RUN chmod +x ./entrypoint.sh

EXPOSE 18789

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -sf http://localhost:18789/health || exit 1

ENTRYPOINT ["./entrypoint.sh"]
