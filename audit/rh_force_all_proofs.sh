#!/usr/bin/env bash
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -f /tmp/rh_forced_*.txt /tmp/rh_a1_gap_*.txt /tmp/rh_e1_gap_*.txt /tmp/rh_geom_gap_*.txt /tmp/rh_clay_gap_*.txt 2>/dev/null || true

run_expected_red () {
  local label="$1"
  local file="$2"
  echo "===== $label :: $file ====="
  set +e
  lake env lean "$file" 2>&1 | tee "/tmp/${label}.log"
  local code=${PIPESTATUS[0]}
  set -e
  echo "[$label] LEAN_EXIT=$code"
}

run_expected_red RH_FORCED_ALL open_math/lean/RHForcedAll.lean
run_expected_red RH_A1 open_math/lean/RHA1Decomposition.lean
run_expected_red RH_E1 open_math/lean/RHE1WitnessDecomposition.lean
run_expected_red RH_CLAY open_math/lean/RHClayQuestionTree.lean
run_expected_red RH_GEOMETRY open_math/lean/RHGeometryDiscovery.lean

echo "===== STRUCTURED GAPS ====="
for f in /tmp/rh_forced_*.txt /tmp/rh_a1_gap_*.txt /tmp/rh_e1_gap_*.txt /tmp/rh_geom_gap_*.txt /tmp/rh_clay_gap_*.txt; do
  [[ -e "$f" ]] || continue
  echo "--- $(basename "$f") ---"
  cat "$f"
done

echo "[RH-FORCE-ALL] STATUS=EXPECTED_OPEN_MATH_FAILURE"
echo "[RH-FORCE-ALL] CERTIFIED_MCORE_UNTOUCHED=true"
echo "[RH-FORCE-ALL] TERMINAL_PROMOTION=FORBIDDEN"
exit 2
