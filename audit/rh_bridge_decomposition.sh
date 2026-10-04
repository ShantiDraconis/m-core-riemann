#!/usr/bin/env bash
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
rm -f /tmp/rh_a1_gap_*.txt /tmp/rh_e1_gap_*.txt 2>/dev/null || true

run_red () {
  local file="$1"
  echo "===== $file ====="
  set +e
  lake env lean "$file"
  local code=$?
  set -e
  echo "LEAN_EXIT=$code"
}

run_red open_math/lean/RHA1Decomposition.lean
run_red open_math/lean/RHE1WitnessDecomposition.lean

for f in /tmp/rh_a1_gap_*.txt /tmp/rh_e1_gap_*.txt; do
  [[ -e "$f" ]] || continue
  echo "===== $(basename "$f") ====="
  cat "$f"
done

echo "[RH-BRIDGES] STATUS=EXPECTED_DISCOVERY_FAILURE"
echo "[RH-BRIDGES] TERMINAL_PROMOTION=FORBIDDEN"
exit 2
