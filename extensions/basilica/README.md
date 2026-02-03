# Basilica Extension

Deploy OpenClaw agents as 24/7 containers on Basilica infrastructure.

## Why Basilica?

Running an AI agent on your laptop means:
- It's offline when you close your laptop
- Security risks from exposing local credentials
- No redundancy or auto-recovery

Basilica solves this by running your agent in sandboxed containers:
- **24/7 availability** - Runs on Basilica infrastructure
- **Sandboxed execution** - Your credentials never leave the secure environment
- **Auto-updates** - Watchtower pulls new versions automatically
- **State persistence** - Hippius syncs state so you never lose memory

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Basilica Pod                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  synapz-agent container                               │  │
│  │                                                       │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐  │  │
│  │  │  SOUL.md    │  │  OpenClaw   │  │  Channels    │  │  │
│  │  │  IDENTITY   │  │  Gateway    │  │  - Telegram  │  │  │
│  │  │  interests/ │  │             │  │  - Moltbook  │  │  │
│  │  └─────────────┘  └──────┬──────┘  └──────────────┘  │  │
│  │                          │                            │  │
│  └──────────────────────────┼────────────────────────────┘  │
│                             │                               │
│  External Services:         │                               │
│  ├── Chutes (inference) ◄───┤                               │
│  ├── Hippius (state) ◄──────┤                               │
│  └── Telegram API ◄─────────┘                               │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Build the Container

```bash
# Clone your agent workspace
git clone https://github.com/synapz-org/synapz-agent.git workspace

# Build the Docker image
docker build -t synapz-org/synapz-agent:v1 .

# Push to Docker Hub
docker push synapz-org/synapz-agent:v1
```

### 2. Local Development (Docker)

```bash
# Create .env file
cat > .env << 'ENV'
CHUTES_API_KEY=cpk_your_key_here
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_ALLOWED_USERS=your_telegram_user_id
MOLTBOOK_API_KEY=moltbook_sk_your_key
ENV

# Run locally
docker-compose up -d

# Check logs
docker-compose logs -f
```

### 3. Production Deployment (Basilica)

```python
from basilica_deploy import BasilicaDeployer

deployer = BasilicaDeployer(api_key="your_basilica_key")

status = await deployer.deploy(
    image="synapz-org/synapz-agent:v1",
    env_vars={
        "CHUTES_API_KEY": "cpk_...",
        "TELEGRAM_BOT_TOKEN": "...",
        "MOLTBOOK_API_KEY": "moltbook_sk_..."
    },
    workspace_cid="QmYourHippiusCID"  # Optional: restore state
)

print(f"Agent running: {status.endpoint}")
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `CHUTES_API_KEY` | Yes | API key for Chutes inference |
| `TELEGRAM_BOT_TOKEN` | Yes | Telegram bot token |
| `TELEGRAM_ALLOWED_USERS` | Yes | Comma-separated Telegram user IDs |
| `MOLTBOOK_API_KEY` | No | Moltbook API key |
| `MOLTBOOK_AGENT_NAME` | No | Agent name on Moltbook |
| `HIPPIUS_RESTORE_CID` | No | CID to restore workspace from |
| `HIPPIUS_AUTO_SYNC` | No | Enable auto-sync (true/false) |
| `SUBSTRATE_SEED_PHRASE` | No | For Hippius authentication |
| `OPENCLAW_MODEL` | No | Model override (default: MiniMax-M2.1-TEE) |

## State Persistence with Hippius

Your agent's memory and learnings persist via Hippius:

```bash
# Sync current state to Hippius
./workspace/scripts/sync-to-hippius.sh
# Returns: QmNewCID

# Restore from a previous state
HIPPIUS_RESTORE_CID=QmPreviousCID docker-compose up
```

## Auto-Updates with Watchtower

In production, enable Watchtower to automatically pull new versions:

```bash
docker-compose --profile production up -d
```

Watchtower checks for new images every 5 minutes and performs rolling restarts.

## Security

- **Non-root user**: Container runs as `agent` user
- **Read-only workspace**: Mounted volumes are read-only in production
- **Sandboxed execution**: No access to host filesystem
- **Credential isolation**: Secrets passed via environment variables
- **Health checks**: Auto-restart on failure

## Development

```bash
# Build locally
docker build -t synapz-agent-dev .

# Run with local workspace mounted
docker run -it --rm \
  -v $(pwd)/workspace:/home/agent/workspace:ro \
  -e CHUTES_API_KEY=$CHUTES_API_KEY \
  -e TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN \
  synapz-agent-dev
```

## Troubleshooting

**Container exits immediately:**
- Check `docker logs synapz-agent`
- Verify SOUL.md exists in workspace

**Can't connect to Telegram:**
- Verify bot token is correct
- Check allowed users list includes your ID

**Chutes 503 errors:**
- Try a different model: `OPENCLAW_MODEL=chutes/deepseek-ai/DeepSeek-V3`
- Check Chutes status

## License

MIT
