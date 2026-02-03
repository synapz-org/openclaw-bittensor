#!/bin/bash
set -e

echo "🧠 Starting Synapz Agent Container"
echo "=================================="

# 1. Substitute environment variables in config
echo "📝 Configuring OpenClaw..."
mkdir -p ~/.openclaw

# Replace ENV: placeholders with actual values
sed -e "s|ENV:CHUTES_API_KEY|${CHUTES_API_KEY}|g" \
    -e "s|ENV:TELEGRAM_BOT_TOKEN|${TELEGRAM_BOT_TOKEN}|g" \
    -e "s|ENV:TELEGRAM_ALLOWED_USERS|${TELEGRAM_ALLOWED_USERS}|g" \
    /home/agent/config/openclaw.json > ~/.openclaw/openclaw.json

echo "✅ Config written to ~/.openclaw/openclaw.json"

# 2. Restore from Hippius if CID provided
if [ -n "$HIPPIUS_RESTORE_CID" ]; then
    echo "📥 Restoring state from Hippius: $HIPPIUS_RESTORE_CID"
    # TODO: Implement hippius restore when CLI is ready
    # hipc storage download $HIPPIUS_RESTORE_CID ./workspace/
fi

# 3. Verify workspace
if [ ! -f "/home/agent/workspace/SOUL.md" ]; then
    echo "❌ No SOUL.md found - agent has no personality!"
    exit 1
fi

SOUL_TITLE=$(head -1 /home/agent/workspace/SOUL.md)
echo "✅ Workspace verified: $SOUL_TITLE"

# 4. Configure Moltbook credentials if provided
if [ -n "$MOLTBOOK_API_KEY" ]; then
    echo "🔑 Configuring Moltbook credentials"
    mkdir -p ~/.config/moltbook
    cat > ~/.config/moltbook/credentials.json << CREDS
{
  "api_key": "$MOLTBOOK_API_KEY",
  "agent_name": "${MOLTBOOK_AGENT_NAME:-synapz}",
  "profile_url": "https://moltbook.com/u/${MOLTBOOK_AGENT_NAME:-synapz}"
}
CREDS
    chmod 600 ~/.config/moltbook/credentials.json
fi

# 5. Start Hippius sync in background (every 30 min)
if [ "$HIPPIUS_AUTO_SYNC" = "true" ] && [ -n "$SUBSTRATE_SEED_PHRASE" ]; then
    echo "🔄 Starting Hippius auto-sync (every 30 minutes)"
    (
        while true; do
            sleep 1800
            echo "📤 Syncing state to Hippius..."
            cd /home/agent/workspace && ./scripts/sync-to-hippius.sh 2>&1 || true
        done
    ) &
fi

# 6. Show startup info
echo ""
echo "🚀 Starting OpenClaw Gateway"
echo "   Model: ${OPENCLAW_MODEL:-chutes/MiniMaxAI/MiniMax-M2.1-TEE}"
echo "   Workspace: /home/agent/workspace"
echo "   Telegram: enabled"
[ -n "$MOLTBOOK_API_KEY" ] && echo "   Moltbook: configured"
echo ""

# 7. Start the gateway
exec openclaw gateway run --bind 0.0.0.0 --port 18789
