---
summary: "CLI reference for `clawx voicecall` (voice-call plugin command surface)"
read_when:
  - You use the voice-call plugin and want the CLI entry points
  - You want quick examples for `voicecall call|continue|status|tail|expose`
title: "voicecall"
---

# `clawx voicecall`

`voicecall` is a plugin-provided command. It only appears if the voice-call plugin is installed and enabled.

Primary doc:

- Voice-call plugin: [Voice Call](/plugins/voice-call)

## Common commands

```bash
clawx voicecall status --call-id <id>
clawx voicecall call --to "+15555550123" --message "Hello" --mode notify
clawx voicecall continue --call-id <id> --message "Any questions?"
clawx voicecall end --call-id <id>
```

## Exposing webhooks (Tailscale)

```bash
clawx voicecall expose --mode serve
clawx voicecall expose --mode funnel
clawx voicecall unexpose
```

Security note: only expose the webhook endpoint to networks you trust. Prefer Tailscale Serve over Funnel when possible.
