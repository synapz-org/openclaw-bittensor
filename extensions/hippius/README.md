# Hippius Extension

Decentralized state persistence via Bittensor Subnet 75.

## Features

- Upload files to IPFS
- Sync agent state (memory, relationships, etc.)
- Restore from backup
- Track CID history

## Configuration

Set environment variables:
```bash
SUBSTRATE_NODE_URL=wss://hippius.node.url
SUBSTRATE_SEED_PHRASE="your 12 or 24 word mnemonic"
```

## Tools

- `hippius_upload` - Upload a file and get IPFS CID
- `hippius_sync` - Sync workspace state to Hippius
- `hippius_restore` - Restore workspace from CID
