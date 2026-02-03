# Chutes Models Extension

Pre-configured Bittensor-native inference models.

## Available Models

| Preset | Model | Use Case |
|--------|-------|----------|
| kimi-k2-thinking | Kimi K2 Thinking TEE | Deep reasoning tasks |
| deepseek-v3 | DeepSeek V3 | General purpose |
| minimax-m2 | MiniMax M2.1 TEE | Balanced performance |

## Configuration

Add your Chutes API key to OpenClaw config:
```json
{
  "models": {
    "providers": {
      "chutes": {
        "apiKey": "cpk_your_key_here"
      }
    }
  }
}
```
