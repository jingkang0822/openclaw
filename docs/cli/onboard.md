---
summary: "CLI reference for `clawx onboard` (interactive onboarding wizard)"
read_when:
  - You want guided setup for gateway, workspace, auth, channels, and skills
title: "onboard"
---

# `clawx onboard`

Interactive onboarding wizard (local or remote Gateway setup).

## Related guides

- CLI onboarding hub: [Onboarding Wizard (CLI)](/start/wizard)
- CLI onboarding reference: [CLI Onboarding Reference](/start/wizard-cli-reference)
- CLI automation: [CLI Automation](/start/wizard-cli-automation)
- macOS onboarding: [Onboarding (macOS App)](/start/onboarding)

## Examples

```bash
clawx onboard
clawx onboard --flow quickstart
clawx onboard --flow manual
clawx onboard --mode remote --remote-url ws://gateway-host:19789
```

Flow notes:

- `quickstart`: minimal prompts, auto-generates a gateway token.
- `manual`: full prompts for port/bind/auth (alias of `advanced`).
- Fastest first chat: `clawx dashboard` (Control UI, no channel setup).

## Common follow-up commands

```bash
clawx configure
clawx agents add <name>
```

<Note>
`--json` does not imply non-interactive mode. Use `--non-interactive` for scripts.
</Note>
