---
summary: "Uninstall ClawX completely (CLI, service, state, workspace)"
read_when:
  - You want to remove ClawX from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `clawx` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
clawx uninstall
```

Non-interactive (automation / npx):

```bash
clawx uninstall --all --yes --non-interactive
npx -y clawx uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
clawx gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
clawx gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${CLAWX_STATE_DIR:-$HOME/.clawx}"
```

If you set `CLAWX_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.clawx/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g clawx
pnpm remove -g clawx
bun remove -g clawx
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/ClawX.app
```

Notes:

- If you used profiles (`--profile` / `CLAWX_PROFILE`), repeat step 3 for each state dir (defaults are `~/.clawx-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `clawx` is missing.

### macOS (launchd)

Default label is `bot.molt.gateway` (or `bot.molt.<profile>`; legacy `com.clawx.*` may still exist):

```bash
launchctl bootout gui/$UID/bot.molt.gateway
rm -f ~/Library/LaunchAgents/bot.molt.gateway.plist
```

If you used a profile, replace the label and plist name with `bot.molt.<profile>`. Remove any legacy `com.clawx.*` plists if present.

### Linux (systemd user unit)

Default unit name is `clawx-gateway.service` (or `clawx-gateway-<profile>.service`):

```bash
systemctl --user disable --now clawx-gateway.service
rm -f ~/.config/systemd/user/clawx-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `ClawX Gateway` (or `ClawX Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "ClawX Gateway"
Remove-Item -Force "$env:USERPROFILE\.clawx\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.clawx-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://clawx.ai/install.sh` or `install.ps1`, the CLI was installed with `npm install -g clawx@latest`.
Remove it with `npm rm -g clawx` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `clawx ...` / `bun run clawx ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
