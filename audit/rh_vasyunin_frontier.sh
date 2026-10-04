#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -f /tmp/rh_vasyunin_gap_*.txt /tmp/rh_vasyunin_core_*.txt 2>/dev/null || true

echo "[RH-VASYUNIN] SOURCE CHECK"
lake env lean lean/MCore/RH/R0/VasyuninStructural.lean
lake env lean lean/MCore/RH/R0/VasyuninFormulaReduction.lean
lake env lean lean/MCore/RH/R0/VasyuninGCD.lean
lake env lean lean/MCore/RH/R0/VasyuninRateReduction.lean

echo "[RH-VASYUNIN] COPRIME DISCOVERY"
set +e
lake env lean open_math/lean/RHVasyuninCoprimeChallenge.lean 2>&1 | tee /tmp/rh-vasyunin-coprime.log
COP=$?
lake env lean open_math/lean/RHVasyuninCoprimeDecomposition.lean 2>&1 | tee /tmp/rh-vasyunin-decomposition.log
DEC=$?
set -e

for f in /tmp/rh_vasyunin_gap_*.txt /tmp/rh_vasyunin_core_*.txt; do
  [[ -e "$f" ]] || continue
  echo "===== $(basename "$f") ====="
  cat "$f"
done

echo "[RH-VASYUNIN] COPRIME_EXIT=$COP"
echo "[RH-VASYUNIN] DECOMPOSITION_EXIT=$DEC"
echo "[RH-VASYUNIN] CLASSICAL_BRIDGE=CoprimeVasyuninFormula"
echo "[RH-VASYUNIN] MATERIAL_TARGET=FiniteVasyuninRateTarget"
echo "[RH-VASYUNIN] TERMINAL_PROMOTION=FORBIDDEN_WITHOUT_BOTH"
exit 2
