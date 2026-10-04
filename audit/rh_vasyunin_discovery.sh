#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

OUT="/tmp/rh_vasyunin_discovery.log"
G1="/tmp/rh_vasyunin_gap_GRAM_FORMULA.txt"
G2="/tmp/rh_vasyunin_gap_FINITE_RATE.txt"
rm -f "$OUT" "$G1" "$G2"

set +e
lake env lean open_math/lean/RHVasyuninDiscovery.lean >"$OUT" 2>&1
STATUS=$?
set -e

[[ -f "$G1" ]] && echo "CLASSICAL_FORMALIZATION_GAP=VasyuninGramFormula"
[[ -f "$G2" ]] && echo "MATERIAL_RATE_GAP=FiniteVasyuninRateTarget"

if [[ -f "$G1" || -f "$G2" ]]; then
  echo "STATUS=EXPECTED_OPEN_MATH_FAILURE"
  echo "TERMINAL_PROMOTION=FORBIDDEN"
  exit 2
fi

if [[ $STATUS -ne 0 ]]; then
  cat "$OUT"
  echo "STATUS=UNEXPECTED_RED"
  exit "$STATUS"
fi

echo "STATUS=SOURCE_CLOSED"
