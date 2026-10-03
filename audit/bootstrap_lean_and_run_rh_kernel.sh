#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TOOLCHAIN="$(tr -d '\r\n' < lean-toolchain)"
echo "[BOOTSTRAP] toolchain=$TOOLCHAIN"

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

if ! need_cmd curl; then
  echo "[BOOTSTRAP] installing curl/git via apt"
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y curl git ca-certificates zstd
fi

if ! need_cmd git; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y git
fi

if ! need_cmd elan; then
  echo "[BOOTSTRAP] installing elan"
  curl -sSfL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --no-modify-path
fi

export PATH="$HOME/.elan/bin:$PATH"

echo "[BOOTSTRAP] installing/selecting exact Lean toolchain"
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
  echo "[BOOTSTRAP] mathlib cache executable unavailable; continuing with source build"
fi

echo "[BOOTSTRAP] running RH kernel preflight"
bash audit/rh_terminal_kernel_check.sh
