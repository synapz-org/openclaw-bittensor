# ============================================
# OpenClaw Agent Container for Basilica
# ============================================

FROM node:22-bookworm

LABEL org.opencontainers.image.source="https://github.com/synapz-org/openclaw-bittensor"
LABEL org.opencontainers.image.description="OpenClaw agent container for Basilica deployment"

# Install system dependencies (including Chromium for browser tool)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    git \
    ca-certificates \
    chromium \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libxshmfence1 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Set Chromium path for Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Patch @homebridge/ciao mDNS to handle long hostnames (Kubernetes compatibility)
# K8s pod names exceed the 63-byte DNS label limit, causing an uncaught assertion crash.
# Replace the assertion with label truncation so mDNS degrades gracefully instead of crashing.
RUN CIAO_FILE=$(find /usr/local/lib/node_modules/openclaw -path "*/ciao/lib/coder/DNSLabelCoder.js" -type f) && \
    if [ -n "$CIAO_FILE" ]; then \
        sed -i 's/(0, assert_1.default)(byteLength <= 63, "Label cannot be longer than 63 bytes (" + label + ")");/if (byteLength > 63) { label = label.substring(0, 63); }/g' "$CIAO_FILE" && \
        echo "Patched ciao mDNS for K8s compatibility: $CIAO_FILE"; \
    fi

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
