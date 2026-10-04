#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FILE="open_math/lean/RHMaterialChallenge.lean"
LOG="${TMPDIR:-/tmp}/rh-material-discovery.log"

echo "[RH-DISCOVERY] compiling intentional OPEN_MATH challenge"
echo "[RH-DISCOVERY] file=$FILE"

set +e
lake env lean "$FILE" 2>&1 | tee "$LOG"
code=${PIPESTATUS[0]}
set -e

if [[ $code -eq 0 ]]; then
  echo "[RH-DISCOVERY] STATUS=UNEXPECTED_GREEN"
  echo "[RH-DISCOVERY] The discovery challenge compiled."
  echo "[RH-DISCOVERY] Next action: run audit/rh_material_gate.sh and full strict preflight."
  exit 0
fi

echo "[RH-DISCOVERY] STATUS=EXPECTED_OPEN_MATH_FAILURE"
echo "[RH-DISCOVERY] LEAN_EXIT=$code"
echo "[RH-DISCOVERY] GAP_ID=ConcreteUniformLogDNBound"
echo "[RH-DISCOVERY] The Lean error output above is the current exact proof-state frontier."
echo "[RH-DISCOVERY] This failure does not affect MCore because the challenge is not imported."
exit 2
