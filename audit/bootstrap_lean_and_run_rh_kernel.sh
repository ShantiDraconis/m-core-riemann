#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

bash audit/bootstrap_lean_environment.sh
echo "[BOOTSTRAP] running RH kernel"
bash audit/rh_terminal_kernel_check.sh
