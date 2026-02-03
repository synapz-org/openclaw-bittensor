# OpenClaw Bittensor Extensions Roadmap

## Vision

A complete Bittensor-native stack for OpenClaw agents:
- **Inference**: Decentralized, censorship-resistant (Chutes)
- **Storage**: Immutable, provenance-tracked (Hippius)
- **Social**: Agent-native communities (Moltbook)
- **Hosting**: 24/7 containerized deployment (Basilica)
- **Intelligence**: Custom fine-tuned models (Gradients)

---

## Current Status

| Extension | Subnet | Status | Description |
|-----------|--------|--------|-------------|
| `chutes-models` | SN64 | 🟡 Scaffolded | Pre-configured inference models |
| `hippius` | SN75 | 🟡 Scaffolded | Decentralized storage |
| `moltbook` | - | 🟡 Scaffolded | Agent social network |
| `basilica` | - | 🟢 New | Container deployment |

---

## Planned Extensions

| Extension | Subnet | Priority | Description |
|-----------|--------|----------|-------------|
| `desearch` | SN22 | High | Real-time Twitter/Reddit/web search |
| `dataverse` | SN13 | Medium | Bulk social data collection |
| `gradients` | SN56 | Medium | Fine-tune custom agent models |

---

## Extension Details

### Basilica (Container Deployment)
Run OpenClaw agents 24/7 in sandboxed containers.

- Dockerfile for agent containers
- Hippius state restore on startup
- Auto-updates via Watchtower
- Local dev with docker-compose

### Desearch (Real-time Search)
Give agents awareness of current events and social discussions.

- Twitter/Reddit/web search
- Sentiment analysis
- Real-time monitoring

### Dataverse (Bulk Data)
Deep research capability for agents.

- Large-scale social data collection
- Parquet dataset output
- Historical analysis

### Gradients (Fine-tuning)
Train custom models on agent-specific data.

- Fine-tune base models on conversation history
- Deploy custom models via Chutes
- Continuous improvement loop

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                OpenClaw Agent (Basilica)                    │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Agent Workspace (SOUL.md, IDENTITY.md, interests/)   │  │
│  └───────────────────────────────────────────────────────┘  │
│                              │                              │
│  ┌───────────────────────────┴───────────────────────────┐  │
│  │                  Bittensor Services                    │  │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────┐  │  │
│  │  │ Chutes  │ │ Hippius │ │Desearch │ │  Gradients  │  │  │
│  │  │  SN64   │ │  SN75   │ │  SN22   │ │    SN56     │  │  │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Contributing

1. Check the [Chi reference repo](https://github.com/unconst/Chi) for patterns
2. Follow existing extension structure
3. Submit a PR

## License

MIT
