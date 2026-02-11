#!/usr/bin/env bash
set -euo pipefail

cd /repo

export CLAWX_STATE_DIR="/tmp/clawx-test"
export CLAWX_CONFIG_PATH="${CLAWX_STATE_DIR}/clawx.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${CLAWX_STATE_DIR}/credentials"
mkdir -p "${CLAWX_STATE_DIR}/agents/main/sessions"
echo '{}' >"${CLAWX_CONFIG_PATH}"
echo 'creds' >"${CLAWX_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${CLAWX_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm clawx reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${CLAWX_CONFIG_PATH}"
test ! -d "${CLAWX_STATE_DIR}/credentials"
test ! -d "${CLAWX_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${CLAWX_STATE_DIR}/credentials"
echo '{}' >"${CLAWX_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm clawx uninstall --state --yes --non-interactive

test ! -d "${CLAWX_STATE_DIR}"

echo "OK"
