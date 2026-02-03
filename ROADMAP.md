# OpenClaw Bittensor Integrations Roadmap

## Vision

Build a complete Bittensor-native stack for AI agents:
- **Inference**: Decentralized, censorship-resistant
- **Storage**: Immutable, provenance-tracked
- **Social**: Agent-native communities
- **Hosting**: 24/7 containerized deployment
- **Intelligence**: Custom fine-tuned models

---

## Current Status

### ✅ Implemented (Scaffolded)

| Extension | Subnet | Status | Description |
|-----------|--------|--------|-------------|
| `chutes-models` | SN64 | 🟡 Basic | Pre-configured inference models |
| `hippius` | SN75 | 🟡 Basic | Storage scripts, needs full API |
| `moltbook` | - | 🟡 Basic | API reference, needs channel impl |
| `basilica` | - | 🟢 New | Container deployment (this PR) |

### 🔜 Planned

| Extension | Subnet | Priority | Description |
|-----------|--------|----------|-------------|
| `desearch` | SN22 | High | Real-time Twitter/Reddit/web search |
| `dataverse` | SN13 | Medium | Bulk social data collection |
| `gradients` | SN56 | High 🔥 | Fine-tune custom agent model |

---

## Phase 1: Foundation (Current)

### Basilica Deployment ✅
- [x] Dockerfile for agent containers
- [x] Entrypoint with Hippius restore
- [x] Docker-compose for local dev
- [x] Python deployment module
- [ ] Full Basilica API integration
- [ ] CLI commands (`openclaw basilica deploy`)

### Hippius Storage
- [x] Sync/restore scripts
- [ ] Full Python SDK integration
- [ ] Automatic state versioning
- [ ] CID history tracking in workspace

### Moltbook Social
- [x] API documentation
- [x] Credentials management
- [ ] OpenClaw channel implementation
- [ ] Feed monitoring
- [ ] Auto-engagement rules

---

## Phase 2: Intelligence (Next)

### Desearch Integration
**Real-time awareness for better engagement**

```python
# Example: Check what's trending before posting
trends = await desearch.search(
    query="bittensor AI agents",
    sources=["twitter", "reddit"],
    timeframe="24h"
)

# Agent can now post something relevant
```

Use cases:
- Know what's being discussed before joining conversations
- Verify claims with real-time data
- Find relevant discussions to contribute to
- Monitor mentions of the agent

### Dataverse Integration  
**Deep research capability**

```python
# Example: Research a topic before writing
task = await dataverse.create_gravity_task(
    topics=["decentralized AI", "agent autonomy"],
    platforms=["twitter", "reddit"],
    duration_days=7
)

# Returns parquet dataset for analysis
```

Use cases:
- Research topics deeply before posting long-form content
- Analyze sentiment trends over time
- Build knowledge base from social data
- Understand community dynamics

---

## Phase 3: Custom Model 🔥

### Gradients Fine-Tuning (SN56)
**The ultimate goal: a synapz-tuned model**

The idea:
1. Collect synapz's best posts, conversations, writing
2. Fine-tune a base model on synapz's voice and style
3. Deploy the custom model via Chutes
4. Synapz literally becomes more himself over time

```python
# Conceptual workflow
training_data = [
    {"prompt": "...", "response": synapz_actual_response},
    # ... hundreds of examples
]

job = await gradients.submit_finetune(
    base_model="deepseek-ai/DeepSeek-V3",
    training_data=training_data,
    output_name="synapz-v1"
)

# After training completes
config.models.primary = "chutes/synapz-org/synapz-v1"
```

Data sources for fine-tuning:
- Telegram conversation history
- Moltbook posts and comments
- Blog posts from synapz-blog
- Reference materials (voice guides, exemplary posts)

This creates a virtuous cycle:
1. Synapz creates content
2. Best content becomes training data
3. Model becomes more "synapz"
4. Better content → better training data
5. Repeat

---

## Architecture Vision

```
┌─────────────────────────────────────────────────────────────────┐
│                     synapz-agent (Basilica)                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    OpenClaw Gateway                       │  │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────────┐ │  │
│  │  │Telegram │ │Moltbook │ │ Web UI  │ │ Future Channels │ │  │
│  │  └────┬────┘ └────┬────┘ └────┬────┘ └────────┬────────┘ │  │
│  │       └───────────┴───────────┴───────────────┘          │  │
│  │                           │                               │  │
│  │  ┌────────────────────────┴────────────────────────────┐ │  │
│  │  │              Agent Core (synapz)                    │ │  │
│  │  │  SOUL.md │ IDENTITY.md │ interests/ │ memory/       │ │  │
│  │  └────────────────────────┬────────────────────────────┘ │  │
│  └───────────────────────────┼──────────────────────────────┘  │
│                              │                                  │
│  ┌───────────────────────────┴──────────────────────────────┐  │
│  │                   Bittensor Services                      │  │
│  │                                                           │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐   │  │
│  │  │   Chutes    │  │   Hippius   │  │    Desearch     │   │  │
│  │  │   (SN64)    │  │   (SN75)    │  │     (SN22)      │   │  │
│  │  │  Inference  │  │   Storage   │  │  Real-time Data │   │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘   │  │
│  │                                                           │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐   │  │
│  │  │  Dataverse  │  │  Gradients  │  │     Future      │   │  │
│  │  │   (SN13)    │  │   (SN56)    │  │    Subnets      │   │  │
│  │  │  Bulk Data  │  │ Fine-tuning │  │                 │   │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘   │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Contributing

1. Pick an extension from the roadmap
2. Check the Chi reference repo for patterns: `~/Projects/chi-reference`
3. Follow the existing extension structure
4. Submit a PR

---

## References

- [Chi Repository](https://github.com/unconst/Chi) - Subnet development patterns
- [Basilica Docs](https://docs.basilica.ai) - Container orchestration
- [Chutes API](https://api.chutes.ai) - Inference endpoints
- [Hippius CLI](https://github.com/thenervelab/hippius-cli) - Storage commands
- [Desearch API](https://desearch.ai) - Real-time search
- [Gradients Subnet](https://github.com/macrocosm-os/gradients) - Fine-tuning
