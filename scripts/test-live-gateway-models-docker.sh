#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${CLAWX_IMAGE:-${CLAWX_IMAGE:-clawx:local}}"
CONFIG_DIR="${CLAWX_CONFIG_DIR:-${CLAWX_CONFIG_DIR:-$HOME/.clawx}}"
WORKSPACE_DIR="${CLAWX_WORKSPACE_DIR:-${CLAWX_WORKSPACE_DIR:-$HOME/.clawx/workspace}}"
PROFILE_FILE="${CLAWX_PROFILE_FILE:-${CLAWX_PROFILE_FILE:-$HOME/.profile}}"

PROFILE_MOUNT=()
if [[ -f "$PROFILE_FILE" ]]; then
  PROFILE_MOUNT=(-v "$PROFILE_FILE":/home/node/.profile:ro)
fi

echo "==> Build image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" -f "$ROOT_DIR/Dockerfile" "$ROOT_DIR"

echo "==> Run gateway live model tests (profile keys)"
docker run --rm -t \
  --entrypoint bash \
  -e COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  -e HOME=/home/node \
  -e NODE_OPTIONS=--disable-warning=ExperimentalWarning \
  -e CLAWX_LIVE_TEST=1 \
  -e CLAWX_LIVE_GATEWAY_MODELS="${CLAWX_LIVE_GATEWAY_MODELS:-${CLAWX_LIVE_GATEWAY_MODELS:-all}}" \
  -e CLAWX_LIVE_GATEWAY_PROVIDERS="${CLAWX_LIVE_GATEWAY_PROVIDERS:-${CLAWX_LIVE_GATEWAY_PROVIDERS:-}}" \
  -e CLAWX_LIVE_GATEWAY_MODEL_TIMEOUT_MS="${CLAWX_LIVE_GATEWAY_MODEL_TIMEOUT_MS:-${CLAWX_LIVE_GATEWAY_MODEL_TIMEOUT_MS:-}}" \
  -v "$CONFIG_DIR":/home/node/.clawx \
  -v "$WORKSPACE_DIR":/home/node/.clawx/workspace \
  "${PROFILE_MOUNT[@]}" \
  "$IMAGE_NAME" \
  -lc "set -euo pipefail; [ -f \"$HOME/.profile\" ] && source \"$HOME/.profile\" || true; cd /app && pnpm test:live"
