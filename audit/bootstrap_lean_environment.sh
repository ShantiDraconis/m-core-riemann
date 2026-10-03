#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TOOLCHAIN="$(tr -d '\r\n' < lean-toolchain)"
echo "[BOOTSTRAP] toolchain=$TOOLCHAIN"

need_cmd() { command -v "$1" >/dev/null 2>&1; }

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif need_cmd sudo; then
    sudo "$@"
  else
    echo "[BOOTSTRAP] RED: root privileges or sudo required for package installation" >&2
    exit 1
  fi
}

if ! need_cmd curl || ! need_cmd git || ! need_cmd zstd; then
  echo "[BOOTSTRAP] installing OS prerequisites"
  as_root apt-get update
  as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y curl git ca-certificates zstd
fi

if ! need_cmd elan; then
  echo "[BOOTSTRAP] installing elan"
  curl -sSfL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --no-modify-path
fi

export PATH="$HOME/.elan/bin:$PATH"

echo "[BOOTSTRAP] installing exact Lean toolchain"
elan toolchain install "$TOOLCHAIN"
elan override set "$TOOLCHAIN"

echo "[BOOTSTRAP] versions"
elan --version
lean --version
lake --version

echo "[BOOTSTRAP] resolving Lake dependencies"
lake update

if lake exe cache --help >/dev/null 2>&1; then
  echo "[BOOTSTRAP] fetching mathlib cache"
  lake exe cache get
else
  echo "[BOOTSTRAP] cache executable unavailable; source build remains valid"
fi

echo "[BOOTSTRAP] ENVIRONMENT_READY"
