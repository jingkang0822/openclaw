---
summary: "CLI reference for `clawx logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
title: "logs"
---

# `clawx logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:

- Logging overview: [Logging](/logging)

## Examples

```bash
clawx logs
clawx logs --follow
clawx logs --json
clawx logs --limit 500
```
