#!/usr/bin/env bash
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FILE="open_math/forced/Forced.lean"

echo "[RH-FORCED] CONDITIONAL WORLD / NOT A CERTIFICATE"
lake env lean "$FILE"
code=$?

if [[ $code -eq 0 ]]; then
  echo "[RH-FORCED] STATUS=CONDITIONAL_WORLD_GREEN"
  echo "[RH-FORCED] CERTIFICATE=FORBIDDEN"
  echo "[RH-FORCED] TERMINAL_PROMOTION=FORBIDDEN"
else
  echo "[RH-FORCED] STATUS=CONDITIONAL_WORLD_RED"
fi
exit $code
