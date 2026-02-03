#!/bin/bash
set -e

echo "🧠 Starting Synapz Agent Container"
echo "=================================="

# 1. Restore from Hippius if CID provided
if [ -n "$HIPPIUS_RESTORE_CID" ]; then
    echo "📥 Restoring state from Hippius: $HIPPIUS_RESTORE_CID"
    # TODO: Implement hippius restore
    # hipc storage download $HIPPIUS_RESTORE_CID ./workspace/
fi

# 2. Verify workspace
if [ ! -f "./workspace/SOUL.md" ]; then
    echo "❌ No SOUL.md found - agent has no personality!"
    exit 1
fi

echo "✅ Workspace verified: $(head -1 ./workspace/SOUL.md)"

# 3. Configure credentials from environment
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
fi

# 4. Start Hippius sync in background (every 30 min)
if [ -n "$HIPPIUS_AUTO_SYNC" ] && [ "$HIPPIUS_AUTO_SYNC" = "true" ]; then
    echo "🔄 Starting Hippius auto-sync (every 30 minutes)"
    (
        while true; do
            sleep 1800
            echo "📤 Syncing state to Hippius..."
            # TODO: Implement hippius sync
            # ./workspace/scripts/sync-to-hippius.sh
        done
    ) &
fi

# 5. Start the OpenClaw gateway
echo "🚀 Starting OpenClaw Gateway"
echo "   Model: ${OPENCLAW_MODEL:-chutes/MiniMaxAI/MiniMax-M2.1-TEE}"
echo "   Channels: Telegram, Moltbook (coming soon)"

exec openclaw gateway run --bind 0.0.0.0 --port 18789
