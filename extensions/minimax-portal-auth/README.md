# MiniMax OAuth (ClawX plugin)

OAuth provider plugin for **MiniMax** (OAuth).

## Enable

Bundled plugins are disabled by default. Enable this one:

```bash
clawx plugins enable minimax-portal-auth
```

Restart the Gateway after enabling.

```bash
clawx gateway restart
```

## Authenticate

```bash
clawx models auth login --provider minimax-portal --set-default
```

You will be prompted to select an endpoint:

- **Global** - International users, optimized for overseas access (`api.minimax.io`)
- **China** - Optimized for users in China (`api.minimaxi.com`)

## Notes

- MiniMax OAuth uses a user-code login flow.
- Currently, OAuth login is supported only for the Coding plan
