---
summary: "CLI reference for `clawx reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `clawx reset`

Reset local config/state (keeps the CLI installed).

```bash
clawx reset
clawx reset --dry-run
clawx reset --scope config+creds+sessions --yes --non-interactive
```
